//
// Minimal host-build stand-in for circle/timer.h (local time unused by the test).
//
#ifndef _circle_timer_h
#define _circle_timer_h

#include <circle/types.h>

class CTimer
{
public:
	static CTimer *Get (void)
	{
		static CTimer Instance;
		return &Instance;
	}

	u32 GetLocalTime (void) const
	{
		return 0x00210000;	// 2001-01-01 00:00:00
	}

	u32 GetTicks (void) const
	{
		return 0;
	}

	static boolean IsLeapYear (unsigned nYear)
	{
		return    nYear % 4 == 0
		       && (nYear % 100 != 0 || nYear % 400 == 0);
	}

	static unsigned GetDaysOfMonth (unsigned nMonth, unsigned nYear)
	{
		static const unsigned Days[12] =
			{ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

		if (nMonth < 1 || nMonth > 12)
		{
			return 0;
		}

		unsigned nDays = Days[nMonth - 1];
		if (nMonth == 2 && IsLeapYear (nYear))
		{
			nDays++;
		}

		return nDays;
	}
};

#endif
