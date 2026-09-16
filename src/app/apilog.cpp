//
// apilog.cpp
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//

#include "apilog.h"

#define LOG_BUF_SIZE 8192U

static char        g_LogBuf[LOG_BUF_SIZE];
static volatile unsigned long g_nHead = 0;	// next write index (monotonic)
static volatile unsigned long g_nTail = 0;	// next read index  (monotonic)

void LogAppend (const void *pBuffer, size_t nCount)
{
	const char *p = (const char *) pBuffer;

	for (size_t i = 0; i < nCount; i++)
	{
		unsigned long idx = __sync_fetch_and_add (&g_nHead, 1);
		g_LogBuf[idx % LOG_BUF_SIZE] = p[i];
	}
}

size_t LogAvailable (void)
{
	unsigned long avail = g_nHead - g_nTail;

	if (avail > LOG_BUF_SIZE)
	{
		avail = LOG_BUF_SIZE;
	}

	return (size_t) avail;
}

size_t LogRead (char *pOut, size_t nMax)
{
	size_t nAvail = LogAvailable ();

	if (nAvail > nMax)
	{
		nAvail = nMax;
	}

	for (size_t i = 0; i < nAvail; i++)
	{
		unsigned long idx = g_nTail + i;
		pOut[i] = g_LogBuf[idx % LOG_BUF_SIZE];
	}

	g_nTail += nAvail;

	return nAvail;
}
