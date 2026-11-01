//
// msx_audio_psg.c
//
// BlueberryMSX - MSX1 audio device adapter.
//
// Implements the MSX_Audio seam (include/msx_audio.h) over the AY-3-8910 model
// in src/chips/sound/psg.c. This is where the MSX PSG port protocol lives:
//   - 0xA0 write: latch the register number
//   - 0xA1 write: write the latched register
//   - 0xA2 read : read the latched register
// src/core/msx.c routes those ports here and does not include psg.h.
//
// The sub-frame write log moved here from the machine with the seam. blueMSX
// R3 syncs every AY write into the audio stream at its exact output sample
// (AY8910.c updateRegister -> mixerSync) and openMSX timestamps writes against
// the CPU clock. This core has no cycle counter, so the machine passes the
// fraction of the frame's instruction budget that had run when the write
// happened (frac16), and render() replays the batch from the state saved at
// the frame's first write, applying each write at its recorded position.
// Rendering the whole frame with only the final register state audibly
// roughens fast passages.
//

#include <msx_audio.h>

#include <stddef.h>
#include <stdlib.h>

#include "psg.h"

typedef struct {
    UInt16 frac16;
    UInt8 reg;
    UInt8 val;
} PsgWriteLogEntry;

#define PSG_WRITE_LOG_MAX 256

typedef struct {
    PSG *psg;

    /* Frame write log, replayed by psg_audio_render(). */
    PsgWriteLogEntry log[PSG_WRITE_LOG_MAX];
    unsigned count;
    int overflow;
    PSG start;       /* state saved at the frame's first data write */
    int have_start;
} PsgAudio;

static UInt8 psg_read_port(void *dev, UInt16 port)
{
    PsgAudio *a = (PsgAudio *)dev;

    if (port == 0xA2)
        return psg_read(a->psg, psg_get_reg_latch(a->psg));
    return 0xFF;
}

static void psg_write_port(void *dev, UInt16 port, UInt8 val)
{
    PsgAudio *a = (PsgAudio *)dev;

    if (port == 0xA0)
        psg_set_reg_latch(a->psg, val);
    else if (port == 0xA1)
        psg_write(a->psg, psg_get_reg_latch(a->psg), val);
}

static void psg_write_port_at(void *dev, UInt16 port, UInt8 val, UInt16 frac16)
{
    PsgAudio *a = (PsgAudio *)dev;

    if (port == 0xA0) {
        psg_set_reg_latch(a->psg, val);
        return;
    }
    if (port != 0xA1)
        return;

    /* Save the pre-frame state once, at the first data write. */
    if (!a->have_start) {
        a->start = *a->psg;
        a->have_start = 1;
    }
    if (a->count < PSG_WRITE_LOG_MAX) {
        PsgWriteLogEntry *e = &a->log[a->count++];
        e->frac16 = frac16;
        e->reg = psg_get_reg_latch(a->psg);
        e->val = val;
    } else {
        a->overflow = 1;
    }

    /* Apply live too, so a 0xA2 read during the frame sees the new value. */
    psg_write(a->psg, psg_get_reg_latch(a->psg), val);
}

static UInt8 psg_latched_register(void *dev)
{
    PsgAudio *a = (PsgAudio *)dev;
    return psg_get_reg_latch(a->psg);
}

static void *psg_native(void *dev)
{
    return ((PsgAudio *)dev)->psg;
}

static void psg_log_reset(void *dev)
{
    PsgAudio *a = (PsgAudio *)dev;
    a->count = 0;
    a->overflow = 0;
    a->have_start = 0;
}

static unsigned psg_audio_render(void *dev, Int16 *out, unsigned samples,
                                 UInt32 masterCycles)
{
    PsgAudio *a = (PsgAudio *)dev;

    if (!out || samples == 0)
        return 0;

    if (a->count == 0 || a->overflow) {
        /* No in-frame writes, or the log overflowed: render the whole frame
         * with the live state rather than replaying a partial order. */
        psg_log_reset(a);
        return psg_render(a->psg, out, samples, masterCycles);
    }

    /* Replay from the state saved at the frame's first write. The live chip
     * keeps its end-of-frame state (already correct for the next frame's
     * reads); only the 0xA0 latch must survive the struct restore, since
     * psg_write never touches it. */
    UInt8 latch = a->psg->reg_latch;
    *a->psg = a->start;
    a->psg->reg_latch = latch;

    unsigned done = 0;
    unsigned cyclesDone = 0;
    for (unsigned k = 0; k < a->count; k++) {
        unsigned long long f = a->log[k].frac16;
        unsigned s1 = (unsigned)((unsigned long long)samples * f >> 16);
        unsigned c1 = (unsigned)((unsigned long long)masterCycles * f >> 16);
        if (s1 > done) {
            psg_render(a->psg, out + done, s1 - done,
                       (UInt32)(c1 - cyclesDone));
            done = s1;
            cyclesDone = c1;
        }
        psg_write(a->psg, a->log[k].reg, a->log[k].val);
    }
    psg_render(a->psg, out + done, samples - done,
               (UInt32)(masterCycles - cyclesDone));
    psg_log_reset(a);
    return samples;
}

static void psg_audio_destroy(void *dev)
{
    PsgAudio *a = (PsgAudio *)dev;
    if (!a) return;
    psg_destroy(a->psg);
    free(a);
}

static const MSX_AudioOps s_psg_ops = {
    psg_read_port,
    psg_write_port,
    psg_write_port_at,
    psg_latched_register,
    psg_log_reset,
    psg_audio_render,
    psg_native,
    psg_audio_destroy
};

void msx_audio_attach(MSX_Audio *audio, const MSX_AudioOps *ops, void *dev)
{
    if (!audio) return;
    audio->ops = ops;
    audio->dev = dev;
}

int msx_audio_init_psg(MSX_Audio *audio)
{
    PsgAudio *a;

    if (!audio) return -1;
    audio->ops = NULL;
    audio->dev = NULL;

    a = (PsgAudio *)calloc(1, sizeof *a);
    if (!a) return -1;
    a->psg = psg_create();
    if (!a->psg) {
        free(a);
        return -1;
    }
    audio->dev = a;
    audio->ops = &s_psg_ops;
    return 0;
}

void msx_audio_destroy(MSX_Audio *audio)
{
    if (!audio) return;
    if (audio->ops && audio->ops->destroy && audio->dev)
        audio->ops->destroy(audio->dev);
    audio->ops = NULL;
    audio->dev = NULL;
}

UInt8 msx_audio_read_io(MSX_Audio *audio, UInt16 port)
{
    if (!audio || !audio->ops || !audio->ops->read_io) return 0xFF;
    return audio->ops->read_io(audio->dev, port);
}

void msx_audio_write_io(MSX_Audio *audio, UInt16 port, UInt8 val)
{
    if (!audio || !audio->ops || !audio->ops->write_io) return;
    audio->ops->write_io(audio->dev, port, val);
}

void msx_audio_write_io_at(MSX_Audio *audio, UInt16 port, UInt8 val,
                           UInt16 frac16)
{
    if (!audio || !audio->ops) return;
    if (audio->ops->write_io_at)
        audio->ops->write_io_at(audio->dev, port, val, frac16);
    else
        msx_audio_write_io(audio, port, val);
}

UInt8 msx_audio_latched_register(const MSX_Audio *audio)
{
    if (!audio || !audio->ops || !audio->ops->latched_register) return 0;
    return audio->ops->latched_register(audio->dev);
}

void *msx_audio_native(const MSX_Audio *audio)
{
    if (!audio || !audio->ops || !audio->ops->native) return NULL;
    return audio->ops->native(audio->dev);
}

void msx_audio_log_reset(MSX_Audio *audio)
{
    if (!audio || !audio->ops || !audio->ops->log_reset) return;
    audio->ops->log_reset(audio->dev);
}

unsigned msx_audio_render(MSX_Audio *audio, Int16 *out, unsigned samples,
                          UInt32 masterCycles)
{
    if (!audio || !audio->ops || !audio->ops->render) return 0;
    return audio->ops->render(audio->dev, out, samples, masterCycles);
}
