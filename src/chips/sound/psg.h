#ifndef PSG_H
#define PSG_H

#ifdef __cplusplus
extern "C" {
#endif

#include "msx_types.h"

/* AY-3-8910 PSG (the MSX sound chip).
 *
 * Semantics follow openMSX src/sound/AY8910.cc, which is the reference for
 * this project:
 *   - One emulation tick is 16 master clocks (openMSX NATIVE_FREQ = 3579545/16).
 *   - Tone half period  = max(1, fine + 256*(coarse & 0x0F)) ticks, so the
 *     square wave is master/(32*period). Writing a period clamps the running
 *     counter to period-1 (it counts up, not down).
 *   - Noise period      = 2*max(1, R6 & 0x1F) ticks.
 *   - Envelope step     = EFINE + 256*ECOARSE ticks (clamped to >= 1).
 *   - Per channel output = (toneOut | toneDisabled) & (noiseOut | noiseDisabled),
 *     which is 1 when tone AND noise are both disabled.
 *   - Volume is logarithmic, 2^((v-15)/4) of full scale, 0 for v=0.
 *   - Envelope shapes use openMSX's 32-step (attack XOR step) formulation.
 *
 * MSX port protocol (openMSX src/sound/MSXPSG.cc, which switches on port&3):
 *   - 0xA0 write: register latch = value & 0x0F
 *   - 0xA1 write: write the latched register
 *   - 0xA2 read : read the latched register
 */
typedef struct {
    uint8_t reg[16];
    uint8_t reg_latch;       /* 0xA0 latch, 0..15 */

    /* Tone generators: square wave, output toggles every `period` ticks. */
    UInt16 tone_period[3];
    UInt16 tone_count[3];
    uint8_t tone_out[3];

    /* Noise generator: 17 bit LFSR, one step every `noise_period` ticks. */
    UInt16 noise_period;
    UInt16 noise_count;
    UInt32 noise_rng;

    /* Envelope: one step every `env_period` ticks. */
    UInt16 env_period;
    UInt16 env_count;
    int env_step;            /* 0..31, counts down (openMSX uses a signed int) */
    int env_attack;          /* 0 or 0x1F, XORed with env_step */
    uint8_t env_hold;        /* stop after one pass */
    uint8_t env_alternate;   /* flip direction when wrapping */
    uint8_t env_holding;     /* finished */

    /* Per channel volume (0..15) and "use envelope" flag (bit 4 of R8..R10). */
    uint8_t volume[3];
    uint8_t env_chan[3];

    /* Master clock remainder from the previous render call. */
    UInt32 clock_rem;
} PSG;

PSG* psg_create(void);
void psg_destroy(PSG *psg);
void psg_reset(PSG *psg);

/* Select the register that 0xA1 writes / 0xA2 reads. */
void psg_set_reg_latch(PSG *psg, UInt8 value);
UInt8 psg_get_reg_latch(const PSG *psg);

void psg_write(PSG *psg, UInt8 reg, UInt8 value);
UInt8 psg_read(const PSG *psg, UInt8 reg);

/* Render nSamples mono samples covering nMasterCycles master clocks.
 * The generators are only evaluated at sample boundaries, so a register write
 * takes effect on the next sample: with 800 samples per 1/60 s frame this
 * quantises changes to one MSX frame, which is inaudible.
 * Returns the number of samples written (nSamples, or 0 on error). */
unsigned psg_render(PSG *psg, Int16 *out, unsigned nSamples, UInt32 nMasterCycles);

/* Diagnostic: current envelope step / attack pair (for the serial log). */
void psg_get_debug(const PSG *psg, int *pStep, int *pAttack, int *pEnvLevel);

#ifdef __cplusplus
}
#endif

#endif
