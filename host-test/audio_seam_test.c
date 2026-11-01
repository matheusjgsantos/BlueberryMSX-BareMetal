#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "msx.h"
#include "msx_audio.h"
#include "psg.h"

/* Fake device: proves the seam is device-agnostic (a future machine can
 * install a different sound chip without touching the machine code). */
typedef struct {
    int writes;
    int timed;
    int reads;
    int resets;
    int renders;
    int destroyed;
    UInt8 last_port;
    UInt8 last_val;
    UInt16 last_frac;
    UInt8 latch;
    UInt32 last_cycles;
} FakeAudio;

static UInt8 fake_read(void *dev, UInt16 port)
{
    FakeAudio *f = (FakeAudio *)dev;
    f->reads++;
    f->last_port = (UInt8)port;
    return 0x33;
}

static void fake_write(void *dev, UInt16 port, UInt8 val)
{
    FakeAudio *f = (FakeAudio *)dev;
    f->writes++;
    f->last_port = (UInt8)port;
    f->last_val = val;
}

static void fake_write_at(void *dev, UInt16 port, UInt8 val, UInt16 frac16)
{
    FakeAudio *f = (FakeAudio *)dev;
    f->timed++;
    f->last_port = (UInt8)port;
    f->last_val = val;
    f->last_frac = frac16;
}

static UInt8 fake_latch(void *dev) { return ((FakeAudio *)dev)->latch; }

static void *fake_native(void *dev) { return dev; }

static void fake_reset(void *dev) { ((FakeAudio *)dev)->resets++; }

static unsigned fake_render(void *dev, Int16 *out, unsigned samples,
                            UInt32 cycles)
{
    FakeAudio *f = (FakeAudio *)dev;
    f->renders++;
    f->last_cycles = cycles;
    for (unsigned i = 0; i < samples; i++) out[i] = 7;
    return samples;
}

static void fake_destroy(void *dev) { ((FakeAudio *)dev)->destroyed++; }

static const MSX_AudioOps kFakeOps = {
    fake_read, fake_write, fake_write_at, fake_latch, fake_reset,
    fake_render, fake_native, fake_destroy
};

static void test_seam_is_device_agnostic(void)
{
    MSX_Audio audio = {0};
    FakeAudio fake = {0};
    Int16 out[4];

    msx_audio_attach(&audio, &kFakeOps, &fake);

    msx_audio_write_io(&audio, 0xA0, 0x01);
    assert(fake.writes == 1 && fake.last_port == 0xA0 && fake.last_val == 0x01);

    msx_audio_write_io_at(&audio, 0xA1, 0x5A, 0x1234);
    assert(fake.timed == 1 && fake.last_val == 0x5A && fake.last_frac == 0x1234);

    assert(msx_audio_read_io(&audio, 0xA2) == 0x33);
    assert(fake.reads == 1 && fake.last_port == 0xA2);

    fake.latch = 9;
    assert(msx_audio_latched_register(&audio) == 9);
    assert(msx_audio_native(&audio) == &fake);

    msx_audio_log_reset(&audio);
    assert(fake.resets == 1);

    assert(msx_audio_render(&audio, out, 4, 64) == 4);
    assert(fake.renders == 1 && out[3] == 7 && fake.last_cycles == 64);

    msx_audio_destroy(&audio);
    assert(fake.destroyed == 1);
    assert(audio.ops == NULL && audio.dev == NULL);

    /* Calls after destroy are inert, not crashes. */
    msx_audio_write_io(&audio, 0xA1, 0x00);
    assert(msx_audio_read_io(&audio, 0xA2) == 0xFF);
    assert(msx_audio_latched_register(&audio) == 0);
    assert(msx_audio_native(&audio) == NULL);
    assert(msx_audio_render(&audio, out, 4, 64) == 0);
    msx_audio_destroy(&audio); /* idempotent */
    msx_audio_log_reset(NULL);
    msx_audio_write_io(NULL, 0xA1, 0);
    assert(msx_audio_read_io(NULL, 0xA1) == 0xFF);
}

/* Performs one AY register write through the seam at a frame position. */
static void write_at(MSX_Audio *audio, UInt8 reg, UInt8 val, UInt16 frac)
{
    msx_audio_write_io_at(audio, 0xA0, reg, frac);
    msx_audio_write_io_at(audio, 0xA1, val, frac);
}

static void write_now(PSG *psg, UInt8 reg, UInt8 val)
{
    psg_set_reg_latch(psg, reg);
    psg_write(psg, reg, val);
}

static void test_psg_port_protocol(void)
{
    MSX_Audio audio = {0};
    PSG *raw = psg_create();
    assert(raw != NULL);
    assert(msx_audio_init_psg(&audio) == 0);
    assert(msx_audio_native(&audio) != NULL && audio.ops != NULL);

    /* Same port sequence, same chip state: the adapter is a forwarder. */
    msx_audio_write_io(&audio, 0xA0, 0x01);
    msx_audio_write_io(&audio, 0xA1, 0x5A);
    write_now(raw, 1, 0x5A);
    assert(psg_read(msx_audio_native(&audio), 1) == psg_read(raw, 1));
    assert(psg_read(msx_audio_native(&audio), 1) == 0x0A);

    assert(msx_audio_read_io(&audio, 0xA2) == psg_read(raw, 1));
    assert(msx_audio_read_io(&audio, 0xA0) == 0xFF);
    assert(msx_audio_read_io(&audio, 0xA1) == 0xFF);
    msx_audio_write_io(&audio, 0xA0, 0x07);
    assert(msx_audio_latched_register(&audio) == 7);

    /* Unrouted ports must not touch the chip. */
    msx_audio_write_io(&audio, 0x99, 0x42);
    assert(psg_read(msx_audio_native(&audio), 7) == psg_read(raw, 7));

    msx_audio_destroy(&audio);
    psg_destroy(raw);
}

/* The important behavioural test: a captured write must shape only the part of
 * the frame after it. Silence until mid-frame, then tone, must be byte-equal
 * to a manual two-segment render, and must differ from a naive whole-frame
 * render of the final register state. */
static void test_timed_writes_replay_at_their_position(void)
{
    enum { NSAMPLES = 64, CYCLES = 64 * 16 };
    MSX_Audio audio = {0};
    Int16 timed[NSAMPLES];
    Int16 manual[NSAMPLES];
    Int16 naive[NSAMPLES];
    PSG *ref = psg_create();
    PSG *flat = psg_create();

    assert(ref && flat);
    assert(msx_audio_init_psg(&audio) == 0);
    PSG *chip = (PSG *)msx_audio_native(&audio);
    assert(chip);

    /* Channel A square wave, volume 0 (silent) at the top of the frame. */
    const UInt8 setup[][2] = {
        {0, 0x00}, {1, 0x01}, {7, 0x3E}, {8, 0x00}, {9, 0x00}, {10, 0x00}
    };
    for (unsigned i = 0; i < sizeof setup / sizeof setup[0]; i++) {
        write_at(&audio, setup[i][0], setup[i][1], 0);
        write_now(ref, setup[i][0], setup[i][1]);
    }
    /* Bring channel A up at the middle of the frame. */
    write_at(&audio, 8, 0x0F, 0x8000);
    assert(psg_get_reg_latch(chip) == 8);

    assert(msx_audio_render(&audio, timed, NSAMPLES, CYCLES) == NSAMPLES);

    /* Manual equivalent: first half silent, then the volume write. */
    psg_render(ref, manual, NSAMPLES / 2, CYCLES / 2);
    write_now(ref, 8, 0x0F);
    psg_render(ref, manual + NSAMPLES / 2, NSAMPLES / 2, CYCLES / 2);
    assert(memcmp(timed, manual, sizeof timed) == 0);

    /* Position really matters: the first half is silent, the second is not. */
    for (unsigned i = 0; i < NSAMPLES / 2; i++) assert(timed[i] == 0);
    int nonzero = 0;
    for (unsigned i = NSAMPLES / 2; i < NSAMPLES; i++) nonzero += timed[i] != 0;
    assert(nonzero > 0);

    /* The old whole-frame behaviour is audibly different. */
    for (unsigned i = 0; i < sizeof setup / sizeof setup[0]; i++)
        write_now(flat, setup[i][0], setup[i][1]);
    write_now(flat, 8, 0x0F);
    psg_render(flat, naive, NSAMPLES, CYCLES);
    assert(memcmp(timed, naive, sizeof timed) != 0);
    assert(naive[0] != 0);

    /* The log is consumed by the render, and the latch survives the replay
     * (a 0xA2 read after rendering must still see register 8). */
    assert(psg_get_reg_latch(chip) == 8);
    assert(msx_audio_read_io(&audio, 0xA2) == 0x0F);
    Int16 again[NSAMPLES];
    assert(msx_audio_render(&audio, again, NSAMPLES, CYCLES) == NSAMPLES);

    msx_audio_destroy(&audio);
    psg_destroy(ref);
    psg_destroy(flat);
}

/* A frame with more writes than the log can hold must fall back to the
 * whole-frame behaviour instead of replaying a partial order. */
static void test_log_overflow_falls_back(void)
{
    enum { NSAMPLES = 32, CYCLES = 32 * 16 };
    MSX_Audio audio = {0};
    Int16 got[NSAMPLES];
    Int16 expect[NSAMPLES];
    PSG *ref = psg_create();
    assert(ref);

    assert(msx_audio_init_psg(&audio) == 0);
    for (unsigned i = 0; i < 400; i++) {
        write_at(&audio, 8, (UInt8)(i & 0x0F), (UInt16)(i * 128));
        write_now(ref, 8, (UInt8)(i & 0x0F));
    }
    assert(msx_audio_render(&audio, got, NSAMPLES, CYCLES) == NSAMPLES);
    psg_render(ref, expect, NSAMPLES, CYCLES);
    assert(memcmp(got, expect, sizeof got) == 0);

    msx_audio_destroy(&audio);
    psg_destroy(ref);
}

static void test_machine_alias(void)
{
    MSX_Machine *m = msx_create();
    assert(m != NULL);
    assert(m->audio.dev != NULL && m->audio.ops != NULL);
    /* Diagnostics and older tests read the chip pointer directly. */
    assert(m->sound == msx_audio_native(&m->audio));
    assert(((PSG *)m->sound)->reg_latch == 0);

    m->bus.write_io(m, 0xA0, 0x07);
    assert(((PSG *)m->sound)->reg_latch == 7);
    assert(msx_audio_latched_register(&m->audio) == 7);

    Int16 samples[8];
    assert(msx_psg_render(m, samples, 8, 8 * 16) == 8);
    msx_destroy(m);
}

int main(void)
{
    test_seam_is_device_agnostic();
    test_psg_port_protocol();
    test_timed_writes_replay_at_their_position();
    test_log_overflow_falls_back();
    test_machine_alias();
    puts("PASS: audio seam forwards to the PSG, replays timed writes, "
         "accepts other devices");
    return 0;
}
