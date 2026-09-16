//
// syscalls.cpp
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//
// newlib syscall stubs. stdout/stderr are routed to the log ring buffer
// (visible at /log); malloc is backed by a static heap via _sbrk.

#include <circle/types.h>
#include "apilog.h"

#include <sys/stat.h>
#include <stdint.h>

extern "C"
{

static unsigned char s_acHeap[512 * 1024];
static unsigned long s_nHeapPos = 0;

void *_sbrk (intptr_t nIncrement)
{
	unsigned long nPrev = s_nHeapPos;
	if (nIncrement > 0 && s_nHeapPos + (unsigned long) nIncrement > sizeof(s_acHeap))
	{
		return (void *) -1;
	}

	s_nHeapPos += (unsigned long) nIncrement;
	return (void *) (s_acHeap + nPrev);
}

int _write (int nFile, const void *pBuffer, unsigned int nCount)
{
	if (nCount > 0 && pBuffer != 0)
	{
		LogAppend (pBuffer, nCount);
	}

	return (int) nCount;
}

int _read (int nFile, void *pBuffer, unsigned int nCount)
{
	(void) nFile;
	(void) pBuffer;
	(void) nCount;
	return 0;
}

int _open (const char *pPath, int nFlags, int nMode)
{
	(void) pPath;
	(void) nFlags;
	(void) nMode;
	return -1;
}

int _close (int nFile)
{
	(void) nFile;
	return 0;
}

off_t _lseek (int nFile, off_t nOffset, int nWhence)
{
	(void) nFile;
	(void) nOffset;
	(void) nWhence;
	return 0;
}

int _fstat (int nFile, struct stat *pStat)
{
	(void) nFile;
	pStat->st_mode = S_IFREG;
	return 0;
}

int _isatty (int nFile)
{
	(void) nFile;
	return 1;
}

void _kill (int nPid, int nSig)
{
	(void) nPid;
	(void) nSig;
}

int _getpid (void)
{
	return 1;
}

void _exit (int nStatus)
{
	(void) nStatus;
	for (;;)
	{
	}
}

}
