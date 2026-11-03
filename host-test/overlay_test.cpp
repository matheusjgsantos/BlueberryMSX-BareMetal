//
// overlay_test.cpp
//
// Host test for the on-screen ROM selection menu. Compiles src/app/overlay.cpp
// against stub framebuffer accessors, so the drawing code is checked without
// hardware. Build/run instructions live in HANDOFF.md.
//

#include <circle/types.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern "C" {
#include "msx_font.h"
}

#include "overlay.h"

// vdpblit.h drags in the whole Circle screen stack; declare just the two
// entry points the overlay uses and provide host stubs for them.
struct VDPBlitTarget
{
	void *pBuffer;
	int nPitch;
	int nWidth;
	int nHeight;
	int nDepth;
};

static VDPBlitTarget s_Target;
static boolean s_bTargetValid;
static unsigned s_nRedrawCalls;

boolean VDPBlit_GetTarget (VDPBlitTarget *pTarget)
{
	if (!s_bTargetValid)
	{
		return FALSE;
	}

	*pTarget = s_Target;
	return TRUE;
}

void VDPBlit_Redraw (void)
{
	s_nRedrawCalls++;
}

#define WIDTH	640
#define HEIGHT	480
#define DEPTH	32

static unsigned int s_Fb[HEIGHT * WIDTH];
static unsigned int s_FbBefore[HEIGHT * WIDTH];
static unsigned int s_Fb16[HEIGHT * WIDTH];
static unsigned char s_Guard[HEIGHT * (WIDTH * 4 + 64)];

static int s_nFailures;
static int s_nChecks;

static void check (const char *pName, int bOK)
{
	s_nChecks++;
	if (!bOK)
	{
		s_nFailures++;
		printf ("%-58s FAIL\n", pName);
	}
	else
	{
		printf ("%-58s PASS\n", pName);
	}
}

static unsigned int Pixel (int x, int y)
{
	return s_Fb[y * WIDTH + x];
}

static int CountPixels (unsigned int nRGB)
{
	int n = 0;
	for (int i = 0; i < HEIGHT * WIDTH; i++)
	{
		if (s_Fb[i] == nRGB) n++;
	}
	return n;
}

static void FillBackground (void)
{
	for (int i = 0; i < HEIGHT * WIDTH; i++)
	{
		s_Fb[i] = 0x123456u;
	}
}

// The menu is always drawn with the same machine labels in the app; the test
// supplies them so the label-driven layout can be checked too.
static const char *s_apMachineLabels[] = { "MSX1", "COLECOVISION" };
static const char *s_apShortLabels[] = { "A", "B" };
static const char *s_pAudioLabel = "AUDIO OUT: JACK";
static int s_nMachineSel;

static void Draw (int nSelected)
{
	Overlay_Draw (nSelected, s_apMachineLabels, OVERLAY_MACHINE_OPTIONS,
		      s_nMachineSel, s_pAudioLabel);
}

static int Setup (int nWidth, int nHeight, int nDepth, void *pBuffer)
{
	s_Target.pBuffer = pBuffer;
	s_Target.nPitch = nWidth * (nDepth / 8);
	s_Target.nWidth = nWidth;
	s_Target.nHeight = nHeight;
	s_Target.nDepth = nDepth;
	s_bTargetValid = TRUE;
	s_nRedrawCalls = 0;
	return Overlay_Init ();
}

// Find the highlighted (inverted) item row. The highlight is a filled block of
// one glyph cell, so contiguous rows count as one block. Returns the number of
// blocks and reports the first/last row of the first one.
static int FindHighlight (int nMinX, int nMaxX, int nMinY, int nMaxY,
			  int *pnFirstRow, int *pnLastRow)
{
	int nBlocks = 0, nStart = 0;
	*pnFirstRow = *pnLastRow = -1;

	for (int y = nMinY + 3; y <= nMaxY - 3; y++)
	{
		int nWhite = 0;
		for (int x = nMinX + 2; x <= nMaxX - 2; x++)
		{
			if (Pixel (x, y) == 0xFFFFFFu) nWhite++;
		}

		bool bHigh = nWhite * 10 > 7 * (nMaxX - nMinX);
		if (bHigh && nStart == 0)
		{
			nStart = y;
		}
		else if (!bHigh && nStart != 0)
		{
			nBlocks++;
			if (*pnFirstRow < 0) *pnFirstRow = nStart;
			*pnLastRow = y - 1;
			nStart = 0;
		}
	}

	if (nStart != 0)
	{
		nBlocks++;
		if (*pnFirstRow < 0) *pnFirstRow = nStart;
		*pnLastRow = nMaxY - 3;
	}

	return nBlocks;
}

// Bounding box of the menu: the border and backdrop colours only.
static void FindBox (int *pnMinX, int *pnMaxX, int *pnMinY, int *pnMaxY)
{
	*pnMinX = WIDTH;
	*pnMaxX = -1;
	*pnMinY = HEIGHT;
	*pnMaxY = -1;
	for (int y = 0; y < HEIGHT; y++)
	{
		for (int x = 0; x < WIDTH; x++)
		{
			unsigned int c = Pixel (x, y);
			if (c == 0x101828u || c == 0xFFFFFFu)
			{
				if (x < *pnMinX) *pnMinX = x;
				if (x > *pnMaxX) *pnMaxX = x;
				if (y < *pnMinY) *pnMinY = y;
				if (y > *pnMaxY) *pnMaxY = y;
			}
		}
	}
}

// White glyph pixels inside one text row (border and highlight excluded).
static int CountRowPixels (int nRowY, int nMinX, int nMaxX)
{
	int n = 0;
	for (int y = nRowY; y < nRowY + 8; y++)
	{
		for (int x = nMinX + 2; x <= nMaxX - 2; x++)
		{
			if (Pixel (x, y) == 0xFFFFFFu) n++;
		}
	}
	return n;
}

int main (void)
{
	setbuf (stdout, NULL);
	memset (s_Fb, 0, sizeof(s_Fb));
	s_nMachineSel = 0;

	// ---- Init reports failure without a target -----------------------------
	s_bTargetValid = FALSE;
	check ("init fails without a framebuffer target", !Overlay_Init ());

	// ---- Draw into a 640x480 32bpp target ---------------------------------
	check ("init succeeds with a target", Setup (WIDTH, HEIGHT, DEPTH, s_Fb));
	check ("overlay reports ready", Overlay_IsReady ());

	FillBackground ();
	Draw (0);

	int nBorder = CountPixels (0xFFFFFFu);
	check ("menu draws a white border", nBorder > 200);
	check ("menu fills a backdrop area", CountPixels (0x101828u) > 2000);

	// The box must be centred: find its bounding box.
	int nMinX, nMaxX, nMinY, nMaxY;
	FindBox (&nMinX, &nMaxX, &nMinY, &nMaxY);
	check ("menu box is inside the screen",
	       nMinX >= 0 && nMinY >= 0 && nMaxX < WIDTH && nMaxY < HEIGHT);
	check ("menu box is horizontally centred",
	       abs ((nMinX + nMaxX) / 2 - WIDTH / 2) <= 2);
	check ("menu box is vertically centred",
	       abs ((nMinY + nMaxY) / 2 - HEIGHT / 2) <= 2);
	check ("menu box is wider than tall", (nMaxX - nMinX) > (nMaxY - nMinY));

	// The highlighted (selected) entry is an inverted block exactly one glyph
	// cell tall; everything else is text on the backdrop.
	int nSelY = 0, nSelEnd = 0, nBlocks = 0;
	nBlocks = FindHighlight (nMinX, nMaxX, nMinY, nMaxY, &nSelY, &nSelEnd);
	check ("selection highlight drawn on exactly one block", nBlocks == 1);
	check ("selection highlight is one glyph cell tall",
	       nSelEnd - nSelY == 7);

	// Text glyph pixels must exist inside the box, outside the highlight.
	int nTextPixels = 0;
	for (int y = nMinY + 3; y <= nMaxY - 3; y++)
	{
		if (y >= nSelY && y <= nSelEnd) continue;
		for (int x = nMinX + 2; x <= nMaxX - 2; x++)
		{
			if (Pixel (x, y) == 0xFFFFFFu) nTextPixels++;
		}
	}
	check ("menu contains glyph pixels outside the highlight",
	       nTextPixels > 50);

	// ---- Moving the selection moves the highlight block -------------------
	int nPrevSelY = nSelY;
	FillBackground ();
	Draw (1);
	int nNewSelY = 0, nNewSelEnd = 0;
	nBlocks = FindHighlight (nMinX, nMaxX, nMinY, nMaxY, &nNewSelY, &nNewSelEnd);
	check ("selection moves to the next entry",
	       nBlocks == 1 && nNewSelY > nPrevSelY);

	// ---- Selection is clamped --------------------------------------------
	FillBackground ();
	Draw (-5);
	int nFirstY = 0, nFirstEnd = 0;
	nBlocks = FindHighlight (nMinX, nMaxX, nMinY, nMaxY, &nFirstY, &nFirstEnd);
	check ("out-of-range selection clamps to the first entry",
	       nBlocks == 1 && nFirstY == nPrevSelY);

	FillBackground ();
	Draw (99);
	int nLastY = 0, nLastEnd = 0;
	nBlocks = FindHighlight (nMinX, nMaxX, nMinY, nMaxY, &nLastY, &nLastEnd);
	check ("out-of-range selection clamps to the last entry",
	       nBlocks == 1 && nLastY > nNewSelY);

	// ---- Row model: machine radio group, then carts, then audio ----------
	check ("two machine radio options", OVERLAY_MACHINE_OPTIONS == 2);
	check ("cart rows start after the radio group",
	       OVERLAY_CART_ROW_FIRST == OVERLAY_MACHINE_OPTIONS);
	check ("cart row helper walks the cart list",
	       OVERLAY_CART_ROW (0) == OVERLAY_CART_ROW_FIRST
	       && OVERLAY_CART_ROW (1) == OVERLAY_CART_ROW_FIRST + 1
	       && OVERLAY_CART_ROW (2) == OVERLAY_CART_ROW_FIRST + 2);
	check ("audio row follows the cart rows",
	       OVERLAY_AUDIO_ROW == OVERLAY_CART_ROW (OVERLAY_CART_COUNT - 1) + 1);
	check ("audio row is the last row",
	       OVERLAY_AUDIO_ROW == OVERLAY_ROW_COUNT - 1);
	check ("last row is the audio row", nLastY == nFirstY + (OVERLAY_ROW_COUNT - 1) * (nNewSelY - nFirstY));

	// ---- Machine radio marker -------------------------------------------
	// Park the selection on the audio row so no radio row is inverted, then
	// flip the selected machine: only the two radio rows may change, and the
	// "(*)" marker must move from the first to the second one.
	const int nPitch = nNewSelY - nFirstY;
	FillBackground ();
	s_nMachineSel = 0;
	Draw (OVERLAY_AUDIO_ROW);
	int nRow0Sel0 = CountRowPixels (nFirstY, nMinX, nMaxX);
	int nRow1Sel0 = CountRowPixels (nFirstY + nPitch, nMinX, nMaxX);
	memcpy (s_FbBefore, s_Fb, sizeof (s_FbBefore));

	FillBackground ();
	s_nMachineSel = 1;
	Draw (OVERLAY_AUDIO_ROW);
	int nRow0Sel1 = CountRowPixels (nFirstY, nMinX, nMaxX);
	int nRow1Sel1 = CountRowPixels (nFirstY + nPitch, nMinX, nMaxX);

	int dMinX = WIDTH, dMaxX = -1, dMinY = HEIGHT, dMaxY = -1, nDiff = 0;
	for (int y = 0; y < HEIGHT; y++)
	{
		for (int x = 0; x < WIDTH; x++)
		{
			if (Pixel (x, y) != s_FbBefore[y * WIDTH + x])
			{
				nDiff++;
				if (x < dMinX) dMinX = x;
				if (x > dMaxX) dMaxX = x;
				if (y < dMinY) dMinY = y;
				if (y > dMaxY) dMaxY = y;
			}
		}
	}
	check ("the selected-machine marker is drawn", nRow0Sel0 > nRow0Sel1);
	check ("the marker moves to the other option", nRow1Sel1 > nRow1Sel0);
	check ("changing the machine redraws a few pixels", nDiff > 0 && nDiff < 400);
	check ("changing the machine only touches the radio group",
	       dMinY >= nFirstY && dMaxY <= nFirstY + nPitch + 7
	       && dMinX >= nMinX && dMaxX <= nMaxX);

	// ---- The machine labels drive the radio rows -------------------------
	// The hint line is the widest text, so the box does not resize; the row
	// content must follow the caller's labels instead.
	FillBackground ();
	Overlay_Draw (OVERLAY_AUDIO_ROW, s_apShortLabels, OVERLAY_MACHINE_OPTIONS, 0,
		      s_pAudioLabel);
	int nRow0Short = CountRowPixels (nFirstY, nMinX, nMaxX);
	check ("machine labels are drawn into the row", nRow0Sel0 > nRow0Short);
	check ("short machine labels keep the menu centred",
	       abs ((nMinX + nMaxX) / 2 - WIDTH / 2) <= 2);

	// ---- Empty labels must not crash or draw a bogus row ----------------
	FillBackground ();
	Overlay_Draw (0, NULL, 0, 0, NULL);
	check ("null labels still draw the menu", CountPixels (0xFFFFFFu) > 200);

	// ---- Cart names ------------------------------------------------------
	check ("cart 0 is MSX DIAG", strcmp (Overlay_CartName (0), "MSX DIAG") == 0);
	check ("cart 1 is SLOTS (MSXBUS)", strcmp (Overlay_CartName (1), "SLOTS (MSXBUS)") == 0);
	check ("cart 2 is ROM FROM FILE", strcmp (Overlay_CartName (2), "ROM FROM FILE") == 0);
	check ("cart name is safe out of range", Overlay_CartName (-1)[0] == '\0');
	check ("cart name is safe past the end", Overlay_CartName (77)[0] == '\0');
	check ("cart count matches the label table", OVERLAY_CART_COUNT == 3);

	// ---- RGB565 target ----------------------------------------------------
	memset (s_Fb16, 0, sizeof(s_Fb16));
	check ("init succeeds for a 16bpp target",
	       Setup (WIDTH, HEIGHT, 16, s_Fb16));
	Draw (0);
	unsigned short nBackdrop565 =
		(unsigned short) (((0x101828 >> 8 & 0xF800) | (0x101828 >> 5 & 0x07E0)
				 | (0x101828 >> 3 & 0x001F)));
	int nWhite565 = 0, nBackdropCount = 0, nUntouched = 0;
	for (int i = 0; i < HEIGHT * WIDTH; i++)
	{
		unsigned short c = ((unsigned short *) s_Fb16)[i];
		if (c == 0xFFFF) nWhite565++;
		else if (c == nBackdrop565) nBackdropCount++;
		else if (c == 0) nUntouched++;
	}
	check ("16bpp border converts to 0xFFFF", nWhite565 > 200);
	check ("16bpp backdrop converts to RGB565", nBackdropCount > 2000);
	// The overlay must not clear the screen: everything outside the box keeps
	// the caller's content (zeros here).
	check ("16bpp draw leaves the area around the box untouched",
	       nUntouched > HEIGHT * WIDTH / 2);

	// ---- Target smaller than the menu must clip, not overflow -------------
	// The overlay writes with pitch 2560 for a 120x90 target, so only bytes
	// below 90*2560 may change; the 64-byte guard gap per row catches row
	// wrap-around.
	memset (s_Guard, 0xA5, sizeof(s_Guard));
	s_Target.pBuffer = s_Guard;
	s_Target.nPitch = WIDTH * 4;
	s_Target.nWidth = 120;
	s_Target.nHeight = 90;
	s_Target.nDepth = 32;
	s_bTargetValid = TRUE;
	check ("init succeeds for a tiny target", Overlay_Init ());
	s_nMachineSel = 0;
	Draw (0);
	Draw (1);
	int nCorrupt = 0;
	int nWritten = 0;
	unsigned nValidBytes = (unsigned) (90 * (WIDTH * 4));
	for (unsigned i = 0; i < sizeof(s_Guard); i++)
	{
		int bChanged = s_Guard[i] != 0xA5;
		if (i < nValidBytes)
		{
			nWritten += bChanged;
		}
		else if (bChanged)
		{
			nCorrupt++;
		}
	}
	check ("draw on a tiny target writes inside the target", nWritten > 100);
	check ("draw on a tiny target never writes past it", nCorrupt == 0);

	printf ("\nRESULT: %s (%d checks, %d failures)\n",
		s_nFailures ? "FAIL" : "PASS", s_nChecks, s_nFailures);
	return s_nFailures ? 1 : 0;
}
