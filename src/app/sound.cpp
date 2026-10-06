//
// sound.cpp
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//

#include "sound.h"

#include <circle/sched/scheduler.h>
#include <circle/sound/hdmisoundbasedevice.h>
#include <circle/timer.h>

#include <stdlib.h>
#include <string.h>

// Multiple of 384 sub-frames, as CHDMISoundBaseDevice requires.
#define MSX_SOUND_CHUNK_SIZE	(384 * 10)

// Nominal master clocks in one 1/60 s MSX frame, used when the measured gap
// between two frames is implausible (boot, reset, after the menu was open).
#define MSX_SOUND_NOMINAL_US	(1000000 / 60)

CMsxSound::CMsxSound (CInterruptSystem *pInterrupt, unsigned nSampleRate):
	m_pDevice (0),
	m_nSampleRate (nSampleRate),
	m_nFramesPerVideoFrame (nSampleRate / 60),
	m_pMono (0),
	m_pStereo (0),
	m_nLastTickUs (CTimer::GetClockTicks ()),
	m_nPushedFrames (0),
	m_nDroppedFrames (0),
	m_nPeak (0),
	m_nLastSample (0)
{
	m_pDevice = new CHDMISoundBaseDevice (pInterrupt, m_nSampleRate,
					      MSX_SOUND_CHUNK_SIZE);
	if (m_pDevice != 0)
	{
		m_pMono = new Int16[m_nFramesPerVideoFrame];
	m_pStereo = new Int16[m_nFramesPerVideoFrame * 2];
	}
}

CMsxSound::~CMsxSound (void)
{
	delete [] m_pMono;
	m_pMono = 0;

	delete [] m_pStereo;
	m_pStereo = 0;

	delete m_pDevice;
	m_pDevice = 0;
}

boolean CMsxSound::Start (void)
{
	if (m_pDevice == 0 || m_pMono == 0 || m_pStereo == 0)
	{
		return FALSE;
	}

	if (!m_pDevice->AllocateQueue (MSX_SOUND_QUEUE_MSECS))
	{
		return FALSE;
	}

	m_pDevice->SetWriteFormat (SoundFormatSigned16, 2);

	// Start from a full queue so the first frames do not underrun while the
	// emulator is still warming up. The queue is MSX_SOUND_QUEUE_MSECS deep,
	// i.e. deeper than one video frame, so hand it over in video-frame sized
	// chunks until it is full.
	memset (m_pStereo, 0, m_nFramesPerVideoFrame * 2 * sizeof (Int16));
	unsigned nBytes = m_nFramesPerVideoFrame * 2 * sizeof (Int16);
	unsigned nQueueFrames = m_nSampleRate * MSX_SOUND_QUEUE_MSECS / 1000;

	for (unsigned nFrames = 0; nFrames + m_nFramesPerVideoFrame <= nQueueFrames;
	     nFrames += m_nFramesPerVideoFrame)
	{
		if (m_pDevice->Write (m_pStereo, nBytes) != (int) nBytes)
		{
			// Queue already full: silence was pushed far enough.
			break;
		}
	}

	return m_pDevice->Start ();
}

boolean CMsxSound::IsActive (void) const
{
	return m_pDevice != 0 && m_pDevice->IsActive ();
}

unsigned CMsxSound::PushFrame (MSX_Machine *machine)
{
	if (m_pDevice == 0 || m_pMono == 0 || m_pStereo == 0 || machine == 0 ||
	    !m_pDevice->IsActive ())
	{
		return 0;
	}

	// PSG time follows the real frame duration, so the pitch stays right even
	// when the emulator misses a frame deadline. Keep the previous timestamp
	// updated on every call, otherwise returning from the menu would hand the
	// PSG a huge bogus jump.
	unsigned nNowUs = CTimer::GetClockTicks ();
	unsigned nElapsedUs = nNowUs - m_nLastTickUs;
	m_nLastTickUs = nNowUs;

	unsigned nClocks;
	if (nElapsedUs < 4000 || nElapsedUs > 100000)
	{
		nClocks = MSX_PSG_CLOCKS_PER_FRAME;
	}
	else
	{
		nClocks = (unsigned) ((unsigned long long) nElapsedUs *
				      MSX_PSG_MASTER_CLOCK / 1000000ULL);
	}

	// Render mono, then spread it to both channels. The PSG output is already
	// centred (see psg.c), so this needs no DC offset.
	unsigned nSamples = m_nFramesPerVideoFrame;
	Int16 *pMono = m_pMono;
	unsigned nPeak = 0;
	int nLast = 0;

	if (msx_psg_render (machine, pMono, nSamples, nClocks) != nSamples)
	{
		return 0;
	}

	for (unsigned i = 0; i < nSamples; i++)
	{
		Int16 s = pMono[i];
		int a = s < 0 ? -s : s;

		if ((unsigned) a > nPeak) nPeak = (unsigned) a;

		m_pStereo[i * 2] = s;
		m_pStereo[i * 2 + 1] = s;
		nLast = s;
	}

	m_nPeak = nPeak;
	m_nLastSample = nLast;

	unsigned nBytes = nSamples * 2 * sizeof (Int16);
	int nResult = m_pDevice->Write (m_pStereo, nBytes);

	if (nResult != (int) nBytes)
	{
		// The queue was full: the emulator outran the sound engine. Drop the
		// rest instead of blocking, and let the log show it happened.
		unsigned nWritten = (unsigned) nResult / (2 * sizeof (Int16));
		m_nPushedFrames += nWritten;
		m_nDroppedFrames += nSamples - nWritten;
		return nWritten;
	}

	m_nPushedFrames += nSamples;
	return nSamples;
}
