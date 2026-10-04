#include <msx.h>
#include "../../src/chips/z80/R800.h"
#include "../../src/chips/vdp/tms9918.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

/* Optional per-frame display hook. The Circle app overrides this with a strong
 * definition in src/app/vdpblit.cpp that blits the VDP screen to the
 * framebuffer. */
#if defined(__GNUC__)
__attribute__((weak))
#endif
void msx_frame_render(void *vdp) {
    (void)vdp;
}

static int g_boot_frames = 0;
static int g_boot_first_pc = -1;

static UInt8 slot_read_mem(void *ref, UInt16 addr) {
    MSX_Machine *machine = (MSX_Machine*)ref;
    
    if (addr >= 0x1A7E && addr <= 0x1A90 && g_boot_frames < 10) {
        printf("[MEM-R-PC] PC=%04X slot=%d sslot=%d base=%p\n", 
               addr, machine->activeSlot[addr/REGION_SIZE], 
               (machine->activeSlot[addr/REGION_SIZE]) >> 2, ref);
    }

    int region = addr / REGION_SIZE;
    if (region > 3) region = 3;

    int active = machine->activeSlot[region];
    int slot = active & 3;
    int sslot = (active >> 2) & 3;

    if (slot < NUM_SLOTS && sslot < NUM_SUBSLOTS) {
        uint8_t *base = machine->slots[slot].subslots[sslot].data;
        int size = machine->slots[slot].subslots[sslot].size;
        // Each (slot, subslot) backs a full 64KB address space, indexed by the
        // complete Z80 address (region << 14 | offset). The active slot for the
        // 16KB region selects which slot's buffer is visible.
        if (size > 0 && addr < size) return base[addr];
    }
    return 0xFF;
}

static void slot_write_mem(void *ref, UInt16 addr, UInt8 val) {
    MSX_Machine *machine = (MSX_Machine*)ref;
    
    if (addr >= 0x1A7E && addr <= 0x1A90 && g_boot_frames < 5) {
        printf("[MEM-W] PC=%04X slot=%d sslot=%d val=%02X\n", 
               addr, machine->activeSlot[addr/REGION_SIZE],
               (machine->activeSlot[addr/REGION_SIZE]) >> 2, val);
        g_boot_frames++;
    }

    int region = addr / REGION_SIZE;
    if (region > 3) region = 3;

    int active = machine->activeSlot[region];
    int slot = active & 3;
    int sslot = (active >> 2) & 3;

    if (slot < NUM_SLOTS && sslot < NUM_SUBSLOTS) {
        MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
        int size = ss->size;
        // ROM bytes are read-only: ignore writes (matches real hardware, where
        // writing to a ROM region has no effect). This is what lets the BIOS
        // RAM test (chkram) detect the RAM/ROM boundary and exit its loop.
        if (size > 0 && addr < size && !ss->rom[addr]) ss->data[addr] = val;
    }
}

int g_trace_io = 0;   /* promoted to non-static so host harness can enable */
int g_tms_trace = 0;  /* VDP-level trace (tms9918.c) */
unsigned g_trace_count = 0;   /* promoted to non-static so harness can reset */
unsigned g_trace_cap = 500;   /* promoted to non-static so harness can raise cap */
#define TRACE_MAX g_trace_cap

/* Diagnostic logger (bridged to CKernel::LogLine by the app).
 * C implementation without vprintf-style expansion: uses snprintf into a
 * stack buffer (up to 160 chars). Caller passes a printf-style fmt. */
void msx_diag(MSX_Machine *machine, const char *fmt, ...) {
    if (machine && machine->diag_log == 0) return;
    if (!machine) return;
    if (machine->diag_log_budget > 0 &&
        machine->diag_log_count >= machine->diag_log_budget) return;

    char line[160];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(line, sizeof line, fmt, ap);
    va_end(ap);
    line[sizeof line - 1] = 0;

    machine->diag_log(line, machine->diag_user);
    machine->diag_log_count++;
}

static UInt8 slot_read_io(void *ref, UInt16 port) {
    /* MSX peripherals decode A0-A7; the Z80 also drives A8-A15 on I/O. */
    port &= 0xFF;
    MSX_Machine *machine = (MSX_Machine*)ref;
    if (g_trace_io && (port >= 0x98 && port <= 0x9F) && g_trace_count < TRACE_MAX) {
        printf("    [IO-R] PC=%04X port=%02X\n", ((R800*)machine->z80)->regs.PC.W, port);
        if (++g_trace_count == TRACE_MAX)
            printf("    [trace] (IO log capped at %d; auto-disabled)\n", TRACE_MAX);
    }
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
    port &= 0xFF;
    MSX_Machine *machine = (MSX_Machine*)ref;
    if (g_trace_io && (port >= 0x98 && port <= 0x9F) && g_trace_count < TRACE_MAX) {
        printf("    [IO-W] PC=%04X port=%02X val=%02X\n", ((R800*)machine->z80)->regs.PC.W, port, val);
        if (++g_trace_count == TRACE_MAX)
            printf("    [trace] (IO log capped at %d; auto-disabled)\n", TRACE_MAX);
    }
    if (port >= 0x98 && port <= 0x9F) {
        tms9918_write_reg((TMS9918*)machine->vdp, port, val);
        return;
    }
    if (port == 0xA8) {
        unsigned pc = ((R800*)machine->z80)->regs.PC.W;
        msx_diag(machine, "CKR [A8] PC=%04X val=%02X -> R0=%d R1=%d R2=%d R3=%d",
                 (int)pc, (int)val,
                 val & 0x03, (val>>2)&0x03, (val>>4)&0x03, (val>>6)&0x03);
        machine->slotReg = val;
        machine->activeSlot[0] = val & 0x03;
        machine->activeSlot[1] = (val >> 2) & 0x03;
        machine->activeSlot[2] = (val >> 4) & 0x03;
        machine->activeSlot[3] = (val >> 6) & 0x03;
        return;
    }
    if (port == 0xAA) {
        msx_diag(machine, "CKR [AA-GIO] PC=%04X val=%02X",
                 (int)((R800*)machine->z80)->regs.PC.W, (int)val);
        return;
    }
    if (port == 0xAB) {
        msx_diag(machine, "CKR [AB-PPI] PC=%04X val=%02X",
                 (int)((R800*)machine->z80)->regs.PC.W, (int)val);
        return;
    }
    if (port >= 0xFC && port <= 0xFF) {
        // C-BIOS MAP_REG1..4: per-region slot/subslot bank select. Currently
        // IGNORED by the core (this is the suspect: chkram relies on it).
        const char *name = (port==0xFC)?"MAP_REG1":(port==0xFD)?"MAP_REG2":
                           (port==0xFE)?"MAP_REG3":"MAP_REG4";
        msx_diag(machine, "CKR [%s=%02X] PC=%04X val=%02X (IGNORED)",
                 name, (int)port, (int)((R800*)machine->z80)->regs.PC.W, (int)val);
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
        /* Throttled IRQ delivery trace (~1 line / 60 frames) for the Knightmare
         * bring-up serial log: tells us the IRQ is being latched, the IM mode,
         * whether interrupts are enabled (IFF1), and where the PC is.
         * Respect the diag_log budget. */
        static int s_irq_log_frame = 0;
        if ((++s_irq_log_frame % 60) == 0)
            msx_diag(machine, "IRQ: pending iff1=%u im=%u pc=%04X",
                     z80->regs.iff1, z80->regs.im,
                     z80->regs.PC.W);
    }
    return vdp_frame_instr;
}
