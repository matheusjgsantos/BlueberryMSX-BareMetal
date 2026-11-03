#ifndef SN76489_H
#define SN76489_H

#include "msx_types.h"

/* TI SN76489AN discrete sound generator, modeled from openMSX SN76489.cc. */
typedef struct {
    UInt16 reg[8];
    UInt8 latch;
    UInt16 counter[4];
    UInt8 output[4];
    UInt32 noise_rng;
    UInt32 clock_rem;
} SN76489;

void sn76489_reset(SN76489 *sn);
void sn76489_write(SN76489 *sn, UInt8 value);
unsigned sn76489_render(SN76489 *sn, Int16 *out, unsigned samples,
                        UInt32 masterCycles);

#endif
