#ifndef MSX_MAPPER_H
#define MSX_MAPPER_H

#include "msx_types.h"
#include "msx_memory.h"

#ifdef __cplusplus
extern "C" {
#endif

/* MegaROM bank-mapper policy, independent of the address decoder.
 *
 * The memory decoder (src/core/msx.c) decides which subslot serves an address
 * and handles the physical cartridge bus; this module decides what a mapped
 * ROM subslot returns for a read and which bank-register writes it accepts.
 * All functions operate on one MSX_SubSlot whose mapperType is not AUTO (the
 * machine resolves AUTO when loading the ROM).
 */

/* True for the mapper types that expose four switchable 8 KB windows:
 * ASCII8, ASCII16 (approximated with the ASCII8 decode), Konami and
 * Konami-SCC. False for NONE/NOMAPPER/AUTO. */
int msx_mapper_is_mapped(MSX_MapperType type);

/* Read one byte from a mapped ROM subslot. Call only when
 * msx_mapper_is_mapped(ss->mapperType) and ss->romSize > 0 and addr >= 0x4000;
 * addresses outside the four windows (>= 0xC000) read as idle bus (0xFF). */
UInt8 msx_mapper_read(const MSX_SubSlot *ss, UInt16 addr);

/* Decode a write in the cartridge area. Bank-register writes update
 * ss->bank[]; every other write to a mapped ROM is ignored (ROM is read-only).
 * Call only when msx_mapper_is_mapped(ss->mapperType) and ss->romSize > 0. */
void msx_mapper_write(MSX_SubSlot *ss, UInt16 addr, UInt8 val);

/* Bank-select heuristic ("LD (nn),A" idiom scan), used when the ROM declares
 * MSX_MAPPER_AUTO. Mirrors openMSX's bias away from ASCII8. */
MSX_MapperType msx_mapper_guess(const uint8_t *pImage, unsigned nSize);

#ifdef __cplusplus
}
#endif

#endif /* MSX_MAPPER_H */
