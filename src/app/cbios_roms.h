//
// cbios_roms.h
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//
// C-BIOS ROM images (main BIOS at 0x0000, logo screen at 0x8000).
//

#ifndef _msx_cbios_roms_h
#define _msx_cbios_roms_h

#include <stdint.h>

extern const uint8_t  cbios_main_rom[];
extern const uint32_t cbios_main_rom_size;
extern const uint8_t  cbios_logo_rom[];
extern const uint32_t cbios_logo_rom_size;

#endif
