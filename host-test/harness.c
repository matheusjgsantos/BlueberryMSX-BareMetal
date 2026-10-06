//
// harness.c -- host-side C harness for BlueberryMSX-BareMetal
//
// Reproduces the exact boot sequence from src/app/kernel.cpp (C-BIOS load,
// slot map 0xC0, Knightmare cart in slot 1) and runs
// msx_step_frame() for a fixed number of frames, dumping the live VDP
// registers, decoded screen mode, computed table bases, and the actual
// rendered content at key frames.
//
// Purpose: pin the root cause of "solid blue background, no logo / tiles /
// sprites". The Pi3 serial log (200-line budget) never reached a steady-state
// VDP dump; this harness has no budget and runs the identical core + chips
// (msx.c, tms9918.c, R800.c) byte-for-byte on x86.
//
// Build & run (see Makefile):
//   make -f host-test/Makefile -C ..   # or run the Makefile directly
//

#include <msx.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "R800.h"
#include "tms9918.h"
#include "psg.h"
#include "cbios_roms.h"
#include "knightmare_roms.h"

/* msx.c exposes this for the host (promoted from static). */
extern int g_trace_io;

/* Audio: render PSG samples each frame when a third argument is given, so the
 * harness can prove the running ROM drives the AY-3-8910. */
static int render_audio = 0;

/* Audio aggregate, printed once at the end of the run. */
static int g_audio_loud_frames;
static int g_audio_vol_max[3];
static unsigned g_audio_r7[256];
extern int g_tms_trace;
extern unsigned g_trace_count;
extern unsigned g_trace_cap;

/* Z80 instructions per frame -- MUST match src/app/msx_task.cpp:20 (12000). */
#define VDP_FRAME_INSTR   12000

/* Frames at which to run the full diagnostics. */
#define DIAG_FRAME_1      40
#define DIAG_FRAME_2      240
#define DIAG_FRAME_3      1200
#define DIAG_FRAME_4      4000

/* k_msx_palette duplicated only so the harness can reverse-map the 16
 * fixed palette entries that tms9918_render() writes. Matches
 * src/chips/vdp/tms9918.c:8 exactly. */
static const uint32_t pal[16] = {
    0x000000u,0xFFFFFFu,0xC40404u,0x04C404u,0xDBC800u,
    0x0000C8u,0xC800C8u,0x00C8C8u,0xFF5858u,0x58FF58u,
    0xFFEC5Cu,0x5C7CFFu,0xFF8CE8u,0x84F8F8u,0xAAAAAAu,0xFFFFFFu,
};

static int col_of(uint32_t w)
{
    for (int c = 0; c < 16; c++) if (pal[c] == w) return c;
    return -1;
}

static void hexdump(const char *label, const uint8_t *p, size_t n)
{
    if (label && *label) printf("  %s:\n", label);
    for (size_t i = 0; i < n; i += 16)
    {
        printf("    %04zx: ", i);
        for (size_t j = 0; j < 16; j++) printf("%02X ", p[i + j]);
        printf(" |");
        for (size_t j = 0; j < 16; j++)
            printf("%c", j < (n - i) && p[i+j] >= 32 && p[i+j] < 127 ? p[i+j] : '.');
        printf(" |\n");
    }
}

static void rle_row(const char *lbl, uint32_t *row, int n)
{
    printf("  %s (run-length):\n", lbl);
    int x = 0;
    while (x < n)
    {
        uint32_t w = row[x];
        int e = x + 1;
        while (e < n && row[e] == w) e++;
        printf("    x=%3d..%3d col=%d len=%d\n", x, e - 1, col_of(w), e - x);
        x = e;
    }
}

/* Scan the full 16K VRAM and report which 256-byte blocks contain nonzero
 * bytes, plus explicit dumps of the SCREEN 1 regions Knightmare expects
 * (pattern ~0x0800, name/color 0x1C00). This pins down WHERE the ~2800
 * nonzero bytes actually live, which distinguishes "data in the wrong place"
 * (0x99 addr decode bug) from "data in the right place but render is broken". */
static void scan_vram(const TMS9918 *v, int frame)
{
    const uint8_t *vr = v->vram;
    int sz = v->vram_size;

    printf("  VRAM scan @ frame %d (total size %d):\n", frame, sz);
    printf("  256-byte blocks with nonzero content (first nonzero shown):\n");
    int any_block = 0;
    for (int blk = 0; blk < sz / 256; blk++)
    {
        int nz = 0, first = -1;
        int base = blk * 256;
        for (int i = 0; i < 256; i++)
            if (vr[base + i]) { if (first < 0) first = i; nz++; }
        if (nz)
        {
            any_block = 1;
            int hi = 0; for (int i = 0; i < 256; i++) if (vr[base+i] > hi) hi = vr[base+i];
            printf("    block %03X (0x%04X-0x%04X): nz=%3d first=%02X maxval=%02X\n",
                   blk, base, base + 255, nz, first, hi);
        }
    }
    if (!any_block) printf("    (VRAM entirely zero)\n");

    printf("  Expected SCREEN 1 regions:\n");
    UInt16 mask = v->vram_size - 1;
    UInt16 name_ba = (UInt16)((v->reg[2] & 0xF0) << 6);
    UInt16 col_ba  = (UInt16)((v->reg[3] & 0xF0) << 6);
    UInt16 pat_ba  = (UInt16)((v->reg[4] & 0x07) << 11);
    hexdump("name table @ name_ba", vr + (name_ba & mask), 64);
    hexdump("pat  table @ pat_ba ", vr + (pat_ba  & mask), 16);
    hexdump("col  table @ col_ba ", vr + (col_ba  & mask), 24);
}

static void dump_vdp(TMS9918 *v, int frame)
{
    printf("\n=== VDP @ frame %d ===\n", frame);
    printf("  regs: R0=%02X R1=%02X R2=%02X R3=%02X R4=%02X R5=%02X R6=%02X R7=%02X\n",
           v->reg[0], v->reg[1], v->reg[2], v->reg[3],
           v->reg[4], v->reg[5], v->reg[6], v->reg[7]);
    printf("  addr=%04X write_mode=%d pending=%02X irq=%d\n",
           v->addr, v->write_mode, v->pending, v->irq);

    int r0 = v->reg[0], r1 = v->reg[1];
    const char *mode;
    if (r1 & 0x08) mode = (r1 & 0x10) ? "SCREEN 1" : "MULTICOLOR";
    else if (r1 & 0x10) mode = (r0 & 0x02) ? "TEXT80" : "TEXT40";
    else if (r0 & 0x02) mode = "GRAPHICS 2";
    else mode = "GRAPHICS 1";
    printf("  mode: %s\n", mode);

    /* Base decode must match tms9918_render() (openMSX setMask semantics).
     * NOTE: previously this used the old broken formulas AND, worse, called
     * tms9918_render() with pitch=256 (pixels) while the function expects a
     * pitch in BYTES -- so the render silently returned early and every
     * "black screen" histogram below was an artifact of the harness. */
    int r1_is_text = (v->reg[1] & 0x10) != 0;
    UInt16 name_ba = r1_is_text ? (UInt16)((v->reg[2] & 0x0C) << 10)
                                : (UInt16)((v->reg[2] & 0x0F) << 10);
    UInt16 col_ba  = (UInt16)(((v->reg[3] << 6) | 0x003F) & 0x3FC0);
    UInt16 pat_ba  = (UInt16)((v->reg[4] & 0x07) << 11);
    printf("  bases: name=%04X col=%04X pat=%04X  (sprite_pat=%04X)\n",
           name_ba, col_ba, pat_ba, (UInt16)((v->reg[6] & 0x07) << 11));

    {
        UInt16 mask = v->vram_size - 1;
        const uint8_t *vram = v->vram;
        hexdump("name table", vram + (name_ba & mask), 64);
        hexdump("pat  table", vram + (pat_ba  & mask), 32);
        hexdump("col  table", vram + (col_ba  & mask), 32);
        hexdump("sprite RAM 0x3C0", vram + 0x3C0, 32);
        hexdump("VRAM @0x0000", vram, 64);

        /* Render exactly like vdpblit.cpp does, then profile. */
        static uint32_t buf[256 * 192];
        memset(buf, 0, sizeof(buf));
        tms9918_render(v, buf, 256 * 4);

        long hist[16] = {0}; long total = 256L * 192L;
        for (int y = 0; y < 192; y++)
            for (int x = 0; x < 256; x++)
            {
                int c = col_of(buf[y * 256 + x]);
                if (c >= 0) hist[c]++;
            }
        printf("  render histogram (of %ld px):\n", total);
        static const char *names[16] = {
            "black","white","red","green","yellow","blue",
            "magenta","cyan","br.red","br.grn","br.yel","br.blu",
            "br.mag","br.cyn","grey","wht2/unk"};
        for (int c = 0; c < 16; c++)
            if (hist[c]) printf("    %2d %-7s %8ld  %5.1Lf%%\n",
                                c, names[c], hist[c],
                                100.0L * hist[c] / total);
        long nz = 0; for (int c = 0; c < 16; c++) if (hist[c]) nz++;
        printf("    distinct palette slots: %ld\n", nz);

        rle_row("row 0",  buf + 0  * 256, 256);
        rle_row("row 48", buf + 48 * 256, 256);
        rle_row("row 96", buf + 96 * 256, 256);
        rle_row("row 144", buf + 144 * 256, 256);
        rle_row("row 191", buf + 191 * 256, 256);
    }

    scan_vram(v, frame);
}

static void dump_z80(const R800 *z, int frame)
{
    printf("  z80@%d: PC=%04X SP=%04X AF=%04X BC=%04X DE=%04X HL=%04X I=%02X im=%u iff1=%u mode=%d\n",
           frame, z->regs.PC.W, z->regs.SP.W, z->regs.AF.W, z->regs.BC.W,
           z->regs.DE.W, z->regs.HL.W, z->regs.I, z->regs.im, z->regs.iff1,
           (int)z->cpuMode);
}

/* argv[7] input-injection test: press one key at a time while Knightmare
 * runs and report, at the end of each press window, what the GUEST sees
 * (keyboard rows probed through the real bus decode, PSG joystick
 * registers, game RAM state, name-table hash).  A phase that changes
 * namehash/PC/state proves the key reached the game. */
struct InPhase { int start, end; int ec; const char *name; };
static const struct InPhase in_phases[] = {
    {    0,  999, 0,             "baseline" },
    { 1000, 1059, MSX_EC_RETURN, "RETURN" },
    { 1060, 1119, MSX_EC_SPACE,  "SPACE"  },
    { 1120, 1179, MSX_EC_UP,     "UP"     },
    { 1180, 1239, MSX_EC_DOWN,   "DOWN"   },
    { 1240, 1299, MSX_EC_LEFT,   "LEFT"   },
    { 1300, 1359, MSX_EC_RIGHT,  "RIGHT"  },
    { 1360, 1419, MSX_EC_A,      "A"      },
    { 1420, 1479, MSX_EC_ESC,    "ESC"    },
    { 1480, 1539, MSX_EC_F1,     "F1"     },
    { 1540, 1599, 0,             "cooldown" },
};
#define IN_NPHASES ((int)(sizeof in_phases / sizeof in_phases[0]))

static void in_report(MSX_Machine *m, int frame, const char *name)
{
    printf("[IN] phase=%s end frame=%d\n", name, frame);

    /* Guest-visible matrix: select the row latch, then read A9, exactly
     * what SNSMAT does (the guest re-selects the row before its own
     * reads, so this probe cannot confuse it).  Rows 6/7/8 are the input
     * rows; anything with a clear bit means a key the guest can see. */
    for (int row = 0; row < 12; row++) {
        m->bus.write_io(m->bus.ref, 0xAA, (UInt8)(0xF0 | row));
        printf("  row%d=%02X\n", row, m->bus.read_io(m->bus.ref, 0xA9));
    }

    /* Joystick path Knightmare reads every frame: RDPSG(14) with the
     * R14 latch.  Must read 0xFF (pins pulled up) while R7 port A is an
     * input; a 0x00 here is the "all directions pressed" regression. */
    m->bus.write_io(m->bus.ref, 0xA0, 0x0E);
    UInt8 r14 = m->bus.read_io(m->bus.ref, 0xA2);
    m->bus.write_io(m->bus.ref, 0xA0, 0x0F);
    UInt8 r15 = m->bus.read_io(m->bus.ref, 0xA2);
    PSG *pg = (PSG *)m->sound;
    printf("  PSG R14=%02X R15=%02X R7=%02X\n", r14, r15, pg->reg[7]);

    TMS9918 *v = (TMS9918 *)m->vdp;
    unsigned nb = (unsigned)(v->reg[2] & 15) << 10;
    uint32_t h = 2166136261u;
    for (int i = 0; i < 768; i++)
        h = (h ^ v->vram[(nb + i) & (v->vram_size - 1)]) * 16777619u;
    R800 *z = (R800 *)m->z80;
    printf("  PC=%04X namehash=%08X\n", z->regs.PC.W, h);
    printf("  E000: %02X %02X %02X %02X %02X %02X %02X %02X  "
           "E600=%02X E03A=%02X E052=%02X\n",
           m->bus.read_mem(m->bus.ref, 0xE000),
           m->bus.read_mem(m->bus.ref, 0xE001),
           m->bus.read_mem(m->bus.ref, 0xE002),
           m->bus.read_mem(m->bus.ref, 0xE003),
           m->bus.read_mem(m->bus.ref, 0xE004),
           m->bus.read_mem(m->bus.ref, 0xE005),
           m->bus.read_mem(m->bus.ref, 0xE006),
           m->bus.read_mem(m->bus.ref, 0xE007),
           m->bus.read_mem(m->bus.ref, 0xE600),
           m->bus.read_mem(m->bus.ref, 0xE03A),
           m->bus.read_mem(m->bus.ref, 0xE052));
}

int main(int argc, char **argv)
{
    int stop = (argc > 1) ? atoi(argv[1]) : DIAG_FRAME_4;
    int trace   = (argc > 2) ? atoi(argv[2]) : 0;
    /* Optional: trace_window_start (argv[3]), window_len (argv[4]),
     * trace cap (argv[5]). When [3] is set, tracing is enabled only for
     * frames [3, 3+4) and g_trace_count is reset at window start. */
    int tws = (argc > 3) ? atoi(argv[3]) : -1;
    int twl = (argc > 4) ? atoi(argv[4]) : 100;
    if (argc > 5) g_trace_cap = (unsigned)atoi(argv[5]);
    /* argv[6]: render PSG audio each frame and report writes/level (1=on). */
    render_audio = (argc > 6) ? atoi(argv[6]) : 0;
    /* argv[7]: key-injection test (1=on); presses one key per phase and
     * reports what the guest reads at the end of each press window. */
    int input_test = (argc > 7) ? atoi(argv[7]) : 0;

    MSX_Machine *m = msx_create();
    if (!m) { fprintf(stderr, "msx_create failed\n"); return 1; }

    if (trace) {
        /* If a window is requested, the loop owns the g_trace_io/g_tms_trace
         * toggles; otherwise enable tracing from frame 1. */
        if (tws < 0) { g_trace_io = 1; g_tms_trace = 1; }
        fprintf(stderr, "IO tracing ENABLED (argv[2]=%d, window_start=%d len=%d cap=%lu)\n",
                trace, tws, twl, (unsigned long)g_trace_cap);
    }

    /* ---- kernel.cpp :: msx_load_cbios ---- */
    msx_set_slot(m, 3, 0, 0, 0);
    memset(m->slots[3].subslots[0].data, 0, SLOT_MAX_SIZE);
    msx_load_data(m, 0, 0, 0x0000, (uint8_t *)cbios_main_rom, (int)cbios_main_rom_size);
    msx_load_data(m, 0, 0, 0x8000, (uint8_t *)cbios_logo_rom, (int)cbios_logo_rom_size);
    m->bus.write_io(m->bus.ref, 0xA8, 0xC0);

    /* ---- kernel.cpp :: msx_load_knightmare ---- */
    if (knightmare_rom_size == 32768u)
    {
        msx_load_data(m, 1, 0, 0x4000, (uint8_t *)knightmare_rom, 16384);
        msx_load_data(m, 1, 0, 0x8000, (uint8_t *)knightmare_rom + 16384, 16384);
    }
    else
    {
        fprintf(stderr, "knightmare_rom_size=%u (expected 32768)\n",
                (unsigned)knightmare_rom_size);
        return 2;
    }

    int first_nonzero_seen = 0;
    int lastPhase = -1;
    for (int f = 1; f <= stop; f++)
    {
        /* Enable windowed trace before the frame so frame tws is captured. */
        if (trace && tws >= 0 && f >= tws && f < tws + twl) {
            if (!g_trace_io) { g_trace_io = 1; g_trace_count = 0; }
            if (!g_tms_trace) g_tms_trace = 1;
        } else if (trace && g_trace_io) {
            if (tws >= 0) { g_trace_io = 0; g_tms_trace = 0; }
        }

        msx_step_frame(m, VDP_FRAME_INSTR);

        /* Key-injection phases: press the phase key after the frame, so
         * the guest first sees it at frame start+1, and report at the
         * end of the press window (the key is still held). */
        if (input_test) {
            int ph = -1;
            for (int i = 0; i < IN_NPHASES; i++)
                if (f >= in_phases[i].start && f <= in_phases[i].end) ph = i;
            if (ph != lastPhase) {
                if (lastPhase >= 0 && in_phases[lastPhase].ec)
                    msx_ppi_set_ec(m, in_phases[lastPhase].ec, 0);
                if (ph >= 0) {
                    if (in_phases[ph].ec)
                        msx_ppi_set_ec(m, in_phases[ph].ec, 1);
                    printf("\n[IN] frame=%d phase=%s%s\n", f, in_phases[ph].name,
                           in_phases[ph].ec ? " (press)" : "");
                }
                lastPhase = ph;
            }
            if (ph >= 0 && f == in_phases[ph].end)
                in_report(m, f, in_phases[ph].name);
        }

        /* Render one video frame of PSG audio so the harness shows whether the
         * running ROM actually programs the sound chip (this is what decides
         * whether hardware will produce sound at all). */
        if (render_audio) {
            static Int16 pcm[800];
            msx_psg_render(m, pcm, 800, MSX_PSG_CLOCKS_PER_FRAME);
            long long sum = 0; int peak = 0;
            for (int q = 0; q < 800; q++) {
                sum += pcm[q];
                int a = pcm[q] < 0 ? -pcm[q] : pcm[q];
                if (a > peak) peak = a;
            }
            static long long nSumAcc = 0; static int nPeakAcc = 0;
            nSumAcc += sum; if (peak > nPeakAcc) nPeakAcc = peak;
            /* Aggregate: how much of the run actually makes sound, and how the
             * mixer/volume registers were used over time. */
            static int nLoudFrames = 0, nVolMax[3] = {0,0,0};
            static unsigned nR7Seen[256]; static int bInit = 0;
            PSG *ap = (PSG *)m->sound;
            if (!bInit) { bInit = 1; }
            if (peak > 64) nLoudFrames++;
            for (int c = 0; c < 3; c++) {
                int v = ap->reg[8 + c] & 0x0F;
                if (v > nVolMax[c]) nVolMax[c] = v;
            }
            nR7Seen[ap->reg[7]]++;
            g_audio_loud_frames = nLoudFrames;
            g_audio_vol_max[0] = nVolMax[0];
            g_audio_vol_max[1] = nVolMax[1];
            g_audio_vol_max[2] = nVolMax[2];
            memcpy(g_audio_r7, nR7Seen, sizeof(nR7Seen));
            if (f % 100 == 0 && f > 0) {
                PSG *dp = (PSG *)m->sound;
                printf("[PSG] frame=%d writes=%u last=R%u val=%02X "
                       "sum/frame=%lld peak_max=%d | R5=%02X R6=%02X R7=%02X "
                       "R8=%02X R9=%02X R10=%02X R11=%02X R12=%02X R13=%02X "
                       "| tA=%04X tB=%04X tC=%04X\n",
                       f, g_psg_writes, g_psg_last_reg, g_psg_last_val,
                       nSumAcc / f, nPeakAcc,
                       dp->reg[5], dp->reg[6], dp->reg[7], dp->reg[8],
                       dp->reg[9], dp->reg[10], dp->reg[11], dp->reg[12],
                       dp->reg[13],
                       dp->tone_period[0], dp->tone_period[1],
                       dp->tone_period[2]);
                nSumAcc = 0; nPeakAcc = 0;
            }
        }

        /* Checkpoint VRAM-population probes at 10, 20, 50, 100, 200, 500,
         * 1000, 2000, 4000 (covers C-BIOS fill, Knightmare entry, steady). */
        if (f == 10 || f == 20 || f == 50 || f == 100 || f == 200 ||
            f == 500 || f == 1000 || f == 2000 || f == 4000 ||
            f == 8000 || f == 16000 || f == 32000)
        {
            TMS9918 *vv = (TMS9918 *)m->vdp;
            int nz = 0; for (int q = 0; q < vv->vram_size; q++) if (vv->vram[q]) nz++;
            int a = 0; while (a < vv->vram_size && !vv->vram[a]) a++;
            int name_nz = 0; for (int q = 0x3800; q < 0x3900; q++) if (vv->vram[q]) name_nz++;
            int E600 = m->bus.read_mem(m->bus.ref, 0xE600) & 0xFF;
            printf("[VRAM-pop] frame=%d nonzero=%d name_0x38_nz=%d E600=%02X  vdp_addr=%04X pending=%02X\n",
                    f, nz, name_nz, E600, vv->addr, vv->pending);
            if (nz && !first_nonzero_seen)
            {
                first_nonzero_seen = 1;
                int s = (a & ~31) ? (a & ~31) : 0;
                for (int k = s; k < s + 96 && k < vv->vram_size; k += 16)
                {
                    printf("    [%04X] ", k);
                    for (int j = k; j < k + 16 && j < vv->vram_size; j++)
                        printf("%02X ", vv->vram[j]);
                    printf("\n");
                }
            }
        }

        if (f % 100 == 0)
        {
            R800 *z = (R800 *)m->z80;
            TMS9918 *v = (TMS9918 *)m->vdp;
            printf("\n-- frame %d --\n", f);
            dump_z80(z, f);
            printf("  VDP R0=%02X R1=%02X R2=%02X R3=%02X R4=%02X R5=%02X R6=%02X R7=%02X\n",
                   v->reg[0], v->reg[1], v->reg[2], v->reg[3],
                   v->reg[4], v->reg[5], v->reg[6], v->reg[7]);
            /* Probe the H.TIMI hook chain in RAM: C-BIOS calls 0xFD9A from
             * its RST38 handler (0x1919), and Knightmare overwrites it with
             * JP 0x402E (its per-frame draw routine). Resolve through the bus
             * so we read the same bytes the CPU sees, whatever slot is active. */
            {
                printf("  slotReg=%02X active=[%d %d %d %d]\n",
                       m->slotReg, m->activeSlot[0], m->activeSlot[1],
                       m->activeSlot[2], m->activeSlot[3]);
                printf("  H.TIMI@FD9A: %02X %02X %02X   H.KEYI@FD9F: %02X %02X %02X\n",
                       m->bus.read_mem(m->bus.ref, 0xFD9A),
                       m->bus.read_mem(m->bus.ref, 0xFD9B),
                       m->bus.read_mem(m->bus.ref, 0xFD9C),
                       m->bus.read_mem(m->bus.ref, 0xFD9F),
                       m->bus.read_mem(m->bus.ref, 0xFDA0),
                       m->bus.read_mem(m->bus.ref, 0xFDA1));
                printf("  work@E000:   %02X %02X %02X %02X %02X %02X %02X %02X\n",
                       m->bus.read_mem(m->bus.ref, 0xE000),
                       m->bus.read_mem(m->bus.ref, 0xE001),
                       m->bus.read_mem(m->bus.ref, 0xE002),
                       m->bus.read_mem(m->bus.ref, 0xE003),
                       m->bus.read_mem(m->bus.ref, 0xE004),
                       m->bus.read_mem(m->bus.ref, 0xE005),
                       m->bus.read_mem(m->bus.ref, 0xE006),
                       m->bus.read_mem(m->bus.ref, 0xE007));
                /* Draw state machine (see disassembly of 0x49C0):
                 * IX walks 0xE010 / 0xE01E / 0xE02C, 14 bytes per record,
                 * type byte at +2, state byte at 0xE03A. */
                for (int rec = 0; rec < 3; rec++) {
                    UInt16 base = (UInt16)(0xE010 + rec * 14);
                    printf("  rec%d@%04X:", rec, base);
                    for (int k = 0; k < 14; k++)
                        printf(" %02X", m->bus.read_mem(m->bus.ref, base + k));
                    printf("   (type=%02X)\n",
                           m->bus.read_mem(m->bus.ref, base + 2));
                }
                printf("  type@E012=%02X E020=%02X E02E=%02X | E02D=%02X E009=%02X E052=%02X E600=%02X E001=%02X\n",
                       m->bus.read_mem(m->bus.ref, 0xE012),
                       m->bus.read_mem(m->bus.ref, 0xE020),
                       m->bus.read_mem(m->bus.ref, 0xE02E),
                       m->bus.read_mem(m->bus.ref, 0xE02D),
                       m->bus.read_mem(m->bus.ref, 0xE009),
                       m->bus.read_mem(m->bus.ref, 0xE052),
                       m->bus.read_mem(m->bus.ref, 0xE600),
                       m->bus.read_mem(m->bus.ref, 0xE001));
                printf("  state@E03A=%02X  E064=%02X E065=%02X E066=%02X\n",
                       m->bus.read_mem(m->bus.ref, 0xE03A),
                       m->bus.read_mem(m->bus.ref, 0xE064),
                       m->bus.read_mem(m->bus.ref, 0xE065),
                       m->bus.read_mem(m->bus.ref, 0xE066));
            }
        }

        if (f == DIAG_FRAME_1) { dump_vdp((TMS9918 *)m->vdp, f); dump_z80((R800 *)m->z80, f); }
        if (f == DIAG_FRAME_2) { dump_vdp((TMS9918 *)m->vdp, f); dump_z80((R800 *)m->z80, f); }
        if (f == DIAG_FRAME_3) { dump_vdp((TMS9918 *)m->vdp, f); dump_z80((R800 *)m->z80, f); }
        if (f == DIAG_FRAME_4) { dump_vdp((TMS9918 *)m->vdp, f); dump_z80((R800 *)m->z80, f); }
    }

    {
        extern unsigned tms9918_w98;
        extern unsigned tms9918_w99;
        extern unsigned tms9918_w98_dropped;
        fprintf(stderr, "\n[TMS total] 98_writes=%u 99_writes=%u 98_dropped(wm=0)=%u\n",
                tms9918_w98, tms9918_w99, tms9918_w98_dropped);
    }

#ifdef PC_SAMPLER
    {
        extern unsigned long pcHist[0x10000];
        int i;
        /* Probe Knightmare-critical addresses first so they read un-zeroed. */
        static const int probes[] = {
            0x402E, /* H.TIMI hook entry            */
            0x4032, /* hook: CALL 0x49C0 (draw)     */
            0x40C9, /* idle loop JR $               */
            0x44A0, /* game init (boot only)        */
            0x490C, /* record-type setter           */
            0x4946, /* type setter: LD (HL),A write  */
            0x49C0, /* draw dispatcher              */
            0x49E9, /* pattern blit                 */
            0x4A59, /* type-0 sound-only path       */
            0x58D3, /* E600 read gate               */
            0x58E1, /* E600=3 writer                */
            0x40D3, /* advance routine              */
            0x4262, /* continuation                 */
            0x44C6, /* RES 2 in 0x40CB              */
        };
        fprintf(stderr, "\n[PC-probes] Knightmare-critical addresses:\n");
        for (i = 0; i < (int)(sizeof probes / sizeof probes[0]); i++)
            fprintf(stderr, "  PC=%04X  count=%lu\n", (unsigned)probes[i], pcHist[probes[i]]);
        /* Then top-hot for context (does not affect probes). */
        fprintf(stderr, "\n[PC-hist] top hot addresses (cumulative):\n");
        int shown = 0;
        unsigned long best; int best_pc = -1;
        while (shown < 25) {
            best = 0; best_pc = -1;
            for (i = 0; i < 0x10000; i++)
                if (pcHist[i] > best) { best = pcHist[i]; best_pc = i; }
            if (best == 0 || best_pc < 0) break;
            fprintf(stderr, "  PC=%04X  count=%lu\n", (unsigned)best_pc, best);
            pcHist[best_pc] = 0;
            shown++;
        }
    }
#endif

    /* Render current screen to PPM so we can see what the user sees. */
    {
        static uint32_t _fb[256 * 192];
        TMS9918 *v = (TMS9918*)m->vdp;
        /* Count bytes actually addressed by G2, not just all VRAM bytes. */
        if ((v->reg[0] & 2) && !(v->reg[1] & 0x18)) {
            unsigned names = 0, patterns = 0, colors = 0;
            unsigned nb = (v->reg[2] & 15) << 10;
            unsigned cb = (v->reg[3] << 6) | 63;
            unsigned pb = (v->reg[4] << 11) | ((v->reg[3] & 31) << 6) | 63;
            for (unsigned cell = 0; cell < 768; cell++) {
                unsigned ch = v->vram[(nb + cell) & 0x3FFF];
                names += ch != 0;
                for (unsigned line = 0; line < 8; line++) {
                    unsigned off = (cell / 256) * 2048 + ch * 8 + line;
                    patterns += v->vram[(pb & (0x2000 | off)) & 0x3FFF] != 0;
                    colors += v->vram[(cb & (0x2000 | off)) & 0x3FFF] != 0;
                }
            }
            fprintf(stderr, "[G2-used] names_nonzero=%u/768 pattern_rows_nonzero=%u/6144 color_rows_nonzero=%u/6144\n",
                    names, patterns, colors);
        }
        tms9918_render(v, _fb, 256 * 4);  /* pitch in BYTES */
        const char *name = "screen.ppm";
        if (getenv("SCREEN_PPM")) name = getenv("SCREEN_PPM");
        FILE *f = fopen(name, "wb");
        if (f) {
            int y;
            fprintf(f, "P6\n256 192\n255\n");
            for (y = 0; y < 192; y++) {
                int x;
                for (x = 0; x < 256; x++) {
                    uint32_t c = _fb[y * 256 + x];
                    unsigned char b[3];
                    b[0] = (unsigned char)((c>>16) & 0xFF);
                    b[1] = (unsigned char)((c>>8) & 0xFF);
                    b[2] = (unsigned char)(c & 0xFF);
                    fwrite(b, 1, 3, f);
                }
            }
            fclose(f);
            fprintf(stderr, "[screen] wrote %s\n", name);
        }
        /* Also a 48-line ASCII preview (sample every 4x4 pixels, char by luminance).
           XRGB8888: R = bits 23..16, G = 15..8, B = 7..0. Use max of RGB. */
        fprintf(stderr, "[screen-ascii]\n");
        { const char *shp = " .:-=+*#%@";
          int yy, xx, firstNonZeroRow = -1;
          for (yy = 0; yy < 192; yy++) {
            int row_has = 0;
            for (xx = 0; xx < 256 && !row_has; xx++) if (_fb[yy*256+xx]) row_has = 1;
            if (row_has && firstNonZeroRow < 0) firstNonZeroRow = yy;
          }
          fprintf(stderr, "  fb firstNonZeroRow=%d (%d=blank)\n", firstNonZeroRow, firstNonZeroRow<0);
          for (yy = 0; yy < 192; yy += 4) {
            char line[65];
            for (xx = 0; xx < 256; xx += 4) {
              uint32_t c = _fb[yy*256 + xx];
              unsigned r = (c>>16)&0xFF, g = (c>>8)&0xFF, b = c&0xFF;
              unsigned mx = r>g ? (r>b?r:b) : (g>b?g:b);
              int idx = (mx<32)?0:(mx<64)?1:(mx<96)?2:(mx<160)?3:(mx<200)?4:(mx<240)?5:6;
              line[xx/4] = shp[idx+1];
            }
            line[64]='\0';
            fprintf(stderr, "%s\n", line);
          }
        }
    }

    if (render_audio) {
        PSG *ap = (PSG *)m->sound;
        printf("\n[PSG-summary] frames_with_audio(peak>64)=%d/%d  "
               "writes=%u\n", g_audio_loud_frames, stop, g_psg_writes);
        printf("[PSG-summary] max volume A/B/C = %d/%d/%d "
               "(15 = full)\n", g_audio_vol_max[0], g_audio_vol_max[1],
               g_audio_vol_max[2]);
        printf("[PSG-summary] final mixer R7=%02X  volumes R8/R9/R10=%02X/%02X/%02X\n",
               ap->reg[7], ap->reg[8], ap->reg[9], ap->reg[10]);
        printf("[PSG-summary] R7 value histogram (frames each value held):\n");
        for (int v = 0; v < 256; v++)
            if (g_audio_r7[v]) printf("   R7=%02X: %u\n", v, g_audio_r7[v]);
        /* Per-register write counts from the shadow of the last values is not
         * enough, so report the registers the ROM actually touched via the
         * global write counter and the PSG state instead. */
        printf("[PSG-summary] tone periods A/B/C = %04X/%04X/%04X  "
               "noise R6=%02X  env R11/R12/R13=%02X/%02X/%02X\n",
               ap->tone_period[0], ap->tone_period[1], ap->tone_period[2],
               ap->reg[6], ap->reg[11], ap->reg[12], ap->reg[13]);
    }

    msx_destroy(m);
    return 0;
}
