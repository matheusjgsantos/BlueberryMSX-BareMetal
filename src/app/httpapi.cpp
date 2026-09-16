//
// httpapi.cpp
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#include "httpapi.h"
#include "kernel.h"
#include "apilog.h"

#include <circle/sched/scheduler.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

extern "C"
{
#include "R800.h"
#include "tms9918.h"
}

#define MSX_HTTP_PORT	8080
#define CONTENT_SIZE	16384

// RAII guard: pauses the machine for coherent reads, waits for an in-flight
// frame to settle, and restores the previous pause state on exit.
class MachineGuard
{
public:
	explicit MachineGuard (CKernel *pKernel): m_pKernel (pKernel), m_bWasPaused (FALSE)
	{
		m_bWasPaused = m_pKernel->IsPaused ();
		if (!m_bWasPaused)
		{
			m_pKernel->SetPaused (TRUE);
			for (unsigned nWait = 0; nWait < 200 && m_pKernel->IsInStep (); nWait++)
			{
				CScheduler::Get ()->MsSleep (1);
			}
		}
	}

	~MachineGuard ()
	{
		if (!m_bWasPaused)
		{
			m_pKernel->SetPaused (FALSE);
		}
	}

private:
	CKernel *m_pKernel;
	boolean m_bWasPaused;
};

// Return the value of a "name=..." parameter, or 0 if not present.
static const char *QueryValue (const char *pParams, const char *pName)
{
	if (pParams == 0)
	{
		return 0;
	}

	size_t nNameLen = strlen (pName);
	const char *p = pParams;
	while ((p = strstr (p, pName)) != 0)
	{
		if (p != pParams && p[-1] != '&' && p[-1] != '?')
		{
			p += nNameLen;
			continue;
		}

		p += nNameLen;
		if (*p == '=')
		{
			return p + 1;
		}
	}

	return 0;
}

static long ParseInt (const char *pText, long nDefault)
{
	if (pText == 0)
	{
		return nDefault;
	}

	char *pEnd = 0;
	long nVal = strtol (pText, &pEnd, 0);
	return (pEnd != pText) ? nVal : nDefault;
}

CMsxHttpServer::CMsxHttpServer (CNetSubSystem *pNetSubSystem, CKernel *pKernel, u16 nPort):
	CHTTPDaemon (pNetSubSystem, 0, CONTENT_SIZE, nPort),
	m_pKernel (pKernel)
{
}

CHTTPDaemon *CMsxHttpServer::CreateWorker (CNetSubSystem *pNetSubSystem, CSocket *pSocket)
{
	return new CMsxHttpServer (pNetSubSystem, m_pKernel, MSX_HTTP_PORT);
}

THTTPStatus CMsxHttpServer::GetContent (const char  *pPath,
					const char  *pParams,
					const char  *pFormData,
					u8	    *pBuffer,
					unsigned    *pLength,
					const char **ppContentType)
{
	(void) pFormData;

	if (strcmp (pPath, "/") == 0 || strcmp (pPath, "/index.html") == 0)
	{
		HandleIndex (pBuffer, pLength);
		return HTTPOK;
	}

	if (strcmp (pPath, "/status") == 0)
	{
		return HandleStatus (pBuffer, pLength);
	}

	if (strcmp (pPath, "/log") == 0)
	{
		return HandleLog (pBuffer, pLength);
	}

	if (strcmp (pPath, "/command") == 0)
	{
		return HandleCommand (pParams, pBuffer, pLength);
	}

	if (strcmp (pPath, "/regs") == 0)
	{
		return HandleRegs (pBuffer, pLength);
	}

	if (strcmp (pPath, "/mem") == 0)
	{
		return HandleMem (pParams, pBuffer, pLength);
	}

	snprintf ((char *) pBuffer, *pLength, "Not found");
	*pLength = 9;
	*ppContentType = "text/plain";
	return HTTPNotFound;
}

void CMsxHttpServer::HandleIndex (u8 *pBuffer, unsigned *pLength)
{
	const char *pHtml =
		"<html><head><title>BlueberryMSX</title>"
		"<meta http-equiv=\"refresh\" content=\"5\"></head><body>"
		"<h1>BlueberryMSX</h1>"
		"<ul>"
		"<li><a href=\"/status\">/status</a></li>"
		"<li><a href=\"/regs\">/regs</a></li>"
		"<li><a href=\"/mem?addr=0x0000&size=256\">/mem</a></li>"
		"<li><a href=\"/log\">/log</a></li>"
		"</ul>"
		"<p>Commands: "
		"<a href=\"/command?cmd=pause\">pause</a> | "
		"<a href=\"/command?cmd=resume\">resume</a> | "
		"<a href=\"/command?cmd=step\">step</a> | "
		"<a href=\"/command?cmd=reset\">reset</a></p>"
		"</body></html>";

	unsigned nLen = strlen (pHtml);
	if (nLen >= *pLength)
	{
		nLen = *pLength - 1;
	}

	memcpy (pBuffer, pHtml, nLen);
	*pLength = nLen;
}

THTTPStatus CMsxHttpServer::HandleStatus (u8 *pBuffer, unsigned *pLength)
{
	MSX_Machine *machine = m_pKernel->GetMachine ();
	if (machine == 0)
	{
		snprintf ((char *) pBuffer, *pLength, "{\"error\":\"no machine\"}");
		*pLength = strlen ((const char *) pBuffer);
		return HTTPOK;
	}

	R800 *z80 = (R800 *) machine->z80;
	int nLen = snprintf ((char *) pBuffer, *pLength,
		"{\"frames\":%llu,\"paused\":%s,"
		"\"cpu_mode\":%d,\"pc\":\"0x%04X\",\"sp\":\"0x%04X\",\"af\":\"0x%04X\"}",
		(unsigned long long) m_pKernel->GetFrames (),
		m_pKernel->IsPaused () ? "true" : "false",
		z80->cpuMode, z80->regs.PC.W, z80->regs.SP.W, z80->regs.AF.W);

	if (nLen >= (int) *pLength)
	{
		nLen = *pLength - 1;
	}

	*pLength = nLen;
	return HTTPOK;
}

THTTPStatus CMsxHttpServer::HandleLog (u8 *pBuffer, unsigned *pLength)
{
	unsigned nAvailable = LogAvailable ();
	if (nAvailable > *pLength)
	{
		nAvailable = *pLength;
	}

	LogRead ((char *) pBuffer, nAvailable);
	*pLength = nAvailable;
	return HTTPOK;
}

THTTPStatus CMsxHttpServer::HandleCommand (const char *pParams, u8 *pBuffer, unsigned *pLength)
{
	const char *pCmd = QueryValue (pParams, "cmd");
	if (pCmd == 0)
	{
		snprintf ((char *) pBuffer, *pLength, "{\"error\":\"missing cmd\"}");
		*pLength = strlen ((const char *) pBuffer);
		return HTTPBadRequest;
	}

	int nLen;
	if (strcmp (pCmd, "pause") == 0)
	{
		m_pKernel->SetPaused (TRUE);
		nLen = snprintf ((char *) pBuffer, *pLength, "{\"result\":\"paused\"}");
	}
	else if (strcmp (pCmd, "resume") == 0)
	{
		m_pKernel->SetPaused (FALSE);
		nLen = snprintf ((char *) pBuffer, *pLength, "{\"result\":\"resumed\"}");
	}
	else if (strcmp (pCmd, "step") == 0)
	{
		m_pKernel->RequestStep ();
		nLen = snprintf ((char *) pBuffer, *pLength, "{\"result\":\"step requested\"}");
	}
	else if (strcmp (pCmd, "reset") == 0)
	{
		m_pKernel->RequestReset ();
		nLen = snprintf ((char *) pBuffer, *pLength, "{\"result\":\"reset requested\"}");
	}
	else
	{
		snprintf ((char *) pBuffer, *pLength, "{\"error\":\"unknown cmd\"}");
		*pLength = strlen ((const char *) pBuffer);
		return HTTPBadRequest;
	}

	if (nLen >= (int) *pLength)
	{
		nLen = *pLength - 1;
	}

	*pLength = nLen;
	return HTTPOK;
}

THTTPStatus CMsxHttpServer::HandleRegs (u8 *pBuffer, unsigned *pLength)
{
	MachineGuard guard (m_pKernel);
	MSX_Machine *machine = m_pKernel->GetMachine ();
	if (machine == 0)
	{
		snprintf ((char *) pBuffer, *pLength, "{\"error\":\"no machine\"}");
		*pLength = strlen ((const char *) pBuffer);
		return HTTPOK;
	}

	R800 *z80 = (R800 *) machine->z80;
	TMS9918 *vdp = (TMS9918 *) machine->vdp;

	int nLen = snprintf ((char *) pBuffer, *pLength,
		"{\"cpu_mode\":%d,\"inst_cnt\":%u,"
		"\"AF\":\"0x%04X\",\"BC\":\"0x%04X\",\"DE\":\"0x%04X\",\"HL\":\"0x%04X\","
		"\"IX\":\"0x%04X\",\"IY\":\"0x%04X\",\"PC\":\"0x%04X\",\"SP\":\"0x%04X\","
		"\"I\":\"0x%02X\",\"R\":\"0x%02X\",\"im\":%d,\"halt\":%d,"
		"\"vdp\":{\"reg\":[%02X,%02X,%02X,%02X,%02X,%02X,%02X,%02X],"
		"\"addr\":\"0x%04X\",\"irq\":%d}}",
		z80->cpuMode, (unsigned) z80->instCnt,
		z80->regs.AF.W, z80->regs.BC.W, z80->regs.DE.W, z80->regs.HL.W,
		z80->regs.IX.W, z80->regs.IY.W, z80->regs.PC.W, z80->regs.SP.W,
		z80->regs.I, z80->regs.R, z80->regs.im, z80->regs.halt,
		vdp->reg[0], vdp->reg[1], vdp->reg[2], vdp->reg[3],
		vdp->reg[4], vdp->reg[5], vdp->reg[6], vdp->reg[7],
		vdp->addr, vdp->irq);

	if (nLen >= (int) *pLength)
	{
		nLen = *pLength - 1;
	}

	*pLength = nLen;
	return HTTPOK;
}

THTTPStatus CMsxHttpServer::HandleMem (const char *pParams, u8 *pBuffer, unsigned *pLength)
{
	MachineGuard guard (m_pKernel);
	MSX_Machine *machine = m_pKernel->GetMachine ();
	if (machine == 0)
	{
		snprintf ((char *) pBuffer, *pLength, "{\"error\":\"no machine\"}");
		*pLength = strlen ((const char *) pBuffer);
		return HTTPOK;
	}

	long nAddr = ParseInt (QueryValue (pParams, "addr"), 0);
	long nSize = ParseInt (QueryValue (pParams, "size"), 64);
	if (nAddr < 0)
	{
		nAddr = 0;
	}
	if (nAddr > 0xFFFF)
	{
		nAddr = 0xFFFF;
	}
	if (nSize < 1)
	{
		nSize = 1;
	}
	if (nSize > 1024)
	{
		nSize = 1024;
	}

	int nPos = 0;
	for (long i = 0; i < nSize; i += 16)
	{
		char sLine[96];
		int nLen = snprintf (sLine, sizeof(sLine), "%04X:", (unsigned) (nAddr + i));

		for (long j = 0; j < 16 && (i + j) < nSize; j++)
		{
			UInt8 b = machine->bus.read_mem (machine->bus.ref, (UInt16) (nAddr + i + j));
			nLen += snprintf (sLine + nLen, sizeof(sLine) - nLen, " %02X", b);
		}

		if (nPos + nLen < (int) *pLength)
		{
			memcpy (pBuffer + nPos, sLine, nLen);
			nPos += nLen;
		}
	}

	*pLength = nPos;
	return HTTPOK;
}
