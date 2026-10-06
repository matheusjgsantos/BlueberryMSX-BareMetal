//
// hid_keydiff_test.c
//
// Host test for the usage-based USB HID report diff (src/app/hid_keydiff.h).
//
// The hardware bug this guards against: a keyboard repacks its six-slot key
// array between reports, so a per-slot diff releases keys that are still held.
// "Hold LEFT, press RIGHT" then produced release(LEFT) + press(RIGHT) +
// press(LEFT) followed later by a spurious release(LEFT): the game saw the
// character stall.
//

#include <stdio.h>
#include <string.h>
#include "hid_keydiff.h"

#define KEY_A	0x04
#define KEY_B	0x05
#define KEY_LEFT	0x50
#define KEY_RIGHT	0x4F
#define KEY_UP		0x52
#define KEY_DOWN	0x51
#define F1		0x3A
#define F2		0x3B
#define F3		0x3C
#define F4		0x3D
#define F5		0x3E
#define F6		0x3F

static int s_nChecks;
static int s_nFailures;

static void check (const char *pName, int bOK)
{
	s_nChecks++;
	if (!bOK)
	{
		s_nFailures++;
		printf ("%-62s FAIL\n", pName);
	}
	else
	{
		printf ("%-62s PASS\n", pName);
	}
}

// Simulates the guest key matrix: a set of usages that are currently down.
typedef struct
{
	CHidKeyDiff Diff;
	unsigned char aDown [256];
	int nPress;
	int nRelease;
} CSim;

static void report (CSim *pSim, const unsigned char *pReport)
{
	HidKeyDiff_Update (&pSim->Diff, pReport);

	// Releases first, exactly like the kernel handler does.
	for (unsigned i = 0; i < pSim->Diff.nReleased; i++)
	{
		unsigned char uc = pSim->Diff.aReleased[i];
		if (pSim->aDown[uc])
		{
			pSim->aDown[uc] = 0;
			pSim->nRelease++;
		}
	}
	for (unsigned i = 0; i < pSim->Diff.nPressed; i++)
	{
		unsigned char uc = pSim->Diff.aPressed[i];
		if (!pSim->aDown[uc])
		{
			pSim->aDown[uc] = 1;
			pSim->nPress++;
		}
	}
}

static int isDown (const CSim *pSim, unsigned char uc)
{
	return pSim->aDown[uc] != 0;
}

static const unsigned char s_Empty[6] = {0, 0, 0, 0, 0, 0};

int main (void)
{
	CSim S;

	setbuf (stdout, NULL);

	// ---- Baseline --------------------------------------------------------
	CSim *p = &S;
	memset (p, 0, sizeof (*p));
	HidKeyDiff_Init (&p->Diff);
	report (p, s_Empty);
	check ("idle report produces no events", p->nPress == 0 && p->nRelease == 0);

	{
		static const unsigned char aA[] = {KEY_A, 0, 0, 0, 0, 0};
		static const unsigned char aARepeat[] = {KEY_A, 0, 0, 0, 0, 0};
		report (p, aA);
		check ("single key press is one press", p->nPress == 1 && p->nRelease == 0);
		check ("key A is down", isDown (p, KEY_A));
		report (p, aARepeat);
		check ("unchanged report produces no events", p->nPress == 1 && p->nRelease == 0);
		report (p, s_Empty);
		check ("release is one release", p->nRelease == 1 && !isDown (p, KEY_A));
		check ("total events: 1 press, 1 release", p->nPress == 1 && p->nRelease == 1);
	}

	// ---- The hardware bug: hold LEFT, press RIGHT, keyboard repacks ------
	{
		static const unsigned char aLeft[] = {KEY_LEFT, 0, 0, 0, 0, 0};
		// Right added *before* left: the array is repacked, slot 0 changes.
		static const unsigned char aBoth[] = {KEY_RIGHT, KEY_LEFT, 0, 0, 0, 0};
		static const unsigned char aBothSwap[] = {KEY_LEFT, KEY_RIGHT, 0, 0, 0, 0};
		static const unsigned char aLeftAgain[] = {KEY_LEFT, 0, 0, 0, 0, 0};

		memset (p, 0, sizeof (*p));
		HidKeyDiff_Init (&p->Diff);
		report (p, aLeft);
		check ("bug setup: LEFT down", p->nPress == 1 && isDown (p, KEY_LEFT));

		report (p, aBoth);
		check ("repack: LEFT is NOT released", isDown (p, KEY_LEFT) && p->nRelease == 0);
		check ("repack: RIGHT is pressed exactly once",
		       isDown (p, KEY_RIGHT) && p->nPress == 2);

		// Keyboard may swap the two slots on the next report: no events at all.
		report (p, aBothSwap);
		check ("slot swap with both held: no events",
		       p->nPress == 2 && p->nRelease == 0 &&
		       isDown (p, KEY_LEFT) && isDown (p, KEY_RIGHT));

		// RIGHT released, LEFT still held (repacked again into slot 0).
		report (p, aLeftAgain);
		check ("RIGHT released while LEFT stays down",
		       !isDown (p, KEY_RIGHT) && isDown (p, KEY_LEFT) && p->nRelease == 1);

		report (p, s_Empty);
		check ("final release, both up",
		       !isDown (p, KEY_LEFT) && p->nPress == 2 && p->nRelease == 2);
	}

	// ---- Reverse order: hold RIGHT, press LEFT ---------------------------
	{
		static const unsigned char aRight[] = {KEY_RIGHT, 0, 0, 0, 0, 0};
		static const unsigned char aBoth[] = {KEY_LEFT, KEY_RIGHT, 0, 0, 0, 0};

		memset (p, 0, sizeof (*p));
		HidKeyDiff_Init (&p->Diff);
		report (p, aRight);
		report (p, aBoth);
		check ("reverse: LEFT added, RIGHT still down",
		       isDown (p, KEY_LEFT) && isDown (p, KEY_RIGHT) &&
		       p->nPress == 2 && p->nRelease == 0);
		report (p, aRight);
		check ("reverse: LEFT released, RIGHT kept",
		       !isDown (p, KEY_LEFT) && isDown (p, KEY_RIGHT) && p->nRelease == 1);
	}

	// ---- Full six-key array, released from the middle -------------------
	{
		static const unsigned char aSix[] =
			{F1, F2, F3, F4, F5, F6, 0, 0, 0, 0, 0, 0};
		static const unsigned char aFive[] = {F1, F2, F3, F4, F5, 0};

		memset (p, 0, sizeof (*p));
		HidKeyDiff_Init (&p->Diff);
		report (p, aSix);
		check ("six keys: six presses", p->nPress == 6 && p->nRelease == 0);
		report (p, aFive);
		check ("six to five: only F6 released", p->nRelease == 1 &&
		       !isDown (p, F6) && isDown (p, F1) && isDown (p, F5));
		report (p, aFive);
		check ("five held, unchanged report: no events",
		       p->nPress == 6 && p->nRelease == 1);
		report (p, s_Empty);
		check ("release all five at once", p->nRelease == 6);
	}

	// ---- Rotating permutation of the same three keys --------------------
	{
		static const unsigned char aP0[] = {KEY_UP, KEY_DOWN, KEY_LEFT, 0, 0, 0};
		static const unsigned char aP1[] = {KEY_DOWN, KEY_LEFT, KEY_UP, 0, 0, 0};
		static const unsigned char aP2[] = {KEY_LEFT, KEY_UP, KEY_DOWN, 0, 0, 0};

		memset (p, 0, sizeof (*p));
		HidKeyDiff_Init (&p->Diff);
		report (p, aP0);
		report (p, aP1);
		report (p, aP2);
		check ("rotating permutation of held keys: no events",
		       p->nPress == 3 && p->nRelease == 0 &&
		       isDown (p, KEY_UP) && isDown (p, KEY_DOWN) && isDown (p, KEY_LEFT));
	}

	// ---- Duplicate usage in one report ----------------------------------
	{
		static const unsigned char aDup[] = {KEY_A, KEY_A, 0, 0, 0, 0};
		static const unsigned char aOne[] = {KEY_A, 0, 0, 0, 0, 0};

		memset (p, 0, sizeof (*p));
		HidKeyDiff_Init (&p->Diff);
		report (p, aDup);
		check ("duplicate usage yields one press", p->nPress == 1);
		report (p, s_Empty);
		report (p, aOne);
		check ("re-press after release works", p->nPress == 2 && p->nRelease == 1);
	}

	// ---- Gap in the array: {A, 0, B} style sparse reports ---------------
	{
		static const unsigned char aSparse[] = {KEY_UP, 0, KEY_DOWN, 0, KEY_LEFT, 0};

		memset (p, 0, sizeof (*p));
		HidKeyDiff_Init (&p->Diff);
		report (p, aSparse);
		check ("sparse array: three presses", p->nPress == 3 && p->nRelease == 0);
		report (p, aSparse);
		check ("sparse array repeat: no events", p->nPress == 3 && p->nRelease == 0);
		report (p, s_Empty);
		check ("sparse array: three releases", p->nRelease == 3);
	}

	// ---- Init clears stale state ----------------------------------------
	{
		static const unsigned char aA[] = {KEY_A, 0, 0, 0, 0, 0};

		memset (p, 0, sizeof (*p));
		HidKeyDiff_Init (&p->Diff);
		report (p, aA);
		check ("pre-init check: A down", isDown (p, KEY_A));

		// The kernel clears both tables in its constructor.
		memset (p, 0, sizeof (*p));
		HidKeyDiff_Init (&p->Diff);
		check ("Init clears the previous report",
		       HidKeyDiff_Holds (&p->Diff, KEY_A) == 0);
		report (p, aA);
		check ("press after Init is reported again",
		       p->nPress == 1 && p->nRelease == 0 && isDown (p, KEY_A));
	}

	printf ("\nRESULT: %s (%d failures, %d checks)\n",
		s_nFailures ? "FAIL" : "PASS", s_nFailures, s_nChecks);
	return s_nFailures ? 1 : 0;
}
