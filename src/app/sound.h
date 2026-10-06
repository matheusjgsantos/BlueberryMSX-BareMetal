//
// sound.h
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//
// AY-3-8910 PSG output. On Raspberry Pi 3 the only sound path that reaches the
// TV is the HDMI/S-PPDIF one (I2S needs an external DAC on GPIO21/22 and never
// touches HDMI), so this uses Circle's CHDMISoundBaseDevice in DMA mode.
//

#ifndef _msx_sound_h
#define _msx_sound_h

#include <circle/types.h>
#include <circle/interrupt.h>
#include <circle/sound/soundbasedevice.h>

#include <msx.h>

// 48000 Hz is what the HDMI audio info frame wants and 48000/60 is a whole
// number, so one emulated video frame is exactly 800 stereo frames.
#define MSX_SOUND_SAMPLE_RATE		48000
#define MSX_SOUND_FRAMES_PER_VIDEO_FRAME	(MSX_SOUND_SAMPLE_RATE / 60)

// Queue depth in milliseconds. 100 ms absorbs a scheduling hiccup; deeper
// would only add latency.
#define MSX_SOUND_QUEUE_MSECS		100

class CMsxSound
{
public:
	CMsxSound (CInterruptSystem *pInterrupt,
		   unsigned nSampleRate = MSX_SOUND_SAMPLE_RATE);
	~CMsxSound (void);

	// Allocates the queue and starts the device. Must be called once.
	boolean Start (void);

	boolean IsActive (void) const;

	// Render one emulated video frame of PSG samples and queue them for the
	// DMA engine. Returns the number of audio frames handed over; a short
	// result means the queue was full (the emulator must never block on
	// sound, so the remainder is dropped).
	unsigned PushFrame (MSX_Machine *machine);

	// Diagnostics for the serial log.
	unsigned GetPushedFrames (void) const	{ return m_nPushedFrames; }
	unsigned GetDroppedFrames (void) const	{ return m_nDroppedFrames; }
	unsigned GetPeakSample (void) const	{ return m_nPeak; }
	int GetLastSample (void) const		{ return m_nLastSample; }
	const char *GetDeviceName (void) const	{ return "sndhdmi"; }

private:
	CSoundBaseDevice *m_pDevice;
	unsigned m_nSampleRate;
	unsigned m_nFramesPerVideoFrame;

	// One emulated frame of scratch space: mono from the PSG, then interleaved
	// stereo for the device.
	Int16 *m_pMono;
	Int16 *m_pStereo;

	// CTimer::GetClockTicks() (1 MHz) of the previous PushFrame call, so the
	// PSG advances by the time the emulator really used instead of a fixed
	// nominal frame length.
	unsigned m_nLastTickUs;

	unsigned m_nPushedFrames;
	unsigned m_nDroppedFrames;
	unsigned m_nPeak;
	int m_nLastSample;
};

#endif
