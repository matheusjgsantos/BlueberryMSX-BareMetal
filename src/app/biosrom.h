//
// biosrom.h
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//
// C-BIOS ROM loading from the SD data partition. The ROM images ship in the
// BIOS/ directory of the FAT data partition (2nd partition, "emmc1-2"), one
// set per machine type:
//
//   MSX1    BIOS/cbios_main_msx1.rom  -> slot 0/0 @ 0x0000
//           BIOS/cbios_logo_msx1.rom  -> slot 0/0 @ 0x8000
//   MSX2    ... msx2 main/logo + BIOS/cbios_sub.rom   -> slot 3/0 @ 0x0000
//   MSX2+   ... msx2+ main/logo + sub + BIOS/cbios_music.rom -> slot 3/1 @ 0x4000
//
// This replaces the C-BIOS images that used to be linked into msx.img. A
// missing BIOS is fatal: the machine cannot boot without one, so the caller
// must halt when Bios_Load() fails.
//
// NOTE: only MSX1 is complete. The MSX2/MSX2+ sets are mapped and loadable,
// but those machines additionally need the MSX2 secondary-slot register
// (memory-mapped 0xFFFF) and a V9938/V9958 VDP in the core before they boot.
//

#ifndef _msx_biosrom_h
#define _msx_biosrom_h

#include <circle/fs/fat/fatfs.h>
#include <circle/types.h>

#include "msx.h"

enum TMsxMachine
{
	MsxMachineMSX1 = 0,
	MsxMachineMSX2,
	MsxMachineMSX2Plus,
	MsxMachineUnknown
};

// Load and map the C-BIOS ROM set for the given machine into pMachine.
// pFileSystem may be 0 when the data partition is not mounted. On failure
// returns FALSE and, if pError is not 0, writes a short reason there.
boolean Bios_Load (MSX_Machine *pMachine, CFATFileSystem *pFileSystem,
		   TMsxMachine Machine, char *pError, unsigned nErrorSize);

#endif
