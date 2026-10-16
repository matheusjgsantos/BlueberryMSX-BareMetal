//
// overlay.cpp
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#include "overlay.h"
#include "vdpblit.h"

#include "msx_font.h"

#include <string.h>

// Menu palette (RGB888, converted to the framebuffer depth on the fly).
#define OV_BACKDROP	0x101828u
#define OV_BORDER	0xFFFFFFu
#define OV_SHADOW	0x000000u
#define OV_TEXT		0xFFFFFFu
#define OV_TEXT_DIM	0x8090A8u
#define OV_TITLE	0xFF6060u
#define OV_SELECT_BG	0xFFFFFFu
#define OV_SELECT_FG	0x101828u

static const char *s_apCartNames[OVERLAY_CART_COUNT] = {
	"MSX DIAG",
	"SLOTS (MSXBUS)",
	"ROM FROM FILE",
};

static const char *s_apTitle = "SELECT MSX ROM";
static const char *s_apHint = "UP/DOWN SELECT   ENTER BOOT/SET   ESC CLOSE";

static void *s_pBuffer = 0;
static int s_nPitch = 0;
static int s_nWidth = 0;
static int s_nHeight = 0;
static int s_nDepth = 0;

boolean Overlay_Init (void)
{
	VDPBlitTarget Target;

	if (!VDPBlit_GetTarget (&Target))
	{
		return FALSE;
	}

	s_pBuffer = Target.pBuffer;
	s_nPitch = Target.nPitch;
	s_nWidth = Target.nWidth;
	s_nHeight = Target.nHeight;
	s_nDepth = Target.nDepth;
	return TRUE;
}

boolean Overlay_IsReady (void)
{
	return s_pBuffer != 0;
}

const char *Overlay_CartName (int nIndex)
{
	if (nIndex < 0 || nIndex >= OVERLAY_CART_COUNT)
	{
		return "";
	}

	return s_apCartNames[nIndex];
}

static void PutPixel (int x, int y, unsigned int nRGB)
{
	if (x < 0 || y < 0 || x >= s_nWidth || y >= s_nHeight)
	{
		return;
	}

	unsigned char *pRow = (unsigned char *) s_pBuffer + y * s_nPitch;
	if (s_nDepth == 16)
	{
		((unsigned short *) pRow)[x] =
			(unsigned short) (((nRGB >> 8) & 0xF800) |
					  ((nRGB >> 5) & 0x07E0) |
					  ((nRGB >> 3) & 0x001F));
	}
	else
	{
		((unsigned int *) pRow)[x] = nRGB;
	}
}

static void FillRect (int x, int y, int w, int h, unsigned int nRGB)
{
	if (x < 0)
	{
		w += x;
		x = 0;
	}
	if (y < 0)
	{
		h += y;
		y = 0;
	}
	if (x + w > s_nWidth)
	{
		w = s_nWidth - x;
	}
	if (y + h > s_nHeight)
	{
		h = s_nHeight - y;
	}

	// Same clipping as before, but the row is filled with a run of stores
	// instead of one bounds-checked PutPixel call per pixel.
	unsigned int nPixel = s_nDepth == 16
		? (((nRGB >> 8) & 0xF800) | ((nRGB >> 5) & 0x07E0) | ((nRGB >> 3) & 0x001F))
		: nRGB;

	unsigned char *pBase = (unsigned char *) s_pBuffer + y * s_nPitch;
	if (s_nDepth == 16)
	{
		for (int row = 0; row < h; row++, pBase += s_nPitch)
		{
			unsigned short *pOut = (unsigned short *) (pBase + x * 2);
			for (int col = 0; col < w; col++)
			{
				pOut[col] = (unsigned short) nPixel;
			}
		}
	}
	else
	{
		for (int row = 0; row < h; row++, pBase += s_nPitch)
		{
			unsigned int *pOut = (unsigned int *) (pBase + x * 4);
			for (int col = 0; col < w; col++)
			{
				pOut[col] = nPixel;
			}
		}
	}
}

// Draw an 8x8 MSX font string, scaled by nScale, with the glyph cell
// background filled so the text is readable over the menu box.
static void DrawText (int x, int y, const char *pText,
	unsigned int nFG, unsigned int nBG, int nScale)
{
	for (const char *p = pText; *p != '\0'; p++)
	{
		unsigned char ucChar = (unsigned char) *p;
		if (ucChar < 0x20 || ucChar > 0x7F)
		{
			ucChar = '?';
		}

		const unsigned char *pGlyph = k_msx_font + ucChar * 8;
		for (int py = 0; py < 8; py++)
		{
			unsigned char ucBits = pGlyph[py];
			for (int px = 0; px < 8; px++)
			{
				unsigned int nColor = (ucBits & (0x80 >> px)) ? nFG : nBG;
				for (int sy = 0; sy < nScale; sy++)
				{
					for (int sx = 0; sx < nScale; sx++)
					{
						PutPixel (x + px * nScale + sx,
							  y + py * nScale + sy,
							  nColor);
					}
				}
			}
		}

		x += 8 * nScale;
	}
}

static int TextWidth (const char *pText, int nScale)
{
	int nLen = 0;
	while (pText[nLen] != '\0')
	{
		nLen++;
	}
	return nLen * 8 * nScale;
}

void Overlay_Draw (int nSelected, const char *pAudioLabel)
{
	if (!Overlay_IsReady ())
	{
		return;
	}

	if (pAudioLabel == 0)
	{
		pAudioLabel = "";
	}

	// Rows: 0..OVERLAY_CART_COUNT-1 cartridges, then the audio row.
	int nRows = OVERLAY_CART_COUNT + 1;

	if (nSelected < 0)
	{
		nSelected = 0;
	}
	if (nSelected >= nRows)
	{
		nSelected = nRows - 1;
	}

	// Keep the whole menu on screen: at least 1x, grow while it fits.
	int nScale = s_nHeight / 300;
	if (nScale < 1)
	{
		nScale = 1;
	}

	int nCell = 8 * nScale;
	int nTitleW = TextWidth (s_apTitle, nScale);
	int nHintW = TextWidth (s_apHint, nScale);
	int nItemW = 0;
	for (int i = 0; i < nRows; i++)
	{
		const char *pRow = i < OVERLAY_CART_COUNT ? s_apCartNames[i]
							 : pAudioLabel;
		int w = TextWidth (pRow, nScale);
		if (w > nItemW) nItemW = w;
	}
	// +2 cells for the "> " cursor column.
	int nTextW = nItemW + 2 * nCell;
	if (nTitleW > nTextW) nTextW = nTitleW;
	if (nHintW > nTextW) nTextW = nHintW;

	int nBoxW = nTextW + 4 * nCell;
	// Rows: outer border, gap, dim line (3) + title (1) + one per cartridge
	// + audio row + gap (1) + hint (1) + dim line, gap, outer border (3).
	int nBoxH = (OVERLAY_CART_COUNT + 10) * nCell;
	if (nBoxW > s_nWidth) nBoxW = s_nWidth;
	if (nBoxH > s_nHeight) nBoxH = s_nHeight;

	int nBoxX = (s_nWidth - nBoxW) / 2;
	int nBoxY = (s_nHeight - nBoxH) / 2;
	if (nBoxX < 0) nBoxX = 0;
	if (nBoxY < 0) nBoxY = 0;

	// Drop shadow, box, then a double border.
	FillRect (nBoxX + nCell, nBoxY + nCell, nBoxW, nBoxH, OV_SHADOW);
	FillRect (nBoxX, nBoxY, nBoxW, nBoxH, OV_BACKDROP);
	for (int i = 0; i < nBoxW; i++)
	{
		PutPixel (nBoxX + i, nBoxY, OV_BORDER);
		PutPixel (nBoxX + i, nBoxY + nBoxH - 1, OV_BORDER);
	}
	for (int i = 0; i < nBoxH; i++)
	{
		PutPixel (nBoxX, nBoxY + i, OV_BORDER);
		PutPixel (nBoxX + nBoxW - 1, nBoxY + i, OV_BORDER);
	}
	for (int i = 2; i < nBoxW - 2; i++)
	{
		PutPixel (nBoxX + i, nBoxY + 2, OV_TEXT_DIM);
		PutPixel (nBoxX + i, nBoxY + nBoxH - 3, OV_TEXT_DIM);
	}

	int nTextX = nBoxX + (nBoxW - nTextW) / 2;
	int nY = nBoxY + 3 * nCell;

	DrawText (nBoxX + (nBoxW - nTitleW) / 2, nY, s_apTitle, OV_TEXT, OV_BACKDROP, nScale);
	nY += nCell;

	for (int i = 0; i < nRows; i++)
	{
		const char *pRow = i < OVERLAY_CART_COUNT ? s_apCartNames[i]
							 : pAudioLabel;
		int nRowW = nTextW - nCell;
		int nRowX = nTextX + nCell / 2;
		bool bSelected = (i == nSelected);

		FillRect (nRowX - nCell / 2, nY, nRowW, nCell,
			  bSelected ? OV_SELECT_BG : OV_BACKDROP);

		if (bSelected)
		{
			DrawText (nRowX, nY, ">", OV_SELECT_FG, OV_SELECT_BG, nScale);
		}
		DrawText (nRowX + 2 * nCell, nY, pRow,
			  bSelected ? OV_SELECT_FG : OV_TEXT,
			  bSelected ? OV_SELECT_BG : OV_BACKDROP, nScale);
		nY += nCell;
	}

	nY += nCell;
	DrawText (nBoxX + (nBoxW - nHintW) / 2, nY, s_apHint,
		  OV_TEXT_DIM, OV_BACKDROP, nScale);
}

void Overlay_DrawBrowser (const char *pDir, const char *const *apItems,
			  int nCount, int nSel, int nScroll)
{
	if (!Overlay_IsReady ())
	{
		return;
	}

	if (pDir == 0 || pDir[0] == '\0')
	{
		pDir = "/";
	}

	int nScale = s_nHeight / 300;
	if (nScale < 1)
	{
		nScale = 1;
	}

	int nCell = 8 * nScale;

	// Visible rows: at least 1, at most OVERLAY_BROWSER_ROWS, and never
	// more than the number of entries.
	int nRows = nCount < OVERLAY_BROWSER_ROWS ? nCount : OVERLAY_BROWSER_ROWS;
	if (nRows < 1)
	{
		nRows = 1;
	}

	if (nScroll < 0)
	{
		nScroll = 0;
	}
	if (nSel < nScroll)
	{
		nScroll = nSel;
	}
	if (nSel >= nScroll + nRows)
	{
		nScroll = nSel - nRows + 1;
	}
	if (nScroll > nCount - nRows && nCount >= nRows)
	{
		nScroll = nCount - nRows;
	}

	static const char *apTitle = "LOAD ROM FROM SD";
	static const char *apHint = "UP/DOWN MOVE  ENTER SELECT  ESC BACK";

	int nTitleW = TextWidth (apTitle, nScale);
	int nDirW = TextWidth (pDir, nScale);
	int nHintW = TextWidth (apHint, nScale);

	int nItemW = 0;
	for (int i = 0; i < nRows; i++)
	{
		int nIdx = nScroll + i;
		const char *pRow = nIdx < nCount ? apItems[nIdx] : "";
		int w = TextWidth (pRow, nScale);
		if (w > nItemW) nItemW = w;
	}

	int nTextW = nItemW + 2 * nCell;	// cursor column
	if (nTitleW > nTextW) nTextW = nTitleW;
	if (nDirW > nTextW) nTextW = nDirW;
	if (nHintW > nTextW) nTextW = nHintW;

	int nBoxW = nTextW + 4 * nCell;
	int nBoxH = (nRows + 7) * nCell;

	if (nBoxW > s_nWidth) nBoxW = s_nWidth;
	if (nBoxH > s_nHeight) nBoxH = s_nHeight;

	int nBoxX = (s_nWidth - nBoxW) / 2;
	int nBoxY = (s_nHeight - nBoxH) / 2;
	if (nBoxX < 0) nBoxX = 0;
	if (nBoxY < 0) nBoxY = 0;

	FillRect (nBoxX + nCell, nBoxY + nCell, nBoxW, nBoxH, OV_SHADOW);
	FillRect (nBoxX, nBoxY, nBoxW, nBoxH, OV_BACKDROP);
	for (int i = 0; i < nBoxW; i++)
	{
		PutPixel (nBoxX + i, nBoxY, OV_BORDER);
		PutPixel (nBoxX + i, nBoxY + nBoxH - 1, OV_BORDER);
	}
	for (int i = 0; i < nBoxH; i++)
	{
		PutPixel (nBoxX, nBoxY + i, OV_BORDER);
		PutPixel (nBoxX + nBoxW - 1, nBoxY + i, OV_BORDER);
	}
	for (int i = 2; i < nBoxW - 2; i++)
	{
		PutPixel (nBoxX + i, nBoxY + 2, OV_TEXT_DIM);
		PutPixel (nBoxX + i, nBoxY + nBoxH - 3, OV_TEXT_DIM);
	}

	int nY = nBoxY + 3 * nCell;
	DrawText (nBoxX + (nBoxW - nTitleW) / 2, nY, apTitle,
		  OV_TEXT, OV_BACKDROP, nScale);
	nY += nCell;

	DrawText (nBoxX + (nBoxW - TextWidth (pDir, nScale)) / 2, nY, pDir,
		  OV_TEXT_DIM, OV_BACKDROP, nScale);
	nY += nCell;

	int nTextX = nBoxX + (nBoxW - nTextW) / 2;
	for (int i = 0; i < nRows; i++)
	{
		int nIdx = nScroll + i;
		const char *pRow = nIdx < nCount ? apItems[nIdx] : "";
		int nRowW = nTextW - nCell;
		int nRowX = nTextX + nCell / 2;
		bool bSelected = nIdx < nCount && nIdx == nSel;

		FillRect (nRowX - nCell / 2, nY, nRowW, nCell,
			  bSelected ? OV_SELECT_BG : OV_BACKDROP);

		if (bSelected)
		{
			DrawText (nRowX, nY, ">", OV_SELECT_FG, OV_SELECT_BG, nScale);
		}
		DrawText (nRowX + 2 * nCell, nY, pRow,
			  bSelected ? OV_SELECT_FG : OV_TEXT,
			  bSelected ? OV_SELECT_BG : OV_BACKDROP, nScale);
		nY += nCell;
	}

	nY += nCell;
	DrawText (nBoxX + (nBoxW - nHintW) / 2, nY, apHint,
		  OV_TEXT_DIM, OV_BACKDROP, nScale);
}

void Overlay_ShowError (const char *pTitle, const char *pDetail, const char *pHint)
{
	if (!Overlay_IsReady ())
	{
		return;
	}

	if (pTitle == 0)  pTitle = "";
	if (pDetail == 0) pDetail = "";
	if (pHint == 0)   pHint = "";

	// Same growth rule as the menu: at least 1x, larger on big displays.
	int nScale = s_nHeight / 300;
	if (nScale < 1)
	{
		nScale = 1;
	}

	int nCell = 8 * nScale;

	int nTitleW  = TextWidth (pTitle, nScale);
	int nDetailW = TextWidth (pDetail, nScale);
	int nHintW   = TextWidth (pHint, nScale);

	int nTextW = nTitleW;
	if (nDetailW > nTextW) nTextW = nDetailW;
	if (nHintW > nTextW) nTextW = nHintW;

	int nBoxW = nTextW + 4 * nCell;
	int nBoxH = 8 * nCell;
	if (nBoxW > s_nWidth)  nBoxW = s_nWidth;
	if (nBoxH > s_nHeight) nBoxH = s_nHeight;

	int nBoxX = (s_nWidth - nBoxW) / 2;
	int nBoxY = (s_nHeight - nBoxH) / 2;
	if (nBoxX < 0) nBoxX = 0;
	if (nBoxY < 0) nBoxY = 0;

	// Black page, then the same shadow/box/double-border style as the menu.
	FillRect (0, 0, s_nWidth, s_nHeight, OV_SHADOW);
	FillRect (nBoxX + nCell, nBoxY + nCell, nBoxW, nBoxH, OV_SHADOW);
	FillRect (nBoxX, nBoxY, nBoxW, nBoxH, OV_BACKDROP);
	for (int i = 0; i < nBoxW; i++)
	{
		PutPixel (nBoxX + i, nBoxY, OV_BORDER);
		PutPixel (nBoxX + i, nBoxY + nBoxH - 1, OV_BORDER);
	}
	for (int i = 0; i < nBoxH; i++)
	{
		PutPixel (nBoxX, nBoxY + i, OV_BORDER);
		PutPixel (nBoxX + nBoxW - 1, nBoxY + i, OV_BORDER);
	}
	for (int i = 2; i < nBoxW - 2; i++)
	{
		PutPixel (nBoxX + i, nBoxY + 2, OV_TITLE);
		PutPixel (nBoxX + i, nBoxY + nBoxH - 3, OV_TEXT_DIM);
	}

	DrawText (nBoxX + (nBoxW - nTitleW) / 2, nBoxY + 2 * nCell, pTitle,
		  OV_TITLE, OV_BACKDROP, nScale);

	// Dim divider between the title and the detail line.
	for (int i = nCell; i < nBoxW - nCell; i++)
	{
		PutPixel (nBoxX + i, nBoxY + 3 * nCell, OV_TEXT_DIM);
	}

	DrawText (nBoxX + (nBoxW - nDetailW) / 2, nBoxY + 4 * nCell, pDetail,
		  OV_TEXT, OV_BACKDROP, nScale);
	DrawText (nBoxX + (nBoxW - nHintW) / 2, nBoxY + 5 * nCell, pHint,
		  OV_TEXT_DIM, OV_BACKDROP, nScale);
}
