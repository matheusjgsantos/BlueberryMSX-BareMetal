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

#include <circle/string.h>
#include <string.h>
#include <stdio.h>

static const char *FromKernel = "kernel";

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

// Load the MSX Diagnostics 32K cartridge into slot 1, subslot 0.
// A 32K MSX1 cart spans both the 4000-7FFF (R1) and 8000-BFFF (R2) regions:
//   file[0x0000-0x3FFF] -> data offset 0x4000 (magic at 0x4000 = "AB")
//   file[0x4000-0x7FFF] -> data offset 0x8000
// C-BIOS search_roms remaps R1/R2 to slot 1 on the fly when it finds the
// "AB" header, so the permanent slot map above stays C-BIOS-owned.
static void msx_load_msxdiag (MSX_Machine *machine)
{
	if (msxdiag_rom_size != 32768u)
	{
		return;
	}

	msx_load_data (machine, 1, 0, 0x4000, (uint8_t *) msxdiag_rom, 16384);
	msx_load_data (machine, 1, 0, 0x8000, (uint8_t *) msxdiag_rom + 16384, 16384);
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
	m_Logger (m_Options.GetLogLevel (), &m_Timer),
	m_EMMC (&m_Interrupt, &m_Timer, &m_ActLED),
	m_bFsMounted (FALSE),
	m_pMachine (0)
	, m_bPaused (FALSE)
	, m_bInStep (FALSE)
	, m_bResetRequest (FALSE)
	, m_bStepRequest (FALSE)
	, m_nFrames (0)
{
}

CKernel::~CKernel (void)
{
}

boolean CKernel::Initialize (void)
{
	boolean bOK = TRUE;

	if (bOK)
	{
		bOK = m_Screen.Initialize ();
	}

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
		m_Logger.Write ("App", LogNotice, "Stage 1: Hardware Initialized");
	}

	if (bOK)
	{
		bOK = m_Interrupt.Initialize ();
	}

	if (bOK)
	{
		m_Logger.Write ("App", LogNotice, "Stage 2: Interrupts Initialized");
	}

	if (bOK)
	{
		bOK = m_Timer.Initialize ();
	}

	if (bOK)
	{
		m_Logger.Write ("App", LogNotice, "Stage 3: Timer Initialized");
	}

	// USB host controller - lazy init after timer/interrupt ready
	if (bOK)
	{
		m_Logger.Write ("App", LogNotice, "Stage 4a: Creating USB controller");
		m_pUSBController = new CUSBHCIDevice(&m_Interrupt, &m_Timer, TRUE);
		m_Logger.Write ("App", LogNotice, "Stage 4b: USB controller created");
		if (m_pUSBController != nullptr)
		{
			m_Logger.Write ("App", LogNotice, "Stage 4c: Initializing USB controller");
			// Scan devices disabled: enumeration of the CH340 USB-serial console
			// adapter deadlocks in a blocking transfer (no IRQ for interrupt IN
			// endpoints). Devices are discovered later via UpdatePlugAndPlay().
			if (m_pUSBController->Initialize (FALSE))
			{
				m_Logger.Write ("App", LogNotice, "Stage 4: USB Initialized");
			}
			else
			{
				m_Logger.Write ("App", LogWarning, "Stage 4: USB Initialize failed");
			}
		}
		else
		{
			m_Logger.Write ("App", LogWarning, "Stage 4: USB controller alloc failed");
		}
	}
	else
	{
		m_Logger.Write ("App", LogWarning, "Stage 4: Skipped (previous init failed)");
	}

	m_Logger.Write ("App", LogNotice, "Stage 5: Network not present in this build");

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

	m_Logger.Write ("App", LogNotice, "Stage 6: Run started");

	VDPBlit_Init (&m_Screen);
	VDPBlit_SetDumpHook (
		[](const unsigned char *pRGB, unsigned nBytes, unsigned nFrame, void *pUser)
		{
			((CKernel *) pUser)->WriteFrame (pRGB, nBytes, nFrame);
		},
		this);

	m_Logger.Write ("App", LogNotice, "Stage 7: VDP blit initialized");

	LogLine ("msx_create() starting...");
	m_Logger.Write ("App", LogNotice, "Stage 8: msx_create starting");
	m_pMachine = msx_create ();
	m_Logger.Write ("App", LogNotice, "Stage 9: msx_create returned");
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
	m_Logger.Write ("App", LogNotice, "Stage 10: C-BIOS loaded");
	LogLine ("C-BIOS loaded successfully");

	{
		msx_load_msxdiag (m_pMachine);
		char sBuf[96];
		snprintf (sBuf, sizeof(sBuf),
			"MSX Diag loaded in slot1s0: [0x4000]=0x%02X [0x4001]=0x%02X init=0x%04X",
			m_pMachine->slots[1].subslots[0].data[0x4000],
			m_pMachine->slots[1].subslots[0].data[0x4001],
			(m_pMachine->slots[1].subslots[0].data[0x4003] << 8) | m_pMachine->slots[1].subslots[0].data[0x4002]);
		LogLine (sBuf);
	}

	m_Logger.Write ("App", LogNotice, "Stage 11: MSX Diag loaded");

	{
		char sBuf[96];
		snprintf (sBuf, sizeof(sBuf), "C-BIOS loaded: [0x0000]=0x%02X",
			 m_pMachine->bus.read_mem (m_pMachine->bus.ref, 0x0000));
		LogLine (sBuf);
	}

	m_Logger.Write ("App", LogNotice, "Stage 12: Creating MSX task");
	new CMsxTask (this);
	m_Logger.Write ("App", LogNotice, "Stage 13: MSX task created");

	m_Logger.Write ("App", LogNotice, "Stage 14: Entering scheduler loop");

	unsigned nUSBPollCountdown = 0;
	unsigned nUSBPollCount = 0;
	for (;;)
	{
		// Poll USB plug-and-play from task level. Must be called periodically
		// because Initialize(FALSE) skipped the initial device scan.
		if (m_pUSBController != nullptr && ++nUSBPollCountdown >= 30)
		{
			nUSBPollCountdown = 0;
			nUSBPollCount++;
			m_Logger.Write ("App", LogDebug, "USB poll %u start", nUSBPollCount);
			m_pUSBController->UpdatePlugAndPlay ();
			m_Logger.Write ("App", LogDebug, "USB poll %u done", nUSBPollCount);
		}

		m_Scheduler.Yield ();
	}

	return ShutdownHalt;
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
	if (m_pMachine != 0)
	{
		msx_destroy (m_pMachine);
	}

	m_pMachine = msx_create ();
	if (m_pMachine == 0)
	{
		LogLine ("FATAL: msx_create() failed during reset");
		return;
	}

	msx_load_cbios (m_pMachine);
	msx_load_msxdiag (m_pMachine);
	m_nFrames = 0;
	LogLine ("MSX machine reset");
}

void CKernel::LogLine (const char *pText)
{
	m_Logger.Write ("msx", LogNotice, "%s", pText);
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
