//
// sound.cpp
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//

#include "sound.h"

#include <circle/sched/scheduler.h>
#include <circle/sound/hdmisoundbasedevice.h>
#include <circle/timer.h>
#include <vc4/sound/vchiqsoundbasedevice.h>

#include <stdlib.h>
#include <string.h>

// Multiple of 384 sub-frames, as CHDMISoundBaseDevice requires (fallback).
#define MSX_SOUND_CHUNK_SIZE	(384 * 10)

// Samples per VCHIQ transfer (Circle default). ~42 ms at 48000 Hz stereo.
#define MSX_SOUND_VCHIQ_CHUNK	4000

CMsxSound::CMsxSound (CVCHIQDevice *pVCHIQDevice, CInterruptSystem *pInterrupt,
		      unsigned nSampleRate):
	m_pDevice (0),
	m_pVCHIQDevice (pVCHIQDevice),
	m_pInterrupt (pInterrupt),
	m_pDeviceName ("none"),
	m_nSampleRate (nSampleRate),
	m_nMaxFrames (nSampleRate * MSX_SOUND_MAX_MSECS / 1000),
	m_nSampleRem (0),
	m_pMono (0),
	m_pStereo (0),
	m_nLastTickUs (CTimer::GetClockTicks ()),
	m_nPushedFrames (0),
	m_nDroppedFrames (0),
	m_nPeak (0),
	m_nLastSample (0),
	m_nClockTotal (0),
	m_nPushUsMax (0),
	m_nOutput (MSX_OUTPUT_JACK)
{
	// Preferred path: firmware audio service over VCHIQ with an explicit
	// destination. AUTO would make the firmware feed the jack AND HDMI
	// from the same stream (dual-drive); we boot on the jack and let the
	// overlay menu switch to HDMI at runtime (SetOutput). Without a VCHIQ
	// device (or if Start() fails, see below) the direct HDMI driver is
	// used, which only reaches HDMI.
	if (pVCHIQDevice != 0)
	{
		m_pDevice = new CVCHIQSoundBaseDevice (pVCHIQDevice,
					       m_nSampleRate,
					       MSX_SOUND_VCHIQ_CHUNK,
					       VCHIQSoundDestinationHeadphones);
		m_pDeviceName = "sndvchiq";
	}
	else
	{
		m_pDevice = new CHDMISoundBaseDevice (pInterrupt, m_nSampleRate,
						      MSX_SOUND_CHUNK_SIZE);
		m_pDeviceName = "sndhdmi";
		m_nOutput = MSX_OUTPUT_HDMI;
	}

	if (m_pDevice != 0)
	{
		m_pMono = new Int16[m_nMaxFrames];
		m_pStereo = new Int16[m_nMaxFrames * 2];
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

boolean CMsxSound::TryStartDevice (void)
{
	if (m_pDevice == 0)
	{
		return FALSE;
	}

	if (!m_pDevice->AllocateQueue (MSX_SOUND_QUEUE_MSECS))
	{
		return FALSE;
	}

	m_pDevice->SetWriteFormat (SoundFormatSigned16, 2);

	// Start from half the queue (MSX_SOUND_PREFILL_MSECS): a full prefill
	// left zero headroom for the firmware's bursty pulls, so every pull
	// cycle ended in an overflow drop - a gap in the waveform, heard as
	// rasp/crackle. Push silence batches until the queue holds its target.
	memset (m_pStereo, 0, m_nMaxFrames * 2 * sizeof (Int16));
	unsigned nBytes = m_nMaxFrames * 2 * sizeof (Int16);
	unsigned nTarget = m_pDevice->GetQueueSizeFrames () / 2;

	while (m_pDevice->GetQueueFramesAvail () < nTarget)
	{
		if (m_pDevice->Write (m_pStereo, nBytes) <= 0)
		{
			break;	// defensive: no progress, do not spin
		}
	}

	return m_pDevice->Start ();
}

boolean CMsxSound::Start (void)
{
	if (m_pDevice == 0 || m_pMono == 0 || m_pStereo == 0)
	{
		return FALSE;
	}

	if (TryStartDevice ())
	{
		m_nLastTickUs = CTimer::GetClockTicks ();	// first push measures from Start(), not the ctor
		return TRUE;
	}

	// VCHIQ path failed (service missing, firmware refused, ...): fall back
	// to the direct HDMI driver, which needs no firmware service.
	if (m_pVCHIQDevice != 0)
	{
		delete m_pDevice;
		m_pDevice = new CHDMISoundBaseDevice (m_pInterrupt,
						      m_nSampleRate,
						      MSX_SOUND_CHUNK_SIZE);
		m_pDeviceName = "sndhdmi";
		m_nOutput = MSX_OUTPUT_HDMI;

		if (m_pDevice != 0 && TryStartDevice ())
		{
			m_nLastTickUs = CTimer::GetClockTicks ();
			return TRUE;
		}
	}

	return FALSE;
}

boolean CMsxSound::IsActive (void) const
{
	return m_pDevice != 0 && m_pDevice->IsActive ();
}

unsigned CMsxSound::GetQueueFrames (void) const
{
	if (m_pDevice == 0 || !m_pDevice->IsActive ())
	{
		return 0;
	}

	return m_pDevice->GetQueueFramesAvail ();
}

unsigned CMsxSound::PushFrame (MSX_Machine *machine)
{
	if (m_pDevice == 0 || m_pMono == 0 || m_pStereo == 0 || machine == 0 ||
	    !m_pDevice->IsActive ())
	{
		return 0;
	}

	// The device consumes at a fixed m_nSampleRate, so size the batch from
	// the wall clock: samples = elapsed * rate. The fractional remainder is
	// carried across frames, keeping the long-term rate exact. A fixed
	// per-frame batch underfeeds the device whenever the emulator runs
	// below 60 fps; the queue then stays permanently starved and every
	// VCHIQ chunk pull is padded with silence (constant artifacts), and the
	// queue never recovers because production can never exceed 60 fps.
	unsigned nNowUs = CTimer::GetClockTicks ();
	unsigned nElapsedUs = nNowUs - m_nLastTickUs;
	m_nLastTickUs = nNowUs;

	// Clamp long stalls (boot, menu, reset) to the maximum batch. The clamp
	// equals the prefill level, so the stall drains the queue and the
	// clamped push refills it exactly back to prefill (MSX_SOUND_MAX_MSECS).
	if (nElapsedUs > MSX_SOUND_MAX_MSECS * 1000)
	{
		nElapsedUs = MSX_SOUND_MAX_MSECS * 1000;
	}

	unsigned long long nAccum = (unsigned long long) nElapsedUs * m_nSampleRate
				    + m_nSampleRem;
	unsigned nSamples = (unsigned) (nAccum / 1000000);
	m_nSampleRem = (unsigned) (nAccum % 1000000);

	if (nSamples == 0)
	{
		return 0;
	}
	if (nSamples > m_nMaxFrames)
	{
		nSamples = m_nMaxFrames;	// cannot happen; defensive clamp
	}

	// PSG time follows the real interval too, so pitch stays right even
	// when a frame misses its deadline.
	unsigned nClocks = (unsigned) ((unsigned long long) nElapsedUs *
				      MSX_PSG_MASTER_CLOCK / 1000000ULL);

	// Execution timer around the heavy part (render + interleave + queue
	// write), reported as worst-case through the SB beacon: this is the
	// "wrap a timer around your chunk-filling logic" check.
	unsigned nT0 = CTimer::GetClockTicks ();

	// Render mono, then spread it to both channels. The PSG output is already
	// centred (see psg.c), so this needs no DC offset.
	Int16 *pMono = m_pMono;
	unsigned nPeak = 0;
	int nLast = 0;

	if (msx_psg_render (machine, pMono, nSamples, nClocks) != nSamples)
	{
		return 0;
	}

	m_nClockTotal += nClocks;

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

	unsigned nPushUs = CTimer::GetClockTicks () - nT0;
	if (nPushUs > m_nPushUsMax)
	{
		m_nPushUsMax = nPushUs;
	}

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

boolean CMsxSound::SetOutput (int nOutput)
{
	if (m_pDevice == 0 || nOutput < MSX_OUTPUT_AUTO || nOutput > MSX_OUTPUT_HDMI)
	{
		return FALSE;
	}

	// Only the VCHIQ firmware device has a destination to switch; the
	// direct HDMI fallback is fixed. SetControl() blocks on the VCHIQ
	// completion event, so the caller must be on core 0.
	if (strcmp (m_pDeviceName, "sndvchiq") == 0)
	{
		static_cast<CVCHIQSoundBaseDevice *> (m_pDevice)
			->SetControl (VCHIQ_SOUND_VOLUME_DEFAULT,
				      (TVCHIQSoundDestination) nOutput);
		m_nOutput = nOutput;
		return TRUE;
	}

	return FALSE;
}
