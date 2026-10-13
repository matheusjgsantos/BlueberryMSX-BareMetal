//
// kernel.cpp
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#include "kernel.h"
#include "msx_task.h"
#include "vdpblit.h"
#include "cbios_roms.h"
#include "msxdiag_roms.h"
#include "overlay.h"
#include "hid_keydiff.h"
#include "msxconfig.h"
#include "msxbus.h"
#include "R800.h"

#include <circle/string.h>
#include <circle/usb/usbhid.h>
#include <circle/machineinfo.h>
#include <circle/gpioclock.h>
#include <string.h>
#include <stdio.h>
#include <stdarg.h>
#include <math.h>

static const char *FromKernel = "kernel";

extern "C" void diag_uart (char c);

// HID usage codes for the keys the overlay menu needs. Arrow keys use the
// USB HID keyboard page values (see circle/usb/usbhid.h).
#define HID_F11		0x44
#define HID_F12		0x45
#define HID_RIGHT	0x4F
#define HID_LEFT	0x50
#define HID_DOWN	0x51
#define HID_UP		0x52
#define HID_ENTER	0x28
#define HID_ESC		0x29

// Keys the open overlay menu owns; they must not reach the emulated keyboard.
static bool IsMenuKey (unsigned char ucCode)
{
	return ucCode == HID_UP || ucCode == HID_DOWN
	    || ucCode == HID_ENTER || ucCode == HID_ESC;
}

// USB HID usage code -> MSX EC code, or -1 when unmapped.
// Usage values follow the USB HID keyboard page (see circle/usb/usbhid.h and
// the Linux evdev mapping); EC codes are the MSX ones from include/msx.h.
static int HidKeyToEC (unsigned char ucKey)
{
	switch (ucKey)
	{
	case 0x04: return MSX_EC_A;
	case 0x05: return MSX_EC_B;
	case 0x06: return MSX_EC_C;
	case 0x07: return MSX_EC_D;
	case 0x08: return MSX_EC_E;
	case 0x09: return MSX_EC_F;
	case 0x0A: return MSX_EC_G;
	case 0x0B: return MSX_EC_H;
	case 0x0C: return MSX_EC_I;
	case 0x0D: return MSX_EC_J;
	case 0x0E: return MSX_EC_K;
	case 0x0F: return MSX_EC_L;
	case 0x10: return MSX_EC_M;
	case 0x11: return MSX_EC_N;
	case 0x12: return MSX_EC_O;
	case 0x13: return MSX_EC_P;
	case 0x14: return MSX_EC_Q;
	case 0x15: return MSX_EC_R;
	case 0x16: return MSX_EC_S;
	case 0x17: return MSX_EC_T;
	case 0x18: return MSX_EC_U;
	case 0x19: return MSX_EC_V;
	case 0x1A: return MSX_EC_W;
	case 0x1B: return MSX_EC_X;
	case 0x1C: return MSX_EC_Y;
	case 0x1D: return MSX_EC_Z;

	case 0x1E: return MSX_EC_1;
	case 0x1F: return MSX_EC_2;
	case 0x20: return MSX_EC_3;
	case 0x21: return MSX_EC_4;
	case 0x22: return MSX_EC_5;
	case 0x23: return MSX_EC_6;
	case 0x24: return MSX_EC_7;
	case 0x25: return MSX_EC_8;
	case 0x26: return MSX_EC_9;
	case 0x27: return MSX_EC_0;

	case 0x28: return MSX_EC_RETURN;
	case 0x29: return MSX_EC_ESC;
	case 0x2A: return MSX_EC_BKSPACE;
	case 0x2B: return MSX_EC_TAB;
	case 0x2C: return MSX_EC_SPACE;
	case 0x2D: return MSX_EC_NEG;
	case 0x2E: return MSX_EC_LBRACK;
	case 0x2F: return MSX_EC_RBRACK;
	case 0x30: return MSX_EC_BKSLASH;
	case 0x31: return MSX_EC_CIRCFLX;	// non-US # / ~
	case 0x32: return MSX_EC_SEMICOL;
	case 0x33: return MSX_EC_AT;
	case 0x34: return MSX_EC_UNDSCRE;	// ` / accent
	case 0x35: return MSX_EC_COMMA;
	case 0x36: return MSX_EC_PERIOD;
	case 0x37: return MSX_EC_DIV;
	case 0x38: return MSX_EC_CAPS;

	case 0x3A: return MSX_EC_F1;
	case 0x3B: return MSX_EC_F2;
	case 0x3C: return MSX_EC_F3;
	case 0x3D: return MSX_EC_F4;
	case 0x3E: return MSX_EC_F5;

	case 0x4F: return MSX_EC_RIGHT;
	case 0x50: return MSX_EC_LEFT;
	case 0x51: return MSX_EC_DOWN;
	case 0x52: return MSX_EC_UP;

	case 0x53: return MSX_EC_JIKKOU;	// Katakana/Hiragana
	case 0x54: return MSX_EC_CODE;
	case 0x55: return MSX_EC_UNDSCRE;	// non-US \ and |
	case 0x56: return MSX_EC_TORIKE;
	case 0x57: return MSX_EC_TORIKE;
	case 0x58: return MSX_EC_JIKKOU;	// Henkan_Mode
	case 0x5A: return MSX_EC_NUMDIV;
	case 0x5B: return MSX_EC_NUMMUL;
	case 0x5C: return MSX_EC_NUMSUB;
	case 0x5D: return MSX_EC_NUMPER;
	case 0x5E: return MSX_EC_NUMADD;
	case 0x5F: return MSX_EC_NUM0;
	case 0x60: return MSX_EC_NUM1;
	case 0x61: return MSX_EC_NUM2;
	case 0x62: return MSX_EC_NUM3;
	case 0x63: return MSX_EC_NUM4;
	case 0x64: return MSX_EC_NUM5;
	case 0x65: return MSX_EC_NUM6;
	case 0x66: return MSX_EC_NUM7;
	case 0x67: return MSX_EC_NUM8;
	case 0x68: return MSX_EC_NUM9;
	}

	return -1;
}

// Load the C-BIOS MSX1 ROMs and set up the slot map (same mapping as the
// host build):
//   Region 0 (0x0000-0x3FFF) -> slot 0 main BIOS
//   Region 1 (0x4000-0x7FFF) -> slot 0 main BIOS
//   Region 2 (0x8000-0xBFFF) -> slot 0 logo BIOS
//   Region 3 (0xC000-0xFFFF) -> slot 3 RAM area
static void msx_load_cbios (MSX_Machine *machine)
{
	// initialize RAM in slot 3
	msx_set_slot (machine, 3, 0, 0, 0);
	memset (machine->slots[3].subslots[0].data, 0, SLOT_MAX_SIZE);

	// C-BIOS main BIOS and logo screen
	msx_load_data (machine, 0, 0, 0x0000, (uint8_t *) cbios_main_rom, (int) cbios_main_rom_size);
	msx_load_data (machine, 0, 0, 0x8000, (uint8_t *) cbios_logo_rom, (int) cbios_logo_rom_size);

	// C-BIOS MSX1 slot map
	machine->bus.write_io (machine->bus.ref, 0xA8, 0xC0);
}

// Load one of the embedded 32K cartridges into slot 1, subslot 0.
// A 32K MSX1 cart spans both the 4000-7FFF (R1) and 8000-BFFF (R2) regions:
//   file[0x0000-0x3FFF] -> data offset 0x4000 (magic at 0x4000 = "AB")
//   file[0x4000-0x7FFF] -> data offset 0x8000
// C-BIOS search_roms remaps R1/R2 to slot 1 on the fly when it finds the
// "AB" header, so the permanent slot map above stays C-BIOS-owned.
// The slot is cleared first so a previous cartridge cannot leave stale bytes.
static void msx_load_cart (MSX_Machine *machine, int nCart)
{
	const uint8_t *pRom;
	unsigned nRomSize;

	switch (nCart)
	{
	default:
		pRom = msxdiag_rom;
		nRomSize = msxdiag_rom_size;
		break;
	}

	if (nRomSize != 32768u)
	{
		return;
	}

	memset (machine->slots[1].subslots[0].data, 0, SLOT_MAX_SIZE);
	msx_load_data (machine, 1, 0, 0x4000, (uint8_t *) pRom, 16384);
	msx_load_data (machine, 1, 0, 0x8000, (uint8_t *) pRom + 16384, 16384);
}

// Diagnostic bridge: core logs CHKRAM trace through this C function pointer
// (set on MSX_Machine.diag_log). The CKernel is passed as diag_user so we
// can reach its DiagLog() accessor. Budget (diag_log_budget) is enforced
// by the core so this is never called after the budget is exhausted.
extern "C" void msx_diag_cb (const char *line, void *opaque)
{
	CKernel *k = (CKernel *) opaque;
	if (k == 0) return;
	k->DiagLog (line);
}

CKernel::CKernel (void):
	// Framebuffer size: pin 800x480 (DSI native) unless options.txt says
	// otherwise. With width=0 Circle asks the firmware for the CONNECTED
	// display's preferred mode: the DSI panel reports 800x480 and runs at
	// full speed, but an external HDMI monitor reports its native mode
	// (e.g. 1920x1080) and msx_blit_frame then scales 256x192 up to the
	// full framebuffer every frame - ~5x the pixel work, which is what
	// made everything slow on HDMI while DSI was perfect. The firmware
	// picks a supported timing for sinks that cannot do 800x480 exactly;
	// VDPBlit_Init clamps the target to the granted pitch.
	m_Screen (m_Options.GetWidth () ? m_Options.GetWidth () : MSX_FB_WIDTH,
		  m_Options.GetHeight () ? m_Options.GetHeight () : MSX_FB_HEIGHT),
	m_TeeLog (&m_Serial),
	m_Timer (&m_Interrupt),
	m_VCHIQ (CMemorySystem::Get (), &m_Interrupt),
	m_pUSBController (nullptr),
	m_pKeyboard (nullptr),
	m_Logger (m_Options.GetLogLevel (), &m_Timer),
	m_EMMC (&m_Interrupt, &m_Timer, &m_ActLED),
	m_bFsMounted (FALSE),
	m_pMachine (0)
	, m_bPaused (FALSE)
	, m_bInStep (FALSE)
	, m_bResetRequest (FALSE)
	, m_bStepRequest (FALSE)
	, m_nFrames (0)
	, m_bSerialEnabled (TRUE)
	, m_bFileLog (FALSE)
	, m_bMsxbusActive (FALSE)
	, m_nLogFileLen (0)
	, m_nUiEvents (0)
	, m_bOverlayOpen (FALSE)
	, m_nOverlaySel (0)
	, m_nCurrentCart (CartSlots)
	, m_nAudioDest (MSX_OUTPUT_AUTO)
	, m_nAudioDestReq (-1)
	, m_pSound (0)
#ifdef ARM_ALLOW_MULTI_CORE
	, m_MultiCore (this)
#endif
	, m_pMsxTask (0)
	, m_bMsxGo (FALSE)
	, m_bResetArmed (FALSE)
	, m_bResetDone (FALSE)
{
	diag_uart ('9');	// all member ctors (incl. m_VCHIQ) completed

	UiQueue_Init (&m_UiQueue);

	// Key tracking tables: no key is held at boot.
	HidKeyDiff_Init (&m_HidDiff);
	memset (m_aKeyGuest, 0, sizeof (m_aKeyGuest));
	memset (m_aUiDownUs, 0, sizeof (m_aUiDownUs));
	memset (m_aUiUpUs, 0, sizeof (m_aUiUpUs));
	memset (m_aLogFile, 0, sizeof (m_aLogFile));

	diag_uart ('8');	// ctor body completed, about to return
}

CKernel::~CKernel (void)
{
}

boolean CKernel::Initialize (void)
{
	boolean bOK = TRUE;

	diag_uart ('1');

	if (bOK)
	{
		bOK = m_Screen.Initialize ();
	}

	diag_uart ('2');

	if (bOK)
	{
		bOK = m_Serial.Initialize (115200);
	}

	if (bOK)
	{
		bOK = m_Logger.Initialize (&m_TeeLog);
	}

	if (bOK)
	{
		WriteLog ("App", "Stage 1: Hardware Initialized");
	}

	if (bOK)
	{
		bOK = m_Interrupt.Initialize ();
	}

	if (bOK)
	{
		WriteLog ("App", "Stage 2: Interrupts Initialized");
	}

	if (bOK)
	{
		bOK = m_Timer.Initialize ();
	}

	if (bOK)
	{
		WriteLog ("App", "Stage 3: Timer Initialized");
	}

	// VCHIQ: firmware mailbox interface for the audio (and video) service.
	// Required by CVCHIQSoundBaseDevice (sound path to headphone jack + HDMI).
	// A failure is not fatal: sound then falls back to the direct HDMI path.
	if (bOK)
	{
		if (m_VCHIQ.Initialize ())
		{
			WriteLog ("App", "Stage 3b: VCHIQ initialized");
		}
		else
		{
			LogLine ("VCHIQ: init failed, sound falls back to direct HDMI");
		}
	}

	// USB host controller - lazy init after timer/interrupt ready
	if (bOK)
	{
		WriteLog ("App", "Stage 4a: Creating USB controller");
		m_pUSBController = new CUSBHCIDevice(&m_Interrupt, &m_Timer, TRUE);
		WriteLog ("App", "Stage 4b: USB controller created");
		if (m_pUSBController != nullptr)
		{
			WriteLog ("App", "Stage 4c: Initializing USB controller");
			// Scan devices disabled: enumeration of the CH340 USB-serial console
			// adapter deadlocks in a blocking transfer (no IRQ for interrupt IN
			// endpoints). Devices are discovered later via UpdatePlugAndPlay().
			if (m_pUSBController->Initialize (FALSE))
			{
				WriteLog ("App", "Stage 4: USB Initialized");
			}
			else
			{
				WriteLog ("App", "Stage 4: USB Initialize failed");
			}
		}
		else
		{
			WriteLog ("App", "Stage 4: USB controller alloc failed");
		}
	}
	else
	{
		WriteLog ("App", "Stage 4: Skipped (previous init failed)");
	}

	WriteLog ("App", "Stage 5: Network not present in this build");

	// SD card DATA partition (2nd VFAT, "emmc1-2") for msx.ini,
	// boot.log, CART*.ROM and frame dumps - non-fatal if unavailable.
	// This MUST NOT be the boot partition (emmc1-1): writing there
	// corrupts the boot files, so the data partition is the only
	// filesystem this build ever opens.
	{
		CDevice *pPartition = m_EMMC.Initialize ()
			? m_DeviceNameService.GetDevice ("emmc1-2", TRUE)
			: 0;

		if (   pPartition != 0
		    && (m_FileSystem.Mount (pPartition) != 0))
		{
			m_bFsMounted = TRUE;
			m_Logger.Write (FromKernel, LogNotice, "SD data partition mounted: emmc1-2");
		}
		else
		{
			m_Logger.Write (FromKernel, LogNotice, "SD data partition not available - no file log/dumps");
		}
	}

	// Multi-core support has to be initialized last (doc/multicore.txt):
	// the secondary cores start here, run CMultiCoreSupport::Run(nCore)
	// and immediately spin on IsMsxGo() until Run() has built the machine.
#ifdef ARM_ALLOW_MULTI_CORE
	if (bOK)
	{
		bOK = m_MultiCore.Initialize ();
		if (bOK)
		{
			WriteLog ("App", "Stage 5b: secondary cores started (ARM_ALLOW_MULTI_CORE)");
		}
	}
#endif

	return bOK;
}

TShutdownMode CKernel::Run (void)
{
	// msx.ini must be applied before anything else logs or touches the
	// RPMC bus: on a msxbus machine the UART shares GPIO 14/15 with
	// IORQ/MREQ, so logging mode and the bus are the same decision.
	LoadMsxConfig ();

	// Optional boot cartridge-dump test (Milestone A). Bus assumed after
	// this point until the machine is torn down for reboot.
	if (m_Config.bMsxbusEnable || m_Config.bMsxbusDump)
	{
		MsxbusBringUp ();
	}
	if (m_Config.bMsxbusDump)
	{
		DumpCartridges ();
	}
	if (m_Config.bMfrProbe)
	{
		ProbeMfrMapper ();
	}

	WriteLog (FromKernel, "BlueberryMSX: Circle MSX emulator compiled %s %s", __DATE__, __TIME__);

	WriteLog ("App", "Stage 6: Run started");

	VDPBlit_Init (&m_Screen);
	if (m_Config.bDiagDump)
	{
		// Diagnostic frame capture writes a ~147 KB PPM per capture and
		// stalls the emulator; only when msx.ini asks for it.
		VDPBlit_SetDumpHook (
			[](const unsigned char *pRGB, unsigned nBytes, unsigned nFrame, void *pUser)
			{
				((CKernel *) pUser)->WriteFrame (pRGB, nBytes, nFrame);
			},
			this);
	}

	WriteLog ("App", "Stage 7: VDP blit initialized");

	// PSG sound: CVCHIQSoundBaseDevice routes through the firmware audio
	// service to whichever output is connected (headphone jack or HDMI);
	// it falls back to the direct CHDMISoundBaseDevice (HDMI only) if the
	// VCHIQ path cannot start. If both fail the emulator keeps running,
	// just silently.
	m_pSound = new CMsxSound (&m_VCHIQ, &m_Interrupt);
	if (m_pSound != 0 && m_pSound->Start ())
	{
		WriteLog ("App", "Stage 7b: sound device started (%s, %u Hz)",
			  m_pSound->GetDeviceName (), MSX_SOUND_SAMPLE_RATE);
	}
	else
	{
		LogLine ("SOUND: device unavailable, continuing without audio");
	}

	if (!Overlay_Init ())
	{
		LogLine ("UI: overlay unavailable (no framebuffer target)");
	}
	else
	{
		LogLine ("UI: overlay ready");
	}

	LogLine ("msx_create() starting...");
	WriteLog ("App", "Stage 8: msx_create starting");
	m_pMachine = msx_create ();
	WriteLog ("App", "Stage 9: msx_create returned");
	if (!m_pMachine)
	{
		LogLine ("FATAL: msx_create() failed");
		return ShutdownHalt;
	}
	m_pMachine->diag_log       = msx_diag_cb;
	m_pMachine->diag_user      = this;
	m_pMachine->diag_log_count = 0;
	m_pMachine->diag_log_budget = 200;   // cap: ~30 CHKRAM tests + I/O trace
	{
		char sBuf[96];
		snprintf (sBuf, sizeof(sBuf), "msx_create() succeeded at %p", (void*)m_pMachine);
		LogLine (sBuf);
	}

	msx_load_cbios (m_pMachine);
	WriteLog ("App", "Stage 10: C-BIOS loaded");
	LogLine ("C-BIOS loaded successfully");

	if (m_nCurrentCart == CartSlots && m_Config.bMsxbusEnable)
	{
		// Live mode: the cartridges are the real ones on the RPMC board.
		AttachMsxbus (m_pMachine);
		LogLine ("MSXBUS: live cartridges attached (SLOTS)");
	}
	else
	{
		msx_load_cart (m_pMachine, m_nCurrentCart);
		char sBuf[96];
		snprintf (sBuf, sizeof(sBuf),
			"Cart %s in slot1s0: [0x4000]=0x%02X [0x4001]=0x%02X init=0x%04X",
			GetCartName (m_nCurrentCart),
			m_pMachine->slots[1].subslots[0].data[0x4000],
			m_pMachine->slots[1].subslots[0].data[0x4001],
			(m_pMachine->slots[1].subslots[0].data[0x4003] << 8) | m_pMachine->slots[1].subslots[0].data[0x4002]);
		LogLine (sBuf);
	}

	WriteLog ("App", "Stage 11: cartridge loaded");

	{
		char sBuf[96];
		snprintf (sBuf, sizeof(sBuf), "C-BIOS loaded: [0x0000]=0x%02X",
			 m_pMachine->bus.read_mem (m_pMachine->bus.ref, 0x0000));
		LogLine (sBuf);
	}

	WriteLog ("App", "Stage 12: Scanning USB devices");

	// Enumerate the USB device tree *before* the MSX task exists. The DWHCI
	// blocking transfers spin (libusb is built without NO_BUSY_WAIT, which is
	// required because the DWHCI locks are IRQ-context CSpinLocks). Doing the
	// scan here means nothing can be starved by the busy wait, and the HID
	// keyboard is known to the app before the first MSX frame.
	if (m_pUSBController != nullptr)
	{
		for (unsigned nScan = 1; nScan <= 4; nScan++)
		{
			WriteLog ("App", "USB scan %u start", nScan);
			m_pUSBController->UpdatePlugAndPlay ();
			WriteLog ("App", "USB scan %u done", nScan);

			if (UpdateUSB ())
			{
				break;
			}

			m_Timer.MsDelay (100);
		}
	}

	LogLine (m_pKeyboard != 0 ? "USB keyboard ready" : "USB keyboard not found");

	WriteLog ("App", "Stage 13: Creating MSX task");
	m_pMsxTask = new CMsxTask (this);
	WriteLog ("App", "Stage 14: MSX task created");

	// Release core 1 into the frame loop: it has been spinning on this
	// flag since CMultiCoreSupport::Initialize(). The barrier publishes
	// m_pMsxTask and everything built above before the flag is visible.
	DataMemBarrier ();
	m_bMsxGo = TRUE;

	WriteLog ("App", "Stage 15: Entering scheduler loop");

	// Continue USB plug-and-play from task level for hot-plugged devices.
	// Rate limited: the old every-30-yields pass logged two lines each time,
	// which saturated the 115200 baud console and starved the MSX task.
	unsigned nLastUSBPoll = 0;
	for (;;)
	{
		// Resets run on core 0: msx_destroy/msx_create use the newlib
		// heap (syscalls.cpp _sbrk), and the frame loop on core 1 never
		// allocates, so the newlib heap stays single-core by design.
		if (ClaimCore0Reset ())
		{
			DoReset ();
			FinishCore0Reset ();
		}

		// Audio output switch armed from the overlay menu (core 1).
		// SetOutput() blocks on the VCHIQ completion event, which needs
		// the scheduler to run the ka thread - only valid here, on the
		// core 0 task.
		int nAudioOutput = TakeAudioDestRequest ();
		if (nAudioOutput >= 0)
		{
			if (m_pSound != 0 && m_pSound->SetOutput (nAudioOutput))
			{
				WriteLog ("App", "Audio output -> %s",
					  nAudioOutput == MSX_OUTPUT_JACK ? "jack"
					  : nAudioOutput == MSX_OUTPUT_HDMI ? "HDMI"
										  : "HDMI+jack");
			}
			else
			{
				WriteLog ("App", "Audio output switch not supported (device=%s)",
					  m_pSound != 0 ? m_pSound->GetDeviceName () : "none");
			}
		}

		unsigned nNow = CTimer::GetClockTicks (); // 1 MHz, may wrap
		if (m_pUSBController != nullptr &&
		    nNow - nLastUSBPoll >= USB_POLL_INTERVAL_US)
		{
			nLastUSBPoll = nNow;
			m_pUSBController->UpdatePlugAndPlay ();

			UpdateUSB ();
		}

		m_Scheduler.Yield ();
	}

	return ShutdownHalt;
}

// USB HID usages that drive the overlay, in the same order as the TUiKey
// values UiKeyF11..UiKeyEsc (see kernel.h).
static const unsigned char s_aUiHid [UI_KEY_COUNT] =
{
	HID_F11, HID_F12, HID_UP, HID_DOWN, HID_ENTER, HID_ESC
};

// Slots of s_aUiHid that are the ALT hotkeys; the rest are menu navigation.
enum { UI_F11_SLOT = 0, UI_F12_SLOT = 1 };

// Auto-repeat filter. A keyboard that repeats on its own (many do when the host
// does not program a repeat rate) sends a fresh press for every repeat; without
// this filter every repeat of ALT+F11 would toggle the menu, which shows up as a
// flickering overlay. The rule is the classic one: a press that arrives shortly
// after the release of a key that had been held for a long time is a repeat.
// A fast human re-press (short hold, or a real gap) still gets through.
#define UI_REPEAT_HOLD_US	400000		// 400 ms held
#define UI_REPEAT_GAP_US	60000		// ...and back within 60 ms

// USB HID raw report handler. Called from the USB interrupt context, so it only
// touches the PPI key matrix (single-byte stores), the UI key queue and the
// timer. Anything that needs the screen, the scheduler or the machine's ROM
// state must be deferred to the MSX task.
//
// Key state is tracked by HID usage code, not by slot index: keyboards repack
// the six-slot key array between reports (the array is packed in scan order),
// so a per-slot diff happily releases a key that is still held and then drops
// the real press of the next one. Diffing by usage is order independent.
void CKernel::KeyStatusHandlerRaw (unsigned char ucModifiers,
	const unsigned char RawKeys[6], void *pArg)
{
	CKernel *pSelf = (CKernel *) pArg;
	MSX_Machine *machine = pSelf->m_pMachine;

	// Usage-based diff of the previous report against this one: at most 12
	// changes per report, and a repacked HID array is invisible.
	CHidKeyDiff *pDiff = &pSelf->m_HidDiff;
	HidKeyDiff_Update (pDiff, RawKeys);
	const unsigned char *aPressed = pDiff->aPressed;
	const unsigned nPressed = pDiff->nPressed;
	const unsigned char *aReleased = pDiff->aReleased;
	const unsigned nReleased = pDiff->nReleased;

	// ---- UI keys --------------------------------------------------------
	// Overlay hotkeys are recognized before the MSX mapping: ALT+F11 toggles
	// the menu, ALT+F12 reboots. F11/F12 have no MSX EC code, so they would
	// otherwise be swallowed below.
	unsigned nNowUs = CTimer::GetClockTicks ();
	for (unsigned i = 0; i < nPressed; i++)
	{
		for (unsigned k = 0; k < UI_KEY_COUNT; k++)
		{
			if (aPressed[i] != s_aUiHid[k])
			{
				continue;
			}

			// A press that follows a long hold by a very short gap is the
			// keyboard repeating itself; each repeat would toggle the menu.
			unsigned nUpUs = pSelf->m_aUiUpUs[k];
			bool bRepeat = nUpUs != 0
				&& nNowUs - nUpUs < UI_REPEAT_GAP_US
				&& nUpUs - pSelf->m_aUiDownUs[k] > UI_REPEAT_HOLD_US;
			if (bRepeat)
			{
				break;
			}

			// s_aUiHid is ordered like TUiKey, so the slot is the event.
			int nUiKey = UiKeyF11 + (int) k;
			if (k <= UI_F12_SLOT)
			{
				// ALT+F11 toggles the menu, ALT+F12 reboots.
				if ((ucModifiers & ALT) != 0)
				{
					pSelf->PushUiKey (nUiKey);
				}
			}
			else if (pSelf->m_bOverlayOpen)
			{
				// UP/DOWN/ENTER/ESC belong to the menu only while it is open.
				pSelf->PushUiKey (nUiKey);
			}

			pSelf->m_aUiDownUs[k] = nNowUs;
			break;
		}
	}

	for (unsigned i = 0; i < nReleased; i++)
	{
		for (unsigned k = 0; k < UI_KEY_COUNT; k++)
		{
			if (aReleased[i] == s_aUiHid[k])
			{
				pSelf->m_aUiUpUs[k] = nNowUs;
				break;
			}
		}
	}

	if (machine == 0)
	{
		return;
	}

	static int PrevModifier = MSX_EC_NONE;

	// The USB HID modifier byte only has one bit for SHIFT and one for CTRL,
	// while the MSX keyboard matrix has a separate bit for right SHIFT. Map
	// the HID report onto a single MSX modifier key, exactly like the real
	// MSX keyboard controller does.
	int Modifier = MSX_EC_NONE;
	if ((ucModifiers & (LWIN | ALTGR)) != 0)
	{
		Modifier = MSX_EC_CODE;
	}
	else if ((ucModifiers & ALT) != 0)
	{
		Modifier = MSX_EC_GRAPH;
	}
	else if ((ucModifiers & LSHIFT) != 0)
	{
		Modifier = (ucModifiers & RCTRL) != 0 ? MSX_EC_RSHIFT : MSX_EC_LSHIFT;
	}
	else if ((ucModifiers & (LCTRL | RCTRL)) != 0)
	{
		Modifier = MSX_EC_CTRL;
	}

	if (Modifier != PrevModifier)
	{
		if (PrevModifier != MSX_EC_NONE)
		{
			msx_ppi_set_ec (machine, PrevModifier, 0);
		}
		if (Modifier != MSX_EC_NONE)
		{
			msx_ppi_set_ec (machine, Modifier, 1);
		}
		PrevModifier = Modifier;
	}

	// Releases before presses, so a chord swap in one report cannot leave the
	// old key stuck in the matrix.
	for (unsigned i = 0; i < nReleased; i++)
	{
		unsigned char ucKey = aReleased[i];
		if (pSelf->m_aKeyGuest[ucKey] != 0)
		{
			pSelf->m_aKeyGuest[ucKey] = 0;
			int ec = HidKeyToEC (ucKey);
			if (ec >= 0)
			{
				msx_ppi_set_ec (machine, ec, 0);
			}
		}
	}

	// The menu owns the navigation keys: a key the guest already held when the
	// menu opened has to be dropped, or it stays stuck for as long as it is held.
	bool bMenuOpen = pSelf->m_bOverlayOpen != FALSE;
	if (bMenuOpen)
	{
		for (unsigned k = UI_F11_SLOT; k < UI_KEY_COUNT; k++)
		{
			unsigned char ucKey = s_aUiHid[k];
			if (pSelf->m_aKeyGuest[ucKey] != 0)
			{
				pSelf->m_aKeyGuest[ucKey] = 0;
				int ec = HidKeyToEC (ucKey);
				if (ec >= 0)
				{
					msx_ppi_set_ec (machine, ec, 0);
				}
			}
		}
	}

	// Presses, skipping the keys the open menu owns.
	for (unsigned i = 0; i < nPressed; i++)
	{
		unsigned char ucKey = aPressed[i];
		if (pSelf->m_aKeyGuest[ucKey] != 0)
		{
			continue;
		}
		if (bMenuOpen && IsMenuKey (ucKey))
		{
			continue;
		}

		int ec = HidKeyToEC (ucKey);
		if (ec >= 0)
		{
			pSelf->m_aKeyGuest[ucKey] = 1;
			msx_ppi_set_ec (machine, ec, 1);
		}
	}
}

boolean CKernel::UpdateUSB (void)
{
	if (m_pKeyboard == 0)
	{
		CDevice *pDevice = m_DeviceNameService.GetDevice ("ukbd1", FALSE);
		if (pDevice == 0)
		{
			return FALSE;
		}

		m_pKeyboard = (CUSBKeyboardDevice *) pDevice;
		WriteLog ("App", "USB keyboard detected, registering handler");
		m_pKeyboard->RegisterKeyStatusHandlerRaw (KeyStatusHandlerRaw, FALSE, this);
	}

	return TRUE;
}

boolean CKernel::TakeResetRequest (void)
{
	boolean b = m_bResetRequest;
	m_bResetRequest = FALSE;
	return b;
}

boolean CKernel::TakeStepRequest (void)
{
	boolean b = m_bStepRequest;
	m_bStepRequest = FALSE;
	return b;
}

void CKernel::DoReset (void)
{
	// Clear the pointer *before* destroying: the USB IRQ handler writes the PPI
	// key matrix through m_pMachine, and a key event arriving between the
	// destroy and the re-create would write into freed memory.
	MSX_Machine *pOld = m_pMachine;
	m_pMachine = 0;
	if (pOld != 0)
	{
		msx_destroy (pOld);
	}

	m_pMachine = msx_create ();
	if (m_pMachine == 0)
	{
		LogLine ("FATAL: msx_create() failed during reset");
		return;
	}

	m_pMachine->diag_log       = msx_diag_cb;
	m_pMachine->diag_user      = this;
	m_pMachine->diag_log_count = 0;
	m_pMachine->diag_log_budget = 200;

	msx_load_cbios (m_pMachine);
	if (m_nCurrentCart == CartSlots && m_Config.bMsxbusEnable)
	{
		AttachMsxbus (m_pMachine);
	}
	else
	{
		msx_load_cart (m_pMachine, m_nCurrentCart);
	}
	m_nFrames = 0;

	char sBuf[96];
	snprintf (sBuf, sizeof(sBuf), "MSX machine reset on cart %s", GetCartName (m_nCurrentCart));
	LogLine (sBuf);
}

void CKernel::SetCurrentCart (int nCart)
{
	if (nCart < 0 || nCart >= TCartIdCount)
	{
		return;
	}

	m_nCurrentCart = nCart;
}

const char *CKernel::GetCartName (int nCart) const
{
	if (nCart < 0 || nCart >= TCartIdCount)
	{
		return "UNKNOWN";
	}

	return Overlay_CartName (nCart);
}

// Producer side: runs in the USB interrupt context. Only volatile stores, no
// allocation and no locks. A full queue drops the event, which is the right
// trade-off for a menu keypress.
void CKernel::PushUiKey (unsigned nKey)
{
	UiQueue_Push (&m_UiQueue, (unsigned char) nKey);
}

// Consumer side: runs in the MSX task. Returns UiKeyNone when the queue is
// empty.
int CKernel::PopUiKey (void)
{
	unsigned char ucKey = 0;
	if (!UiQueue_Pop (&m_UiQueue, &ucKey))
	{
		return UiKeyNone;
	}

	m_nUiEvents++;

	return (int) ucKey;
}

void CKernel::GetSoundStats (unsigned *pWrites, unsigned *pPeak,
			     unsigned *pDropped) const
{
	if (pWrites) *pWrites = g_psg_writes;
	if (pPeak) *pPeak = m_pSound != 0 ? m_pSound->GetPeakSample () : 0;
	if (pDropped) *pDropped = m_pSound != 0 ? m_pSound->GetDroppedFrames () : 0;
}

unsigned long long CKernel::GetSoundClockTotal (void) const
{
	return m_pSound != 0 ? m_pSound->GetClockTotal () : 0;
}

unsigned CKernel::GetSoundQueueFrames (void) const
{
	return m_pSound != 0 ? m_pSound->GetQueueFrames () : 0;
}

unsigned CKernel::GetSoundPushedFrames (void) const
{
	return m_pSound != 0 ? m_pSound->GetPushedFrames () : 0;
}

unsigned CKernel::GetSoundPushUsMax (void) const
{
	return m_pSound != 0 ? m_pSound->GetPushUsMax () : 0;
}

unsigned CKernel::GetSoundQueueMin (void) const
{
	return m_pSound != 0 ? m_pSound->GetQueueMinFrames () : 0;
}

unsigned CKernel::GetSoundUnderruns (void) const
{
	return m_pSound != 0 ? m_pSound->GetUnderrunPushes () : 0;
}

int CKernel::GetSoundLevelEma (void) const
{
	return m_pSound != 0 ? m_pSound->GetLevelEma () : 0;
}

void CKernel::PushSound (MSX_Machine *machine)
{
	if (m_pSound == 0)
	{
		return;
	}

	m_pSound->PushFrame (machine);
}

void CKernel::LogLine (const char *pText)
{
	WriteLog ("msx", "%s", pText);
}

void CKernel::WriteLog (const char *pPrefix, const char *pFmt, ...)
{
	va_list var;
	char sBuf[256];

	va_start (var, pFmt);
	vsnprintf (sBuf, sizeof (sBuf), pFmt, var);
	va_end (var);

	// Writers are now on three contexts - core 0 task, core 1 frame loop,
	// IRQ handlers - so the yield-based flag lock is replaced by a real
	// SMP spinlock (enabled by CMultiCoreSupport::Initialize()). It also
	// serializes the CString heap use inside CLogger::WriteV.
	m_LogLock.Acquire ();

	// "file" (and "net") logging: keep a bounded copy on the RAM buffer,
	// flushed to boot.log on the FAT partition at checkpoints. This is
	// what carries the msxbus dump results when the UART is off.
	if (m_bFileLog)
	{
		unsigned nLen = (unsigned) strlen (sBuf);
		if (m_nLogFileLen + nLen + 1 <= sizeof (m_aLogFile))
		{
			memcpy (m_aLogFile + m_nLogFileLen, sBuf, nLen);
			m_nLogFileLen += nLen;
			m_aLogFile[m_nLogFileLen++] = '\n';
		}
	}

	// Serial kill switch (set from msx.ini once the boot diagnostics and
	// AUD lines are out; locked forever when the msxbus owns GPIO 14/15).
	if (m_bSerialEnabled)
	{
		m_Logger.Write (pPrefix, LogNotice, "%s", sBuf);
	}

	m_LogLock.Release ();
}

// Load msx.ini and apply the logging decision. Serial must be off before
// the msxbus takes over GPIO 14/15, and the file-log buffer is the only
// output left then, so a bus machine always keeps a recording copy.
void CKernel::LoadMsxConfig (void)
{
	m_Config = MSXConfig ();

	bool bRead = false;
	if (m_bFsMounted)
	{
		bRead = MsxConfig_Load (&m_Config, &m_FileSystem);
	}

	bool bBus = m_Config.bMsxbusEnable || m_Config.bMsxbusDump;
	if (bBus)
	{
		m_bSerialEnabled = FALSE;	// GPIO 14/15 become IORQ/MREQ
	}

	switch (m_Config.nLogMode)
	{
	case MsxLogOff:
		m_bSerialEnabled = FALSE;
		m_bFileLog = FALSE;
		break;

	case MsxLogFile:
	case MsxLogNet:
		m_bSerialEnabled = FALSE;
		m_bFileLog = TRUE;
		break;

	default:	// MsxLogUart
		m_bFileLog = bBus ? TRUE : FALSE;
		break;
	}

	WriteLog ("kernel", "msx.ini loaded=%d log=%s%s msxbus=%s dump=%s diag=%s mode=%d size=%u rddelay=%d",
		  bRead ? 1 : 0, MsxLogModeName (m_Config.nLogMode),
		  bBus ? " (UART locked off)" : "",
		  m_Config.bMsxbusEnable ? "on" : "off",
		  m_Config.bMsxbusDump ? "on" : "off",
		  m_Config.bDiagDump ? "on" : "off",
		  m_Config.nMsxbusMode, m_Config.nDumpBytes, m_Config.nMsxbusReadDelay);
}

// Flush the captured log to boot.log on the FAT partition (best effort).
void CKernel::FlushFileLog (void)
{
	m_LogLock.Acquire ();
	if (m_bFsMounted && m_nLogFileLen > 0)
	{
		unsigned hFile = m_FileSystem.FileCreate ("boot.log");
		if (hFile != 0)
		{
			m_FileSystem.FileWrite (hFile, m_aLogFile, m_nLogFileLen);
			m_FileSystem.FileClose (hFile);
		}
		m_nLogFileLen = 0;
	}
	m_LogLock.Release ();
}

// Core <-> GPIO bus bridges. The MSX core calls these through function
// pointers (see MSX_Machine in msx.h), so the core keeps no link dependency
// on the bare-metal driver and stays host-testable.
static UInt8 MsxbusCoreRead (void *pRef, int nSlot, UInt16 nAddr)
{
	(void) pRef;
	return (UInt8) MsxBus_Read (nSlot, (uint16_t) nAddr);
}

static void MsxbusCoreWrite (void *pRef, int nSlot, UInt16 nAddr, UInt8 nVal)
{
	(void) pRef;
	MsxBus_Write (nSlot, (uint16_t) nAddr, (uint8_t) nVal);
}

static UInt8 MsxbusCoreReadIo (void *pRef, UInt16 nPort)
{
	(void) pRef;
	return (UInt8) MsxBus_ReadIo ((uint16_t) nPort);
}

static void MsxbusCoreWriteIo (void *pRef, UInt16 nPort, UInt8 nVal)
{
	(void) pRef;
	MsxBus_WriteIo ((uint16_t) nPort, (uint8_t) nVal);
}

// Hook the live RPMC bus into the emulated machine: every access to the
// mapped primary slots is served by the physical cartridges, and any port the
// emulator does not own goes to the board (music modules, SCC, FM...).
void CKernel::AttachMsxbus (MSX_Machine *pMachine)
{
	if (pMachine == 0)
	{
		return;
	}

	pMachine->bus_ref      = this;
	pMachine->bus_read     = MsxbusCoreRead;
	pMachine->bus_write    = MsxbusCoreWrite;
	pMachine->bus_read_io  = MsxbusCoreReadIo;
	pMachine->bus_write_io = MsxbusCoreWriteIo;

	// Board connector 1 and connector 3 each get one emulated primary slot.
	// Defaults keep slot 3 free for the system RAM (0xC000-0xFFFF).
	msx_slot_set_bus (pMachine, m_Config.nMsxbusSlot1, 0, MsxBusSlot1);
	msx_slot_set_bus (pMachine, m_Config.nMsxbusSlot3, 0, MsxBusSlot3);

	char sBuf[128];
	snprintf (sBuf, sizeof (sBuf),
		"MSXBUS: live - connector1 -> primary slot %d, connector3 -> primary slot %d",
		m_Config.nMsxbusSlot1, m_Config.nMsxbusSlot3);
	WriteLog ("msxbus", "%s", sBuf);
}

// Bring the RPMC bus up (pin map, GPCLK0, reset pulse) and light PWR. Safe to
// call more than once: the second call is a no-op. After this the UART pins
// are IORQ/MREQ, so no serial output is allowed (msx.ini log mode handles it).
void CKernel::MsxbusBringUp (void)
{
	if (m_bMsxbusActive)
	{
		return;
	}

	// Divisor for ~3,579,545 Hz from the runtime oscillator: 19.2 MHz on
	// Pi 3/Zero 2, 54 MHz on Pi 4/400. MASH=1 dithering covers the fraction.
	unsigned nSource = CMachineInfo::Get ()->GetGPIOClockSourceRate (GPIOClockSourceOscillator);
	double dDiv = (double) nSource / 3579545.0;
	unsigned nDivi = (unsigned) dDiv;
	unsigned nDivF = (unsigned) ((dDiv - nDivi) * 4096.0 + 0.5);

	MsxBus_Init (nDivi, nDivF);
	MsxBus_SetReadDelay (m_Config.nMsxbusReadDelay);
	MsxBus_SetCacheMode (m_Config.nMsxbusMode == MsxBusCache);
	m_bMsxbusActive = TRUE;
	DataMemBarrier ();

	MsxBus_Leds (0x80);	// PWR

	char sBuf[160];
	snprintf (sBuf, sizeof (sBuf),
		"MSXBUS: bus up, GPCLK0 div=%u+%u/4096 (src %u Hz), SW1=%s, rddelay=%d mode=%s",
		nDivi, nDivF, nSource, MsxBus_PackPresent () ? "pressed" : "open",
		m_Config.nMsxbusReadDelay,
		m_Config.nMsxbusMode == MsxBusCache ? "cache" : "live");
	WriteLog ("msxbus", "%s", sBuf);
}

// Milestone A test: dump both cartridge slots to CART1.ROM / CART3.ROM, so a
// cartridge can be verified on the PC (the expected "AB" header at 0x4000 and
// the md5 against the known ROM).
void CKernel::DumpCartridges (void)
{
	MsxbusBringUp ();

	if (!m_Config.bMsxbusDump)
	{
		return;
	}

	char sBuf[160];
	static const char *s_aNames[MsxBusSlotCount] = { "CART1.ROM", "CART3.ROM" };
	static const unsigned char s_aSlotLed[MsxBusSlotCount] = { 0x20, 0x40 };

	for (int nSlot = 0; nSlot < MsxBusSlotCount; nSlot++)
	{
		unsigned nBytes = m_Config.nDumpBytes;
		unsigned char *pBuf = new unsigned char[nBytes];
		if (pBuf == 0)
		{
			WriteLog ("msxbus", "dump %s: out of memory", s_aNames[nSlot]);
			continue;
		}

		MsxBus_Leds (0x80 | s_aSlotLed[nSlot]);
		for (unsigned i = 0; i < nBytes; i++)
		{
			pBuf[i] = MsxBus_Read (nSlot, (uint16_t) (0x4000u + i));
		}

		snprintf (sBuf, sizeof (sBuf),
			"MSXBUS: %s %u bytes [%02X %02X %02X %02X %02X %02X %02X %02X ...]",
			s_aNames[nSlot], nBytes,
			pBuf[0], pBuf[1], pBuf[2], pBuf[3],
			pBuf[4], pBuf[5], pBuf[6], pBuf[7]);
		WriteLog ("msxbus", "%s", sBuf);

		if (m_bFsMounted)
		{
			unsigned hFile = m_FileSystem.FileCreate (s_aNames[nSlot]);
			if (hFile != 0)
			{
				unsigned nWritten = m_FileSystem.FileWrite (hFile, pBuf, nBytes);
				m_FileSystem.FileClose (hFile);
				WriteLog ("msxbus", "%s: wrote %u bytes to FAT", s_aNames[nSlot], nWritten);
			}
			else
			{
				WriteLog ("msxbus", "%s: FileCreate failed", s_aNames[nSlot]);
			}
		}
		else
		{
			WriteLog ("msxbus", "%s: SD not mounted, dump kept in RAM only", s_aNames[nSlot]);
		}

		delete[] pBuf;
	}

	MsxBus_Leds (0x80);

	MsxBusStats Stats;
	MsxBus_GetStats (&Stats);
	snprintf (sBuf, sizeof (sBuf),
		"MSXBUS: slot1 reads=%lu slot3 reads=%lu WAIT iters=%lu timeouts=%lu slow=%lu",
		Stats.nMemReads[MsxBusSlot1], Stats.nMemReads[MsxBusSlot3],
		Stats.nWaitIters, Stats.nWaitTimeouts, Stats.nSlowOps);
	WriteLog ("msxbus", "%s", sBuf);
}

// Diagnostic probe of the physical MegaFlashROM SCC+ mapper, run once after
// the bus is up and before C-BIOS boots. The MFR powers up with its
// configuration register at 0 (Konami-SCC mode), where the bank registers live
// at 0x5000/0x7000/0x9000/0xB000; the multicart menu instead writes its banks
// to 0x8000/0xA000, which only latch in Konami mode (config bit 5 set). The
// probe records which (mode,address) actually moves which page, then leaves the
// cart in Konami mode with its default bank mapping restored, so the launch can
// be retested. Writes a padded MFRPROBE.TXT to the data partition.
void CKernel::ProbeMfrMapper (void)
{
	if (!m_bFsMounted)
	{
		return;
	}

	const unsigned nSize = 0x20000;		// 128 KiB padded, like the STA dumps
	unsigned char *pBuf = new unsigned char[nSize];
	if (pBuf == 0)
	{
		return;
	}
	memset (pBuf, 0, nSize);

	char *p = (char *) pBuf;
	unsigned nOff = 0;
	unsigned nCap = nSize - 256;
#define APP(...)	do { if (nOff < nCap) nOff += (unsigned) snprintf (p + nOff, 200, __VA_ARGS__); } while (0)

	// Signature of a page: the cart's 8 KiB bank begins "AB" then a 16-bit
	// INIT vector. Reading the four pages reveals which 8 KiB bank is mapped.
	auto sig = [&](uint16_t base) -> unsigned {
		unsigned b2 = MsxBus_Read (MsxBusSlot1, (uint16_t) (base + 2));
		unsigned b3 = MsxBus_Read (MsxBusSlot1, (uint16_t) (base + 3));
		return (b3 << 8) | b2;
	};
	auto line4 = [&](const char *tag) {
		APP ("%s p0=%04X p1=%04X p2=%04X p3=%04X\n",
			tag, sig (0x4000), sig (0x6000), sig (0x8000), sig (0xA000));
	};

	static const struct { const char *name; unsigned char mode; } s_aMode[5] = {
		{ "konami-scc", 0x00 },
		{ "konami",     0x20 },
		{ "64k",        0x40 },
		{ "ascii8",     0x80 },
		{ "ascii16",    0xC0 },
	};
	static const unsigned short s_aReg[8] = { 0x4000, 0x5000, 0x6000, 0x7000, 0x8000, 0x9000, 0xA000, 0xB000 };

	APP ("MFR MAPPER PROBE (connector1)\n");
	line4 ("boot  ");

	for (unsigned m = 0; m < 5; m++)
	{
		MsxBus_Write (MsxBusSlot1, 0x7FFE, s_aMode[m].mode);	// set config register
		line4 (s_aMode[m].name);

		for (unsigned r = 0; r < 8; r++)
		{
			MsxBus_Write (MsxBusSlot1, s_aReg[r], 0x05);
			char tag[24];
			snprintf (tag, sizeof (tag), "  w%04X", s_aReg[r]);
			line4 (tag);
		}
	}

#undef APP

	// Leave a sane launch state: force Konami mode so the menu's
	// 0x8000/0xA000 bank stores latch, then restore the default bank mapping
	// (banks 0..3 = p0..p3). In Konami mode page0 latches at 0x5000-0x57FF,
	// page1 at 0x6000, page2 at 0x8000 and page3 at 0xA000.
	MsxBus_Write (MsxBusSlot1, 0x7FFE, 0x20);
	MsxBus_Write (MsxBusSlot1, 0x5000, 0x00);
	MsxBus_Write (MsxBusSlot1, 0x6000, 0x01);
	MsxBus_Write (MsxBusSlot1, 0x8000, 0x02);
	MsxBus_Write (MsxBusSlot1, 0xA000, 0x03);

	unsigned hFile = m_FileSystem.FileCreate ("MFRPROBE.TXT");
	if (hFile != 0)
	{
		m_FileSystem.FileWrite (hFile, pBuf, nSize);
		m_FileSystem.FileClose (hFile);
	}
	WriteLog ("msxbus", "MFRPROBE.TXT written (mapper probe, Konami mode forced)");

	delete[] pBuf;
}

// Diagnostic: report the RPMC bus counters as a file on the data partition so
// they can be read back on a PC. The log itself is RAM-buffered (log=file) and
// cannot be flushed (a small FAT write hangs this Circle build), so the report
// is padded to 128 KiB - the same size class as the cartridge dumps and PPM
// frames, which write reliably. Called once per heartbeat from the MSX task.
void CKernel::DumpMsxbusDiag (unsigned long long nFrame, unsigned nTicks)
{
	if (!m_bFsMounted)
	{
		return;
	}

	MsxBusStats Stats;
	MsxBus_GetStats (&Stats);

	const unsigned nSize = 0x20000;		// 128 KiB
	unsigned char *pBuf = new unsigned char[nSize];
	if (pBuf == 0)
	{
		return;
	}
	memset (pBuf, 0, nSize);

	snprintf ((char *) pBuf, 256,
		"MSXBUS DIAG\n"
		"frame=%llu ticks=%u\n"
		"reads1=%lu reads3=%lu writes1=%lu writes3=%lu\n"
		"ioreads=%lu iowrites=%lu\n"
		"waititers=%lu waittimeouts=%lu slowops=%lu\n"
		"cachehits=%lu cachemisses=%lu\n",
		nFrame, nTicks,
		Stats.nMemReads[MsxBusSlot1], Stats.nMemReads[MsxBusSlot3],
		Stats.nMemWrites[MsxBusSlot1], Stats.nMemWrites[MsxBusSlot3],
		Stats.nIoReads, Stats.nIoWrites,
		Stats.nWaitIters, Stats.nWaitTimeouts, Stats.nSlowOps,
		Stats.nCacheHits, Stats.nCacheMisses);

	// Machine-side state at this frame: the physical MegaFlashROM menu decides
	// RAM is missing and aborts, so dump exactly what it saw - the current slot
	// register, per-page active slots, the current-slot marker (0xE200) the
	// scan skips, the RAMAD result (0xF341-3) and EXPTBL. Padded file, so it
	// writes reliably (see note above).
	if (m_pMachine != 0)
	{
		UInt8 *pRam = m_pMachine->slots[3].subslots[0].data;
		unsigned nPc = 0;
		if (m_pMachine->z80 != 0)
		{
			nPc = ((R800 *) m_pMachine->z80)->regs.PC.W;
		}

		snprintf ((char *) pBuf + 256, 256,
			"MSX STATE\n"
			"pc=%04X slotReg=%02X active=%d %d %d %d\n"
			"E210=%02X E200=%02X F3E9=%02X RAMAD=%02X %02X %02X\n"
			"EXPTBL=%02X %02X %02X %02X\n"
			"F380=%02X %02X %02X %02X %02X %02X %02X %02X\n",
			nPc, m_pMachine->slotReg,
			m_pMachine->activeSlot[0], m_pMachine->activeSlot[1],
			m_pMachine->activeSlot[2], m_pMachine->activeSlot[3],
			pRam[0xE210], pRam[0xE200], pRam[0xF3E9],
			pRam[0xF341], pRam[0xF342], pRam[0xF343],
			pRam[0xFCC1], pRam[0xFCC2], pRam[0xFCC3], pRam[0xFCC4],
			pRam[0xF380], pRam[0xF381], pRam[0xF382], pRam[0xF383],
			pRam[0xF384], pRam[0xF385], pRam[0xF386], pRam[0xF387]);

		// Slot/MFR event log: page-1 (port 0xA8) transitions and every write
		// to 0xE200/0xE210, each with the store PC. Shows whether the
		// cartridge INIT ran once or more and which page-1 slot each saw.
		{
			char *pEvt = (char *) pBuf + 512;
			unsigned nEvt = msx_slot_event_count ();
			unsigned nOff = (unsigned) snprintf (pEvt, 128,
				"SLOT EVT count=%u\n", nEvt);
			for (unsigned i = 0; i < nEvt; i++)
			{
				unsigned nPcE = 0, nPortE = 0, nValE = 0;
				if (!msx_slot_event_get (i, &nPcE, &nPortE, &nValE))
				{
					break;
				}
				const char *pName = (nPortE == 0) ? "A8" :
				                    (nPortE == 1) ? "E200" : "E210";
				nOff += (unsigned) snprintf (pEvt + nOff, 64,
					"%03u %s=%02X pc=%04X\n", i, pName, nValE, nPcE);
				if (nOff > 9000)
				{
					break;
				}
			}
		}
	}

	// Bank-switch log: the physical cart's memory accesses in 0x4000-0xBFFF.
	// Tells whether the MFR menu's bank-register stores reached the cartridge
	// (WRITES) and, critically, whether the loader's read-back of the entry
	// vectors (first bytes of each 8 KiB bank) changed after the store - i.e.
	// whether the physical bank switch actually took effect.
	{
		char *pLog = (char *) pBuf + 0x4000;
		unsigned nCap = 0x10000;	// 64 KiB region for the log
		unsigned nOff = (unsigned) snprintf (pLog, 128,
			"BUS LOG writes=%d reads=%d\n",
			MsxBus_LogWriteCount (), MsxBus_LogReadCount ());

		int nW = MsxBus_LogWriteCount ();
		nOff += (unsigned) snprintf (pLog + nOff, 64, "-- writes --\n");
		for (int i = 0; i < nW && nOff < nCap - 64; i++)
		{
			uint16_t nA = 0; uint8_t nS = 0, nV = 0;
			if (!MsxBus_LogWriteGet (i, &nA, &nS, &nV)) break;
			nOff += (unsigned) snprintf (pLog + nOff, 32,
				"W%u %04X=%02X\n", nS, nA, nV);
		}

		int nR = MsxBus_LogReadCount ();
		nOff += (unsigned) snprintf (pLog + nOff, 64, "-- reads --\n");
		for (int i = 0; i < nR && nOff < nCap - 64; i++)
		{
			uint16_t nA = 0; uint8_t nV = 0;
			if (!MsxBus_LogReadGet (i, &nA, &nV)) break;
			nOff += (unsigned) snprintf (pLog + nOff, 32,
				"R %04X=%02X\n", nA, nV);
		}
	}

	char sName[16];
	snprintf (sName, sizeof (sName), "MB%06X.STA", (unsigned) (nFrame & 0xFFFFFFu));

	unsigned hFile = m_FileSystem.FileCreate (sName);
	if (hFile != 0)
	{
		m_FileSystem.FileWrite (hFile, pBuf, nSize);
		m_FileSystem.FileClose (hFile);
	}

	delete[] pBuf;
}

boolean CKernel::ClaimCore0Reset (void)
{
	if (!m_bResetArmed)
	{
		return FALSE;
	}

	m_bResetArmed = FALSE;
	DataMemBarrier ();
	return TRUE;
}

const char *CKernel::GetAudioDestLabel (void) const
{
	switch (m_nAudioDest)
	{
	case MSX_OUTPUT_JACK:	return "JACK";
	case MSX_OUTPUT_HDMI:	return "HDMI";
	default:		return "HDMI+JACK";	// MSX_OUTPUT_AUTO: both sinks
	}
}

// Core 1 -> core 0 handoff: publish the destination for the menu label,
// then arm the request the Run() loop consumes. The barrier between the
// two writes keeps the label visible before the request can fire.
void CKernel::SetAudioDest (int nOutput)
{
	m_nAudioDest = nOutput;
	DataMemBarrier ();
	m_nAudioDestReq = nOutput;
}

int CKernel::TakeAudioDestRequest (void)
{
	DataMemBarrier ();
	int nOutput = m_nAudioDestReq;
	if (nOutput < 0)
	{
		return -1;
	}
	m_nAudioDestReq = -1;
	return nOutput;
}

#ifdef ARM_ALLOW_MULTI_CORE
// Core 1 entry of the multi-core partition: spin until Run() has created
// the machine and the frame-loop object, then run the emulator loop
// (never returns). Cores 2 and 3 are unused; EntrySecondary halts them
// after Run() returns.
void CMSXMultiCore::Run (unsigned nCore)
{
	if (nCore != 1)
	{
		return;
	}

	// The emulator core never takes interrupts: pacing polls the CLO,
	// reset/audio handshakes are polled flags, and the sound queue write
	// is a spinlock ring push. Circle enables IRQs on secondaries
	// (EntrySecondary), but the Pi's legacy interrupt controller presents
	// the GPU IRQ sources to every core - a VCHIQ/USB interrupt landing
	// here steals time straight from the frame loop (HDMI audio raises
	// that rate). Core 0 services all of them; mask them here.
	DisableIRQs ();

	while (!m_pKernel->IsMsxGo ())
	{
		// spin: core 0 is still building the machine
	}
	DataMemBarrier ();

	m_pKernel->GetMsxTask ()->Run ();
}
#endif

void CKernel::DiagLog (const char *pText)
{
	LogLine (pText);
}

// Write one captured 256x192 RGB frame to the SD card as a PPM (P6) file.
// pFrame must already be converted to 8bpp-per-channel RGB (73728 bytes).
void CKernel::WriteFrame (const unsigned char *pFrame, unsigned int nBytes, unsigned int nFrameNo)
{
	if (!m_bFsMounted)
	{
		return;
	}

	char sName[16];
	snprintf (sName, sizeof(sName), "msxf%u.ppm", nFrameNo);

	unsigned hFile = m_FileSystem.FileCreate (sName);
	if (hFile == 0)
	{
		LogLine ("frame dump: FileCreate failed");
		return;
	}

	unsigned char sHeader[64];
	unsigned nHeaderLen = snprintf ((char *) sHeader, sizeof(sHeader),
		"P6\n256 192\n255\n");

	if (   m_FileSystem.FileWrite (hFile, sHeader, nHeaderLen) != nHeaderLen
	    || m_FileSystem.FileWrite (hFile, pFrame, nBytes) != nBytes)
	{
		m_FileSystem.FileClose (hFile);
		LogLine ("frame dump: FileWrite failed");
		return;
	}

	m_FileSystem.FileClose (hFile);
	LogLine (sName);
}
