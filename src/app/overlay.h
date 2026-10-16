//
// overlay.h
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//
// On-screen ROM selection menu drawn straight into the screen framebuffer.
// Drawn from the MSX task only; the USB IRQ handler never touches the screen.
//

#ifndef _msx_overlay_h
#define _msx_overlay_h

#include <circle/types.h>

// Number of entries in the menu; must match the cartridge list in kernel.cpp.
#define OVERLAY_CART_COUNT 3

// Cache the framebuffer geometry. Call once after VDPBlit_Init(). Returns
// FALSE when the screen target is unusable, in which case the menu is inert.
boolean Overlay_Init (void);

// True when the menu can be drawn (i.e. Overlay_Init succeeded).
boolean Overlay_IsReady (void);

// Draw the menu with nSelected highlighted. pAudioLabel names the current
// audio output (e.g. "AUDIO OUT: JACK") on the bottom row; NULL draws it
// empty. No-op when not ready.
void Overlay_Draw (int nSelected, const char *pAudioLabel);

// Draw a full-screen, bordered fatal-error page (title, a detail line and a
// hint line) straight into the framebuffer. Used for boot failures that must
// be visible even when the serial log is disabled and the MSX task (which
// normally owns the screen) has not started yet. No-op when not ready.
void Overlay_ShowError (const char *pTitle, const char *pDetail, const char *pHint);

// Menu entry labels, indexed like CKernel::GetCartName().
const char *Overlay_CartName (int nIndex);

// File browser page: pDir is the current directory ("/" for root),
// apItems[nCount] are the display entries, nSel the highlighted index and
// nScroll the first visible item. Draws a scrollable list. No-op when not
// ready.
#define OVERLAY_BROWSER_ROWS 10
void Overlay_DrawBrowser (const char *pDir, const char *const *apItems,
			  int nCount, int nSel, int nScroll);

#endif
