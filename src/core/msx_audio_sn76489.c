#include <msx_audio.h>

#include <stdlib.h>

#include "sn76489.h"

#define SN_WRITE_LOG_MAX 256

typedef struct {
    UInt16 frac16;
    UInt8 value;
} SNWrite;

typedef struct {
    SN76489 chip;
    SN76489 start;
    SNWrite log[SN_WRITE_LOG_MAX];
    unsigned count;
    int have_start;
    int overflow;
} SNAudio;

static UInt8 sn_read(void *dev, UInt16 port)
{
    (void)dev;
    (void)port;
    return 0xFF;
}

static void sn_write_at(void *dev, UInt16 port, UInt8 value, UInt16 frac16)
{
    SNAudio *audio = (SNAudio *)dev;
    (void)port;
    if (!audio->have_start) {
        audio->start = audio->chip;
        audio->have_start = 1;
    }
    if (audio->count < SN_WRITE_LOG_MAX) {
        audio->log[audio->count].frac16 = frac16;
        audio->log[audio->count++].value = value;
    } else {
        audio->overflow = 1;
    }
    sn76489_write(&audio->chip, value);
}

static void sn_write(void *dev, UInt16 port, UInt8 value)
{
    sn_write_at(dev, port, value, 0);
}

static UInt8 sn_latch(void *dev)
{
    return ((SNAudio *)dev)->chip.latch;
}

static void *sn_native(void *dev)
{
    return &((SNAudio *)dev)->chip;
}

static void sn_log_reset(void *dev)
{
    SNAudio *audio = (SNAudio *)dev;
    audio->count = 0;
    audio->have_start = 0;
    audio->overflow = 0;
}

static unsigned sn_render(void *dev, Int16 *out, unsigned samples,
                         UInt32 masterCycles)
{
    SNAudio *audio = (SNAudio *)dev;
    if (!out || !samples) return 0;
    if (!audio->count || audio->overflow) {
        sn_log_reset(dev);
        return sn76489_render(&audio->chip, out, samples, masterCycles);
    }

    /* Replay from the state saved at the frame's first write, then KEEP the
     * replayed end state (the AY adapter does the same). The tone counters,
     * noise phase and master-clock remainder must carry into the next frame:
     * restoring the pre-frame struct would restart every oscillator at the
     * same phase on each frame, which is a 60 Hz discontinuity in the middle
     * of the waveform (audible as rough/buzzy tone). */
    audio->chip = audio->start;
    unsigned done = 0, cyclesDone = 0;
    for (unsigned k = 0; k < audio->count; ++k) {
        unsigned long long frac = audio->log[k].frac16;
        unsigned sampleAt = (unsigned)((unsigned long long)samples * frac >> 16);
        unsigned cyclesAt = (unsigned)((unsigned long long)masterCycles * frac >> 16);
        if (sampleAt > done) {
            sn76489_render(&audio->chip, out + done, sampleAt - done,
                           cyclesAt - cyclesDone);
            done = sampleAt;
            cyclesDone = cyclesAt;
        }
        sn76489_write(&audio->chip, audio->log[k].value);
    }
    sn76489_render(&audio->chip, out + done, samples - done,
                   masterCycles - cyclesDone);
    sn_log_reset(dev);
    return samples;
}

static void sn_destroy(void *dev)
{
    free(dev);
}

static const MSX_AudioOps s_sn_ops = {
    sn_read, sn_write, sn_write_at, sn_latch, sn_log_reset,
    sn_render, sn_native, sn_destroy
};

int msx_audio_init_sn76489(MSX_Audio *audio)
{
    SNAudio *dev;
    if (!audio) return -1;
    audio->ops = NULL;
    audio->dev = NULL;
    dev = (SNAudio *)calloc(1, sizeof(*dev));
    if (!dev) return -1;
    sn76489_reset(&dev->chip);
    msx_audio_attach(audio, &s_sn_ops, dev);
    return 0;
}
