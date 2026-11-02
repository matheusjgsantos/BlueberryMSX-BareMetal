#include <msx.h>
#include <msx_mapper.h>
#include "../../src/chips/z80/R800.h"
#include <msx_video.h>
#include <msx_audio.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

/* Primary slot select (PPI port A, 0xA8) is machine memory policy: the input
 * device reports the write here and this applies it. Kept as a plain function
 * so the seam can call it through a function pointer. */
static void machine_port_a(void *ref, UInt8 val);

static void machine_memory_attach(MSX_Machine *machine)
{
    msx_memory_init(&machine->memory);
    msx_memory_set_ops(&machine->memory, msx_memory_ops_msx(), machine);
    machine->slots = machine->memory.slots;
    machine->activeSlot = machine->memory.activeSlot;
    machine->slotReg = machine->memory.slotReg;
}

void msx_ppi_init(MSX_Machine *machine) {
    if (!machine) return;
    if (msx_input_init_ppi(&machine->input, machine_port_a, machine) != 0) {
        machine->ppi = NULL;
        return;
    }
    /* Compatibility alias: diagnostics and older tests read the device pointer
     * directly; machine->input is the machine-facing handle. */
    machine->ppi = msx_input_native(&machine->input);
}

void msx_ppi_set_ec(MSX_Machine *machine, int ecCode, int pressed) {
    if (!machine) return;
    msx_input_set_key(&machine->input, ecCode, pressed);
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

/* Slot/MFR event log (see msx.h). Two independent lists so the flood of
 * page-1 (port 0xA8) transitions - the BIOS trampoline flips it on every
 * CALSLT - can never crowd out the MegaFlashROM markers:
 *   - MFR events: every write to 0xE200/0xE210 (0xE200 gated on 0xE210!=0),
 *     kept in full (only a few), so a later re-INIT stays visible.
 *   - A8 transitions: a ring of the most recent page-1 changes only. */
#define MSX_MFR_EVT_MAX 64
#define MSX_A8_EVT_MAX 64
static UInt16 s_mfrPc[MSX_MFR_EVT_MAX];
static UInt8  s_mfrPort[MSX_MFR_EVT_MAX];
static UInt8  s_mfrVal[MSX_MFR_EVT_MAX];
static unsigned s_mfrCount = 0;
static UInt8  s_slotEvtE210 = 0;
static UInt16 s_a8Pc[MSX_A8_EVT_MAX];
static UInt8  s_a8Val[MSX_A8_EVT_MAX];
static unsigned s_a8Total = 0;
static int s_slotEvtLastPage1 = -1;

static void mfr_evt(UInt16 pc, UInt8 port, UInt8 val) {
    if (s_mfrCount >= MSX_MFR_EVT_MAX) return;
    s_mfrPc[s_mfrCount] = pc;
    s_mfrPort[s_mfrCount] = port;
    s_mfrVal[s_mfrCount] = val;
    s_mfrCount++;
}

static void a8_evt(UInt16 pc, UInt8 val) {
    unsigned idx = s_a8Total % MSX_A8_EVT_MAX;
    s_a8Pc[idx] = pc;
    s_a8Val[idx] = val;
    s_a8Total++;
}

unsigned msx_slot_event_count(void) {
    unsigned nA8 = (s_a8Total < MSX_A8_EVT_MAX) ? s_a8Total : MSX_A8_EVT_MAX;
    return s_mfrCount + nA8;
}

int msx_slot_event_get(unsigned nIndex, unsigned *nPc, unsigned *nPort, unsigned *nVal) {
    unsigned nA8 = (s_a8Total < MSX_A8_EVT_MAX) ? s_a8Total : MSX_A8_EVT_MAX;
    if (nIndex >= s_mfrCount + nA8) return 0;
    if (nIndex < s_mfrCount) {
        if (nPc)   *nPc = s_mfrPc[nIndex];
        if (nPort) *nPort = s_mfrPort[nIndex];
        if (nVal)  *nVal = s_mfrVal[nIndex];
    } else {
        unsigned nStart = (s_a8Total > MSX_A8_EVT_MAX) ? s_a8Total - MSX_A8_EVT_MAX : 0;
        unsigned idx = (nStart + (nIndex - s_mfrCount)) % MSX_A8_EVT_MAX;
        if (nPc)   *nPc = s_a8Pc[idx];
        if (nPort) *nPort = 0;
        if (nVal)  *nVal = s_a8Val[idx];
    }
    return 1;
}

static UInt8 slot_read_mem(void *ref, UInt16 addr) {
    MSX_Machine *machine = (MSX_Machine*)ref;
    return msx_memory_read(&machine->memory, addr);
}

static void slot_write_mem(void *ref, UInt16 addr, UInt8 val) {
    MSX_Machine *machine = (MSX_Machine*)ref;

    if (addr == 0xE200)
    {
        // C-BIOS itself mirrors the slot register into 0xE200 (PC=0D43/0D48)
        // many times during boot, so only record writes once the MegaFlashROM
        // INIT has claimed the machine by setting 0xE210=1.
        if (s_slotEvtE210)
            mfr_evt((UInt16)((R800*)machine->z80)->regs.PC.W, 1, val);
    }
    else if (addr == 0xE210)
    {
        s_slotEvtE210 = val;
        mfr_evt((UInt16)((R800*)machine->z80)->regs.PC.W, 2, val);
    }

    /* Slot routing, live bus and mapper policy live in the attached memory
     * profile (src/core/msx_memory_msx.c for MSX1). */
    msx_memory_write(&machine->memory, addr, val);
}

int g_trace_io = 0;   /* promoted to non-static so host harness can enable */

/* PSG port activity counters (diagnostics: proves the running ROM programs
 * the sound chip, and which register it touched last). */
unsigned g_psg_writes = 0;
unsigned g_psg_last_reg = 0;
unsigned g_psg_last_val = 0;

/* Frame position of the running instruction, used to timestamp sound writes.
 * msx_step_frame() sets these; the audio device records the fraction with each
 * write so it can render the frame segment by segment (see
 * include/msx_audio.h and src/core/msx_audio_psg.c). */
static unsigned s_instrDone;
static unsigned s_instrTotal;

/* 0..65535 = how far into the frame the CPU is right now. */
static UInt16 s_frame_frac16(void) {
    if (s_instrTotal == 0) return 0;
    return (UInt16)((unsigned long long)s_instrDone * 65536u / s_instrTotal);
}

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

/* Ports the emulator answers itself (VDP, PSG/PPI/slot register, C-BIOS map
 * registers). Everything else is a cartridge/peripheral port and, when the
 * live bus is attached, is handed to the real hardware - this is what makes a
 * music module, SCC or FM pack in the second slot audible. */
static int io_is_internal (UInt16 port)
{
    return (port >= 0x98 && port <= 0x9F)
        || (port >= 0xA0 && port <= 0xAB)
        || (port >= 0xFC && port <= 0xFF);
}

/* 0xA8: PPI port A selects the primary slot per 16 KB page. */
static void machine_port_a(void *ref, UInt8 val) {
    MSX_Machine *machine = (MSX_Machine *)ref;
    unsigned pc = ((R800*)machine->z80)->regs.PC.W;
    msx_diag(machine, "CKR [A8] PC=%04X val=%02X -> R0=%d R1=%d R2=%d R3=%d",
             (int)pc, (int)val,
             val & 0x03, (val>>2)&0x03, (val>>4)&0x03, (val>>6)&0x03);
    machine->memory.slotReg = val;
    machine->slotReg = machine->memory.slotReg;
    machine->activeSlot[0] = val & 0x03;
    machine->activeSlot[1] = (val >> 2) & 0x03;
    machine->activeSlot[2] = (val >> 4) & 0x03;
    machine->activeSlot[3] = (val >> 6) & 0x03;
    {
        int page1 = (val >> 2) & 0x03;
        if (page1 != s_slotEvtLastPage1) {
            a8_evt((UInt16)pc, val);
            s_slotEvtLastPage1 = page1;
        }
    }
}

static UInt8 slot_read_io(void *ref, UInt16 port) {
    /* MSX peripherals decode A0-A7; the Z80 also drives A8-A15 on I/O. */
    port &= 0xFF;
    MSX_Machine *machine = (MSX_Machine*)ref;
    UInt8 v;
    /* Live bus: unclaimed ports belong to a cartridge. */
    if (machine->bus_read_io && !io_is_internal(port))
        return machine->bus_read_io(machine->bus_ref, port);
    if (port >= 0x98 && port <= 0x9F) {
        v = msx_video_read_io(&machine->video, port);
        // Reading the VDP status register (0x99) clears the sync IRQ line.
        if (port == 0x99) msx_cpu_clear_irq(machine->cpu);
    }
    else if (port == 0xA2) v = msx_audio_read_io(&machine->audio, port);
    else if (port == 0xA0 || port == 0xA1) v = 0xFF;
    else if (port == 0xA8) v = machine->memory.slotReg;
    else if (port == 0xA9) v = msx_input_read_io(&machine->input, port);
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
        msx_video_write_io(&machine->video, port, val);
        return;
    }
    if (port == 0xA0 || port == 0xA1) {
        /* Timestamp the write against the frame so the device can render it
         * at the right sample; without a frame budget there is no position to
         * record, so apply it immediately (whole-frame behaviour). */
        if (s_instrTotal > 0)
            msx_audio_write_io_at(&machine->audio, port, val, s_frame_frac16());
        else
            msx_audio_write_io(&machine->audio, port, val);
        g_psg_writes++;
        g_psg_last_reg = msx_audio_latched_register(&machine->audio);
        g_psg_last_val = val;
        return;
    }
    if (port >= 0xA8 && port <= 0xAB) {
        /* PPI ports. 0xA8 (port A) is applied to the machine's slot map by the
         * device's port-A callback; the rest is keyboard matrix state. The
         * C-BIOS port traces stay here: they are machine bring-up diagnostics
         * and the device has no diag sink. */
        if (port == 0xAA)
            msx_diag(machine, "CKR [AA-GIO] PC=%04X val=%02X",
                     (int)((R800*)machine->z80)->regs.PC.W, (int)val);
        if (port == 0xAB)
            msx_diag(machine, "CKR [AB-PPI] PC=%04X val=%02X",
                     (int)((R800*)machine->z80)->regs.PC.W, (int)val);
        msx_input_write_io(&machine->input, port, val);
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
    /* Live bus: unclaimed ports belong to a cartridge (SCC/FM/MSX-Music...). */
    if (machine->bus_write_io && !io_is_internal(port))
        machine->bus_write_io(machine->bus_ref, port, val);
}

void msx_set_bus_callbacks(MSX_Machine *machine,
                           const MSX_HostCallbacks *callbacks) {
    if (!machine) return;

    machine->bus_ref = callbacks ? callbacks->ref : NULL;
    machine->bus_read = callbacks ? callbacks->bus_read : NULL;
    machine->bus_write = callbacks ? callbacks->bus_write : NULL;
    machine->bus_read_io = callbacks ? callbacks->bus_read_io : NULL;
    machine->bus_write_io = callbacks ? callbacks->bus_write_io : NULL;
}

void msx_set_host_callbacks(MSX_Machine *machine,
                            const MSX_HostCallbacks *callbacks) {
    if (!machine) return;

    msx_set_bus_callbacks(machine, callbacks);

    if (!callbacks) {
        machine->diag_log = NULL;
        machine->diag_user = NULL;
        machine->diag_log_count = 0;
        machine->diag_log_budget = 0;
        return;
    }

    machine->diag_log = callbacks->diag_log;
    machine->diag_user = callbacks->diag_ref;
    machine->diag_log_count = 0;
    machine->diag_log_budget = callbacks->diag_log_budget;
}

MSX_Machine* msx_create() {
    MSX_Machine *machine = (MSX_Machine*)calloc(1, sizeof(MSX_Machine));
    if (!machine) return NULL;

    machine->bus.ref = machine;
    machine->bus.read_mem = slot_read_mem;
    machine->bus.write_mem = slot_write_mem;
    machine->bus.read_io = slot_read_io;
    machine->bus.write_io = slot_write_io;

    /* The MSX1 memory profile owns slots and page selection. The pointer
     * fields retain the old machine->slots[] / activeSlot[] interface. */
    machine_memory_attach(machine);

    // The CPU/clock seam (include/msx_cpu.h). MSX_CPU_OPTION_M1 matches the
    // reference blueMSX MSX board timing: it adds the Z80 M1 (opcode fetch)
    // cycle to each instruction's delay so the per-instruction systemTime
    // advance matches blueMSX. Without it the core is ~1 T-state/instruction
    // too fast. (MSX.c reference sets the same flag.)
    static const MSX_CPUBus s_cpuBus = {
        slot_read_mem, slot_write_mem, slot_read_io, slot_write_io
    };
    machine->cpu = msx_cpu_create(MSX_CPU_OPTION_M1, &s_cpuBus, machine);
    if (!machine->cpu) {
        fprintf(stderr, "Failed to create CPU\n");
        free(machine);
        return NULL;
    }
    machine->z80 = msx_cpu_native_handle(machine->cpu);

    if (msx_video_init_tms9918(&machine->video) != 0) {
        fprintf(stderr, "Failed to create TMS9918 VDP\n");
        msx_cpu_destroy(machine->cpu);
        free(machine);
        return NULL;
    }
    // Compatibility alias: the Circle app (vdpblit, msx_task) still reads the
    // concrete device pointer; machine->video is the machine-facing handle.
    machine->vdp = machine->video.dev;

    if (msx_audio_init_psg(&machine->audio) != 0) {
        fprintf(stderr, "Failed to create AY-3-8910 PSG\n");
        msx_video_destroy(&machine->video);
        msx_cpu_destroy(machine->cpu);
        free(machine);
        return NULL;
    }
    /* Compatibility alias: diagnostics and older tests read the chip pointer
     * directly; machine->audio is the machine-facing handle. */
    machine->sound = msx_audio_native(&machine->audio);

    machine->ppi = NULL;
    msx_ppi_init(machine);

    printf("MSX Machine created with Z80 and TMS9918\n");
    return machine;
}

void msx_destroy(MSX_Machine *machine) {
    if (!machine) return;
    for (int s = 0; s < NUM_SLOTS; s++)
        for (int t = 0; t < NUM_SUBSLOTS; t++)
            if (machine->slots[s].subslots[t].pRomImage)
                free(machine->slots[s].subslots[t].pRomImage);
    if (machine->cpu) msx_cpu_destroy(machine->cpu);
    msx_video_destroy(&machine->video);
    msx_audio_destroy(&machine->audio);
    msx_input_destroy(&machine->input);
    free(machine);
    printf("MSX Machine destroyed\n");
}

void msx_set_slot(MSX_Machine *machine, int slot, int sslot, uint8_t *data, int size) {
    if (slot < 0 || slot >= NUM_SLOTS) return;
    if (sslot < 0 || sslot >= NUM_SUBSLOTS) return;
    MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
    if (ss->pRomImage) { free(ss->pRomImage); ss->pRomImage = 0; }
    memset(ss->data, 0xFF, SLOT_MAX_SIZE);
    memset(ss->rom, 0, SLOT_MAX_SIZE); // RAM slot: everything writable
    if (size > SLOT_MAX_SIZE) size = SLOT_MAX_SIZE;
    memcpy(ss->data, data, size);
    ss->size = SLOT_MAX_SIZE;
    ss->mapperType = MSX_MAPPER_NONE;
    ss->romSize = 0;
}

MSX_MapperType msx_guess_mapper(const uint8_t *pImage, unsigned nSize) {
    /* Bank-select heuristic lives with the mapper policy; kept here as the
     * public (MSX_Machine) entry point so callers do not change. */
    return msx_mapper_guess(pImage, nSize);
}

void msx_set_mapper(MSX_Machine *machine, int slot, int sslot, MSX_MapperType type) {
    if (!machine) return;
    if (slot < 0 || slot >= NUM_SLOTS) return;
    if (sslot < 0 || sslot >= NUM_SUBSLOTS) return;
    MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
    if (ss->busSlot >= 0) {
        /* Physical bus owns mapper; ignore. */
        return;
    }
    if (type == MSX_MAPPER_AUTO) {
        /* Let the bank-select heuristic decide; the overlay/config lets the
         * user override it at load time. */
        ss->mapperType = msx_guess_mapper(ss->pRomImage, ss->romSize);
    } else {
        ss->mapperType = type;
    }
    /* Initialize banks: page 0->bank0 at 0x4000-5FFF? standard ASCII8 maps 0x4000->page0, 0x6000->page1, 0x8000->page2, 0xA000->page3 */
    ss->bank[0] = 0; /* 0x4000-0x5FFF */
    ss->bank[1] = 1; /* 0x6000-0x7FFF */
    ss->bank[2] = 2; /* 0x8000-0x9FFF */
    ss->bank[3] = 3; /* 0xA000-0xBFFF */
    if (ss->romSize > 0) {
        unsigned nbanks = ss->romSize / 0x2000;
        if (nbanks < 1) nbanks = 1;
        ss->romMask = nbanks - 1;
        ss->bank[0] &= ss->romMask;
        ss->bank[1] &= ss->romMask;
        ss->bank[2] &= ss->romMask;
        ss->bank[3] &= ss->romMask;
    } else {
        ss->romMask = 0xFF;
    }
}

void msx_load_rom_image(MSX_Machine *machine, int slot, int sslot, uint8_t *pImage, unsigned nSize, MSX_MapperType mapper) {
    if (!machine) return;
    if (slot < 0 || slot >= NUM_SLOTS) return;
    if (sslot < 0 || sslot >= NUM_SUBSLOTS) return;
    MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
    if (ss->pRomImage) {
        free(ss->pRomImage);
        ss->pRomImage = 0;
    }
    memset(ss->data, 0xFF, SLOT_MAX_SIZE);
    memset(ss->rom, 1, SLOT_MAX_SIZE);
    ss->size = SLOT_MAX_SIZE;
    ss->pRomImage = pImage;
    ss->romSize = nSize;
    ss->mapperType = mapper;
    /* Initialize mapper banks */
    ss->bank[0] = 0; ss->bank[1] = 1; ss->bank[2] = 2; ss->bank[3] = 3;
    if (ss->romSize > 0) {
        unsigned nbanks = ss->romSize / 0x2000;
        if (nbanks < 1) nbanks = 1;
        ss->romMask = nbanks - 1;
    } else {
        ss->romMask = 0;
    }
    if (mapper == MSX_MAPPER_AUTO) {
        msx_set_mapper(machine, slot, sslot, MSX_MAPPER_AUTO);
    }
}

void msx_load_data(MSX_Machine *machine, int slot, int sslot, UInt16 offset, uint8_t *data, int size) {
    if (slot < 0 || slot >= NUM_SLOTS) return;
    if (sslot < 0 || sslot >= NUM_SUBSLOTS) return;
    MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
    if (ss->pRomImage) { free(ss->pRomImage); ss->pRomImage = 0; }
    if (ss->size == 0) memset(ss->data, 0xFF, SLOT_MAX_SIZE);
    int end = offset + size;
    if (end > SLOT_MAX_SIZE) end = SLOT_MAX_SIZE;
    if (end > offset) memcpy(ss->data + offset, data, end - offset);
    // Everything reaches here as ROM (a cartridge image or a BIOS). Mark the
    // WHOLE subslot read-only, not just the loaded bytes: bytes outside the
    // image read 0xFF and ignore writes. Leaving them writable made them look
    // like RAM, so an MSX memory scan (MSX Diag, MegaFlashROM) saw phantom RAM
    // in every ROM slot and reported 112KB instead of the machine's 64KB.
    memset(ss->rom, 1, SLOT_MAX_SIZE);
    ss->size = SLOT_MAX_SIZE;
    ss->mapperType = MSX_MAPPER_NONE;
    ss->pRomImage = 0;
    ss->romSize = (unsigned)size;
    ss->romMask = 0;
    ss->bank[0] = ss->bank[1] = ss->bank[2] = ss->bank[3] = 0;
}

void msx_slot_set_bus(MSX_Machine *machine, int slot, int sslot, int nBusSlot) {
    if (!machine) return;
    if (slot < 0 || slot >= NUM_SLOTS) return;
    if (sslot < 0 || sslot >= NUM_SUBSLOTS) return;
    MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
    ss->busSlot = nBusSlot;
    if (nBusSlot >= 0) {
        // The bus owns the whole 64KB subslot; make the emulated buffer look
        // empty so any stray non-bus path stays inert.
        memset(ss->data, 0xFF, SLOT_MAX_SIZE);
        memset(ss->rom, 0, SLOT_MAX_SIZE);
        ss->size = SLOT_MAX_SIZE;
    }
}


/* Non-blocking single-frame step for cooperative schedulers (e.g. Circle).
 * Runs the CPU until one video frame's worth of R800 master-clock time has
 * elapsed (frame_ticks; a 60 Hz frame is R800_MASTER_FREQUENCY/60 ~= 357954),
 * then fires the VDP sync IRQ and the msx_frame_render() hook once. This
 * matches the reference blueMSX MSX board, which drives the CPU from the
 * system timer (r800ExecuteUntil), not a fixed instruction count: a fixed
 * count made CPU-bound games (Konami MegaROMs) run too fast while VBlank
 * synced games stayed correct. Returns the number of instructions executed.
 * (s_instrDone/s_instrTotal now carry elapsed/frame *ticks*, used only to
 * time-stamp PSG writes within the frame.) */
int msx_step_frame(MSX_Machine *machine, int frame_ticks) {
    MSX_CPU *cpu = machine->cpu;
    UInt32 start = msx_cpu_get_time(cpu);
    unsigned n = 0;

    s_instrTotal = (unsigned) frame_ticks;
    while ((UInt32)(msx_cpu_get_time(cpu) - start) < (UInt32) frame_ticks) {
        s_instrDone = (unsigned)(msx_cpu_get_time(cpu) - start);
        msx_cpu_execute(cpu);
        n++;
    }
    s_instrDone = s_instrTotal;

    msx_video_sync_irq(&machine->video);
    msx_frame_render(machine->vdp);
    if (msx_video_irq_pending(&machine->video)) {
        msx_cpu_set_irq(cpu);
        /* Throttled IRQ delivery trace (~1 line / 60 frames) for the bring-up
         * serial log: tells us the IRQ is being latched, the IM mode,
         * whether interrupts are enabled (IFF1), and where the PC is.
         * Respect the diag_log budget. Reads R800 state directly through the
         * compatibility handle: this is a diagnostic, not machine policy. */
        static int s_irq_log_frame = 0;
        if ((++s_irq_log_frame % 60) == 0) {
            R800 *z80 = (R800 *)msx_cpu_native_handle(cpu);
            msx_diag(machine, "IRQ: pending iff1=%u im=%u pc=%04X",
                     z80->regs.iff1, z80->regs.im,
                     z80->regs.PC.W);
        }
    }
    return (int) n;
}

/* Render the sound device into nSamples mono samples covering nMasterCycles
 * master clocks (3579545 Hz). Call once per emulated frame from the host loop:
 * the core has no cycle counter, so the host passes the time it actually
 * spent. The device replays the frame's timestamped writes itself (see
 * include/msx_audio.h); this is just the seam forwarder. */
unsigned msx_psg_render(MSX_Machine *machine, Int16 *out, unsigned nSamples,
                        unsigned nMasterCycles)
{
    if (!machine || !out || nSamples == 0) return 0;
    return msx_audio_render(&machine->audio, out, nSamples,
                            (UInt32)nMasterCycles);
}
