//
// vdpblit.cpp
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#include "vdpblit.h"
#include "framebuffer_blit.h"

#include <string.h>
#include <stdio.h>

extern "C"
{
#include "tms9918.h"
}

#define MSX_WIDTH	256
#define MSX_HEIGHT	192

static void *s_pFrameBuffer = 0;
static int s_nDepth = 0;
static int s_nPitchBytes = 0;
static int s_nWidth = 0;
static int s_nHeight = 0;
static uint32_t s_TempFrame [MSX_WIDTH * MSX_HEIGHT];

static VDPBlitDumpFunc s_pDumpFunc = 0;
static void *s_pDumpUser = 0;
static unsigned long s_nFrame = 0;

void VDPBlit_Init (CScreenDevice *pScreen)
{
	CBcmFrameBuffer *pFb = pScreen->GetFrameBuffer ();
	if (pFb == 0)
	{
		return;
	}

	s_nDepth = pFb->GetDepth ();
	if (s_nDepth != 16 && s_nDepth != 32) return;
	s_pFrameBuffer = (void *) pFb->GetBuffer ();
	s_nPitchBytes = pFb->GetPitch ();
	s_nWidth = pFb->GetWidth ();
	s_nHeight = pFb->GetHeight ();
}

void VDPBlit_SetDumpHook (VDPBlitDumpFunc pFunc, void *pUser)
{
	s_pDumpFunc = pFunc;
	s_pDumpUser = pUser;
}

void VDPBlit_GetDiagnostics (char *pBuffer, unsigned nSize)
{
	unsigned nDifferent = 0;
	uint32_t nHash = 2166136261u;
	for (unsigned i = 0; i < MSX_WIDTH * MSX_HEIGHT; i++)
	{
		uint32_t nRGB = s_TempFrame[i] & 0xFFFFFFu;
		if (nRGB != (s_TempFrame[0] & 0xFFFFFFu)) nDifferent++;
		nHash = (nHash ^ nRGB) * 16777619u;
	}
	snprintf (pBuffer, nSize,
		"VIDEO: ready=%u rgb0=%06X different=%u hash=%08X fb=%dx%d pitch=%d depth=%d",
		(unsigned) (s_pFrameBuffer != 0 && s_nFrame != 0),
		(unsigned) (s_TempFrame[0] & 0xFFFFFFu), nDifferent,
		(unsigned) nHash, s_nWidth, s_nHeight, s_nPitchBytes, s_nDepth);
}

// Strong override of the weak hook in msx.c: called once per VDP frame.
extern "C" void msx_frame_render (void *pVdp)
{
	if (s_pFrameBuffer == 0)
	{
		return;
	}

	tms9918_render ((const TMS9918 *) pVdp, s_TempFrame, MSX_WIDTH * 4);

	s_nFrame++;

	// Capture a handful of frames across the first ~15s to SD card (PPM).
	if (s_pDumpFunc != 0)
	{
		static const unsigned long s_nCaptureAt[] = {
			1, 30, 60, 90, 150, 300, 600, 900
		};
		for (unsigned i = 0; i < sizeof(s_nCaptureAt) / sizeof(s_nCaptureAt[0]); i++)
		{
			if (s_nFrame == s_nCaptureAt[i])
			{
				static unsigned char s_RGB [MSX_WIDTH * MSX_HEIGHT * 3];
				for (unsigned long p = 0; p < MSX_WIDTH * MSX_HEIGHT; p++)
				{
					uint32_t v = s_TempFrame [p];
					s_RGB [p * 3 + 0] = (unsigned char) ((v >> 16) & 0xFF);
					s_RGB [p * 3 + 1] = (unsigned char) ((v >>  8) & 0xFF);
					s_RGB [p * 3 + 2] = (unsigned char) ( v        & 0xFF);
				}
				s_pDumpFunc (s_RGB, sizeof(s_RGB), (unsigned) s_nFrame, s_pDumpUser);
				break;
			}
		}
	}

	msx_blit_frame (s_pFrameBuffer, s_nWidth, s_nHeight, s_nPitchBytes,
		       s_nDepth, s_TempFrame);
}
