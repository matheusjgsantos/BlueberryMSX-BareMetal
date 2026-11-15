//
// Minimal host-build stand-in for circle/sysconfig.h.
// Only the macros the FAT sources actually consult are needed.
//
#ifndef _circle_sysconfig_h
#define _circle_sysconfig_h

// Deliberately no NO_BUSY_WAIT: CGenericLock then uses the (stubbed)
// CSpinLock instead of the scheduler mutex.
#undef NO_BUSY_WAIT

#define RASPPI		3
#define AARCH		64

#endif
