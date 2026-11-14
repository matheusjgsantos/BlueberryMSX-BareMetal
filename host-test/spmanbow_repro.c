/* Headless reproduction harness for the Space Manbow (Konami SCC, 720 KB)
 * MSX2 graphics corruption.  Boots the same C-BIOS the Pi image uses, loads
 * the cartridge into slot 1 subslot 0 through the emulated MegaROM mapper and
 * dumps VRAM/registers/PPM at chosen frames so a hardware ALT+F10 capture can
 * be compared byte-for-byte on the development host.
 *
 * Usage: spmanbow_repro <rom> <outdir> <frame> [<frame> ...]
 */
#include "msx.h"
#include "msx_cpu.h"
#include "v9938.h"
#include "R800.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BIOS_DIR "release/v1.0/BIOS/"

static void load_rom(MSX_Machine *machine, int slot, int subslot,
                     unsigned offset, const char *name)
{
    char path[160];
    snprintf(path, sizeof path, "%s%s", BIOS_DIR, name);
    FILE *file = fopen(path, "rb");
    if (!file) { perror(path); exit(1); }
    static uint8_t image[0x10000];
    size_t size = fread(image, 1, sizeof image, file);
    fclose(file);
    if (size == 0) { fprintf(stderr, "empty %s\n", path); exit(1); }
    msx_load_data(machine, slot, subslot, (UInt16)offset, image, (int)size);
}

static uint8_t *read_file(const char *path, unsigned *size)
{
    FILE *file = fopen(path, "rb");
    if (!file) { perror(path); exit(1); }
    if (fseek(file, 0, SEEK_END) != 0) { perror(path); exit(1); }
    long len = ftell(file);
    rewind(file);
    uint8_t *data = malloc((size_t)len);
    if (!data || fread(data, 1, (size_t)len, file) != (size_t)len) {
        fprintf(stderr, "read failed: %s\n", path);
        exit(1);
    }
    fclose(file);
    *size = (unsigned)len;
    return data;
}

static void write_vds(const char *dir, unsigned frame, const V9938 *vdp)
{
    char path[512];
    snprintf(path, sizeof path, "%s/F%08X.VDS", dir, frame);
    FILE *file = fopen(path, "wb");
    if (!file) { perror(path); exit(1); }
    fwrite("MSXVDPS1", 1, 8, file);
    uint32_t head[4] = { 1, 1, frame, 0x20000 };
    fwrite(head, 4, 4, file);
    fwrite(vdp->reg, 1, 64, file);
    fwrite(vdp->status, 1, 4, file);
    fwrite(vdp->palette, 1, 48, file);
    fwrite(vdp->vram, 1, 0x20000, file);
    fclose(file);
}

static void write_ppm(const char *dir, unsigned frame, const V9938 *vdp)
{
    static uint32_t image[256 * 192];
    V9938 *mutable = (V9938 *)vdp;
    v9938_render(mutable, image, 256 * 4);
    char path[512];
    snprintf(path, sizeof path, "%s/F%08X.PPM", dir, frame);
    FILE *file = fopen(path, "wb");
    if (!file) { perror(path); exit(1); }
    fprintf(file, "P6\n256 192\n255\n");
    for (int i = 0; i < 256 * 192; i++) {
        uint32_t p = image[i];
        uint8_t rgb[3] = { (uint8_t)(p >> 16), (uint8_t)(p >> 8), (uint8_t)p };
        fwrite(rgb, 1, 3, file);
    }
    fclose(file);
}

/* Replica of msx_step_frame() that also keeps the last PCs so a jump into the
 * C-BIOS hang loop can be traced back to its caller. */
static int step_frame_traced(MSX_Machine *machine, MSX_CPU *cpu,
                             uint16_t *ring, unsigned ringSize) {
    UInt32 start = msx_cpu_get_time(cpu);
    unsigned pos = 0;
    v9938_frame_start((V9938 *)machine->vdp);
    while ((UInt32)(msx_cpu_get_time(cpu) - start) < (UInt32)MSX_FRAME_TICKS) {
        uint16_t pc = msx_cpu_get_pc(cpu);
        unsigned elapsed = (unsigned)(msx_cpu_get_time(cpu) - start);
        msx_set_frame_position(elapsed, MSX_FRAME_TICKS);
        v9938_set_frame_time((V9938 *)machine->vdp, elapsed,
                             MSX_FRAME_TICKS);
        if (v9938_irq_pending((V9938 *)machine->vdp))
            msx_cpu_set_irq(cpu);
        if (pc == 0x1B19) {
            printf("trace: entered hang, last %u PCs:\n", ringSize);
            for (unsigned i = 0; i < ringSize; i++)
                printf(" %04X", ring[(pos + i) % ringSize]);
            printf("\n");
            return 1;
        }
        ring[pos] = pc;
        pos = (pos + 1) % ringSize;
        msx_cpu_execute(cpu);
    }
    v9938_gen_sync_irq((V9938 *)machine->vdp);
    if (v9938_irq_pending((V9938 *)machine->vdp))
        msx_cpu_set_irq(cpu);
    return 0;
}

static void write_cmd(const char *dir, unsigned frame, const V9938 *vdp)
{
    char path[512];
    snprintf(path, sizeof path, "%s/F%08X.CMD", dir, frame);
    FILE *file = fopen(path, "wb");
    if (!file) { perror(path); return; }
    fprintf(file, "MSXVDPCMD1\ntotal_launches=%u\nretained=%u\n",
            vdp->commandSequence, vdp->commandHistoryCount);
    for (unsigned i = 0; i < 256; i++)
        if (vdp->commandCounts[i])
            fprintf(file, "count %02X %u\n", i, vdp->commandCounts[i]);
    unsigned oldest = (vdp->commandHistoryNext +
                       V9938_COMMAND_HISTORY_CAPACITY -
                       vdp->commandHistoryCount) %
                      V9938_COMMAND_HISTORY_CAPACITY;
    for (unsigned i = 0; i < vdp->commandHistoryCount; i++) {
        const V9938_CommandEvent *event = &vdp->commandHistory[
            (oldest + i) % V9938_COMMAND_HISTORY_CAPACITY];
        const uint8_t *r = event->registers;
        unsigned sx = r[0] | ((unsigned)(r[1] & 1) << 8);
        unsigned sy = r[2] | ((unsigned)(r[3] & 3) << 8);
        unsigned dx = r[4] | ((unsigned)(r[5] & 1) << 8);
        unsigned dy = r[6] | ((unsigned)(r[7] & 3) << 8);
        unsigned nx = r[8] | ((unsigned)(r[9] & 3) << 8);
        unsigned ny = r[10] | ((unsigned)(r[11] & 3) << 8);
        fprintf(file, "%u cmd=%02X arg=%02X sx=%03X sy=%03X dx=%03X dy=%03X "
                       "nx=%03X ny=%03X col=%02X\n",
                event->sequence, r[14], r[13], sx, sy, dx, dy, nx, ny, r[12]);
    }
    fprintf(file, "vram_reads=%u vram_writes=%u\n",
            vdp->vramReadCount, vdp->vramWriteCount);
    for (int i = 0; i < 8; i++)
        fprintf(file, "bank %d reads=%u writes=%u\n", i,
                vdp->vramReadsByBank[i], vdp->vramWritesByBank[i]);
    /* Most recent accesses, oldest first. */
    unsigned oldestAccess = (vdp->vramAccessHistoryNext +
                             V9938_VRAM_ACCESS_HISTORY_CAPACITY -
                             vdp->vramAccessHistoryCount) %
                            V9938_VRAM_ACCESS_HISTORY_CAPACITY;
    for (unsigned i = 0; i < vdp->vramAccessHistoryCount; i++) {
        const V9938_VramAccessEvent *e = &vdp->vramAccessHistory[
            (oldestAccess + i) % V9938_VRAM_ACCESS_HISTORY_CAPACITY];
        fprintf(file, "vram %u %c %05X %02X\n", e->sequence,
                e->write ? 'W' : 'R', e->address, e->data);
    }
    fclose(file);
}

int main(int argc, char **argv)
{
    if (argc < 4) {
        fprintf(stderr, "usage: %s <rom> <outdir> <frame> [frame...]\n", argv[0]);
        return 2;
    }
    const char *romPath = argv[1];
    const char *outDir = argv[2];

    unsigned romSize = 0;
    uint8_t *rom = read_file(romPath, &romSize);

    setvbuf(stdout, NULL, _IONBF, 0);
    MSX_Machine *machine = msx_create_profile(MSX_MACHINE_MSX2);
    if (!machine) return 1;

    uint8_t zero = 0;
    msx_set_slot(machine, 3, 2, &zero, 0);
    memset(machine->slots[3].subslots[2].data, 0, SLOT_MAX_SIZE);
    load_rom(machine, 0, 0, 0x0000, "cbios_main_msx2.rom");
    load_rom(machine, 0, 0, 0x8000, "cbios_logo_msx2.rom");
    load_rom(machine, 3, 0, 0x0000, "cbios_sub.rom");
    machine->bus.write_io(machine->bus.ref, 0xA8, 0xC0);

    MSX_MapperType mapper = msx_guess_mapper(rom, romSize);
    printf("ROM %s: %u bytes, guessed mapper %d\n", romPath, romSize, (int)mapper);
    msx_load_rom_image(machine, 1, 0, rom, romSize, mapper);

    V9938 *vdp = (V9938 *)machine->vdp;
    R800 *cpu = (R800 *)machine->z80;

    /* Probe the cartridge slot exactly the way the BIOS scan will. */
    {
        uint8_t (*rd)(void *, UInt16) = machine->bus.read_mem;
        void *ref = machine->bus.ref;
        machine->bus.write_io(ref, 0xA8, 0xC4);  /* page 1 -> slot 1 */
        printf("probe 4000: %02X %02X init=%04X  slotReg=%02X\n",
               rd(ref, 0x4000), rd(ref, 0x4001),
               rd(ref, 0x4002) | (rd(ref, 0x4003) << 8), machine->slotReg);
        machine->bus.write_io(ref, 0xA8, 0xD0);  /* page 2 -> slot 1 */
        printf("probe 8000: %02X %02X  slotReg=%02X\n",
               rd(ref, 0x8000), rd(ref, 0x8001), machine->slotReg);
        machine->bus.write_io(ref, 0xA8, 0xC0);
    }

    /* Remaining arguments are either a dump frame number or one of:
     *   survey:<every>          print a state line every <every> frames
     *   until:<frame>           stop after <frame> emulated frames
     *   press:<frame>:<ec>      tap MSX_EC_<ec> for 6 frames there
     * <ec> is the numeric MSX_EC_* code (see enum in include/msx.h). */
    unsigned limit = 3000;
    unsigned survey = 0;
    unsigned pressFrame = 0xFFFFFFFFu;
    int pressEc = -1;
    unsigned frames[64];
    unsigned nFrames = 0;
    for (int i = 3; i < argc; i++) {
        const char *a = argv[i];
        if (!strncmp(a, "survey:", 7)) survey = (unsigned)strtoul(a + 7, NULL, 0);
        else if (!strncmp(a, "until:", 6)) limit = (unsigned)strtoul(a + 6, NULL, 0);
        else if (!strncmp(a, "press:", 6)) {
            char *end = NULL;
            pressFrame = (unsigned)strtoul(a + 6, &end, 0);
            pressEc = end ? (int)strtol(end + 1, NULL, 0) : -1;
        } else if (nFrames < sizeof frames / sizeof frames[0])
            frames[nFrames++] = (unsigned)strtoul(a, NULL, 0);
    }

    static uint16_t ring[128];
    unsigned ringSize = 128;
    unsigned nextFrame = 0;
    for (unsigned frame = 0; frame <= limit; frame++) {
        if (step_frame_traced(machine, machine->cpu, ring, ringSize)) {
            printf("HANG (traced) at frame %u PC=%04X SP=%04X A=%02X BC=%04X DE=%04X HL=%04X\n",
                   frame, cpu->regs.PC.W, cpu->regs.SP.W, cpu->regs.AF.B.h,
                   cpu->regs.BC.W, cpu->regs.DE.W, cpu->regs.HL.W);
            printf("  IX=%04X IY=%04X I=%02X IM=%u iff1=%u\n",
                   cpu->regs.IX.W, cpu->regs.IY.W, cpu->regs.I,
                   (unsigned)cpu->regs.im, (unsigned)cpu->regs.iff1);
            return 3;
        }
        if (pressEc >= 0 && frame >= pressFrame && frame < pressFrame + 6)
            msx_ppi_set_ec(machine, pressEc, 1);
        else if (pressEc >= 0 && frame == pressFrame + 6)
            msx_ppi_set_ec(machine, pressEc, 0);

        int dump = nextFrame < nFrames && frame == frames[nextFrame];
        int show = survey && frame % survey == 0;
        if (dump || show) {
            if (show) {
                const MSX_SubSlot *cs = &machine->slots[1].subslots[0];
                /* Report the latched raster split: the first raster line whose
                 * display state differs from the top of the frame, so the
                 * mid-frame register writes can be located in time. */
                int split = -1;
                for (unsigned l = 1; l < V9938_FRAME_LINES; l++) {
                    const V9938_LineState *a = &vdp->lineState[0];
                    const V9938_LineState *b = &vdp->lineState[l];
                    if (b->r23 != a->r23 || b->r2 != a->r2) { split = (int)l; break; }
                }
                printf("frame %4u PC=%04X R0=%02X R1=%02X R2=%02X R3=%02X "
                       "R9=%02X R14=%02X R19=%02X R20=%02X R23=%02X "
                       "S1=%02X irq=%u line=%u/%u iff=%u wr=%u rd=%u cmds=%u "
                       "bank=%u,%u,%u,%u split=%d r23@0=%02X r23@end=%02X\n",
                       frame, cpu->regs.PC.W, vdp->reg[0], vdp->reg[1],
                       vdp->reg[2], vdp->reg[3], vdp->reg[9], vdp->reg[14],
                       vdp->reg[19], vdp->reg[20], vdp->reg[23],
                       vdp->status[1], vdp->irq, vdp->currentLine,
                       vdp->frameLineOffset, cpu->regs.iff1,
                       vdp->vramWriteCount, vdp->vramReadCount,
                       vdp->commandSequence, cs->bank[0], cs->bank[1],
                       cs->bank[2], cs->bank[3], split,
                       vdp->lineState[0].r23,
                       vdp->lineState[V9938_FRAME_LINES - 1].r23);
            }
            if (dump) {
                printf("dump  %4u PC=%04X R0=%02X R1=%02X R2=%02X R23=%02X "
                       "wr=%u rd=%u cmds=%u\n",
                       frame, cpu->regs.PC.W, vdp->reg[0], vdp->reg[1],
                       vdp->reg[2], vdp->reg[23], vdp->vramWriteCount,
                       vdp->vramReadCount, vdp->commandSequence);
                write_vds(outDir, frame, vdp);
                write_ppm(outDir, frame, vdp);
                write_cmd(outDir, frame, vdp);
                for (int c = 0; c < 256; c++)
                    if (vdp->commandCounts[c])
                        printf("  count %02X %u\n", c, vdp->commandCounts[c]);
                nextFrame++;
            }
        }
    }

    msx_destroy(machine);
    return 0;
}
