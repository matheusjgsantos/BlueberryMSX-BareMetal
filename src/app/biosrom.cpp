//
// biosrom.cpp
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//
// C-BIOS ROM loading from BIOS/ on the SD data partition. See biosrom.h.
//

#include "biosrom.h"

#include <circle/fs/fat/fatfs.h>
#include <circle/util.h>
#include <string.h>
#include <stdio.h>

#define BIOS_DIR	"BIOS/"

struct TBiosRom
{
	const char *pFileName;	// relative to BIOS_DIR
	int	nSlot;
	int	nSubSlot;
	UInt16	nOffset;	// offset within the 64 KiB subslot
};

struct TBiosSet
{
	const TBiosRom	*pRoms;
	unsigned	nCount;
	int		nRamSlot;
	int		nRamSubSlot;
	UInt8		nSlotMap;	// value written to port 0xA8
};

static const TBiosRom s_Msx1Roms[] =
{
	{ "cbios_main_msx1.rom", 0, 0, 0x0000 },
	{ "cbios_logo_msx1.rom", 0, 0, 0x8000 },
};

static const TBiosRom s_Msx2Roms[] =
{
	{ "cbios_main_msx2.rom", 0, 0, 0x0000 },
	{ "cbios_logo_msx2.rom", 0, 0, 0x8000 },
	{ "cbios_sub.rom",       3, 0, 0x0000 },
};

static const TBiosRom s_Msx2PlusRoms[] =
{
	{ "cbios_main_msx2+.rom", 0, 0, 0x0000 },
	{ "cbios_logo_msx2+.rom", 0, 0, 0x8000 },
	{ "cbios_sub.rom",        3, 0, 0x0000 },
	{ "cbios_music.rom",      3, 1, 0x4000 },
};

static const TBiosSet s_BiosSets[] =
{
	// MSX1: 64 KiB RAM in slot 3/0, main+logo BIOS in slot 0/0
	{ s_Msx1Roms,     2, 3, 0, 0xC0 },
	// MSX2: RAM in slot 3/2, SUB-ROM in slot 3/0
	{ s_Msx2Roms,     3, 3, 2, 0xC0 },
	// MSX2+: MSX2 plus MSX-MUSIC in slot 3/1
	{ s_Msx2PlusRoms, 4, 3, 2, 0xC0 },
};

// Read BIOS_DIR + pName into pBuffer. Returns the number of bytes read, or 0.
static unsigned LoadRomFile (CFATFileSystem *pFs, const char *pName,
			     u8 *pBuffer, unsigned nBufferSize)
{
	char Path[64];

	unsigned nDirLen = (unsigned) strlen (BIOS_DIR);
	if (nDirLen + strlen (pName) + 1 > sizeof Path)
	{
		return 0;
	}
	memcpy (Path, BIOS_DIR, nDirLen);
	strncpy (Path + nDirLen, pName, sizeof Path - nDirLen - 1);
	Path[sizeof Path - 1] = '\0';

	unsigned hFile = pFs->FileOpen (Path);
	if (hFile == 0)
	{
		return 0;
	}

	unsigned nRead = pFs->FileRead (hFile, pBuffer, nBufferSize);
	pFs->FileClose (hFile);

	if (nRead == 0 || nRead == FS_ERROR)
	{
		return 0;
	}

	return nRead;
}

static void SetError (char *pError, unsigned nErrorSize, const char *pMsg)
{
	if (pError != 0 && nErrorSize > 0)
	{
		strncpy (pError, pMsg, nErrorSize - 1);
		pError[nErrorSize - 1] = '\0';
	}
}

boolean Bios_Load (MSX_Machine *pMachine, CFATFileSystem *pFileSystem,
		   TMsxMachine Machine, char *pError, unsigned nErrorSize)
{
	if (pMachine == 0)
	{
		SetError (pError, nErrorSize, "no machine");
		return FALSE;
	}

	if ((int) Machine < 0 || Machine >= MsxMachineUnknown)
	{
		SetError (pError, nErrorSize, "unknown machine type");
		return FALSE;
	}

	if (pFileSystem == 0)
	{
		SetError (pError, nErrorSize, "SD data partition not mounted");
		return FALSE;
	}

	const TBiosSet *pSet = &s_BiosSets[(int) Machine];

	// Scratch buffer for one ROM image (largest C-BIOS image is 32 KiB).
	static u8 RomBuffer[SLOT_MAX_SIZE];

	// RAM subslot: a fresh 64 KiB, cleared to 0.
	msx_set_slot (pMachine, pSet->nRamSlot, pSet->nRamSubSlot, 0, 0);
	memset (pMachine->slots[pSet->nRamSlot].subslots[pSet->nRamSubSlot].data,
		0, SLOT_MAX_SIZE);

	for (unsigned i = 0; i < pSet->nCount; i++)
	{
		const TBiosRom *pRom = &pSet->pRoms[i];

		unsigned nSize = LoadRomFile (pFileSystem, pRom->pFileName,
					      RomBuffer, sizeof RomBuffer);
		if (nSize == 0)
		{
			// Report the full device path so the on-screen and serial
			// messages name the file the user must restore.
			char sErr[64];
			snprintf (sErr, sizeof sErr, "Missing %s%s", BIOS_DIR, pRom->pFileName);
			SetError (pError, nErrorSize, sErr);
			return FALSE;
		}

		msx_load_data (pMachine, pRom->nSlot, pRom->nSubSlot,
			       pRom->nOffset, RomBuffer, (int) nSize);
	}

	// C-BIOS slot map: page 3 -> slot 3 (RAM), pages 0/1/2 -> slot 0 (BIOS).
	pMachine->bus.write_io (pMachine->bus.ref, 0xA8, pSet->nSlotMap);

	return TRUE;
}
