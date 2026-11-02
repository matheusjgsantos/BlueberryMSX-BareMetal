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
 * Ownership: MSX_Memory owns the slot array and active page selection. The
 * MSX_Machine compatibility fields are pointers into this object, so existing
 * code can continue to use machine->slots[] and machine->activeSlot[]. A
 * future machine profile can provide a different MSX_Memory instance without
 * changing the CPU or device seams. */

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

typedef struct MSX_Memory MSX_Memory;

/* Address decoder for one memory profile. `ctx` is supplied by the machine
 * when the profile is attached, so the MSX backend can use the live RPMC bus
 * callbacks without the memory object depending on MSX_Machine directly.
 * A profile that has no ops (or a NULL read/write) is inert: reads return
 * 0xFF and writes are ignored. */
typedef struct {
    const char *name;
    UInt8 (*read)(MSX_Memory *memory, void *ctx, UInt16 addr);
    void (*write)(MSX_Memory *memory, void *ctx, UInt16 addr, UInt8 val);
} MSX_MemoryOps;

struct MSX_Memory {
    MSX_Slot slots[NUM_SLOTS];
    UInt8 slotReg;
    int activeSlot[4];
    /* Address-decode profile. MSX1 uses the slot backend in
     * src/core/msx_memory_msx.c; a flat-memory machine can attach its own. */
    const MSX_MemoryOps *ops;
    void *ctx;
};

void msx_memory_init(MSX_Memory *memory);
void msx_memory_set_ops(MSX_Memory *memory, const MSX_MemoryOps *ops, void *ctx);
UInt8 msx_memory_read(MSX_Memory *memory, UInt16 addr);
void msx_memory_write(MSX_Memory *memory, UInt16 addr, UInt8 val);

/* Flat-memory profile used by machines without the MSX slot model
 * (ColecoVision first). The profile owns a byte store and a small ordered
 * region map; a region can alias the same storage with a smaller `size`, which
 * implements the mirrored BIOS and 1 KB RAM windows without special cases.
 *
 * Address hit = first region whose [start,end] contains the address. The byte
 * is storage[offset + ((addr - start) % size)]; reads outside every region
 * return 0xFF and writes are ignored. Read-only regions ignore writes. */
#define MSX_FLAT_STORAGE_SIZE 0x20000
#define MSX_FLAT_MAX_REGIONS 8

typedef struct {
    UInt16 start;      /* first address (inclusive) */
    UInt16 end;        /* last address (inclusive) */
    UInt32 offset;     /* byte offset into MSX_FlatMemory.storage */
    UInt32 size;       /* window size; addresses mirror inside it */
    int readonly;
} MSX_FlatRegion;

typedef struct {
    UInt8 storage[MSX_FLAT_STORAGE_SIZE];
    MSX_FlatRegion regions[MSX_FLAT_MAX_REGIONS];
    int count;
} MSX_FlatMemory;

void msx_flat_init(MSX_FlatMemory *flat);
int msx_flat_map(MSX_FlatMemory *flat, UInt16 start, UInt16 end,
                 UInt32 offset, UInt32 size, int readonly);
void msx_flat_load(MSX_FlatMemory *flat, UInt32 offset,
                   const void *data, UInt32 size);
void msx_flat_fill(MSX_FlatMemory *flat, UInt32 offset, UInt8 val, UInt32 size);
UInt8 msx_flat_read(MSX_FlatMemory *flat, UInt16 addr);
void msx_flat_write(MSX_FlatMemory *flat, UInt16 addr, UInt8 val);
const MSX_MemoryOps *msx_memory_ops_flat(void);

#ifdef __cplusplus
}
#endif

#endif /* MSX_MEMORY_H */
