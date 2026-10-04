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
#include <circle/sched/scheduler.h>
#include <circle/fs/fat/fatfs.h>
#include <SDCard/emmc.h>
#include <circle/types.h>

extern "C"
{
#include <msx.h>
}

#include "teelog.h"

enum TShutdownMode
{
	ShutdownNone,
	ShutdownHalt,
	ShutdownReboot
};

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

	// Recreate and re-initialize the MSX machine.
	// Must only be called from the MSX task context.
	void DoReset (void);

	// Write a preformatted line to the logger (UART + log ring buffer).
	void LogLine (const char *pText);

	// Public entry point for C callbacks (e.g. msx_diag_cb in the core).
	void DiagLog (const char *pText);

	// Write one 256x192 frame (32bpp ARGB) to a PPM file on the SD card.
	void WriteFrame (const unsigned char *pFrame, unsigned int nBytes, unsigned int nFrameNo);

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
};

#endif
