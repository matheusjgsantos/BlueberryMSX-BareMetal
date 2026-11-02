#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "msx.h"

/* Flat memory profile: region map, mirrors, read-only windows and open bus. */

static void test_region_map(void)
{
    MSX_FlatMemory flat;
    UInt8 bios[0x20];

    msx_flat_init(&flat);
    memset(bios, 0xA5, sizeof bios);

    assert(msx_flat_map(&flat, 0x0000, 0x1FFF, 0x0000, 0x2000, 1) == 0);
    assert(msx_flat_map(&flat, 0x6000, 0x7FFF, 0x2000, 0x0400, 0) == 0);
    assert(msx_flat_map(&flat, 0x8000, 0xFFFF, 0x10000, 0x8000, 1) == 0);

    msx_flat_load(&flat, 0x0000, bios, sizeof bios);
    assert(msx_flat_read(&flat, 0x0000) == 0xA5);
    assert(msx_flat_read(&flat, 0x001F) == 0xA5);
    /* Beyond the loaded bytes: erased ROM reads 0xFF. */
    assert(msx_flat_read(&flat, 0x0020) == 0xFF);

    /* Read-only BIOS ignores writes. */
    msx_flat_write(&flat, 0x0000, 0x00);
    assert(msx_flat_read(&flat, 0x0000) == 0xA5);

    /* 1 KB RAM mirrored over 2 KB. */
    msx_flat_write(&flat, 0x6000, 0x12);
    assert(msx_flat_read(&flat, 0x6000) == 0x12);
    assert(msx_flat_read(&flat, 0x6400) == 0x12);
    assert(msx_flat_read(&flat, 0x6800) == 0x12);
    msx_flat_write(&flat, 0x7C00, 0x34);
    assert(msx_flat_read(&flat, 0x6000) == 0x34);
    assert(msx_flat_read(&flat, 0x7400) == 0x34);

    /* Unmapped space is open bus. */
    assert(msx_flat_read(&flat, 0x2000) == 0xFF);
    msx_flat_write(&flat, 0x2000, 0x00);
    assert(msx_flat_read(&flat, 0x2000) == 0xFF);

    /* Cartridge window reads the storage and ignores writes. */
    msx_flat_load(&flat, 0x10000, bios, sizeof bios);
    assert(msx_flat_read(&flat, 0x8000) == 0xA5);
    msx_flat_write(&flat, 0x8000, 0x00);
    assert(msx_flat_read(&flat, 0x8000) == 0xA5);
}

static void test_limits(void)
{
    MSX_FlatMemory flat;
    msx_flat_init(&flat);

    assert(msx_flat_map(&flat, 0x8000, 0x7FFF, 0, 1, 0) == -1); /* start > end */
    assert(msx_flat_map(&flat, 0x0000, 0x1FFF, 0, 0, 0) == -1); /* zero size */
    assert(msx_flat_map(&flat, 0x0000, 0x1FFF,
                        MSX_FLAT_STORAGE_SIZE, 1, 0) == -1);
    assert(msx_flat_map(&flat, 0x0000, 0x1FFF,
                        MSX_FLAT_STORAGE_SIZE - 1, 2, 0) == -1);

    for (int i = 0; i < MSX_FLAT_MAX_REGIONS; i++)
        assert(msx_flat_map(&flat, (UInt16)(i * 0x100),
                            (UInt16)(i * 0x100 + 0xFF),
                            (UInt32)(i * 0x100), 0x100, 0) == 0);
    assert(msx_flat_map(&flat, 0x2000, 0x20FF, 0x2000, 0x100, 0) == -1);
}

static void test_memory_ops(void)
{
    MSX_FlatMemory flat;
    MSX_Memory memory;

    msx_flat_init(&flat);
    msx_flat_map(&flat, 0x6000, 0x7FFF, 0x2000, 0x0400, 0);
    msx_memory_init(&memory);
    msx_memory_set_ops(&memory, msx_memory_ops_flat(), &flat);

    assert(memory.ops == msx_memory_ops_flat());
    assert(memory.ctx == &flat);

    msx_memory_write(&memory, 0x6000, 0x5A);
    assert(msx_memory_read(&memory, 0x6400) == 0x5A);
    assert(msx_memory_read(&memory, 0x1000) == 0xFF);
}

int main(void)
{
    test_region_map();
    test_limits();
    test_memory_ops();
    printf("PASS: flat memory regions, mirrors and read-only windows\n");
    return 0;
}
