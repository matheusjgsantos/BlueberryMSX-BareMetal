//
// kernel.h
//
// Circle - A C++ bare metal environment for Raspberry Pi
// Copyright (C) 2014-2019  R. Stange <rsta2@o2online.de>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
#ifndef _kernel_h
#define _kernel_h

#include <circle/koptions.h>
#include <circle/devicenameservice.h>
#include <circle/screen.h>
#include <circle/serial.h>
#include <circle/exceptionhandler.h>
#include <circle/interrupt.h>
#include <circle/timer.h>
#include <circle/device.h>
#include <SDCard/emmc.h>
#include <circle/fs/fat/fatfs.h>
#include <circle/logger.h>
#include <circle/usb/usbhcidevice.h>
#include <circle/sched/scheduler.h>
#include <circle/net/netsubsystem.h>
#include <circle/types.h>

enum TShutdownMode
{
	ShutdownNone,
	ShutdownHalt,
	ShutdownReboot
};

// logger target which mirrors every line to the serial console and (once a
// file handle has been set) to BOOT.LOG on the boot device FAT partition
class CLogTarget : public CDevice
{
private:
	CSerialDevice	*m_pSerial;
	CFATFileSystem	*m_pFatFS;
	unsigned		m_nFileHandle;

public:
	CLogTarget (CSerialDevice *pSerial, CFATFileSystem *pFatFS)
	:	m_pSerial (pSerial),
		m_pFatFS (pFatFS),
		m_nFileHandle (0)
	{
	}

	void SetFileHandle (unsigned nFileHandle)
	{
		m_nFileHandle = nFileHandle;
	}

	// FileClose updates the directory entry (size, first cluster) and flushes;
	// must run while the USB controller is still up
	void CloseFile ()
	{
		if (m_nFileHandle != 0 && m_pFatFS != 0)
		{
			m_pFatFS->FileClose (m_nFileHandle);
			m_nFileHandle = 0;
		}
	}

	int Write (const void *pBuffer, size_t nCount)
	{
		if (m_pSerial != 0)
		{
			m_pSerial->Write (pBuffer, nCount);
		}

		if (m_nFileHandle != 0 && m_pFatFS != 0)
		{
			m_pFatFS->FileWrite (m_nFileHandle, pBuffer, nCount);
			m_pFatFS->Synchronize ();
		}

		return nCount;
	}
};

class CKernel
{
public:
	CKernel (void);
	~CKernel (void);

	boolean Initialize (void);

	TShutdownMode Run (void);

private:
	void InitializeBootLog (void);
	boolean MountBootLog (const char *pPartA, const char *pPartB);
	// do not change this order
	CKernelOptions		m_Options;
	CDeviceNameService	m_DeviceNameService;
	CScreenDevice		m_Screen;
	CSerialDevice		m_Serial;
	CExceptionHandler	m_ExceptionHandler;
	CInterruptSystem	m_Interrupt;
	CTimer			m_Timer;
	CEMMCDevice		m_EMMC;
	CFATFileSystem	m_FatFS;
	CLogTarget		m_LogTarget;
	CLogger			m_Logger;
	CUSBHCIDevice		m_USBHCI;
	CScheduler		m_Scheduler;
	CNetSubSystem		m_Net;
};

#endif
