//
// msx_task.cpp
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#include "msx_task.h"
#include "kernel.h"
#include "vdpblit.h"
#include "frame_pacer.h"

#include <circle/sched/scheduler.h>
#include <circle/timer.h>
#include <string.h>
#include <stdio.h>

extern "C"
{
#include "R800.h"
#include "tms9918.h"
}

// Existing instruction budget; instruction count is not Z80 cycle timing.
#define VDP_FRAME_INSTR	12000
#define HEARTBEAT_FRAMES	120

void CMsxTask::Run (void)
{
	FramePacer Pacer = {};
	bool bPacingActive = false;
	unsigned nWindowStart = 0, nWindowFrames = 0, nWorkMax = 0;
	unsigned nLastLate = 0, nLastResync = 0;
	u64 nWorkTotal = 0;
	for (;;)
	{
		if (m_pKernel->TakeResetRequest ())
		{
			m_pKernel->DoReset ();
			bPacingActive = false;
		}

		MSX_Machine *machine = m_pKernel->GetMachine ();

		if (machine == 0)
		{
			bPacingActive = false;
			CScheduler::Get ()->MsSleep (10);
			continue;
		}

		if (m_pKernel->IsPaused ())
		{
			bPacingActive = false;
			if (m_pKernel->TakeStepRequest ())
			{
				msx_step_frame (machine, VDP_FRAME_INSTR);
				m_pKernel->IncFrames ();
			}
			CScheduler::Get ()->MsSleep (5);
			continue;
		}

		unsigned nFrameStart = CTimer::GetClockTicks ();
		if (!bPacingActive)
		{
			frame_pacer_reset (&Pacer, nFrameStart);
			nWindowStart = nFrameStart;
			nWindowFrames = nWorkMax = nLastLate = nLastResync = 0;
			nWorkTotal = 0;
			bPacingActive = true;
		}

		m_pKernel->SetInStep (TRUE);
		msx_step_frame (machine, VDP_FRAME_INSTR);
		m_pKernel->SetInStep (FALSE);
		m_pKernel->IncFrames ();

		if (m_pKernel->GetFrames () == 1)
		{
			m_pKernel->LogLine ("BOOT: MSX task produced first frame");
		}

		if ((m_pKernel->GetFrames () % HEARTBEAT_FRAMES) == 0)
		{
			R800 *z80 = (R800 *) machine->z80;
			char sBuf[128];
			snprintf (sBuf, sizeof(sBuf),
				"frame=%llu pc=%04X sp=%04X cpu_mode=%d z=%d nz=%d",
				(unsigned long long) m_pKernel->GetFrames (),
				z80->regs.PC.W, z80->regs.SP.W, (int) z80->cpuMode,
				(z80->regs.AF.B.l & Z_FLAG) != 0, (z80->regs.AF.B.l & Z_FLAG) == 0);
			m_pKernel->LogLine (sBuf);

			// Direct snapshots: status-port reads would clear the VDP IRQ latch.
			const TMS9918 *vdp = (const TMS9918 *) machine->vdp;
			snprintf (sBuf, sizeof(sBuf),
				"VDP: R0-7=%02X %02X %02X %02X %02X %02X %02X %02X display=%u inten=%u irq=%d iff1=%u im=%u",
				vdp->reg[0], vdp->reg[1], vdp->reg[2], vdp->reg[3],
				vdp->reg[4], vdp->reg[5], vdp->reg[6], vdp->reg[7],
				(unsigned) ((vdp->reg[1] & 0x40) != 0),
				(unsigned) ((vdp->reg[1] & 0x20) != 0),
				vdp->irq, z80->regs.iff1, z80->regs.im);
			m_pKernel->LogLine (sBuf);

			unsigned nNonzero = 0;
			uint32_t nHash = 2166136261u;
			for (unsigned i = 0; i < vdp->vram_size; i++)
			{
				if (vdp->vram[i] != 0) nNonzero++;
				nHash = (nHash ^ vdp->vram[i]) * 16777619u;
			}
			snprintf (sBuf, sizeof(sBuf), "VRAM: nonzero=%u hash=%08X addr=%04X write=%d",
				nNonzero, (unsigned) nHash, vdp->addr, vdp->write_mode);
			m_pKernel->LogLine (sBuf);
			VDPBlit_GetDiagnostics (sBuf, sizeof(sBuf));
			m_pKernel->LogLine (sBuf);

			static int boot_log_frames = 1;
			if (m_pKernel->GetFrames() < 240 && boot_log_frames) {
				char vBuf[64];
				snprintf(vBuf, sizeof(vBuf), "BOOT: frame=%llu", (unsigned long long)m_pKernel->GetFrames());
				m_pKernel->LogLine(vBuf);
			}

			if (m_pKernel->GetFrames() >= 240) boot_log_frames = 0;
		}

		unsigned nNow = CTimer::GetClockTicks ();
		unsigned nWork = nNow - nFrameStart;
		nWorkTotal += nWork;
		if (nWork > nWorkMax) nWorkMax = nWork;
		unsigned nSleep = frame_pacer_finish (&Pacer, nNow);
		if (nSleep != 0)
			CScheduler::Get ()->usSleep (nSleep);
		else
			CScheduler::Get ()->Yield ();

		if (++nWindowFrames == HEARTBEAT_FRAMES)
		{
			nNow = CTimer::GetClockTicks ();
			unsigned nElapsed = nNow - nWindowStart;
			unsigned nFPS100 = nElapsed ?
				(unsigned) ((u64) nWindowFrames * 100000000 / nElapsed) : 0;
			char sBuf[160];
			snprintf (sBuf, sizeof(sBuf),
				"PACE: target=%u fps=%u.%02u work_avg_us=%u work_max_us=%u late=%u resync=%u",
				(unsigned) FRAME_TARGET_HZ, nFPS100 / 100, nFPS100 % 100,
				(unsigned) (nWorkTotal / nWindowFrames), nWorkMax,
				Pacer.late - nLastLate, Pacer.resync - nLastResync);
			m_pKernel->LogLine (sBuf);
			nLastLate = Pacer.late;
			nLastResync = Pacer.resync;
			nWindowStart = nNow;
			nWindowFrames = nWorkMax = 0;
			nWorkTotal = 0;
		}
	}
}
