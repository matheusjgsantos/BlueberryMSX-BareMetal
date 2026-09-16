#include "msx.h"
#include "../../src/chips/z80/R800.h"
#include "../../src/chips/vdp/tms9918.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Optional per-frame display hook. The Circle app overrides this with a strong
 * definition in src/app/vdpblit.cpp that blits the VDP screen to the
 * framebuffer. */
#if defined(__GNUC__)
__attribute__((weak))
#endif
void msx_frame_render(void *vdp) {
    (void)vdp;
}

static UInt8 slot_read_mem(void *ref, UInt16 addr) {
    MSX_Machine *machine = (MSX_Machine*)ref;
    int region = addr / REGION_SIZE;
    int offset = addr % REGION_SIZE;
    if (region > 3) region = 3;

    int active = machine->activeSlot[region];
    int slot = active & 3;
    int sslot = (active >> 2) & 3;

    if (slot < NUM_SLOTS && sslot < NUM_SUBSLOTS) {
        uint8_t *base = machine->slots[slot].subslots[sslot].data;
        int size = machine->slots[slot].subslots[sslot].size;
        // Each slot provides data for the full 64KB address space
        // The offset within the region maps to (addr - region_start) in the slot's data
        UInt16 slotAddr = region * REGION_SIZE + offset;
        if (size > 0 && slotAddr < size) return base[slotAddr];
    }
    return 0xFF;
}

static void slot_write_mem(void *ref, UInt16 addr, UInt8 val) {
    MSX_Machine *machine = (MSX_Machine*)ref;
    int region = addr / REGION_SIZE;
    int offset = addr % REGION_SIZE;
    if (region > 3) region = 3;

    int active = machine->activeSlot[region];
    int slot = active & 3;
    int sslot = (active >> 2) & 3;

    if (slot < NUM_SLOTS && sslot < NUM_SUBSLOTS) {
        MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
        int size = ss->size;
        UInt16 slotAddr = region * REGION_SIZE + offset;
        // ROM bytes are read-only: ignore writes (matches real hardware, where
        // writing to a ROM region has no effect). This is what lets the BIOS
        // RAM test (chkram) detect the RAM/ROM boundary and exit its loop.
        if (size > 0 && slotAddr < size && !ss->rom[slotAddr]) ss->data[slotAddr] = val;
    }
}

static int g_trace_io = 0;

static UInt8 slot_read_io(void *ref, UInt16 port) {
    MSX_Machine *machine = (MSX_Machine*)ref;
    if (g_trace_io) printf("    [IO-R] PC=%04X port=%02X\n", ((R800*)machine->z80)->regs.PC.W, port);
    if (port >= 0x98 && port <= 0x9F) {
        UInt8 v = tms9918_read_reg((TMS9918*)machine->vdp, port);
        // Reading the VDP status register (0x99) clears the sync IRQ line.
        if (port == 0x99) r800ClearInt((R800*)machine->z80);
        return v;
    }
    if (port == 0xA8) return machine->slotReg;
    // PPI keyboard scanner ports - return 0xFF (no keys pressed)
    if (port >= 0xA9 && port <= 0xAB) return 0xFF;
    return 0xFF;
}

static void slot_write_io(void *ref, UInt16 port, UInt8 val) {
    MSX_Machine *machine = (MSX_Machine*)ref;
    if (g_trace_io) printf("    [IO-W] PC=%04X port=%02X val=%02X\n", ((R800*)machine->z80)->regs.PC.W, port, val);
    if (port >= 0x98 && port <= 0x9F) {
        tms9918_write_reg((TMS9918*)machine->vdp, port, val);
        return;
    }
    if (port == 0xA8) {
        machine->slotReg = val;
        machine->activeSlot[0] = val & 0x03;
        machine->activeSlot[1] = (val >> 2) & 0x03;
        machine->activeSlot[2] = (val >> 4) & 0x03;
        machine->activeSlot[3] = (val >> 6) & 0x03;
        return;
    }
}

static void dummy_patch(void *ref, CpuRegs *regs) { (void)ref; (void)regs; }
static void dummy_timer(void *ref) { (void)ref; }
static void dummy_bp(void *ref, UInt16 pc) { (void)ref; (void)pc; }
static void dummy_debug(void *ref, int cmd, const char *data) { (void)ref; (void)cmd; (void)data; }
static void dummy_trap(void *ref, UInt8 val) { (void)ref; (void)val; }
static void dummy_watch_mem(void *ref, UInt16 addr, UInt8 val) { (void)ref; (void)addr; (void)val; }
static void dummy_watch_io(void *ref, UInt16 port, UInt8 val) { (void)ref; (void)port; (void)val; }

MSX_Machine* msx_create() {
    MSX_Machine *machine = (MSX_Machine*)calloc(1, sizeof(MSX_Machine));
    if (!machine) return NULL;

    machine->bus.ref = machine;
    machine->bus.read_mem = slot_read_mem;
    machine->bus.write_mem = slot_write_mem;
    machine->bus.read_io = slot_read_io;
    machine->bus.write_io = slot_write_io;

    // Default: all regions map to slot 0, subslot 0
    memset(machine->activeSlot, 0, sizeof(machine->activeSlot));
    machine->slotReg = 0;

    machine->z80 = r800Create(0,
                              slot_read_mem, slot_write_mem,
                              slot_read_io, slot_write_io,
                              dummy_patch, dummy_timer, dummy_bp, dummy_debug,
                              dummy_trap, dummy_watch_mem, dummy_watch_io,
                              machine);

    if (!machine->z80) {
        fprintf(stderr, "Failed to create Z80 CPU\n");
        free(machine);
        return NULL;
    }

    machine->vdp = tms9918_create();
    if (!machine->vdp) {
        fprintf(stderr, "Failed to create TMS9918 VDP\n");
        r800Destroy((R800*)machine->z80);
        free(machine);
        return NULL;
    }

    machine->sound = NULL;
    machine->ppi = NULL;

    printf("MSX Machine created with Z80 and TMS9918\n");
    return machine;
}

void msx_destroy(MSX_Machine *machine) {
    if (!machine) return;
    if (machine->z80) r800Destroy((R800*)machine->z80);
    if (machine->vdp) tms9918_destroy((TMS9918*)machine->vdp);
    free(machine);
    printf("MSX Machine destroyed\n");
}

void msx_set_slot(MSX_Machine *machine, int slot, int sslot, uint8_t *data, int size) {
    if (slot < 0 || slot >= NUM_SLOTS) return;
    if (sslot < 0 || sslot >= NUM_SUBSLOTS) return;
    MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
    memset(ss->data, 0xFF, SLOT_MAX_SIZE);
    memset(ss->rom, 0, SLOT_MAX_SIZE); // RAM slot: everything writable
    if (size > SLOT_MAX_SIZE) size = SLOT_MAX_SIZE;
    memcpy(ss->data, data, size);
    ss->size = SLOT_MAX_SIZE;
}

void msx_load_data(MSX_Machine *machine, int slot, int sslot, UInt16 offset, uint8_t *data, int size) {
    if (slot < 0 || slot >= NUM_SLOTS) return;
    if (sslot < 0 || sslot >= NUM_SUBSLOTS) return;
    MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
    if (ss->size == 0) memset(ss->data, 0xFF, SLOT_MAX_SIZE);
    int end = offset + size;
    if (end > SLOT_MAX_SIZE) end = SLOT_MAX_SIZE;
    memcpy(ss->data + offset, data, end - offset);
    memset(ss->rom + offset, 1, end - offset); // loaded ROM is read-only
    ss->size = SLOT_MAX_SIZE;
}

int msx_load_rom(MSX_Machine *machine, const char *filename, UInt16 address) {
    FILE *f = fopen(filename, "rb");
    if (!f) {
        perror("Failed to open ROM file");
        return -1;
    }

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    uint8_t *romData = (uint8_t*)malloc(size);
    if (!romData) {
        fclose(f);
        return -1;
    }

    size_t bytesRead = fread(romData, 1, size, f);
    fclose(f);

    if (bytesRead != (size_t)size) {
        fprintf(stderr, "Failed to read ROM file\n");
        free(romData);
        return -1;
    }

    int slot = (address < 0xC000) ? 0 : 3;
    msx_load_data(machine, slot, 0, address, romData, size);
    printf("Loaded ROM %s (%ld bytes) at %04X (slot %d)\n", filename, size, address, slot);
    free(romData);
    return 0;
}

/* Non-blocking single-frame step for cooperative schedulers (e.g. Circle).
 * Executes exactly vdp_frame_instr Z80 instructions, then fires the VDP sync
 * IRQ and the msx_frame_render() hook once. Returns the number of instructions
 * executed. */
int msx_step_frame(MSX_Machine *machine, int vdp_frame_instr) {
    R800    *z80 = (R800 *)machine->z80;
    TMS9918 *vdp = (TMS9918 *)machine->vdp;

    for (int i = 0; i < vdp_frame_instr; i++) {
        r800ExecuteInstruction(z80);
    }

    tms9918_gen_sync_irq(vdp);
    msx_frame_render(vdp);
    if (vdp->irq) {
        r800SetInt(z80);
    }
    return vdp_frame_instr;
}
