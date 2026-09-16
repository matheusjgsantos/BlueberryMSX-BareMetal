//
// kernel.cpp
//
// Circle - A C++ bare metal environment for Raspberry Pi
// Copyright (C) 2015-2019  R. Stange <rsta2@o2online.de>
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
#include "kernel.h"
#include "httpbootserver.h"
#include "tftpbootserver.h"
#include <circle/chainboot.h>
#include <circle/sysconfig.h>
#include <assert.h>
#include <string.h>

extern "C" void diag_blink (unsigned nCount);
extern "C" void diag_uart (char c);

#define HTTP_BOOT_PORT		8080

// Network configuration
#define USE_DHCP

#ifndef USE_DHCP
static const u8 IPAddress[]      = {192, 168, 0, 250};
static const u8 NetMask[]        = {255, 255, 255, 0};
static const u8 DefaultGateway[] = {192, 168, 0, 1};
static const u8 DNSServer[]      = {192, 168, 0, 1};
#endif

static const char FromKernel[] = "kernel";

CKernel::CKernel (void)
:	m_Screen (m_Options.GetWidth (), m_Options.GetHeight ()),
	m_Timer (&m_Interrupt),
	m_EMMC (&m_Interrupt, &m_Timer),
	m_LogTarget (&m_Serial, &m_FatFS),
	m_Logger (m_Options.GetLogLevel (), &m_Timer),
	m_USBHCI (&m_Interrupt, &m_Timer)
#ifndef USE_DHCP
	, m_Net (IPAddress, NetMask, DefaultGateway, DNSServer)
#endif
{
}

CKernel::~CKernel (void)
{
	// this body runs before the member destructors; close the boot log
	// first so no FAT I/O is attempted while the USB controller shuts down
	diag_uart ('S');
	m_Logger.Write (FromKernel, LogNotice, "SHDN: closing boot log");
	m_LogTarget.CloseFile ();
}

boolean CKernel::Initialize (void)
{
	boolean bOK = TRUE;

	diag_uart ('H');
	diag_blink (8);

	if (bOK)
	{
		bOK = m_Screen.Initialize ();
	}

	diag_uart ('I');
	diag_blink (9);

	if (bOK)
	{
		bOK = m_Serial.Initialize (115200);
	}

	diag_uart ('J');
	diag_blink (10);

	if (bOK)
	{
		// mirror all log output to the screen and, once available, to
		// BOOT.LOG on the SD card FAT partition
		bOK = m_Logger.Initialize (&m_LogTarget);
	}

	diag_uart ('K');
	diag_blink (11);

	if (bOK)
	{
		bOK = m_Interrupt.Initialize ();
	}

	if (bOK)
	{
		bOK = m_Timer.Initialize ();
	}

	if (bOK)
	{
		bOK = m_USBHCI.Initialize ();
	}

	if (bOK)
	{
		// boot log on the boot device; a missing device or partition must
		// not prevent the TFTP/HTTP boot server from starting
		InitializeBootLog ();
	}

	if (bOK)
	{
		bOK = m_Net.Initialize ();
	}

	diag_uart ('L');
	diag_blink (12);

	return bOK;
}

void CKernel::InitializeBootLog (void)
{
	const char *pBootDev = m_Options.GetAppOptionString ("bootdev", "");

	boolean bOk = FALSE;

	if (strcmp (pBootDev, "emmc") == 0 || pBootDev [0] == '\0')
	{
		if (m_EMMC.Initialize ())
		{
			bOk = MountBootLog ("emmc1-2", "emmc1-1");
		}
		else
		{
			m_Logger.Write (FromKernel, LogError, "SD card not available; boot log disabled");
		}
	}

	if (!bOk && (strcmp (pBootDev, "umsd") == 0 || pBootDev [0] == '\0'))
	{
		bOk = MountBootLog ("umsd1-2", "umsd1-1");
	}

	if (!bOk)
	{
		m_Logger.Write (FromKernel, LogError, "No boot log partition available; boot log disabled");
	}
}

boolean CKernel::MountBootLog (const char *pPartA, const char *pPartB)
{
	const char *pUsed = 0;
	CDevice *pPartition = m_DeviceNameService.GetDevice (pPartA, TRUE);

	if (pPartition != 0)
	{
		pUsed = pPartA;
	}
	else
	{
		pPartition = m_DeviceNameService.GetDevice (pPartB, TRUE);
		if (pPartition != 0)
		{
			pUsed = pPartB;
		}
	}

	if (pPartition == 0 || !m_FatFS.Mount (pPartition))
	{
		m_Logger.Write (FromKernel, LogError, "Cannot mount FAT partition %s or %s; boot log disabled",
				pPartA, pPartB);
		return FALSE;
	}

	unsigned nHandle = m_FatFS.FileCreate ("BOOT.LOG");
	m_LogTarget.SetFileHandle (nHandle);
	m_Logger.Write (FromKernel, LogNotice, "Boot log: %s on %s",
			nHandle != 0 ? "BOOT.LOG" : "unavailable", pUsed);
	return TRUE;
}

TShutdownMode CKernel::Run (void)
{
	diag_uart ('M');
	m_Logger.Write (FromKernel, LogNotice, "MSX boot server compiled " __DATE__ " " __TIME__);

	CString IPString;
	m_Net.GetConfig ()->GetIPAddress ()->Format (&IPString);
	m_Logger.Write (FromKernel, LogNotice, "Open \"http://%s:%u/\" in your web browser!",
			(const char *) IPString, HTTP_BOOT_PORT);
	m_Logger.Write (FromKernel, LogNotice,
			"Select the MSX image and press boot, or:");
	m_Logger.Write (FromKernel, LogNotice,
			"  tftp -m binary %s -c put kernel.img",
			(const char *) IPString);

	new CHTTPBootServer (&m_Net, HTTP_BOOT_PORT, KERNEL_MAX_SIZE + 2000);
	new CTFTPBootServer (&m_Net, KERNEL_MAX_SIZE);

	CString sLastIP ("0.0.0.0");
	for (unsigned nCount = 0; !IsChainBootEnabled (); nCount++)
	{
		m_Screen.Rotor (0, nCount);

		CString sIP;
		m_Net.GetConfig ()->GetIPAddress ()->Format (&sIP);
		if (sIP.Compare ((const char *) sLastIP) != 0)
		{
			sLastIP = sIP;
			m_Logger.Write (FromKernel, LogNotice, "IP address: %s", (const char *) sIP);
		}

		m_Scheduler.Yield ();
	}

	diag_uart ('R');

	m_Logger.Write (FromKernel, LogNotice, "Rebooting ...");

	m_Scheduler.Sleep (1);

	return ShutdownReboot;
}
