#include "psg.h"

#include <stdlib.h>
#include <string.h>

/* AY-3-8910 master clock in Hz. */
#define PSG_MASTER_CLOCK   3579545

/* One emulation tick = 16 master clocks (openMSX NATIVE_FREQ = master/16). */
#define PSG_TICKS_PER_CLOCK 16

/* Volume table: 2^((v-15)/4) of full scale, v=0 is silent. openMSX derives
 * this from its logarithmic YM2149 table as volumeTab[v] = YM[2*v+1]. */
static const Int16 s_aPsgVolume[16] = {
    0, 2896, 3443, 4096, 4871, 5792, 6887, 8192,
    9742, 11585, 13774, 16384, 19484, 23170, 27547, 32767
};

/* AY8910 register read masks (openMSX AY8910::readRegister). */
static const uint8_t s_aPsgRegMask[16] = {
    0xFF, 0x0F, 0xFF, 0x0F, 0xFF, 0x0F, 0x1F, 0xFF,
    0x1F, 0x1F, 0x1F, 0xFF, 0xFF, 0x0F, 0xFF, 0xFF
};

/* openMSX noise: 17 bit LFSR, input is bit0 XOR bit3, Galois form. */
static UInt32 psg_noise_step(UInt32 rng)
{
    return (rng >> 1) ^ ((rng & 1) << 13) ^ ((rng & 1) << 16);
}

PSG* psg_create(void)
{
    PSG *psg = (PSG *)calloc(1, sizeof(PSG));
    if (!psg) return NULL;

    psg_reset(psg);
    return psg;
}

void psg_destroy(PSG *psg)
{
    free(psg);
}

void psg_reset(PSG *psg)
{
    if (!psg) return;

    memset(psg, 0, sizeof(PSG));

    /* openMSX: period = max(1, value) for tone/noise, and the envelope period
     * is at least one tick. Counters start at 0. */
    for (int chan = 0; chan < 3; chan++)
    {
        psg->tone_period[chan] = 1;
        psg->tone_count[chan] = 0;
        psg->tone_out[chan] = 0;
    }

    psg->noise_period = 2;
    psg->noise_count = 0;
    psg->noise_rng = 1;

    psg->env_period = 1;
    psg->env_count = 0;
    psg->env_step = 0x1F;
    psg->env_attack = 0;
}

void psg_set_reg_latch(PSG *psg, UInt8 value)
{
    if (!psg) return;

    psg->reg_latch = value & 0x0F;
}

UInt8 psg_get_reg_latch(const PSG *psg)
{
    return psg ? psg->reg_latch : 0;
}

/* Reload a tone counter from its fine/coarse pair (R0/R1, R2/R3, R4/R5). */
static void psg_set_tone_period(PSG *psg, int chan)
{
    UInt16 period = (UInt16) (psg->reg[chan * 2] + 256 * (psg->reg[chan * 2 + 1] & 0x0F));
    if (period < 1) period = 1;               /* period 0 behaves like 1 */

    psg->tone_period[chan] = period;
    if (psg->tone_count[chan] > period - 1)
    {
        psg->tone_count[chan] = period - 1;
    }
}

static void psg_set_env_shape(PSG *psg, UInt8 shape)
{
    /* openMSX Envelope::setShape. 16 shapes, 32 internal steps:
     *   C At Al H
     *   0  0  x  x  \___
     *   0  1  x  x  /___
     *   1  0  0  0  \\\\
     *   1  0  0  1  \___
     *   1  0  1  0  \/\/
     *   1  0  1  1  \
     *   1  1  0  0  ////
     *   1  1  0  1  /
     *   1  1  1  0  /\/\
     *   1  1  1  1  /___
     */
    psg->env_attack = (shape & 0x04) ? 0x1F : 0x00;
    if ((shape & 0x08) == 0)
    {
        /* Continue = 0: run the equivalent Continue = 1 shape exactly once. */
        psg->env_hold = 1;
        psg->env_alternate = psg->env_attack != 0;
    }
    else
    {
        psg->env_hold = (shape & 0x01) ? 1 : 0;
        psg->env_alternate = (shape & 0x02) ? 1 : 0;
    }

    psg->env_count = 0;
    psg->env_step = 0x1F;
    psg->env_holding = 0;
}

static void psg_env_steps(PSG *psg, int steps)
{
    if (psg->env_holding || steps <= 0) return;

    psg->env_step -= steps;

    if (psg->env_step < 0)
    {
        if (psg->env_hold)
        {
            if (psg->env_alternate) psg->env_attack ^= 0x1F;
            psg->env_holding = 1;
            psg->env_step = 0;
        }
        else
        {
            /* If the step counter looped an odd number of times, invert. */
            if (psg->env_alternate && (psg->env_step & 0x10))
            {
                psg->env_attack ^= 0x1F;
            }
            psg->env_step &= 0x1F;
        }
    }
}

void psg_write(PSG *psg, UInt8 reg, UInt8 value)
{
    if (!psg || reg >= 16) return;

    /* Unused bits are stored too, they can be read back. */
    psg->reg[reg] = value;

    switch (reg)
    {
    case 0: case 1:
    case 2: case 3:
    case 4: case 5:
        psg_set_tone_period(psg, reg >> 1);
        break;

    case 6:
    {
        /* Half the tone frequency; period 0 sounds the same as period 1. */
        UInt16 period = (UInt16) ((value & 0x1F) ? (value & 0x1F) : 1);
        psg->noise_period = (UInt16) (2 * period);
        if (psg->noise_count > psg->noise_period - 1)
        {
            psg->noise_count = (UInt16) (psg->noise_period - 1);
        }
        break;
    }

    case 7:
        /* Mixer (bits 0-2 tone, 3-5 noise) and IO port directions (6-7).
         * Both are read straight from reg[7] by the mixer. */
        break;

    case 8: case 9: case 10:
        psg->volume[reg - 8] = value & 0x0F;
        psg->env_chan[reg - 8] = (value & 0x10) ? 1 : 0;
        break;

    case 11: case 12:
    {
        /* Envelope period = EFINE + 256*ECOARSE (R12 mask 0x0F is applied by
         * the register mask on read only, the full byte counts here). */
        UInt32 period = (UInt32) psg->reg[11] + 256 * psg->reg[12];
        if (period < 1) period = 1;
        psg->env_period = (UInt16) (period > 0xFFFF ? 0xFFFF : period);
        if (psg->env_count > psg->env_period - 1)
        {
            psg->env_count = (UInt16) (psg->env_period - 1);
        }
        break;
    }

    case 13:
        psg_set_env_shape(psg, value & 0x0F);
        break;

    default:
        break;
    }
}

UInt8 psg_read(const PSG *psg, UInt8 reg)
{
    if (!psg || reg >= 16) return 0xFF;

    /* I/O ports A/B (R14/R15): while the port direction bit in R7 is
     * clear the port is an input, and a read returns the external pins
     * instead of the register latch (openMSX AY8910::peekRegister does
     * the same via periphery.readA/readB).  Nothing is attached to the
     * MSX PSG ports, so the pins read 0xFF (pull-ups).  Knightmare's
     * input routine reads R14 with R7=0xB8 (port A input) and would
     * treat a 0x00 latch read as "joystick held in all directions with
     * both triggers pressed", which is what broke keyboard input there.
     * With the direction bit set the port is an output and the latch
     * reads back, like the real chip. */
    if (reg == 14 && !(psg->reg[7] & 0x40)) return 0xFF;
    if (reg == 15 && !(psg->reg[7] & 0x80)) return 0xFF;

    return (UInt8) (psg->reg[reg] & s_aPsgRegMask[reg]);
}

/* Advance every generator by nTicks emulation ticks and return the mixed
 * sample. Tone and noise counters run even when the mixer disables them, like
 * on the real chip. */
static Int16 psg_advance(PSG *psg, UInt32 nTicks)
{
    if (nTicks > 0)
    {
        for (int chan = 0; chan < 3; chan++)
        {
            UInt32 period = psg->tone_period[chan];
            UInt32 total = psg->tone_count[chan] + nTicks;
            UInt32 toggles = total / period;

            psg->tone_count[chan] = (UInt16) (total - toggles * period);

            /* Only the parity matters: the output is a square wave. */
            psg->tone_out[chan] ^= (uint8_t) (toggles & 1);
        }

        {
            UInt32 period = psg->noise_period;
            UInt32 total = psg->noise_count + nTicks;
            UInt32 steps = total / period;

            psg->noise_count = (UInt16) (total - steps * period);
            while (steps-- > 0)
            {
                psg->noise_rng = psg_noise_step(psg->noise_rng);
            }
        }

        {
            UInt32 period = psg->env_period;
            UInt32 total = psg->env_count + nTicks;
            UInt32 steps = total / period;

            psg->env_count = (UInt16) (total - steps * period);
            psg_env_steps(psg, (int) steps);
        }
    }

    /* Envelope level: openMSX indexes its 32 entry table with step^attack,
     * where every 16 level step appears twice and entries 0/1 are silent. */
    int env_index = psg->env_step ^ psg->env_attack;
    int env_level = (env_index >= 2) ? (env_index >> 1) : 0;

    uint8_t mixer = psg->reg[7];
    int noise_out = (int) (psg->noise_rng & 1);
    Int32 mix = 0;

    for (int chan = 0; chan < 3; chan++)
    {
        /* (ToneOn | ToneDisabled) & (NoiseOn | NoiseDisabled): the bit is 1
         * when tone AND noise are both switched off in R7. */
        int on = (psg->tone_out[chan] | ((mixer >> chan) & 1)) &
                 (noise_out | ((mixer >> (3 + chan)) & 1));
        int level = psg->env_chan[chan] ? env_level : (int) psg->volume[chan];

        /* The chip sums three unipolar DACs around a bias point. Emitting
         * +amplitude/-amplitude instead of amplitude/0 keeps the output
         * centred, so no DC offset eats the headroom. */
        mix += on ? s_aPsgVolume[level] : -s_aPsgVolume[level];
    }

    if (mix > 32767) mix = 32767;
    if (mix < -32768) mix = -32768;

    return (Int16) mix;
}

unsigned psg_render(PSG *psg, Int16 *out, unsigned nSamples, UInt32 nMasterCycles)
{
    if (!psg || !out || nSamples == 0) return 0;

    /* Accumulate the master clock remainder so the PSG clock stays exact over
     * many frames (a frame is not a whole number of 16 clock ticks). One MSX
     * frame is about 59659 master clocks, so 16 bits already covers any
     * sane caller and keeps the accumulator from overflowing after a stall. */
    if (nMasterCycles > 0xFFFFu)
    {
        nMasterCycles = 0xFFFFu;
    }

    psg->clock_rem += nMasterCycles;

    UInt32 ticks = psg->clock_rem / PSG_TICKS_PER_CLOCK;
    psg->clock_rem &= (PSG_TICKS_PER_CLOCK - 1);

    /* Spread the ticks evenly over the samples; the extra ones go to the first
     * samples so the total stays exact. */
    UInt32 per_sample = ticks / nSamples;
    UInt32 extra = ticks % nSamples;

    for (unsigned i = 0; i < nSamples; i++)
    {
        UInt32 n = per_sample + ((i < extra) ? 1 : 0);
        out[i] = psg_advance(psg, n);
    }

    return nSamples;
}

void psg_get_debug(const PSG *psg, int *pStep, int *pAttack, int *pEnvLevel)
{
    int step = 0, attack = 0, level = 0;

    if (psg)
    {
        int index;
        step = psg->env_step;
        attack = psg->env_attack;
        index = step ^ attack;
        level = (index >= 2) ? (index >> 1) : 0;
    }

    if (pStep) *pStep = step;
    if (pAttack) *pAttack = attack;
    if (pEnvLevel) *pEnvLevel = level;
}
