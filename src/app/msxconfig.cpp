//
// msxconfig.cpp
//
// BlueberryMSX - Bare-metal MSX emulator for Raspberry Pi (Circle)
//

#define _GNU_SOURCE

#include "msxconfig.h"

#include <circle/fs/fat/fatfs.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define MSX_INI_FILENAME	"msx.ini"
// Must exceed the whole file: the active (uncommented) settings usually sit
// below the comment header, so a too-small buffer silently drops them. The
// shipped msx.ini is ~3.6 KiB; keep headroom for future edits.
#define MSX_INI_MAX		8192

static char *Trim (char *p)
{
	while (*p == ' ' || *p == '\t')
	{
		p++;
	}
	return p;
}

static void TrimEnd (char *p)
{
	size_t n = strlen (p);
	while (n > 0 && (p[n - 1] == ' ' || p[n - 1] == '\t'
		       || p[n - 1] == '\r' || p[n - 1] == '\n'))
	{
		p[--n] = '\0';
	}
}

static bool StrTrue (const char *p)
{
	if (!strcasecmp (p, "on")  || !strcasecmp (p, "yes")
	 || !strcasecmp (p, "1")   || !strcasecmp (p, "true"))
	{
		return true;
	}
	return false;
}

static int LogLevelFromString (const char *p)
{
	if (!strcasecmp (p, "debug"))	return 4;	// LogDebug
	if (!strcasecmp (p, "info"))	return 3;	// LogNotice
	if (!strcasecmp (p, "warn") || !strcasecmp (p, "warning"))	return 2; // LogWarning
	if (!strcasecmp (p, "error"))	return 1;	// LogError
	if (!strcasecmp (p, "panic"))	return 0;	// LogPanic
	return -1;
}

bool MsxConfig_Load (MSXConfig *pCfg, CFATFileSystem *pFs)
{
	if (pFs == 0)
	{
		return false;
	}

	unsigned hFile = pFs->FileOpen (MSX_INI_FILENAME);
	if (hFile == 0)
	{
		return false;
	}

	// static: this is called once at boot; avoids an 8 KiB stack frame
	static char aBuf[MSX_INI_MAX];
	unsigned nRead = pFs->FileRead (hFile, aBuf, sizeof (aBuf) - 1);
	pFs->FileClose (hFile);
	if (nRead == 0)
	{
		return false;
	}
	aBuf[nRead] = '\0';

	bool bParsed = false;
	char *pSave = aBuf;
	for (char *pLine = strtok_r (pSave, "\n", &pSave); pLine != 0;
	     pLine = strtok_r (pSave, "\n", &pSave))
	{
		char *p = Trim (pLine);
		if (*p == '\0' || *p == '#' || *p == ';' || *p == '[')
		{
			continue;
		}

		char *pEq = strchr (p, '=');
		if (pEq == 0)
		{
			continue;
		}
		*pEq = '\0';
		char *pKey = Trim (p);
		TrimEnd (pKey);
		char *pVal = Trim (pEq + 1);
		TrimEnd (pVal);
		if (*pKey == '\0' || *pVal == '\0')
		{
			continue;
		}

		bParsed = true;

		if (!strcasecmp (pKey, "log"))
		{
			if (!strcasecmp (pVal, "off"))		pCfg->nLogMode = MsxLogOff;
			else if (!strcasecmp (pVal, "file"))	pCfg->nLogMode = MsxLogFile;
			else if (!strcasecmp (pVal, "net"))	pCfg->nLogMode = MsxLogNet;
			else /* uart */				pCfg->nLogMode = MsxLogUart;
		}
		else if (!strcasecmp (pKey, "loglevel"))
		{
			int nLevel = LogLevelFromString (pVal);
			if (nLevel >= 0)
			{
				pCfg->nLogLevel = nLevel;
			}
		}
		else if (!strcasecmp (pKey, "msxbus"))
		{
			pCfg->bMsxbusEnable = StrTrue (pVal);
		}
		else if (!strcasecmp (pKey, "msxbus.dump"))
		{
			pCfg->bMsxbusDump = StrTrue (pVal);
		}
		else if (!strcasecmp (pKey, "diag"))
		{
			pCfg->bDiagDump = StrTrue (pVal);
		}
		else if (!strcasecmp (pKey, "mfrprobe"))
		{
			pCfg->bMfrProbe = StrTrue (pVal);
		}
		else if (!strcasecmp (pKey, "machine"))
		{
			if (!strcasecmp (pVal, "msx2+") || !strcasecmp (pVal, "msx2plus")
			 || !strcasecmp (pVal, "msx2+"))
			{
				pCfg->nMachine = 2;
			}
			else if (!strcasecmp (pVal, "msx2"))
			{
				pCfg->nMachine = 1;
			}
			else /* msx1 */
			{
				pCfg->nMachine = 0;
			}
		}
		else if (!strcasecmp (pKey, "cart.mapper") || !strcasecmp (pKey, "mapper"))
		{
			if (!strcasecmp (pVal, "ascii8"))
				pCfg->nCartMapper = MsxMapperAscii8;
			else if (!strcasecmp (pVal, "none"))
				pCfg->nCartMapper = MsxMapperNone;
			else if (!strcasecmp (pVal, "konami"))
				pCfg->nCartMapper = MsxMapperKonami;
			else if (!strcasecmp (pVal, "konamiscc"))
				pCfg->nCartMapper = MsxMapperKonamiScc;
			else
				pCfg->nCartMapper = MsxMapperAuto;
		}
		else if (!strcasecmp (pKey, "msxbus.mode"))
		{
			if (!strcasecmp (pVal, "cache"))
			{
				pCfg->nMsxbusMode = MsxBusCache;
			}
			else
			{
				pCfg->nMsxbusMode = MsxBusLive;
			}
		}
		else if (!strcasecmp (pKey, "msxbus.size"))
		{
			unsigned long n = strtoul (pVal, 0, 0);
			if (n > 0 && n <= 0x100000)	// 1 MiB cap
			{
				pCfg->nDumpBytes = (unsigned) n;
			}
		}
		else if (!strcasecmp (pKey, "msxbus.dumpmapper"))
		{
			if (!strcasecmp (pVal, "konami"))
				pCfg->nDumpMapper = MsxBusDumpKonami;
			else if (!strcasecmp (pVal, "konamiscc"))
				pCfg->nDumpMapper = MsxBusDumpKonamiScc;
			else if (!strcasecmp (pVal, "ascii8"))
				pCfg->nDumpMapper = MsxBusDumpAscii8;
			else /* linear */
				pCfg->nDumpMapper = MsxBusDumpLinear;
		}
		else if (!strcasecmp (pKey, "msxbus.slot1"))
		{
			unsigned long n = strtoul (pVal, 0, 0);
			if (n <= 3)			// an emulated primary slot
			{
				pCfg->nMsxbusSlot1 = (int) n;
			}
		}
		else if (!strcasecmp (pKey, "msxbus.slot3"))
		{
			unsigned long n = strtoul (pVal, 0, 0);
			if (n <= 3)
			{
				pCfg->nMsxbusSlot3 = (int) n;
			}
		}
		else if (!strcasecmp (pKey, "msxbus.rddelay"))
		{
			unsigned long n = strtoul (pVal, 0, 0);
			if (n <= 100000)
			{
				pCfg->nMsxbusReadDelay = (int) n;
			}
		}
	}

	return bParsed;
}

const char *MsxLogModeName (int nMode)
{
	switch (nMode)
	{
	case MsxLogOff:		return "off";
	case MsxLogFile:	return "file";
	case MsxLogNet:		return "net";
	default:		return "uart";
	}
}