//
// vdpblit.h
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#ifndef _msx_vdpblit_h
#define _msx_vdpblit_h

#include <circle/screen.h>

// Initialize the blit target. Call once from the main task after screen init.
void VDPBlit_Init (CScreenDevice *pScreen);

#endif
