#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "msx_audio.h"
#include "sn76489.h"

static void test_serial_register_protocol(void)
{
    SN76489 sn;
    sn76489_reset(&sn);
    sn76489_write(&sn, 0x85); /* latch tone 2, low nibble = 5 */
    sn76489_write(&sn, 0x12); /* continuation supplies high six bits */
    assert(sn.latch == 0);
    assert(sn.reg[0] == 0x125);
    sn76489_write(&sn, 0x9A); /* latch volume 0, attenuation 10 */
    assert(sn.reg[1] == 10);
    sn76489_write(&sn, 0xE7); /* noise control, white + tone2 rate */
    assert(sn.reg[6] == 7);
    assert(sn.noise_rng == 0x4000);
}

static void test_render_and_reset(void)
{
    SN76489 sn;
    Int16 out[512];
    int hasPositive = 0, hasNegative = 0;
    sn76489_reset(&sn);
    sn76489_write(&sn, 0x80); /* tone 0 period = 0 (minimum supported) */
    sn76489_write(&sn, 0x90); /* tone 0 full volume */
    assert(sn76489_render(&sn, out, 512, 357954u) == 512);
    for (unsigned i = 0; i < 512; ++i) {
        hasPositive |= out[i] > 0;
        hasNegative |= out[i] < 0;
    }
    assert(hasPositive && hasNegative);

    sn76489_reset(&sn);
    memset(out, 0x7F, sizeof(out));
    sn76489_render(&sn, out, 512, 357954u);
    for (unsigned i = 0; i < 512; ++i) assert(out[i] == 0);
}

static void test_sample_boxcar_average(void)
{
    SN76489 sn;
    Int16 sample;
    sn76489_reset(&sn);
    sn76489_write(&sn, 0x81); /* tone 0 period 1: toggle each native tick */
    sn76489_write(&sn, 0x90); /* tone 0 full volume */
    assert(sn76489_render(&sn, &sample, 1, 48) == 1); /* three native ticks */
    /* States after the three ticks are +8191, -8191, +8191. */
    assert(sample >= 2730 && sample <= 2731);
}

/* Two frames rendered through the adapter (one register write in each frame,
 * so both frames take the replay path) must equal one continuous chip render:
 * the oscillator phase and the master-clock remainder have to carry across the
 * frame boundary. Regression for the adapter restoring the pre-frame state,
 * which restarted the tone phase every 60 Hz frame. */
static void test_frame_phase_continuity(void)
{
    enum { FRAME_SAMPLES = 100 };
    /* 7500 master cycles = 468 native ticks (plus a 12-cycle remainder) over
     * 100 samples, i.e. 4.68 ticks/sample like the real 48 kHz feed. 468 is
     * not a multiple of the 8-tick waveform, so frame 2 is phase-shifted. */
    const UInt32 frameCycles = FRAME_SAMPLES * 75u;
    MSX_Audio audio = { 0, 0 };
    SN76489 ref;
    Int16 got[2][FRAME_SAMPLES];
    Int16 want[2][FRAME_SAMPLES];

    sn76489_reset(&ref);
    sn76489_write(&ref, 0x84); /* tone 0 low nibble */
    sn76489_write(&ref, 0x00); /* tone 0 high six bits -> period 4 */
    sn76489_write(&ref, 0x90); /* tone 0 full volume */
    sn76489_render(&ref, want[0], FRAME_SAMPLES, frameCycles);
    sn76489_render(&ref, want[1], FRAME_SAMPLES, frameCycles);

    assert(msx_audio_init_sn76489(&audio) == 0);
    msx_audio_write_io_at(&audio, 0xE0, 0x84, 0);
    msx_audio_write_io_at(&audio, 0xE0, 0x00, 0);
    msx_audio_write_io_at(&audio, 0xE0, 0x90, 0);
    assert(msx_audio_render(&audio, got[0], FRAME_SAMPLES, frameCycles)
           == FRAME_SAMPLES);
    msx_audio_write_io_at(&audio, 0xE0, 0x90, 0); /* frame 2 rewrite */
    assert(msx_audio_render(&audio, got[1], FRAME_SAMPLES, frameCycles)
           == FRAME_SAMPLES);
    msx_audio_destroy(&audio);

    assert(memcmp(got[0], want[0], sizeof(want[0])) == 0);
    assert(memcmp(got[1], want[1], sizeof(want[1])) == 0);
    /* The two reference frames must differ, or this test could not see a
     * frozen phase. */
    assert(memcmp(want[0], want[1], sizeof(want[0])) != 0);
}

static void test_audio_adapter(void)
{
    MSX_Audio audio = { 0, 0 };
    SN76489 *chip;
    Int16 out[256];
    assert(msx_audio_init_sn76489(&audio) == 0);
    chip = (SN76489 *)msx_audio_native(&audio);
    assert(chip != NULL);
    msx_audio_write_io_at(&audio, 0xE0, 0x90, 0);
    msx_audio_write_io_at(&audio, 0xFF, 0x80, 0); /* aliased port */
    assert(chip->reg[1] == 0);
    assert(msx_audio_render(&audio, out, 256, 357954u) == 256);
    msx_audio_destroy(&audio);
}

int main(void)
{
    test_serial_register_protocol();
    test_render_and_reset();
    test_sample_boxcar_average();
    test_frame_phase_continuity();
    test_audio_adapter();
    puts("PASS: SN76489 register protocol, synthesis, averaging, adapter");
    return 0;
}
