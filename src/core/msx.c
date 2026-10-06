#include <msx.h>
#include "../../src/chips/z80/R800.h"
#include "../../src/chips/vdp/tms9918.h"
#include "../../src/chips/sound/psg.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

typedef struct {
    UInt8 keyState[12];
    UInt8 row;
    UInt8 regCHi;
} MSX_PPI;

static void ppi_init_state(MSX_PPI *ppi) {
    for (int i = 0; i < 12; i++) ppi->keyState[i] = 0xFF;
    ppi->row = 0;
    ppi->regCHi = 0;
}

void msx_ppi_init(MSX_Machine *machine) {
    if (!machine) return;
    MSX_PPI *ppi = (MSX_PPI *)calloc(1, sizeof(MSX_PPI));
    if (!ppi) return;
    machine->ppi = ppi;
    ppi_init_state(ppi);
}

static const struct {
    int ec;
    int row;
    int bit;
} ppiEcMap[] = {
    { MSX_EC_0, 0, 0 }, { MSX_EC_1, 0, 1 }, { MSX_EC_2, 0, 2 }, { MSX_EC_3, 0, 3 },
    { MSX_EC_4, 0, 4 }, { MSX_EC_5, 0, 5 }, { MSX_EC_6, 0, 6 }, { MSX_EC_7, 0, 7 },
    { MSX_EC_8, 1, 0 }, { MSX_EC_9, 1, 1 }, { MSX_EC_NEG, 1, 2 }, { MSX_EC_CIRCFLX, 1, 3 },
    { MSX_EC_BKSLASH, 1, 4 }, { MSX_EC_AT, 1, 5 }, { MSX_EC_LBRACK, 1, 6 }, { MSX_EC_SEMICOL, 1, 7 },
    { MSX_EC_COLON, 2, 0 }, { MSX_EC_RBRACK, 2, 1 }, { MSX_EC_COMMA, 2, 2 }, { MSX_EC_PERIOD, 2, 3 },
    { MSX_EC_DIV, 2, 4 }, { MSX_EC_UNDSCRE, 2, 5 }, { MSX_EC_A, 2, 6 }, { MSX_EC_B, 2, 7 },
    { MSX_EC_C, 3, 0 }, { MSX_EC_D, 3, 1 }, { MSX_EC_E, 3, 2 }, { MSX_EC_F, 3, 3 },
    { MSX_EC_G, 3, 4 }, { MSX_EC_H, 3, 5 }, { MSX_EC_I, 3, 6 }, { MSX_EC_J, 3, 7 },
    { MSX_EC_K, 4, 0 }, { MSX_EC_L, 4, 1 }, { MSX_EC_M, 4, 2 }, { MSX_EC_N, 4, 3 },
    { MSX_EC_O, 4, 4 }, { MSX_EC_P, 4, 5 }, { MSX_EC_Q, 4, 6 }, { MSX_EC_R, 4, 7 },
    { MSX_EC_S, 5, 0 }, { MSX_EC_T, 5, 1 }, { MSX_EC_U, 5, 2 }, { MSX_EC_V, 5, 3 },
    { MSX_EC_W, 5, 4 }, { MSX_EC_X, 5, 5 }, { MSX_EC_Y, 5, 6 }, { MSX_EC_Z, 5, 7 },
    { MSX_EC_LSHIFT, 6, 0 }, { MSX_EC_CTRL, 6, 1 }, { MSX_EC_GRAPH, 6, 2 }, { MSX_EC_CAPS, 6, 3 },
    { MSX_EC_CODE, 6, 4 }, { MSX_EC_F1, 6, 5 }, { MSX_EC_F2, 6, 6 }, { MSX_EC_F3, 6, 7 },
    { MSX_EC_RSHIFT, 6, 0 },
    { MSX_EC_F4, 7, 0 }, { MSX_EC_F5, 7, 1 }, { MSX_EC_ESC, 7, 2 }, { MSX_EC_TAB, 7, 3 },
    { MSX_EC_STOP, 7, 4 }, { MSX_EC_BKSPACE, 7, 5 }, { MSX_EC_SELECT, 7, 6 }, { MSX_EC_RETURN, 7, 7 },
    { MSX_EC_SPACE, 8, 0 }, { MSX_EC_CLS, 8, 1 }, { MSX_EC_INS, 8, 2 }, { MSX_EC_DEL, 8, 3 },
    { MSX_EC_LEFT, 8, 4 }, { MSX_EC_UP, 8, 5 }, { MSX_EC_DOWN, 8, 6 }, { MSX_EC_RIGHT, 8, 7 },
    { MSX_EC_NUMMUL, 9, 0 }, { MSX_EC_NUMADD, 9, 1 }, { MSX_EC_NUMDIV, 9, 2 }, { MSX_EC_NUM0, 9, 3 },
    { MSX_EC_NUM1, 9, 4 }, { MSX_EC_NUM2, 9, 5 }, { MSX_EC_NUM3, 9, 6 }, { MSX_EC_NUM4, 9, 7 },
    { MSX_EC_NUM5, 10, 0 }, { MSX_EC_NUM6, 10, 1 }, { MSX_EC_NUM7, 10, 2 }, { MSX_EC_NUM8, 10, 3 },
    { MSX_EC_NUM9, 10, 4 }, { MSX_EC_NUMSUB, 10, 5 }, { MSX_EC_NUMCOM, 10, 6 }, { MSX_EC_NUMPER, 10, 7 },
    { MSX_EC_JIKKOU, 11, 1 }, { MSX_EC_TORIKE, 11, 3 }
};

void msx_ppi_set_ec(MSX_Machine *machine, int ecCode, int pressed) {
    MSX_PPI *ppi;
    unsigned i;
    if (!machine) return;
    ppi = (MSX_PPI *)machine->ppi;
    if (!ppi) return;
    for (i = 0; i < sizeof(ppiEcMap) / sizeof(ppiEcMap[0]); i++) {
        if (ppiEcMap[i].ec == ecCode) {
            if (pressed) {
                ppi->keyState[ppiEcMap[i].row] &= (UInt8)(~(1u << ppiEcMap[i].bit));
            } else {
                ppi->keyState[ppiEcMap[i].row] |= (UInt8)(1u << ppiEcMap[i].bit);
            }
            return;
        }
    }
}

static UInt8 ppi_read_b(MSX_Machine *machine) {
    MSX_PPI *ppi = (MSX_PPI *)machine->ppi;
    if (!ppi) return 0xFF;
    int row = ppi->row & 0x0F;
    if (row > 11) return 0xFF;
    return ppi->keyState[row];
}

static void ppi_write_clo(MSX_Machine *machine, UInt8 val) {
    MSX_PPI *ppi = (MSX_PPI *)machine->ppi;
    if (ppi) ppi->row = val;
}

static void ppi_write_chi(MSX_Machine *machine, UInt8 val) {
    MSX_PPI *ppi = (MSX_PPI *)machine->ppi;
    if (ppi) ppi->regCHi = val;
}

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

/* PSG port activity counters (diagnostics: proves the running ROM programs
 * the sound chip, and which register it touched last). */
unsigned g_psg_writes = 0;
unsigned g_psg_last_reg = 0;
unsigned g_psg_last_val = 0;
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


/* Ports the harness trace watches: VDP (98-9F), PSG/PPI (A0-AB) and the
 * joystick pseudo ports (DC/DD). The decode itself is unchanged. */
static int io_traced (UInt16 port)
{
    return (port >= 0x98 && port <= 0x9F)
        || (port >= 0xA0 && port <= 0xAB)
        || port == 0xDC || port == 0xDD;
}

static UInt8 slot_read_io(void *ref, UInt16 port) {
    /* MSX peripherals decode A0-A7; the Z80 also drives A8-A15 on I/O. */
    port &= 0xFF;
    MSX_Machine *machine = (MSX_Machine*)ref;
    UInt8 v;
    if (port >= 0x98 && port <= 0x9F) {
        v = tms9918_read_reg((TMS9918*)machine->vdp, port);
        // Reading the VDP status register (0x99) clears the sync IRQ line.
        if (port == 0x99) r800ClearInt((R800*)machine->z80);
    }
    else if (port == 0xA2) v = psg_read((PSG*)machine->sound, psg_get_reg_latch((PSG*)machine->sound));
    else if (port == 0xA0 || port == 0xA1) v = 0xFF;
    else if (port == 0xA8) v = machine->slotReg;
    else if (port == 0xA9) v = ppi_read_b(machine);
    else if (port == 0xAA) v = 0xFF; /* CLo read not expected */
    else if (port == 0xAB) v = 0xFF; /* CHi read not expected */
    else v = 0xFF;
    if (g_trace_io && io_traced(port) && g_trace_count < TRACE_MAX) {
        printf("    [IO-R] PC=%04X port=%02X val=%02X\n", ((R800*)machine->z80)->regs.PC.W, port, v);
        if (++g_trace_count == TRACE_MAX)
            printf("    [trace] (IO log capped at %d; auto-disabled)\n", TRACE_MAX);
    }
    return v;
}

static void slot_write_io(void *ref, UInt16 port, UInt8 val) {
    port &= 0xFF;
    MSX_Machine *machine = (MSX_Machine*)ref;
    if (g_trace_io && io_traced(port) && g_trace_count < TRACE_MAX) {
        printf("    [IO-W] PC=%04X port=%02X val=%02X\n", ((R800*)machine->z80)->regs.PC.W, port, val);
        if (++g_trace_count == TRACE_MAX)
            printf("    [trace] (IO log capped at %d; auto-disabled)\n", TRACE_MAX);
    }
    if (port >= 0x98 && port <= 0x9F) {
        tms9918_write_reg((TMS9918*)machine->vdp, port, val);
        return;
    }
    if (port == 0xA0 || port == 0xA1) {
        PSG *psg = (PSG*)machine->sound;
        if (!psg) return;
        if (port == 0xA0) {
            psg_set_reg_latch(psg, val);
        } else {
            psg_write(psg, psg_get_reg_latch(psg), val);
        }
        g_psg_writes++;
        g_psg_last_reg = psg_get_reg_latch(psg);
        g_psg_last_val = val;
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
        ppi_write_clo(machine, val);
        return;
    }
    if (port == 0xAB) {
        msx_diag(machine, "CKR [AB-PPI] PC=%04X val=%02X",
                 (int)((R800*)machine->z80)->regs.PC.W, (int)val);
        ppi_write_chi(machine, val);
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

    machine->sound = psg_create();
    if (!machine->sound) {
        fprintf(stderr, "Failed to create AY-3-8910 PSG\n");
        tms9918_destroy((TMS9918*)machine->vdp);
        r800Destroy((R800*)machine->z80);
        free(machine);
        return NULL;
    }

    machine->ppi = NULL;
    msx_ppi_init(machine);

    printf("MSX Machine created with Z80 and TMS9918\n");
    return machine;
}

void msx_destroy(MSX_Machine *machine) {
    if (!machine) return;
    if (machine->z80) r800Destroy((R800*)machine->z80);
    if (machine->vdp) tms9918_destroy((TMS9918*)machine->vdp);
    if (machine->sound) psg_destroy((PSG*)machine->sound);
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

/* Render the PSG into nSamples mono samples covering nMasterCycles master
 * clocks (3579545 Hz). Call once per emulated frame from the host loop: the
 * core has no cycle counter, so the host passes the time it actually spent. */
unsigned msx_psg_render(MSX_Machine *machine, Int16 *out, unsigned nSamples,
                        unsigned nMasterCycles)
{
    if (!machine || !machine->sound || !out || nSamples == 0) return 0;

    return psg_render((PSG*)machine->sound, out, nSamples, (UInt32)nMasterCycles);
}
