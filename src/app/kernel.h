//
// kernel.h
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#ifndef _msx_kernel_h
#define _msx_kernel_h

#include <circle/koptions.h>
#include <circle/devicenameservice.h>
#include <circle/screen.h>
#include <circle/serial.h>
#include <circle/exceptionhandler.h>
#include <circle/interrupt.h>
#include <circle/timer.h>
#include <circle/logger.h>
#include <circle/usb/usbhcidevice.h>
#include <circle/usb/usbkeyboard.h>
#include <circle/sched/scheduler.h>
#include <circle/fs/fat/fatfs.h>
#include <circle/memory.h>
#include <circle/multicore.h>
#include <circle/spinlock.h>
#include <circle/synchronize.h>
#include <SDCard/emmc.h>
#include <circle/types.h>
#include <vc4/vchiq/vchiqdevice.h>

extern "C"
{
#include <msx.h>
}

#include "teelog.h"
#include "ui_queue.h"
#include "hid_keydiff.h"
#include "sound.h"
#include "msxconfig.h"

enum TShutdownMode
{
	ShutdownNone,
	ShutdownHalt,
	ShutdownReboot
};

// Framebuffer geometry requested from the firmware (kernel.cpp ctor).
// The DSI panel's native mode; pinned so the per-frame blit cost never
// scales with whatever resolution the connected display reports as its
// preferred mode (an external HDMI monitor would otherwise hand us
// 1920x1080 and the emulator crawls - see the ctor comment).
#define MSX_FB_WIDTH	800
#define MSX_FB_HEIGHT	480

// Cartridges the overlay menu can boot.
enum TCartId
{
	CartMsxDiag = 0,		// MSX Diagnostics ("AB" 32K cartridge)
	CartKnightmare = 1,	// Knightmare 32K cartridge
	TCartIdCount
};

// Keys the USB IRQ handler hands to the task context (never to the emulated
// MSX keyboard). Values are small integers so they fit the queue byte.
enum TUiKey
{
	UiKeyNone = 0,
	UiKeyF11,		// ALT+F11: toggle the ROM menu
	UiKeyF12,		// ALT+F12: reboot the machine
	UiKeyUp,
	UiKeyDown,
	UiKeyEnter,
	UiKeyEsc
};

// Number of keys tracked by the auto-repeat filter: UiKeyF11..UiKeyEsc.
#define UI_KEY_COUNT 6

// Task-level USB plug-and-play pass interval. 250 ms is fast enough for hot
// plug and cheap enough to leave the console and the MSX task alone.
#define USB_POLL_INTERVAL_US 250000

class CKernel;
class CMsxTask;

// Multi-core partition (Circle has no scheduler-SMP: the cooperative
// scheduler and ALL peripheral IRQs - VCHIQ doorbell, USB, mailbox - are
// architecturally pinned to core 0). Therefore the heavy side moves to
// core 1: the emulator frame loop plus PSG synthesis run in Run(1),
// while core 0 keeps the Circle scheduler (VCHIQ service threads), the
// IRQs, USB plug-and-play and the newlib heap. This is what isolates
// the HDMI audio path: its VCHIQ/IRQ servicing no longer lands inside
// emulator frame windows.
#ifdef ARM_ALLOW_MULTI_CORE
class CMSXMultiCore : public CMultiCoreSupport
{
public:
	CMSXMultiCore (CKernel *pKernel)
	:	CMultiCoreSupport (CMemorySystem::Get ()),
		m_pKernel (pKernel)
	{
	}

	void Run (unsigned nCore);

private:
	CKernel *m_pKernel;
};
#endif

class CKernel
{
public:
	CKernel (void);
	~CKernel (void);

	boolean Initialize (void);
	TShutdownMode Run (void);

	MSX_Machine *GetMachine (void) const { return m_pMachine; }

	void SetPaused (boolean bPaused)   { m_bPaused = bPaused; }
	boolean IsPaused (void)           { return m_bPaused; }

	void SetInStep (boolean bInStep)   { m_bInStep = bInStep; }
	boolean IsInStep (void)           { return m_bInStep; }

	void RequestReset (void)           { m_bResetRequest = TRUE; }
	boolean TakeResetRequest (void);

	void RequestStep (void)            { m_bStepRequest = TRUE; }
	boolean TakeStepRequest (void);

	void IncFrames (void)              { m_nFrames++; }
	unsigned long long GetFrames (void) const { return m_nFrames; }

	// Recreate and re-initialize the MSX machine with the current cartridge.
	// Runs on core 0 now (the frame loop on core 1 hands resets over via
	// ArmCore0Reset/ClaimCore0Reset) because msx_destroy/msx_create use
	// the newlib heap, which only core 0 may touch.
	void DoReset (void);

	// Core 1 -> core 0 reset handoff. Core 1 arms it at the top of the
	// frame loop and spins on IsCore0ResetDone() until core 0 has
	// rebuilt the machine; each flag has a single writer per phase.
	void ArmCore0Reset (void)         { m_bResetArmed = TRUE; }
	boolean ClaimCore0Reset (void);
	void FinishCore0Reset (void)      { m_bResetDone = TRUE; }
	boolean IsCore0ResetDone (void) const { return m_bResetDone; }
	void ClearCore0ResetDone (void)   { m_bResetDone = FALSE; }

	// Core 1 release: set TRUE by Run() once the machine and the frame
	// loop object exist; CMSXMultiCore::Run(1) spins on it from the end
	// of Initialize() onward.
	boolean IsMsxGo (void) const      { return m_bMsxGo; }
	CMsxTask *GetMsxTask (void) const { return m_pMsxTask; }

	// Cartridge selection. SetCurrentCart() takes effect on the next
	// DoReset(), which is what booting a menu entry triggers.
	int  GetCurrentCart (void) const  { return m_nCurrentCart; }
	void SetCurrentCart (int nCart);
	const char *GetCartName (int nCart) const;

	// Audio output destination (MSX_OUTPUT_*). The menu (core 1) sets it
	// optimistically for the on-screen label and arms a request; the core 0
	// loop consumes it via TakeAudioDestRequest() and calls SetOutput(),
	// because the firmware control message blocks on VCHIQ completion -
	// something core 1 (no scheduler) must never wait on.
	int  GetAudioDest (void) const        { return m_nAudioDest; }
	const char *GetAudioDestLabel (void) const;
	void SetAudioDest (int nOutput);
	int  TakeAudioDestRequest (void);

	// UI event queue: pushed from the USB IRQ, popped from task context.
	void PushUiKey (unsigned nKey);
	int  PopUiKey (void);

	// Total UI events drained by the MSX task (diagnostic).
	unsigned GetUiEvents (void) const { return m_nUiEvents; }

	// Overlay menu state, readable from the USB IRQ so navigation keys can be
	// routed to the menu instead of the emulated keyboard.
	void SetOverlayOpen (boolean bOpen)  { m_bOverlayOpen = bOpen; }
	boolean IsOverlayOpen (void)         { return m_bOverlayOpen; }
	void SetOverlaySelection (int nSel)  { m_nOverlaySel = nSel; }
	int  GetOverlaySelection (void)      { return m_nOverlaySel; }

	// Write a preformatted line to the logger (UART + log ring buffer).
	void LogLine (const char *pText);

	// TRUE once the RPMC GPIO bus has been taken over. Disables the
	// serial beacon trick: GPIO 14/15 are IORQ/MREQ on the bus, so
	// nobody may touch the UART after MsxBus_Init().
	boolean IsMsxbusActive (void) const { return m_bMsxbusActive; }

	// One-way serial kill switch: boot diagnostics and the AUD snapshots
	// are emitted first, then the MSX task turns this off for good so the
	// UART and logger cost nothing during play (user request: serial off
	// to save resources).
	void SetSerialEnabled (boolean bEnabled)	{ m_bSerialEnabled = bEnabled; }
	boolean IsSerialEnabled (void) const		{ return m_bSerialEnabled; }

	// printf-style logging with a cross-core spinlock held. CLogger/
	// CSerialDevice are NOT task safe: two writers shred each other's
	// lines and, because CSerialDevice::Write busy-waits on the shared
	// TX FIFO, each writer waits for the other's bytes. The old
	// yield-based lock would also be wrong on core 1 (no scheduler
	// there) and from IRQ context (cannot yield); a CSpinLock covers
	// both, plus serializes the CString heap use inside CLogger.
	void WriteLog (const char *pPrefix, const char *pFmt, ...);

	// Public entry point for C callbacks (e.g. msx_diag_cb in the core).
	void DiagLog (const char *pText);

	// Boot-time msx.ini handling: load the config, apply the log-mode and
	// (optional) cartridge-dump test. See msxconfig.h.
	void LoadMsxConfig (void);
	void FlushFileLog (void);
	void DumpCartridges (void);

	// Write one 256x192 frame (32bpp ARGB) to a PPM file on the SD card.
	void WriteFrame (const unsigned char *pFrame, unsigned int nBytes, unsigned int nFrameNo);

	// PSG activity since boot, for the serial log (writes, peak sample of the
	// last rendered frame, and frames dropped because the queue was full).
	void GetSoundStats (unsigned *pWrites, unsigned *pPeak, unsigned *pDropped) const;

	// AUD telemetry: total PSG clocks rendered and current device queue
	// level, for the one-shot AUD lines emitted before serial is disabled.
	unsigned long long GetSoundClockTotal (void) const;
	unsigned GetSoundQueueFrames (void) const;
	unsigned GetSoundPushedFrames (void) const;
	unsigned GetSoundPushUsMax (void) const;

	// Delivery health: lowest queue level ever seen at push time, pushes
	// that found an empty queue (firmware padded silence), and the level
	// servo's smoothed queue level (target = 40% of the queue).
	unsigned GetSoundQueueMin (void) const;
	unsigned GetSoundUnderruns (void) const;
	int GetSoundLevelEma (void) const;

	// Push one emulated frame of PSG audio. Called from the MSX task once per
	// emulated frame; never blocks, drops samples if the queue is full.
	void PushSound (MSX_Machine *machine);

	// Service the USB host: run plug-and-play and look for a HID keyboard.
	// Must be called from TASK_LEVEL. Returns TRUE if a keyboard is available.
	boolean UpdateUSB (void);

	CUSBKeyboardDevice *GetKeyboard (void) const { return m_pKeyboard; }

private:
	static void KeyStatusHandlerRaw (unsigned char ucModifiers,
					const unsigned char RawKeys[6],
					void *pArg);

private:
	// this order must not change
	CKernelOptions	m_Options;
	CDeviceNameService	m_DeviceNameService;
	CScreenDevice	m_Screen;
	CSerialDevice	m_Serial;
	CTeeLogDevice	m_TeeLog;
	CExceptionHandler	m_ExceptionHandler;
	CInterruptSystem	m_Interrupt;
	CTimer		m_Timer;
	CVCHIQDevice	m_VCHIQ;
	CUSBHCIDevice	*m_pUSBController;
	CUSBKeyboardDevice * volatile m_pKeyboard;
	CLogger		m_Logger;
	CScheduler	m_Scheduler;
	CActLED		m_ActLED;
	CEMMCDevice	m_EMMC;
	CFATFileSystem	m_FileSystem;
	boolean m_bFsMounted;

	MSX_Machine *m_pMachine;
	volatile boolean m_bPaused;
	volatile boolean m_bInStep;
	volatile boolean m_bResetRequest;
	volatile boolean m_bStepRequest;
	unsigned long long m_nFrames;

	// Task-level counters (diagnostics).
	volatile boolean m_bSerialEnabled;

	// msx.ini settings and the log-mode plumbing they drive.
	MSXConfig m_Config;
	volatile boolean m_bFileLog;		// log=file|net: keep a FAT copy
	volatile boolean m_bMsxbusActive;	// GPIO 14/15 are IORQ/MREQ now
	char m_aLogFile [16384];		// captured WriteLog lines (file mode)
	unsigned m_nLogFileLen;

	unsigned m_nUiEvents;

	// UI hotkeys: filled by the USB IRQ (producer), drained by the MSX task.
	CUiQueue m_UiQueue;
	volatile boolean m_bOverlayOpen;
	int m_nOverlaySel;
	int m_nCurrentCart;
	volatile int m_nAudioDest;	// destination shown in the menu
	volatile int m_nAudioDestReq;	// pending request for the core 0 loop

	// USB HID key tracking: usage-based report diff, see hid_keydiff.h.
	CHidKeyDiff m_HidDiff;

	// What is currently asserted in the emulated MSX keyboard matrix, indexed
	// by HID usage code.
	unsigned char m_aKeyGuest [256];

	// Auto-repeat filter for the UI keys only (see KeyStatusHandlerRaw): the two
	// timestamps bracket the previous press, so a self-repeating keyboard cannot
	// toggle the menu once per repeat.
	unsigned m_aUiDownUs [UI_KEY_COUNT];
	unsigned m_aUiUpUs [UI_KEY_COUNT];

	// AY-3-8910 output (CVCHIQSoundBaseDevice with CHDMISoundBaseDevice
	// fallback). NULL when the sound device could not be created or
	// started; the emulator then runs silently.
	CMsxSound *m_pSound;

	// Multi-core partition (see CMSXMultiCore above). m_MultiCore must
	// be constructed last of the non-trivial members: CMultiCoreSupport
	// publishes the singleton used by the secondary cores.
#ifdef ARM_ALLOW_MULTI_CORE
	CMSXMultiCore	m_MultiCore;
#endif
	CMsxTask *m_pMsxTask;
	volatile boolean m_bMsxGo;
	volatile boolean m_bResetArmed;
	volatile boolean m_bResetDone;
	CSpinLock m_LogLock;
};

#endif
