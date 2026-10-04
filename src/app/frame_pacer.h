#ifndef MSX_FRAME_PACER_H
#define MSX_FRAME_PACER_H

#include <stdint.h>

// Circle's microsecond clock wraps every ~71 minutes. Signed differences are
// valid while active frame intervals stay below half that range. Reset on pause.
enum { FRAME_TARGET_HZ = 60 };
typedef struct {
	uint32_t deadline;
	unsigned remainder;
	unsigned late;
	unsigned resync;
} FramePacer;

static inline void frame_pacer_reset (FramePacer *p, uint32_t nNow)
	{
		p->deadline = nNow;
		p->remainder = 0;
		p->late = p->resync = 0;
	}

static inline unsigned frame_pacer_finish (FramePacer *p, uint32_t nNow)
	{
		// Carry fractional microseconds: 60 intervals total exactly one second.
		p->deadline += 1000000 / FRAME_TARGET_HZ;
		p->remainder += 1000000 % FRAME_TARGET_HZ;
		if (p->remainder >= FRAME_TARGET_HZ)
		{
			p->deadline++;
			p->remainder -= FRAME_TARGET_HZ;
		}
		int32_t nRemaining = (int32_t) (p->deadline - nNow);
		if (nRemaining >= 0) return (unsigned) nRemaining;

		p->late++;
		// Bound catch-up to less than one frame. A long stall or sustained
		// overload must not accumulate an ever-growing timing debt.
		if (nRemaining <= -(int32_t) ((1000000 + FRAME_TARGET_HZ - 1) / FRAME_TARGET_HZ))
		{
			p->deadline = nNow;
			p->remainder = 0;
			p->resync++;
		}
		return 0;
	}

#endif
