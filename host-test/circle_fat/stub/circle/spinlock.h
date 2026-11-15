//
// Minimal host-build stand-in for circle/spinlock.h (single-threaded test).
//
#ifndef _circle_spinlock_h
#define _circle_spinlock_h

#include <circle/types.h>

#ifndef TASK_LEVEL
#define TASK_LEVEL	0
#endif

class CSpinLock
{
public:
	CSpinLock (unsigned nTargetLevel = TASK_LEVEL)
	:	m_nTargetLevel (nTargetLevel)
	{
	}

	void Acquire (void)
	{
	}

	void Release (void)
	{
	}

	unsigned GetTargetLevel (void) const
	{
		return m_nTargetLevel;
	}

private:
	unsigned m_nTargetLevel;
};

#endif
