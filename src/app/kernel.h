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
#include <SDCard/emmc.h>
#include <circle/types.h>

extern "C"
{
#include <msx.h>
}

#include "teelog.h"
#include "ui_queue.h"
#include "hid_keydiff.h"
#include "sound.h"

enum TShutdownMode
{
	ShutdownNone,
	ShutdownHalt,
	ShutdownReboot
};

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
	// Must only be called from the MSX task context.
	void DoReset (void);

	// Cartridge selection. SetCurrentCart() takes effect on the next
	// DoReset(), which is what booting a menu entry triggers.
	int  GetCurrentCart (void) const  { return m_nCurrentCart; }
	void SetCurrentCart (int nCart);
	const char *GetCartName (int nCart) const;

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

	// printf-style logging with the task lock held. CLogger/CSerialDevice are
	// NOT task safe: two tasks writing at once shred each other's lines and,
	// because CSerialDevice::Write busy-waits on the shared TX FIFO, each
	// writer ends up waiting for the other's bytes. That starves the MSX task
	// badly enough to drop UI key events.
	void WriteLog (const char *pPrefix, const char *pFmt, ...);

	// Public entry point for C callbacks (e.g. msx_diag_cb in the core).
	void DiagLog (const char *pText);

	// Write one 256x192 frame (32bpp ARGB) to a PPM file on the SD card.
	void WriteFrame (const unsigned char *pFrame, unsigned int nBytes, unsigned int nFrameNo);

	// PSG activity since boot, for the serial log (writes, peak sample of the
	// last rendered frame, and frames dropped because the queue was full).
	void GetSoundStats (unsigned *pWrites, unsigned *pPeak, unsigned *pDropped) const;

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

	// Task-level log lock and counters (diagnostics).
	volatile boolean m_bLogLocked;
	unsigned m_nUiEvents;

	// UI hotkeys: filled by the USB IRQ (producer), drained by the MSX task.
	CUiQueue m_UiQueue;
	volatile boolean m_bOverlayOpen;
	int m_nOverlaySel;
	int m_nCurrentCart;

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

	// AY-3-8910 output (CHDMISoundBaseDevice). NULL when the sound device
	// could not be created or started; the emulator then runs silently.
	CMsxSound *m_pSound;
};

#endif
