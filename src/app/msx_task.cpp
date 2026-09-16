//
// msx_task.cpp
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#include "msx_task.h"
#include "kernel.h"

#include <circle/sched/scheduler.h>
#include <string.h>
#include <stdio.h>

extern "C"
{
#include "R800.h"
}

// Z80 instructions per VDP frame (tunable; a real MSX1 frame is ~215k).
#define VDP_FRAME_INSTR	12000
#define FRAME_SLEEP_MS	16
#define HEARTBEAT_FRAMES	120

void CMsxTask::Run (void)
{
	for (;;)
	{
		if (m_pKernel->TakeResetRequest ())
		{
			m_pKernel->DoReset ();
		}

		MSX_Machine *machine = m_pKernel->GetMachine ();

		if (machine == 0)
		{
			CScheduler::Get ()->MsSleep (10);
			continue;
		}

		if (m_pKernel->IsPaused ())
		{
			if (m_pKernel->TakeStepRequest ())
			{
				msx_step_frame (machine, VDP_FRAME_INSTR);
				m_pKernel->IncFrames ();
			}
			CScheduler::Get ()->MsSleep (5);
			continue;
		}

		m_pKernel->SetInStep (TRUE);
		msx_step_frame (machine, VDP_FRAME_INSTR);
		m_pKernel->SetInStep (FALSE);
		m_pKernel->IncFrames ();

		if ((m_pKernel->GetFrames () % HEARTBEAT_FRAMES) == 0)
		{
			R800 *z80 = (R800 *) machine->z80;
			char sBuf[128];
			snprintf (sBuf, sizeof(sBuf),
				"frame=%llu pc=%04X sp=%04X mode=%d",
				(unsigned long long) m_pKernel->GetFrames (),
				z80->regs.PC.W, z80->regs.SP.W, z80->cpuMode);
			m_pKernel->LogLine (sBuf);
		}

		CScheduler::Get ()->MsSleep (FRAME_SLEEP_MS);
	}
}
