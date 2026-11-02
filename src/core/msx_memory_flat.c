// Flat-memory profile (non-MSX machines).
//
// Owns a byte store plus an ordered region map. Regions may mirror the same
// storage with a smaller window size, which covers the ColecoVision BIOS
// mirror (0x0000-0x5FFF) and its 1 KB RAM mirrored across 0x6000-0x7FFF.

#include <msx_memory.h>

#include <stddef.h>
#include <string.h>

void msx_flat_init(MSX_FlatMemory *flat)
{
    if (!flat) return;
    memset(flat->storage, 0xFF, sizeof flat->storage);
    memset(flat->regions, 0, sizeof flat->regions);
    flat->count = 0;
}

int msx_flat_map(MSX_FlatMemory *flat, UInt16 start, UInt16 end,
                 UInt32 offset, UInt32 size, int readonly)
{
    if (!flat || flat->count >= MSX_FLAT_MAX_REGIONS) return -1;
    if (start > end || size == 0) return -1;
    if (offset >= MSX_FLAT_STORAGE_SIZE) return -1;
    if (size > MSX_FLAT_STORAGE_SIZE - offset) return -1;

    MSX_FlatRegion *r = &flat->regions[flat->count++];
    r->start = start;
    r->end = end;
    r->offset = offset;
    r->size = size;
    r->readonly = readonly != 0;
    return 0;
}

void msx_flat_load(MSX_FlatMemory *flat, UInt32 offset,
                   const void *data, UInt32 size)
{
    if (!flat || !data || offset >= MSX_FLAT_STORAGE_SIZE) return;
    if (size > MSX_FLAT_STORAGE_SIZE - offset)
        size = MSX_FLAT_STORAGE_SIZE - offset;
    memcpy(flat->storage + offset, data, size);
}

void msx_flat_fill(MSX_FlatMemory *flat, UInt32 offset, UInt8 val, UInt32 size)
{
    if (!flat || offset >= MSX_FLAT_STORAGE_SIZE) return;
    if (size > MSX_FLAT_STORAGE_SIZE - offset)
        size = MSX_FLAT_STORAGE_SIZE - offset;
    memset(flat->storage + offset, val, size);
}

static const MSX_FlatRegion *flat_find(const MSX_FlatMemory *flat, UInt16 addr)
{
    for (int i = 0; i < flat->count; i++) {
        const MSX_FlatRegion *r = &flat->regions[i];
        if (addr >= r->start && addr <= r->end) return r;
    }
    return NULL;
}

UInt8 msx_flat_read(MSX_FlatMemory *flat, UInt16 addr)
{
    if (!flat) return 0xFF;
    const MSX_FlatRegion *r = flat_find(flat, addr);
    if (!r) return 0xFF;
    UInt32 index = (UInt32)(addr - r->start) % r->size;
    return flat->storage[r->offset + index];
}

void msx_flat_write(MSX_FlatMemory *flat, UInt16 addr, UInt8 val)
{
    if (!flat) return;
    MSX_FlatRegion *r = (MSX_FlatRegion *)flat_find(flat, addr);
    if (!r || r->readonly) return;
    UInt32 index = (UInt32)(addr - r->start) % r->size;
    flat->storage[r->offset + index] = val;
}

static UInt8 flat_ops_read(MSX_Memory *memory, void *ctx, UInt16 addr)
{
    (void)memory;
    return msx_flat_read((MSX_FlatMemory *)ctx, addr);
}

static void flat_ops_write(MSX_Memory *memory, void *ctx, UInt16 addr, UInt8 val)
{
    (void)memory;
    msx_flat_write((MSX_FlatMemory *)ctx, addr, val);
}

static const MSX_MemoryOps s_flat_ops = {
    "flat",
    flat_ops_read,
    flat_ops_write,
};

const MSX_MemoryOps *msx_memory_ops_flat(void)
{
    return &s_flat_ops;
}
