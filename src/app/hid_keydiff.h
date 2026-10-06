//
// hid_keydiff.h
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//
// Usage-based diff of two USB HID keyboard reports.
//
// A HID report carries up to six key usages in an array whose *slots* carry no
// meaning: keyboards pack the array in scan order, so releasing one key shifts
// the others down. A handler that compares report[i] with the previous
// report[i] therefore releases keys that are still held and drops the press of
// the next one - which shows up in a game as "the character stalls when I press
// a second key".
//
// This helper compares by usage code instead, so the order of the array is
// irrelevant. It only reports *changes* (at most 12 per report), which keeps
// the USB IRQ handler short.
//
// Header-only and static inline so it can be unit tested on the host, the same
// way frame_pacer.h and ui_queue.h are.
//

#ifndef _msx_hid_keydiff_h
#define _msx_hid_keydiff_h

#define HID_REPORT_KEYS 6

typedef struct
{
	unsigned char aPrev [HID_REPORT_KEYS];

	// Usages that went down since the previous report, in report order.
	unsigned char aPressed [HID_REPORT_KEYS];
	unsigned nPressed;

	// Usages that are no longer down, in previous-report order.
	unsigned char aReleased [HID_REPORT_KEYS];
	unsigned nReleased;
}
CHidKeyDiff;

static inline void HidKeyDiff_Init (CHidKeyDiff *pDiff)
{
	for (unsigned i = 0; i < HID_REPORT_KEYS; i++)
	{
		pDiff->aPrev[i] = 0;
	}
	pDiff->nPressed = 0;
	pDiff->nReleased = 0;
}

static inline int HidKeyDiff_Holds (const CHidKeyDiff *pDiff, unsigned char ucUsage)
{
	for (unsigned i = 0; i < HID_REPORT_KEYS; i++)
	{
		if (pDiff->aPrev[i] == ucUsage)
		{
			return 1;
		}
	}

	return 0;
}

// Diff pReport (HID_REPORT_KEYS usages, 0 = empty slot) against the previous
// report and remember it. A usage reported twice in one report is one key.
static inline void HidKeyDiff_Update (CHidKeyDiff *pDiff,
	const unsigned char *pReport)
{
	unsigned char aPrev [HID_REPORT_KEYS];
	for (unsigned i = 0; i < HID_REPORT_KEYS; i++)
	{
		aPrev[i] = pDiff->aPrev[i];
	}

	pDiff->nPressed = 0;
	pDiff->nReleased = 0;

	for (unsigned i = 0; i < HID_REPORT_KEYS; i++)
	{
		unsigned char ucUsage = pReport[i];
		if (ucUsage == 0 || HidKeyDiff_Holds (pDiff, ucUsage))
		{
			continue;
		}

		// Guard against a keyboard that reports the same usage in two slots.
		int bDuplicate = 0;
		for (unsigned j = 0; j < pDiff->nPressed; j++)
		{
			if (pDiff->aPressed[j] == ucUsage)
			{
				bDuplicate = 1;
				break;
			}
		}
		if (!bDuplicate && pDiff->nPressed < HID_REPORT_KEYS)
		{
			pDiff->aPressed[pDiff->nPressed++] = ucUsage;
		}
	}

	for (unsigned i = 0; i < HID_REPORT_KEYS; i++)
	{
		unsigned char ucUsage = aPrev[i];
		if (ucUsage == 0)
		{
			continue;
		}

		int bStillDown = 0;
		for (unsigned j = 0; j < HID_REPORT_KEYS; j++)
		{
			if (pReport[j] == ucUsage)
			{
				bStillDown = 1;
				break;
			}
		}
		if (bStillDown)
		{
			continue;
		}

		int bDuplicate = 0;
		for (unsigned j = 0; j < pDiff->nReleased; j++)
		{
			if (pDiff->aReleased[j] == ucUsage)
			{
				bDuplicate = 1;
				break;
			}
		}
		if (!bDuplicate && pDiff->nReleased < HID_REPORT_KEYS)
		{
			pDiff->aReleased[pDiff->nReleased++] = ucUsage;
		}
	}

	for (unsigned i = 0; i < HID_REPORT_KEYS; i++)
	{
		pDiff->aPrev[i] = pReport[i];
	}
}

#endif
