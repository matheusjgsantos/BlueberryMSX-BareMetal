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

    int region = addr / REGION_SIZE;
    if (region > 3) region = 3;

    int active = machine->activeSlot[region];
    int slot = active & 3;
    int sslot = (active >> 2) & 3;

    if (slot < NUM_SLOTS && sslot < NUM_SUBSLOTS) {
        MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
        // Live cartridge bus: the whole subslot lives on a real RPMC
        // connector, so every byte comes from the physical cartridge.
        if (ss->busSlot >= 0)
            return machine->bus_read
                ? machine->bus_read(machine->bus_ref, ss->busSlot, addr) : 0xFF;
        /* MegaROM mappers for emulated ROM subslots. All supported types
         * (ASCII8, Konami, Konami-SCC) expose four 8KB windows in
         * 0x4000/0x6000/0x8000/0xA000 selected by ss->bank[0..3]; only the
         * bank-register write decode differs. */
        if (ss->mapperType != MSX_MAPPER_NONE &&
            ss->mapperType != MSX_MAPPER_NOMAPPER &&
            ss->mapperType != MSX_MAPPER_AUTO &&
            ss->romSize > 0 && addr >= 0x4000) {
            int window = (addr - 0x4000) >> 13;
            if (window < 0 || window > 3) return 0xFF;
            unsigned bank = ss->bank[window];
            unsigned page = bank & ss->romMask;
            unsigned offset = (page << 13) | (addr & 0x1FFF);
            if (offset < ss->romSize) {
                if (ss->pRomImage) {
                    return ss->pRomImage[offset];
                }
                return ss->data[offset];
            }
            return 0xFF;
        }
        uint8_t *base = ss->data;
        int size = ss->size;
        // Each (slot, subslot) backs a full 64KB address space, indexed by the
        // complete Z80 address (region << 14 | offset). The active slot for the
        // 16KB region selects which slot's buffer is visible.
        if (size > 0 && addr < size) return base[addr];
    }
    return 0xFF;
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

    int region = addr / REGION_SIZE;
    if (region > 3) region = 3;

    int active = machine->activeSlot[region];
    int slot = active & 3;
    int sslot = (active >> 2) & 3;

    if (slot < NUM_SLOTS && sslot < NUM_SUBSLOTS) {
        MSX_SubSlot *ss = &machine->slots[slot].subslots[sslot];
        // Live cartridge bus: pass the write to the real cartridge so its
        // mapper/bank register or on-board RAM sees it (ROM-array writes to
        // emulated slots stay ignored below).
        if (ss->busSlot >= 0) {
            if (machine->bus_write)
                machine->bus_write(machine->bus_ref, ss->busSlot, addr, val);
            return;
        }
        /* MegaROM bank-register writes for emulated ROM subslots. Non-bus
         * mapper writes to any other address are ignored (ROM is read-only). */
        {
            int mapped = (ss->mapperType == MSX_MAPPER_ASCII8 ||
                          ss->mapperType == MSX_MAPPER_ASCII16 ||
                          ss->mapperType == MSX_MAPPER_KONAMI ||
                          ss->mapperType == MSX_MAPPER_KONAMI_SCC);
            if (mapped && ss->romSize > 0) {
                if (ss->mapperType == MSX_MAPPER_KONAMI_SCC) {
                    /* bank 1: 0x5000-0x57FF, bank 2: 0x7000-0x77FF,
                     * bank 3: 0x9000-0x97FF, bank 4: 0xB000-0xB7FF.
                     * (0x9800-0x9FFF is the SCC register window; with no SCC
                     * chip present those writes are ignored.) */
                    if (addr >= 0x5000 && addr < 0xC000 &&
                        (addr & 0x1800) == 0x1000) {
                        int window = (addr >> 13) - 2; /* 0x5000->0 .. 0xB000->3 */
                        if (window >= 0 && window <= 3) {
                            ss->bank[window] = val & ss->romMask;
                        }
                    }
                    return;
                }
                if (ss->mapperType == MSX_MAPPER_KONAMI) {
                    /* Page 0x4000 is fixed at segment 0; 0x6000/0x8000/0xA000
                     * select windows 1/2/3 (any address in the page works). */
                    if (addr >= 0x6000 && addr < 0xC000) {
                        int window = (addr >> 13) - 2; /* 0x6000->1 .. 0xA000->3 */
                        if (window >= 0 && window <= 3) {
                            ss->bank[window] = val & ss->romMask;
                        }
                    }
                    return;
                }
                /* ASCII8: 0x6000/w0, 0x6800/w1, 0x7000/w2, 0x7800/w3. */
                if (addr >= 0x6000 && addr <= 0x67FF) {
                    ss->bank[0] = val & ss->romMask;
                } else if (addr >= 0x6800 && addr <= 0x6FFF) {
                    ss->bank[1] = val & ss->romMask;
                } else if (addr >= 0x7000 && addr <= 0x77FF) {
                    ss->bank[2] = val & ss->romMask;
                } else if (addr >= 0x7800 && addr <= 0x7FFF) {
                    ss->bank[3] = val & ss->romMask;
                }
                return;
            }
        }
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

/* Sub-frame PSG register write log: blueMSX R3 syncs every AY write into the
 * audio stream at its exact output sample (AY8910.c updateRegister ->
 * mixerSync), and openMSX timestamps writes against the CPU clock. The R800
 * core has no cycle counter, so each write records the fraction of the
 * frame's instruction budget executed so far (msx_step_frame), and
 * msx_psg_render() replays the batch by restoring the state saved at the
 * frame's first write and re-applying the writes at those positions.
 * Without this, every write retroactively shaped the WHOLE video frame
 * (~16.6 ms), which audibly roughens fast passages vs. the references. */
typedef struct { UInt16 frac16; UInt8 reg; UInt8 val; } PsgWriteLogEntry;
#define PSG_WRITE_LOG_MAX 256
static PsgWriteLogEntry s_psgLog[PSG_WRITE_LOG_MAX];
static unsigned s_psgLogCount;
static int s_psgLogOverflow;
static PSG s_psgStart;
static const void *s_psgStartOwner;
static unsigned s_instrDone;
static unsigned s_instrTotal;

static void psg_log_clear(void) {
    s_psgLogCount = 0;
    s_psgLogOverflow = 0;
    s_psgStartOwner = 0;
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

static UInt8 slot_read_io(void *ref, UInt16 port) {
    /* MSX peripherals decode A0-A7; the Z80 also drives A8-A15 on I/O. */
    port &= 0xFF;
    MSX_Machine *machine = (MSX_Machine*)ref;
    UInt8 v;
    /* Live bus: unclaimed ports belong to a cartridge. */
    if (machine->bus_read_io && !io_is_internal(port))
        return machine->bus_read_io(machine->bus_ref, port);
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
            /* Record the write's in-frame position first (the live apply
             * below keeps 0xA2 read-back correct during the frame; the
             * batch render replays from the saved start state). */
            if (s_psgLogCount == 0) {
                s_psgStart = *psg;
                s_psgStartOwner = machine->sound;
            }
            if (s_psgLogCount < PSG_WRITE_LOG_MAX && s_instrTotal > 0) {
                PsgWriteLogEntry *e = &s_psgLog[s_psgLogCount++];
                e->frac16 = (UInt16) ((unsigned long long) s_instrDone
                                      * 65536u / s_instrTotal);
                e->reg = psg_get_reg_latch(psg);
                e->val = val;
            } else {
                s_psgLogOverflow = 1;
            }
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
        {
            int page1 = (val >> 2) & 0x03;
            if (page1 != s_slotEvtLastPage1) {
                a8_evt((UInt16)pc, val);
                s_slotEvtLastPage1 = page1;
            }
        }
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
    /* Live bus: unclaimed ports belong to a cartridge (SCC/FM/MSX-Music...). */
    if (machine->bus_write_io && !io_is_internal(port))
        machine->bus_write_io(machine->bus_ref, port, val);
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

    // No slot is bus-backed until msx_slot_set_bus() says so.
    for (int s = 0; s < NUM_SLOTS; s++)
        for (int t = 0; t < NUM_SUBSLOTS; t++)
            machine->slots[s].subslots[t].busSlot = -1;

    // Match the reference blueMSX MSX board timing: CPU_ENABLE_M1 adds the
    // Z80 M1 (opcode fetch) cycle to each instruction's delay so the per
    // instruction systemTime advance matches blueMSX. Without it the core is
    // ~1 T-state/instruction too fast. (MSX.c reference sets the same flag.)
    machine->z80 = r800Create(CPU_ENABLE_M1,
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
    psg_log_clear();
    return machine;
}

void msx_destroy(MSX_Machine *machine) {
    if (!machine) return;
    psg_log_clear();
    for (int s = 0; s < NUM_SLOTS; s++)
        for (int t = 0; t < NUM_SUBSLOTS; t++)
            if (machine->slots[s].subslots[t].pRomImage)
                free(machine->slots[s].subslots[t].pRomImage);
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
    if (!pImage) return MSX_MAPPER_NONE;
    /* Anything that fits in a single 32KB page pair with no bank selects has
     * no mapper. Small ROMs (<64KB) are treated as plain even if a stray
     * 0x32 exists. */
    if (nSize < 0x10000) return MSX_MAPPER_NONE;

    int nScc = 0, nKonami = 0, nAscii8 = 0, nAscii16 = 0;
    unsigned i;
    for (i = 0; i + 3 <= nSize; i++) {
        if (pImage[i] != 0x32) continue; /* LD (nn),A */
        unsigned v = (unsigned)pImage[i + 1] | ((unsigned)pImage[i + 2] << 8);
        switch (v) {
        case 0x5000: case 0x9000: case 0xB000:
            nScc++; break;                              /* Konami-SCC only */
        case 0x4000: case 0x8000: case 0xA000:
            nKonami++; break;                           /* Konami only */
        case 0x6800: case 0x7800:
            nAscii8++; break;                           /* ASCII8 only */
        case 0x6000:
            nKonami++; nAscii8++; nAscii16++; break;    /* ambiguous */
        case 0x7000:
            nScc++; nAscii8++; nAscii16++; break;       /* ambiguous */
        case 0x77FF:
            nAscii16++; break;                          /* ASCII16 marker */
        default:
            break;
        }
    }
    /* openMSX biases away from ASCII8 (its marker is weakest). */
    if (nAscii8 > 0) nAscii8--;

    if (nScc == 0 && nKonami == 0 && nAscii8 == 0 && nAscii16 == 0) {
        /* No recognizable idiom: fall back to ASCII8 (the common MegaROM). */
        return MSX_MAPPER_ASCII8;
    }
    if (nScc > 0 && nScc >= nKonami && nScc >= nAscii8 && nScc >= nAscii16)
        return MSX_MAPPER_KONAMI_SCC;
    if (nKonami > 0 && nKonami >= nAscii8 && nKonami >= nAscii16)
        return MSX_MAPPER_KONAMI;
    if (nAscii8 >= nAscii16) return MSX_MAPPER_ASCII8;
    /* ASCII16 wins, but we approximate it with the shared ASCII8 decode. */
    return MSX_MAPPER_ASCII8;
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
    R800    *z80 = (R800 *)machine->z80;
    TMS9918 *vdp = (TMS9918 *)machine->vdp;
    SystemTime start = r800GetSystemTime(z80);
    unsigned n = 0;

    s_instrTotal = (unsigned) frame_ticks;
    while ((UInt32)(r800GetSystemTime(z80) - start) < (UInt32) frame_ticks) {
        s_instrDone = (unsigned)(r800GetSystemTime(z80) - start);
        r800ExecuteInstruction(z80);
        n++;
    }
    s_instrDone = s_instrTotal;

    tms9918_gen_sync_irq(vdp);
    msx_frame_render(vdp);
    if (vdp->irq) {
        r800SetInt(z80);
        /* Throttled IRQ delivery trace (~1 line / 60 frames) for the bring-up
         * serial log: tells us the IRQ is being latched, the IM mode,
         * whether interrupts are enabled (IFF1), and where the PC is.
         * Respect the diag_log budget. */
        static int s_irq_log_frame = 0;
        if ((++s_irq_log_frame % 60) == 0)
            msx_diag(machine, "IRQ: pending iff1=%u im=%u pc=%04X",
                     z80->regs.iff1, z80->regs.im,
                     z80->regs.PC.W);
    }
    return (int) n;
}

/* Render the PSG into nSamples mono samples covering nMasterCycles master
 * clocks (3579545 Hz). Call once per emulated frame from the host loop: the
 * core has no cycle counter, so the host passes the time it actually spent.
 * If the frame logged sub-frame register writes, the batch is rendered in
 * segments with the writes applied at their recorded positions (see the log
 * comment above); otherwise it renders in one psg_render call. */
unsigned msx_psg_render(MSX_Machine *machine, Int16 *out, unsigned nSamples,
                        unsigned nMasterCycles)
{
    if (!machine || !machine->sound || !out || nSamples == 0) return 0;

    PSG *psg = (PSG*)machine->sound;

    if (s_psgStartOwner != machine->sound) {
        /* Rebuilt machine: the saved start state no longer exists. */
        psg_log_clear();
        s_psgStartOwner = machine->sound;
    }

    if (s_psgLogCount == 0 || s_psgLogOverflow) {
        /* No in-frame writes, or the log overflowed: fall back to the old
         * whole-frame behaviour rather than replaying a partial order. */
        psg_log_clear();
        return psg_render(psg, out, nSamples, (UInt32)nMasterCycles);
    }

    /* Replay from the state saved at the frame's first write. The live chip
     * keeps its end-of-frame state (already correct for the next frame's
     * reads); only the 0xA0 latch must survive the struct restore, since
     * psg_write never touches it. */
    UInt8 latch = psg->reg_latch;
    *psg = s_psgStart;
    psg->reg_latch = latch;

    unsigned n = s_psgLogCount;
    unsigned sDone = 0;
    unsigned cDone = 0;
    for (unsigned k = 0; k < n; k++) {
        unsigned long long f = s_psgLog[k].frac16;
        unsigned s1 = (unsigned) ((unsigned long long) nSamples * f >> 16);
        unsigned c1 = (unsigned) ((unsigned long long) nMasterCycles * f >> 16);
        if (s1 > sDone) {
            psg_render(psg, out + sDone, s1 - sDone, (UInt32) (c1 - cDone));
            sDone = s1;
            cDone = c1;
        }
        psg_write(psg, s_psgLog[k].reg, s_psgLog[k].val);
    }
    psg_render(psg, out + sDone, nSamples - sDone,
               (UInt32) (nMasterCycles - cDone));
    psg_log_clear();
    return nSamples;
}
