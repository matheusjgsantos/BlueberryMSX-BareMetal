//
// sound.h
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//
// AY-3-8910 PSG output. Uses Circle's CVCHIQSoundBaseDevice (firmware audio
// service over VCHIQ) with an EXPLICIT destination (jack by default, switchable
// at runtime from the overlay menu). The firmware's auto mode feeds both the
// 3.5" jack and HDMI at once - dual-drive is avoided on purpose. Falls back to
// CHDMISoundBaseDevice (direct HDMI register access, no VCHIQ) if the VCHIQ
// path cannot be started.
//

#ifndef _msx_sound_h
#define _msx_sound_h

#include <circle/types.h>
#include <circle/interrupt.h>
#include <circle/sound/soundbasedevice.h>

#include <msx.h>

class CVCHIQDevice;

// 48000 Hz is accepted by both paths (VCHIQ: 44100..48000, HDMI info frame
// wants 48000). PushFrame() sizes every batch from the wall-clock interval
// it covers, so the long-term feed rate is exactly this rate even though the
// emulator's frame rate wobbles around 60 Hz.
#define MSX_SOUND_SAMPLE_RATE		48000

// Output destinations. Values match TVCHIQSoundDestination (Auto, Headphones,
// HDMI) so they can be passed to SetOutput() unchanged. AUTO is the boot
// default: the firmware then drives BOTH the 3.5mm jack and HDMI from one
// stream (shown as "HDMI+JACK" in the menu).
enum
{
	MSX_OUTPUT_AUTO = 0,
	MSX_OUTPUT_JACK = 1,
	MSX_OUTPUT_HDMI = 2
};

// Queue depth in milliseconds. The firmware drains it in bursty ~42 ms
// pulls, which sawtooths the level down by that much each pull cycle; the
// prefill below must sit well above one burst so the floor never approaches
// an empty queue (an empty queue = firmware silence padding = audible rasp).
// 200 ms also gives the level servo (PushFrame) room to absorb the ppm
// drift between the wall clock (production) and the audio crystal
// (consumption) in both directions over a long session.
#define MSX_SOUND_QUEUE_MSECS		200

// Prefill level and clamp batch, in milliseconds: half the queue. The queue
// must never sit pinned at full: from a full queue every pull leaves the
// stream one push away from an overflow drop - each dropped batch is a gap
// in the waveform (the audible "rasp"/crackle). Sitting at half depth gives
// the burst timing room (drops go to zero) and keeps latency reasonable.
// The clamp equals the prefill, so a stall (which drains the queue) is
// refilled exactly back to prefill (MSX_SOUND_MAX_MSECS).
#define MSX_SOUND_PREFILL_MSECS		100

// Longest interval a single PushFrame() renders, in milliseconds. A long
// stall (boot, menu, reset) is clamped to this so one call can never
// overflow the queue by more than the prefill headroom (see PushFrame).
#define MSX_SOUND_MAX_MSECS		MSX_SOUND_PREFILL_MSECS

class CMsxSound
{
public:
	CMsxSound (CVCHIQDevice *pVCHIQDevice,
		   CInterruptSystem *pInterrupt,
		   unsigned nSampleRate = MSX_SOUND_SAMPLE_RATE);
	~CMsxSound (void);

	// Allocates the queue and starts the device. Must be called once.
	// If the VCHIQ device fails to start, falls back to the direct HDMI
	// device and tries again.
	boolean Start (void);

	boolean IsActive (void) const;

	// Switch the firmware destination (MSX_OUTPUT_AUTO "HDMI+JACK",
	// MSX_OUTPUT_JACK, MSX_OUTPUT_HDMI; cycles in that ring).
	// Blocks on a VCHIQ completion event, so it MUST run on core 0; the core 1
	// frame loop arms it through the kernel and the core 0 loop applies it.
	// Returns FALSE on the direct-HDMI fallback device (fixed destination).
	boolean SetOutput (int nOutput);
	int GetOutput (void) const		{ return m_nOutput; }

	// Render one emulated video frame of PSG samples and queue them for
	// the device. Returns the number of audio frames handed over; a short
	// result means the queue was full (the emulator must never block on
	// sound, so the remainder is dropped).
	unsigned PushFrame (MSX_Machine *machine);

	// Diagnostics for the serial log.
	unsigned GetPushedFrames (void) const	{ return m_nPushedFrames; }
	unsigned GetDroppedFrames (void) const	{ return m_nDroppedFrames; }
	unsigned GetPeakSample (void) const	{ return m_nPeak; }
	int GetLastSample (void) const		{ return m_nLastSample; }
	const char *GetDeviceName (void) const	{ return m_pDeviceName; }

	// PSG master clocks handed to psg_render since boot. Two AUD snapshots
	// of this over a known wall-clock span prove the real production rate
	// and clocks-per-sample ratio (expected: 3579545/48000 = 74573.85).
	unsigned long long GetClockTotal (void) const { return m_nClockTotal; }

	// Frames currently waiting in the device queue (0 if not started).
	unsigned GetQueueFrames (void) const;

	// Delivery health for the AUD/SB beacons: lowest queue level ever
	// sampled at push time (an empty queue there means the device padded
	// with silence), pushes that saw an empty queue, and the smoothed
	// level the rate servo steers (target = 40% of the queue).
	unsigned GetQueueMinFrames (void) const	{ return m_nQueueMinFrames; }
	unsigned GetUnderrunPushes (void) const	{ return m_nUnderruns; }
	int GetLevelEma (void) const		{ return m_nLevelEma; }

	// Worst PushFrame() duration seen since boot, in microseconds. The
	// synthesis budget check: if this ever reaches the millisecond range
	// the PSG math is the bottleneck; if it stays in the hundreds of
	// microseconds the slowness is elsewhere (VCHIQ wait, display).
	unsigned GetPushUsMax (void) const	{ return m_nPushUsMax; }

private:
	boolean TryStartDevice (void);

	CSoundBaseDevice *m_pDevice;
	CVCHIQDevice *m_pVCHIQDevice;
	CInterruptSystem *m_pInterrupt;
	const char *m_pDeviceName;
	unsigned m_nSampleRate;

	// Maximum batch size: MSX_SOUND_MAX_MSECS worth of frames. Sizes the
	// scratch buffers.
	unsigned m_nMaxFrames;

	// Exact sample pacing: µs*Hz remainder carried across frames so the
	// production rate is m_nSampleRate on average, not rounded per frame.
	unsigned m_nSampleRem;

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
	unsigned long long m_nClockTotal;
	unsigned m_nPushUsMax;

	// Queue-level servo state and delivery health (see PushFrame).
	Int32 m_nLevelEma;		// smoothed queue level, frames
	unsigned m_nQueueMinFrames;	// lowest level ever seen at push time
	unsigned m_nUnderruns;		// pushes that found an empty queue

	// blueMSX R3 1-pole output low-pass state (see PushFrame).
	Int32 m_nOutLp;

	// openMSX DC-removal filter state, t0 (see PushFrame).
	Int32 m_nDcT;

	// Active output destination (MSX_OUTPUT_*), updated by SetOutput().
	int m_nOutput;
};

#endif
