//
// vdpblit.cpp
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#include "vdpblit.h"

#include <string.h>

extern "C"
{
#include "tms9918.h"
}

#define MSX_WIDTH	256
#define MSX_HEIGHT	192

static uint32_t *s_pFrameBuffer = 0;
static int s_nPitchBytes = 0;
static int s_nWidth = 0;
static int s_nHeight = 0;

void VDPBlit_Init (CScreenDevice *pScreen)
{
	CBcmFrameBuffer *pFb = pScreen->GetFrameBuffer ();
	if (pFb == 0)
	{
		return;
	}

	s_pFrameBuffer = (uint32_t *) pFb->GetBuffer ();
	s_nPitchBytes = pFb->GetPitch ();
	s_nWidth = pFb->GetWidth ();
	s_nHeight = pFb->GetHeight ();
}

// Strong override of the weak hook in msx.c: called once per VDP frame.
extern "C" void msx_frame_render (void *pVdp)
{
	if (s_pFrameBuffer == 0)
	{
		return;
	}

	int nXOff = (s_nWidth > MSX_WIDTH) ? (s_nWidth - MSX_WIDTH) / 2 : 0;
	int nYOff = (s_nHeight > MSX_HEIGHT) ? (s_nHeight - MSX_HEIGHT) / 2 : 0;

	uint32_t *pDst = s_pFrameBuffer + (nYOff * s_nPitchBytes / 4) + nXOff;
	tms9918_render ((const TMS9918 *) pVdp, pDst, s_nPitchBytes);
}
