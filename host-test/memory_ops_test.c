#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "msx.h"

/* The MSX1 memory profile must be attached by default, and foreign profiles
 * must be able to replace address routing entirely. */

static int s_bus_reads;
static int s_bus_writes;
static UInt8 s_bus_byte = 0x5A;
static int s_last_slot = -1;

static UInt8 fake_bus_read(void *ref, int nBusSlot, UInt16 addr)
{
    (void)ref;
    s_bus_reads++;
    s_last_slot = nBusSlot;
    return (UInt8)(s_bus_byte + (addr & 1));
}

static void fake_bus_write(void *ref, int nBusSlot, UInt16 addr, UInt8 val)
{
    (void)ref;
    s_bus_writes++;
    s_last_slot = nBusSlot;
    s_bus_byte = (UInt8)(val ^ (addr & 1));
}

static UInt8 flat_read(MSX_Memory *memory, void *ctx, UInt16 addr)
{
    (void)memory;
    return (UInt8)(*(UInt8 *)ctx + (addr & 0xFF));
}

static void flat_write(MSX_Memory *memory, void *ctx, UInt16 addr, UInt8 val)
{
    (void)memory;
    *(UInt8 *)ctx = (UInt8)(val ^ (addr & 0xFF));
    (void)addr;
}

static const MSX_MemoryOps s_flat_ops = { "flat-test", flat_read, flat_write };

static void test_msx_backend_is_attached(void)
{
    MSX_Machine *m = msx_create();
    assert(m != NULL);
    assert(m->memory.ops == msx_memory_ops_msx());
    assert(m->memory.ctx == m);

    /* RAM subslot selected in region 0. */
    uint8_t ram[0x20];
    memset(ram, 0x11, sizeof ram);
    msx_set_slot(m, 3, 0, ram, sizeof ram);
    m->activeSlot[0] = 3; /* slot 3, subslot 0 */

    assert(m->bus.read_mem(m, 0x0005) == 0x11);
    m->bus.write_mem(m, 0x0007, 0x42);
    assert(m->memory.slots[3].subslots[0].data[0x0007] == 0x42);
    assert(m->bus.read_mem(m, 0x0007) == 0x42);

    /* ROM subslot selected in region 3: readable, writes ignored. */
    uint8_t rom[8] = { 0xDE, 0xAD, 0xBE, 0xEF, 0x01, 0x02, 0x03, 0x04 };
    msx_load_data(m, 1, 0, 0xC000, rom, (int)sizeof rom);
    m->activeSlot[3] = 1; /* slot 1, subslot 0 */
    assert(m->bus.read_mem(m, 0xC000) == 0xDE);
    assert(m->bus.read_mem(m, 0xC007) == 0x04);
    m->bus.write_mem(m, 0xC000, 0x00);
    assert(m->bus.read_mem(m, 0xC000) == 0xDE);

    /* Empty subslot reads 0xFF. */
    m->activeSlot[2] = (2 | (3 << 2));
    assert(m->bus.read_mem(m, 0x8000) == 0xFF);

    msx_destroy(m);
}

static void test_live_bus_still_routed_by_msx_backend(void)
{
    MSX_Machine *m = msx_create();
    assert(m != NULL);

    MSX_HostCallbacks cb;
    memset(&cb, 0, sizeof cb);
    cb.ref = NULL;
    cb.bus_read = fake_bus_read;
    cb.bus_write = fake_bus_write;
    msx_set_bus_callbacks(m, &cb);

    m->activeSlot[1] = 2; /* slot 2, subslot 0 */
    msx_slot_set_bus(m, 2, 0, 1);

    s_bus_reads = 0;
    s_bus_writes = 0;
    assert(m->bus.read_mem(m, 0x4000) == (UInt8)(0x5A + 0));
    assert(s_bus_reads == 1 && s_last_slot == 1);

    m->bus.write_mem(m, 0x4001, 0x99);
    assert(s_bus_writes == 1 && s_last_slot == 1);

    msx_destroy(m);
}

static void test_foreign_profile_replaces_routing(void)
{
    MSX_Machine *m = msx_create();
    assert(m != NULL);

    uint8_t ram[0x10];
    memset(ram, 0x33, sizeof ram);
    msx_set_slot(m, 0, 0, ram, sizeof ram);
    m->activeSlot[0] = 0;
    assert(m->bus.read_mem(m, 0x0001) == 0x33);

    /* Attach a flat profile: every address now goes to its ops, not slots. */
    UInt8 base = 0x80;
    msx_memory_set_ops(&m->memory, &s_flat_ops, &base);
    assert(m->bus.read_mem(m, 0x0001) == (UInt8)(0x80 + 0x01));
    assert(m->bus.read_mem(m, 0x1234) == (UInt8)(0x80 + 0x34));

    m->bus.write_mem(m, 0x0002, 0xFF);
    assert(base == (UInt8)(0xFF ^ 0x02));

    /* Restoring the MSX backend brings slot routing back unchanged. */
    msx_memory_set_ops(&m->memory, msx_memory_ops_msx(), m);
    assert(m->bus.read_mem(m, 0x0001) == 0x33);

    msx_destroy(m);
}

static void test_inert_profile_forwarders(void)
{
    MSX_Memory memory;
    msx_memory_init(&memory);
    assert(memory.ops == NULL);
    assert(msx_memory_read(&memory, 0x1234) == 0xFF);
    msx_memory_write(&memory, 0x1234, 0x55); /* must not crash */
    assert(msx_memory_read(NULL, 0x0000) == 0xFF);
    msx_memory_write(NULL, 0x0000, 0x00);
}

int main(void)
{
    test_msx_backend_is_attached();
    test_live_bus_still_routed_by_msx_backend();
    test_foreign_profile_replaces_routing();
    test_inert_profile_forwarders();
    puts("PASS: memory profile ops route MSX slots and accept foreign profiles");
    return 0;
}
