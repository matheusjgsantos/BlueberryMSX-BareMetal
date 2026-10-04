//
// vdpblit.h
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#ifndef _msx_vdpblit_h
#define _msx_vdpblit_h

#include <circle/screen.h>
#include <circle/types.h>

// Initialize the blit target. Call once from the main task after screen init.
void VDPBlit_Init (CScreenDevice *pScreen);

// Summarize the last rendered source frame without reading VDP status ports.
void VDPBlit_GetDiagnostics (char *pBuffer, unsigned nSize);

// Frame-dump hook: pFunc(pRGB, 256*192*3, nFrame, pUser) is called once per
// captured frame, before the blit. pRGB is 8bpp RGB (not ARGB).
typedef void (*VDPBlitDumpFunc) (const unsigned char *pRGB,
                                 unsigned int nBytes,
                                 unsigned int nFrame,
                                 void *pUser);
void VDPBlit_SetDumpHook (VDPBlitDumpFunc pFunc, void *pUser);

#endif
