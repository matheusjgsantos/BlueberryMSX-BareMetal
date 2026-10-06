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
#define OVERLAY_CART_COUNT 2

// Cache the framebuffer geometry. Call once after VDPBlit_Init(). Returns
// FALSE when the screen target is unusable, in which case the menu is inert.
boolean Overlay_Init (void);

// True when the menu can be drawn (i.e. Overlay_Init succeeded).
boolean Overlay_IsReady (void);

// Draw the menu with nSelected highlighted. No-op when not ready.
void Overlay_Draw (int nSelected);

// Menu entry labels, indexed like CKernel::GetCartName().
const char *Overlay_CartName (int nIndex);

#endif
