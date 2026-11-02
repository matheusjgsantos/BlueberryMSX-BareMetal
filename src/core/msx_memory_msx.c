// MSX1 slot-memory profile backend.
//
// The address decoder moved out of src/core/msx.c: the machine now only
// forwards bus accesses to MSX_Memory, and this file implements the MSX slot
// routing (live RPMC bus, MegaROM mapper, ROM read-only mask). A non-MSX
// machine can attach a different MSX_MemoryOps table instead.

#include <msx.h>
#include <msx_mapper.h>

#include <stddef.h>

static UInt8 msx_slot_read(MSX_Memory *memory, void *ctx, UInt16 addr)
{
    MSX_Machine *machine = (MSX_Machine *)ctx;

    int region = addr / REGION_SIZE;
    if (region > 3) region = 3;

    int active = memory->activeSlot[region];
    int slot = active & 3;
    int sslot = (active >> 2) & 3;

    if (slot < NUM_SLOTS && sslot < NUM_SUBSLOTS) {
        MSX_SubSlot *ss = &memory->slots[slot].subslots[sslot];
        // Live cartridge bus: the whole subslot lives on a real RPMC
        // connector, so every byte comes from the physical cartridge.
        if (ss->busSlot >= 0)
            return (machine && machine->bus_read)
                ? machine->bus_read(machine->bus_ref, ss->busSlot, addr) : 0xFF;
        /* MegaROM mappers for emulated ROM subslots: src/core/msx_mapper.c
         * owns the bank decode, this function only routes the address. */
        if (msx_mapper_is_mapped(ss->mapperType) && ss->romSize > 0 &&
            addr >= 0x4000)
            return msx_mapper_read(ss, addr);
        uint8_t *base = ss->data;
        int size = ss->size;
        // Each (slot, subslot) backs a full 64KB address space, indexed by the
        // complete Z80 address (region << 14 | offset). The active slot for the
        // 16KB region selects which slot's buffer is visible.
        if (size > 0 && addr < size) return base[addr];
    }
    return 0xFF;
}

static void msx_slot_write(MSX_Memory *memory, void *ctx, UInt16 addr, UInt8 val)
{
    MSX_Machine *machine = (MSX_Machine *)ctx;

    int region = addr / REGION_SIZE;
    if (region > 3) region = 3;

    int active = memory->activeSlot[region];
    int slot = active & 3;
    int sslot = (active >> 2) & 3;

    if (slot < NUM_SLOTS && sslot < NUM_SUBSLOTS) {
        MSX_SubSlot *ss = &memory->slots[slot].subslots[sslot];
        // Live cartridge bus: pass the write to the real cartridge so its
        // mapper/bank register or on-board RAM sees it (ROM-array writes to
        // emulated slots stay ignored below).
        if (ss->busSlot >= 0) {
            if (machine && machine->bus_write)
                machine->bus_write(machine->bus_ref, ss->busSlot, addr, val);
            return;
        }
        /* MegaROM bank-register writes for emulated ROM subslots: the mapper
         * module decodes the register address. Every other write to a mapped
         * ROM is ignored (ROM is read-only on real hardware). */
        if (msx_mapper_is_mapped(ss->mapperType) && ss->romSize > 0) {
            msx_mapper_write(ss, addr, val);
            return;
        }
        int size = ss->size;
        // ROM bytes are read-only: ignore writes (matches real hardware, where
        // writing to a ROM region has no effect). This is what lets the BIOS
        // RAM test (chkram) detect the RAM/ROM boundary and exit its loop.
        if (size > 0 && addr < size && !ss->rom[addr]) ss->data[addr] = val;
    }
}

static const MSX_MemoryOps s_msx_memory_ops = {
    "msx1-slots",
    msx_slot_read,
    msx_slot_write,
};

const MSX_MemoryOps *msx_memory_ops_msx(void)
{
    return &s_msx_memory_ops;
}
