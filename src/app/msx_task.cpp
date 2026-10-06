//
// msx_task.cpp
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#include "msx_task.h"
#include "kernel.h"
#include "vdpblit.h"
#include "overlay.h"
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
#define OVERLAY_REDRAW_MS	16

// Selection currently painted on screen while the menu is open; -1 means
// "nothing drawn yet", which forces a full repaint.
#define OVERLAY_NOT_DRAWN	(-1)

// Drain the UI key queue. Must run in task context: it may reboot the machine
// and it draws the menu. Returns TRUE when the overlay was opened/closed and
// the caller should skip emulation for this iteration.
static bool ServiceUiQueue (CKernel *pKernel)
{
	bool bChanged = false;

	for (int nKey = pKernel->PopUiKey (); nKey != UiKeyNone; nKey = pKernel->PopUiKey ())
	{
		switch (nKey)
		{
		case UiKeyF11:
			if (pKernel->IsOverlayOpen ())
			{
				pKernel->SetOverlayOpen (FALSE);
				pKernel->LogLine ("UI: overlay closed");
			}
			else
			{
				// Start the cursor on the cartridge that is actually running.
				pKernel->SetOverlaySelection (pKernel->GetCurrentCart ());
				pKernel->SetOverlayOpen (TRUE);
				pKernel->LogLine ("UI: overlay opened");
			}
			bChanged = TRUE;
			break;

		case UiKeyF12:
			pKernel->RequestReset ();
			pKernel->LogLine ("UI: reboot requested");
			break;

		case UiKeyUp:
		case UiKeyDown:
			if (pKernel->IsOverlayOpen ())
			{
				int nSel = pKernel->GetOverlaySelection ();
				nSel += (nKey == UiKeyDown) ? 1 : -1;
				if (nSel < 0) nSel = 0;
				if (nSel >= TCartIdCount) nSel = TCartIdCount - 1;
				pKernel->SetOverlaySelection (nSel);
				bChanged = TRUE;
			}
			break;

		case UiKeyEnter:
			if (pKernel->IsOverlayOpen ())
			{
				int nSel = pKernel->GetOverlaySelection ();
				if (nSel != pKernel->GetCurrentCart ())
				{
					pKernel->SetCurrentCart (nSel);
					pKernel->LogLine ("UI: booting selected cart");
				}
				else
				{
					pKernel->LogLine ("UI: selected cart already running");
				}
				pKernel->SetOverlayOpen (FALSE);
				// DoReset() reloads the current cart, so this both boots a
				// newly selected ROM and reboots the current one.
				pKernel->RequestReset ();
				bChanged = TRUE;
			}
			break;

		case UiKeyEsc:
			if (pKernel->IsOverlayOpen ())
			{
				pKernel->SetOverlayOpen (FALSE);
				pKernel->LogLine ("UI: overlay closed");
				bChanged = TRUE;
			}
			break;

		default:
			break;
		}
	}

	if (bChanged && !pKernel->IsOverlayOpen ())
	{
		// The overlay drew over the last blitted frame; restore it.
		VDPBlit_Redraw ();
	}

	return bChanged;
}

void CMsxTask::Run (void)
{
	FramePacer Pacer = {};
	bool bPacingActive = false;
	unsigned nWindowStart = 0, nWindowFrames = 0, nWorkMax = 0;
	unsigned nLastLate = 0, nLastResync = 0;
	unsigned nPsgWrites = 0, nPsgPeak = 0, nPsgDropped = 0;
	u64 nWorkTotal = 0;

	// Selection last painted into the framebuffer. The menu is only redrawn
	// when it actually changes: the emulator is frozen while the menu is up,
	// so the pixels underneath are static and repainting the box every 16 ms
	// just burned CPU (and could be caught mid-sweep by the HDMI scanout).
	int nDrawnSel = OVERLAY_NOT_DRAWN;
	for (;;)
	{
		if (m_pKernel->TakeResetRequest ())
		{
			m_pKernel->DoReset ();
			bPacingActive = false;

			// DoReset repaints the whole screen, so the menu has to be
			// painted again even if the selection did not move.
			nDrawnSel = OVERLAY_NOT_DRAWN;
		}

		// UI hotkeys first: they are queued by the USB IRQ and must be
		// serviced even while the emulator is paused.
		bool bUiHandled = ServiceUiQueue (m_pKernel);

		// The menu owns the screen while it is open: freeze the emulator.
		if (m_pKernel->IsOverlayOpen ())
		{
			bPacingActive = false;

			// Diagnostic: about once a second, report the frame counter. While
			// the menu is up it must not move - if it does, something is still
			// stepping the machine and it is what overwrites the menu.
			static unsigned s_nOverlayIters = 0;
			if (++s_nOverlayIters >= 64)
			{
				s_nOverlayIters = 0;
				char sBuf[96];
				snprintf (sBuf, sizeof (sBuf),
					"UI: overlay held, frames=%llu, ui_events=%u, sel=%d",
					m_pKernel->GetFrames (), m_pKernel->GetUiEvents (),
					m_pKernel->GetOverlaySelection ());
				m_pKernel->LogLine (sBuf);
			}

			int nSel = m_pKernel->GetOverlaySelection ();
			if (nSel != nDrawnSel)
			{
				nDrawnSel = nSel;
				Overlay_Draw (nSel);
			}
			CScheduler::Get ()->MsSleep (OVERLAY_REDRAW_MS);
			continue;
		}

		// Menu closed: forget what was painted so the next open repaints.
		nDrawnSel = OVERLAY_NOT_DRAWN;

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

		if (bUiHandled)
		{
			// A menu action was handled; do not advance the emulator in the
			// same iteration so the reset/redraw above takes effect first.
			bPacingActive = false;
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

		// One frame of PSG audio per emulated frame. The sound device times
		// the PSG from the wall clock, so this also keeps the pitch right.
		m_pKernel->PushSound (machine);

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

			// PSG: writes proves the ROM programs the chip, peak proves the
			// chip actually produces samples, dropped counts queue overflow.
			m_pKernel->GetSoundStats (&nPsgWrites, &nPsgPeak, &nPsgDropped);
			snprintf (sBuf, sizeof(sBuf),
				"PSG: writes=%u peak=%u dropped=%u last=R%u val=%02X",
				nPsgWrites, nPsgPeak, nPsgDropped, g_psg_last_reg,
				g_psg_last_val);
			m_pKernel->LogLine (sBuf);
			nLastLate = Pacer.late;
			nLastResync = Pacer.resync;
			nWindowStart = nNow;
			nWindowFrames = nWorkMax = 0;
			nWorkTotal = 0;
		}
	}
}
