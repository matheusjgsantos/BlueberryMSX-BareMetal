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
#include "knightmare_roms.h"
#include "overlay.h"
#include "hid_keydiff.h"

#include <circle/string.h>
#include <circle/usb/usbhid.h>
#include <string.h>
#include <stdio.h>
#include <stdarg.h>

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
	case CartKnightmare:
		pRom = knightmare_rom;
		nRomSize = knightmare_rom_size;
		break;

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
	m_Screen (m_Options.GetWidth (), m_Options.GetHeight ()),
	m_TeeLog (&m_Serial),
	m_Timer (&m_Interrupt),
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
	, m_bLogLocked (FALSE)
	, m_nUiEvents (0)
	, m_bOverlayOpen (FALSE)
	, m_nOverlaySel (0)
	, m_nCurrentCart (CartMsxDiag)
	, m_pSound (0)
{
	UiQueue_Init (&m_UiQueue);

	// Key tracking tables: no key is held at boot.
	HidKeyDiff_Init (&m_HidDiff);
	memset (m_aKeyGuest, 0, sizeof (m_aKeyGuest));
	memset (m_aUiDownUs, 0, sizeof (m_aUiDownUs));
	memset (m_aUiUpUs, 0, sizeof (m_aUiUpUs));
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

	// SD card (boot partition) for frame dumps - non-fatal if unavailable.
	{
		CDevice *pPartition = m_EMMC.Initialize ()
			? m_DeviceNameService.GetDevice ("emmc1-1", TRUE)
			: 0;

		if (   pPartition != 0
		    && (m_FileSystem.Mount (pPartition) != 0))
		{
			m_bFsMounted = TRUE;
			m_Logger.Write (FromKernel, LogNotice, "SD card mounted: emmc1-1");
		}
		else
		{
			m_Logger.Write (FromKernel, LogNotice, "SD card not available - no frame dumps");
		}
	}

	return bOK;
}

TShutdownMode CKernel::Run (void)
{
	m_Logger.Write (FromKernel, LogNotice,
		    "BlueberryMSX: Circle MSX emulator compiled %s %s", __DATE__, __TIME__);

	WriteLog ("App", "Stage 6: Run started");

	VDPBlit_Init (&m_Screen);
	VDPBlit_SetDumpHook (
		[](const unsigned char *pRGB, unsigned nBytes, unsigned nFrame, void *pUser)
		{
			((CKernel *) pUser)->WriteFrame (pRGB, nBytes, nFrame);
		},
		this);

	WriteLog ("App", "Stage 7: VDP blit initialized");

	// PSG sound: CHDMISoundBaseDevice is the only Raspberry Pi 3 sound path
	// that reaches the TV (I2S needs an external DAC and never drives HDMI).
	// If this fails the emulator keeps running, just silently.
	m_pSound = new CMsxSound (&m_Interrupt);
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
	new CMsxTask (this);
	WriteLog ("App", "Stage 14: MSX task created");

	WriteLog ("App", "Stage 15: Entering scheduler loop");

	// Continue USB plug-and-play from task level for hot-plugged devices.
	// Rate limited: the old every-30-yields pass logged two lines each time,
	// which saturated the 115200 baud console and starved the MSX task.
	unsigned nLastUSBPoll = 0;
	for (;;)
	{
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
	msx_load_cart (m_pMachine, m_nCurrentCart);
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

	// The MSX task and this task share one UART and one logger. Taking the
	// lock here is what keeps lines intact; skipping it is what made the
	// console unreadable and the MSX task miss key events.
	while (m_bLogLocked)
	{
		m_Scheduler.Yield ();
	}
	m_bLogLocked = TRUE;
	m_Logger.Write (pPrefix, LogNotice, "%s", sBuf);
	m_bLogLocked = FALSE;
}

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
