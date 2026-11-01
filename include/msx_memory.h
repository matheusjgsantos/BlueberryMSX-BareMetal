#ifndef MSX_MEMORY_H
#define MSX_MEMORY_H

#include "msx_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* MSX slot model: four primary slots, each with four subslots, each subslot
 * backing a full 64 KB address space. This header defines the storage and the
 * cartridge-mapper types so the memory decoder (src/core/msx.c) and the mapper
 * policy (src/core/msx_mapper.c) can share them without pulling in the whole
 * machine.
 *
 * Ownership note: the slot array currently still lives in MSX_Machine. Moving
 * it behind an MSX_Memory handle is the next step, once the machine profile
 * layer needs to swap in a non-MSX memory map. */

#define NUM_SLOTS 4
#define NUM_SUBSLOTS 4
#define REGION_SIZE 0x4000
#define SLOT_MAX_SIZE 0x10000

typedef enum {
    MSX_MAPPER_NONE = 0,
    MSX_MAPPER_AUTO,
    MSX_MAPPER_ASCII8,
    MSX_MAPPER_ASCII16,
    MSX_MAPPER_KONAMI,
    MSX_MAPPER_KONAMI_SCC,
    MSX_MAPPER_NOMAPPER
} MSX_MapperType;

typedef struct {
    uint8_t data[0x10000]; // 64KB per slot/subslot
    uint8_t rom[0x10000];  // read-only mask: 1 = ROM byte (writes ignored)
    int size;
    // Live-bus backing: -1 = emulated buffer (data[]), else a physical RPMC
    // board connector (0 = connector 1, 1 = connector 3). When >= 0 every
    // memory read/write in this (slot, subslot) is served by the bus
    // callbacks below instead of data[].
    int busSlot;
    // MegaROM mapper state for emulated (non-bus) subslots. pRomImage is a
    // heap-owned full ROM image (may exceed the 64KB data[] window); it is
    // only used when mapperType != MSX_MAPPER_NONE.
    MSX_MapperType mapperType;
    uint8_t *pRomImage;
    unsigned romSize;      // total ROM bytes loaded
    unsigned romMask;      // bank mask (e.g. (romSize/0x2000)-1)
    unsigned char bank[4]; // 8KB bank numbers for windows 0x4000,0x6000,0x8000,0xA000
} MSX_SubSlot;

typedef struct {
    MSX_SubSlot subslots[NUM_SUBSLOTS];
} MSX_Slot;

#ifdef __cplusplus
}
#endif

#endif /* MSX_MEMORY_H */
