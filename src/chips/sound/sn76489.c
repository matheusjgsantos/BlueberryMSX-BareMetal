#include "sn76489.h"

#include <string.h>

#define SN_MASTER_CLOCK 3579545u
#define SN_TICKS_PER_CLOCK 16u

static void sn_noise_reset(SN76489 *sn)
{
    /* openMSX's floodRight(pattern) seed is top-bit-only for both modes. */
    sn->noise_rng = 0x4000u;
}

void sn76489_reset(SN76489 *sn)
{
    if (!sn) return;
    memset(sn, 0, sizeof(*sn));
    for (unsigned channel = 0; channel < 4; ++channel)
        sn->reg[channel * 2 + 1] = 0x0F;
    sn_noise_reset(sn);
}

void sn76489_write(SN76489 *sn, UInt8 value)
{
    unsigned reg;
    UInt16 next;
    if (!sn) return;
    if (value & 0x80) sn->latch = (value >> 4) & 7;
    reg = sn->latch;
    if (reg == 0 || reg == 2 || reg == 4) {
        next = (value & 0x80)
            ? (UInt16)((sn->reg[reg] & 0x3F0) | (value & 0x0F))
            : (UInt16)((sn->reg[reg] & 0x00F) | ((value & 0x3F) << 4));
    } else if (reg == 6) {
        next = value & 7;
    } else {
        next = value & 0x0F;
    }
    sn->reg[reg] = next;
    if (reg == 6) sn_noise_reset(sn);
}

static UInt32 sn_period(const SN76489 *sn, unsigned channel)
{
    if (channel == 3 && (sn->reg[6] & 3) != 3)
        return 16u << (sn->reg[6] & 3);
    UInt32 period = sn->reg[2 * channel];
    return period ? period : 0x400u;
}

static Int16 sn_mix(const SN76489 *sn)
{
    static const UInt16 amplitude[16] = {
        8191, 6508, 5169, 4106, 3261, 2590, 2058, 1635,
        1299, 1032, 820, 651, 517, 411, 326, 0
    };
    Int32 mix = 0;
    for (unsigned ch = 0; ch < 4; ++ch) {
        unsigned level = amplitude[sn->reg[2 * ch + 1] & 15];
        unsigned high = ch == 3
            ? ((~sn->noise_rng) & 1)
            : sn->output[ch];
        mix += high ? (Int32)level : -(Int32)level;
    }
    if (mix > 32767) mix = 32767;
    if (mix < -32768) mix = -32768;
    return (Int16)mix;
}

static Int16 sn_advance(SN76489 *sn, UInt32 ticks)
{
    for (UInt32 t = 0; t < ticks; ++t) {
        for (unsigned ch = 0; ch < 3; ++ch) {
            if (sn->counter[ch] == 0) {
                sn->output[ch] ^= 1;
                sn->counter[ch] = (UInt16)sn_period(sn, ch);
                if (ch == 2 && (sn->reg[6] & 3) == 3 && sn->output[ch]) {
                    UInt32 pattern = (sn->reg[6] & 4) ? 0x6000u : 0x4000u;
                    sn->noise_rng = (sn->noise_rng >> 1) ^
                        ((sn->noise_rng & 1) ? pattern : 0);
                }
            }
            --sn->counter[ch];
        }
        if ((sn->reg[6] & 3) != 3) {
            if (sn->counter[3] == 0) {
                sn->output[3] ^= 1;
                sn->counter[3] = (UInt16)sn_period(sn, 3);
                if (sn->output[3]) {
                    UInt32 pattern = (sn->reg[6] & 4) ? 0x6000u : 0x4000u;
                    sn->noise_rng = (sn->noise_rng >> 1) ^
                        ((sn->noise_rng & 1) ? pattern : 0);
                }
            }
            --sn->counter[3];
        }
    }
    return sn_mix(sn);
}

/* Average the DAC states across this sample's chip-clock interval, matching
 * the AY adapter's boxcar integration and avoiding point-sampling aliasing. */
static Int16 sn_advance_avg(SN76489 *sn, UInt32 ticks)
{
    if (ticks == 0) return sn_mix(sn);
    Int32 sum = 0;
    for (UInt32 i = 0; i < ticks; ++i)
        sum += sn_advance(sn, 1);
    return (Int16)(sum / (Int32)ticks);
}

unsigned sn76489_render(SN76489 *sn, Int16 *out, unsigned samples,
                        UInt32 masterCycles)
{
    UInt32 ticks, acc = 0;
    if (!sn || !out || !samples) return 0;
    if (masterCycles > SN_MASTER_CLOCK * 10u)
        masterCycles = SN_MASTER_CLOCK * 10u;
    sn->clock_rem += masterCycles;
    ticks = sn->clock_rem / SN_TICKS_PER_CLOCK;
    sn->clock_rem %= SN_TICKS_PER_CLOCK;
    for (unsigned i = 0; i < samples; ++i) {
        acc += ticks;
        UInt32 n = acc / samples;
        acc -= n * samples;
        out[i] = sn_advance_avg(sn, n);
    }
    return samples;
}
