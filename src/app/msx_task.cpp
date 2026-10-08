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

// Core 1 has no Circle scheduler (it is core0-only), so the frame loop
// paces itself by polling the free-running 1 MHz system timer. Signed
// difference keeps this wrap-safe (the clock wraps every ~71 minutes).
static inline void msx_spin_us (unsigned nUs)
{
	unsigned nEnd = CTimer::GetClockTicks () + nUs;
	while ((int) (CTimer::GetClockTicks () - nEnd) < 0)
	{
		// busy-wait: nothing else runs on this core
	}
}

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
				// Rows: 0..TCartIdCount-1 cartridges, TCartIdCount audio.
				if (nSel > TCartIdCount) nSel = TCartIdCount;
				pKernel->SetOverlaySelection (nSel);
				bChanged = TRUE;
			}
			break;

		case UiKeyEnter:
			if (pKernel->IsOverlayOpen ())
			{
				int nSel = pKernel->GetOverlaySelection ();
				if (nSel >= TCartIdCount)
				{
				// Audio output row: HDMI+JACK -> jack -> HDMI ->
				// HDMI+JACK. The menu stays open; core 0 applies
				// the switch and logs it.
				int nCur = pKernel->GetAudioDest ();
				int nNext = (nCur == MSX_OUTPUT_AUTO)
						  ? MSX_OUTPUT_JACK
						  : (nCur == MSX_OUTPUT_JACK)
							 ? MSX_OUTPUT_HDMI
							 : MSX_OUTPUT_AUTO;
				pKernel->SetAudioDest (nNext);
				pKernel->LogLine (nNext == MSX_OUTPUT_AUTO
							  ? "UI: audio output -> HDMI+jack"
							  : nNext == MSX_OUTPUT_HDMI
									 ? "UI: audio output -> HDMI"
									 : "UI: audio output -> jack");
					bChanged = TRUE;
					break;
				}
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

	// One-shot audio telemetry and the serial kill switch (see below).
	bool bAud600 = false, bAud720 = false, bSerialOff = false;
	unsigned nWorkMaxCum = 0, nLastBeacon = 0;

	// Selection last painted into the framebuffer. The menu is only redrawn
	// when it actually changes: the emulator is frozen while the menu is up,
	// so the pixels underneath are static and repainting the box every 16 ms
	// just burned CPU (and could be caught mid-sweep by the HDMI scanout).
	// nDrawnAudio tracks the audio destination label so a switch repaints
	// even when the selection itself did not move.
	int nDrawnSel = OVERLAY_NOT_DRAWN;
	int nDrawnAudio = -1;
	for (;;)
	{
		if (m_pKernel->TakeResetRequest ())
		{
			// msx_destroy/msx_create need the newlib heap, which only
			// core 0 may use (the loop itself never allocates), so the
			// reset is handed over and core 1 waits for the rebuild.
			m_pKernel->ArmCore0Reset ();
			while (!m_pKernel->IsCore0ResetDone ())
			{
				// spin: core 0 is destroying/re-creating the machine
			}
			m_pKernel->ClearCore0ResetDone ();
			bPacingActive = false;

			// DoReset repaints the whole screen, so the menu has to be
			// painted again even if the selection did not move.
			nDrawnSel = OVERLAY_NOT_DRAWN;
			continue;
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
			int nAudio = m_pKernel->GetAudioDest ();
			if (nSel != nDrawnSel || nAudio != nDrawnAudio)
			{
				nDrawnSel = nSel;
				nDrawnAudio = nAudio;
				char sAudio[40];
				snprintf (sAudio, sizeof (sAudio), "AUDIO OUT: %s",
					  m_pKernel->GetAudioDestLabel ());
				Overlay_Draw (nSel, sAudio);
			}
			msx_spin_us (OVERLAY_REDRAW_MS * 1000);
			continue;
		}

		// Menu closed: forget what was painted so the next open repaints.
		nDrawnSel = OVERLAY_NOT_DRAWN;

		MSX_Machine *machine = m_pKernel->GetMachine ();

		if (machine == 0)
		{
			bPacingActive = false;
			msx_spin_us (10000);
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
			msx_spin_us (5000);
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

		// One batch of PSG audio per emulated frame, sized from the real
		// wall-clock interval: feed rate and pitch stay exact even when
		// the emulator misses the 60 Hz deadline.
		m_pKernel->PushSound (machine);

		if (m_pKernel->GetFrames () == 1)
		{
			m_pKernel->LogLine ("BOOT: MSX task produced first frame");
		}

		// One-shot AUD snapshots at frames 600 and 720: totals of pushed
		// / dropped / queued frames and PSG clocks over a known wall-clock
		// span. Offline: production = dPsh/dt, consumption =
		// (dPsh - dQueue)/dt (both expect 48000), clocks per sample =
		// dClock*1000/dPsh (expects 74574). psh is real pushed frames,
		// not the PSG register-write counter.
		if ((!bAud600 && m_pKernel->GetFrames () >= 600) ||
		    (!bAud720 && m_pKernel->GetFrames () >= 720))
		{
			if (!bAud600 && m_pKernel->GetFrames () >= 600)
				bAud600 = true;
			else
				bAud720 = true;

			unsigned nDr = 0;
			m_pKernel->GetSoundStats (0, 0, &nDr);
			char aBuf[192];
			snprintf (aBuf, sizeof (aBuf),
				"AUD: t=%u f=%llu psh=%u drop=%u q=%u ck=%llu qmin=%u ema=%d uns=%u",
				CTimer::GetClockTicks (),
				(unsigned long long) m_pKernel->GetFrames (),
				m_pKernel->GetSoundPushedFrames (), nDr,
				m_pKernel->GetSoundQueueFrames (),
				m_pKernel->GetSoundClockTotal (),
				m_pKernel->GetSoundQueueMin (),
				m_pKernel->GetSoundLevelEma (),
				m_pKernel->GetSoundUnderruns ());
			m_pKernel->LogLine (aBuf);
		}

		// Serial off for good once boot diagnostics and both AUD lines
		// are out: the UART TX busy-wait, the logger and the per-line
		// formatting cost about 0.4 ms per frame, which is exactly the
		// margin the 60 Hz pacer was missing (work_avg 17.1 ms vs the
		// 16.7 ms budget). The core's IRQ diagnostics are cut at the
		// source too, so a later machine reset cannot re-arm them.
		if (!bSerialOff && m_pKernel->GetFrames () >= 900)
		{
			bSerialOff = true;
			char sBuf[96];
			snprintf (sBuf, sizeof (sBuf),
				"SER: serial log disabled at frame=%llu",
				(unsigned long long) m_pKernel->GetFrames ());
			m_pKernel->LogLine (sBuf);
			machine->diag_log = 0;
			m_pKernel->SetSerialEnabled (FALSE);
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
		{
			msx_spin_us (nSleep);
		}

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

			// Remember the worst frame of every window even after
			// the serial kill switch, so a beacon can surface stalls
			// the quiet PACE lines never showed.
			if (nWorkMax > nWorkMaxCum) nWorkMaxCum = nWorkMax;

			// SB beacon: one compact line every ~30 s after the
			// serial kill switch (~140 chars / 30 s = 0.007 ms per
			// frame, vs 0.4 ms/frame for the old per-window logs).
			// fps vs work_avg splits wait-bound stalls (HDMI
			// firmware backpressure: fps low, work normal) from
			// CPU overload (work_avg high); wmaxc catches one-off
			// stalls up to 30 s old; sndus is the worst ever
			// PushFrame duration - stays in the hundreds of
			// microseconds means the PSG synthesis is innocent.
			if (!m_pKernel->IsSerialEnabled () &&
			    nNow - nLastBeacon >= 30000000)
			{
				nLastBeacon = nNow;
				char bBuf[208];
				snprintf (bBuf, sizeof (bBuf),
					"SB: t=%u fps100=%u work=%u wmax=%u wmaxc=%u psh=%u drop=%u q=%u ck=%llu sndus=%u qmin=%u uns=%u",
					nNow, nFPS100,
					(unsigned) (nWorkTotal / nWindowFrames),
					nWorkMax, nWorkMaxCum,
					m_pKernel->GetSoundPushedFrames (),
					nPsgDropped,
					m_pKernel->GetSoundQueueFrames (),
					m_pKernel->GetSoundClockTotal (),
					m_pKernel->GetSoundPushUsMax (),
					m_pKernel->GetSoundQueueMin (),
					m_pKernel->GetSoundUnderruns ());
				m_pKernel->SetSerialEnabled (TRUE);
				m_pKernel->LogLine (bBuf);
				m_pKernel->SetSerialEnabled (FALSE);
				nWorkMaxCum = 0;
			}

			nWindowStart = nNow;
			nWindowFrames = nWorkMax = 0;
			nWorkTotal = 0;
		}
	}
}
