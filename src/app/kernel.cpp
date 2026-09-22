//
// kernel.cpp
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#include "kernel.h"
#include "msx_task.h"
#include "vdpblit.h"
#include "cbios_roms.h"

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

CKernel::CKernel (void):
	m_Screen (m_Options.GetWidth (), m_Options.GetHeight ()),
	m_TeeLog (&m_Serial),
	m_Timer (&m_Interrupt),
	m_Logger (m_Options.GetLogLevel (), &m_Timer),
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
		bOK = m_Interrupt.Initialize ();
	}

	if (bOK)
	{
		bOK = m_Timer.Initialize ();
	}

	return bOK;
}

TShutdownMode CKernel::Run (void)
{
	m_Logger.Write (FromKernel, LogNotice,
		    "BlueberryMSX: Circle MSX emulator compiled %s %s", __DATE__, __TIME__);

	VDPBlit_Init (&m_Screen);

	m_pMachine = msx_create ();
	if (!m_pMachine)
	{
		LogLine ("FATAL: msx_create() failed");
		return ShutdownHalt;
	}

	msx_load_cbios (m_pMachine);

	{
		char sBuf[96];
		snprintf (sBuf, sizeof(sBuf), "C-BIOS loaded: [0x0000]=0x%02X",
			 m_pMachine->bus.read_mem (m_pMachine->bus.ref, 0x0000));
		LogLine (sBuf);
	}

	new CMsxTask (this);

	for (;;)
	{
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
	m_nFrames = 0;
	LogLine ("MSX machine reset");
}

void CKernel::LogLine (const char *pText)
{
	m_Logger.Write ("msx", LogNotice, "%s", pText);
}
