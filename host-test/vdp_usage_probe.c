/* vdp_usage_probe.c -- headless VDP command/usage histogram for a cartridge.
 *
 * Boots the MSX2 C-BIOS profile, loads a cart image into slot 1 subslot 0,
 * runs a number of frames and reports which V9938 commands and which
 * indirect-register targets the software actually uses. Diagnostic only.
 *
 * Usage: host-test/run_vdp_usage_probe.sh [cart.rom] [frames]
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include "msx.h"
#include "msx_cpu.h"
#include "v9938.h"
#include "R800.h"

#ifdef V9938_TRACE
extern unsigned v9938_trace_cmd[256];
extern unsigned v9938_trace_indirect[64];
extern unsigned v9938_trace_r44_stream;
extern unsigned v9938_trace_port9b;
extern unsigned v9938_trace_r44_total;
extern unsigned v9938_trace_complete;
extern unsigned v9938_trace_launches;
struct V9938TraceLaunch {
    uint8_t cmd, lo, arg;
    uint16_t dx, dy, sx, sy, nx, ny;
    unsigned r44;
};
extern struct V9938TraceLaunch v9938_trace_launch[32];
#endif

#define BIOS_DIR "release/v1.0/BIOS/"

static void load_rom(MSX_Machine *machine, int slot, int subslot,
                     unsigned offset, const char *name)
{
    char path[128];
    snprintf(path, sizeof path, "%s%s", BIOS_DIR, name);
    FILE *file = fopen(path, "rb");
    if (!file) { perror(path); exit(1); }
    static uint8_t image[0x10000];
    size_t size = fread(image, 1, sizeof image, file);
    fclose(file);
    if (!size) { fprintf(stderr, "empty %s\n", path); exit(1); }
    msx_load_data(machine, slot, subslot, (UInt16)offset, image, (int)size);
}

int main(int argc, char **argv)
{
    const char *cartPath = (argc > 1) ? argv[1] : "host-test/VKILLER.ROM";
    int frames = (argc > 2) ? atoi(argv[2]) : 600;

    FILE *f = fopen(cartPath, "rb");
    if (!f) { perror(cartPath); return 2; }
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);
    uint8_t *cart = (uint8_t *)malloc((size_t)size);
    if (!cart || fread(cart, 1, (size_t)size, f) != (size_t)size) {
        perror("read cart");
        return 2;
    }
    fclose(f);

    MSX_Machine *machine = msx_create_profile(MSX_MACHINE_MSX2);
    if (!machine) return 2;

    uint8_t zero = 0;
    msx_set_slot(machine, 3, 2, &zero, 0);
    memset(machine->slots[3].subslots[2].data, 0, SLOT_MAX_SIZE);
    load_rom(machine, 0, 0, 0x0000, "cbios_main_msx2.rom");
    load_rom(machine, 0, 0, 0x8000, "cbios_logo_msx2.rom");
    load_rom(machine, 3, 0, 0x0000, "cbios_sub.rom");
    machine->bus.write_io(machine->bus.ref, 0xA8, 0xC0);

    MSX_MapperType mapper = msx_guess_mapper(cart, (unsigned)size);
    printf("cart %s: %ld bytes, mapper %d\n", cartPath, size, (int)mapper);
    if (mapper == MSX_MAPPER_NONE) {
        unsigned nBlk = size < 0x4000 ? (unsigned)size : 0x4000;
        msx_load_data(machine, 1, 0, 0x4000, cart, (int)nBlk);
        if (size > 0x4000) {
            unsigned nBlk2 = (unsigned)(size - 0x4000);
            if (nBlk2 > 0x4000) nBlk2 = 0x4000;
            msx_load_data(machine, 1, 0, 0x8000, cart + 0x4000, (int)nBlk2);
        }
        free(cart);
    } else {
        msx_load_rom_image(machine, 1, 0, cart, (unsigned)size, mapper);
    }

    for (int frame = 0; frame < frames; frame++) {
        /* Hold the space bar (matrix row 8, bit 0) after boot so title
         * screens advance into the game/demo. */
        if (frame > 120) machine->bus.write_io(machine->bus.ref, 0xA9, 0x08);
        if (frame > 120) machine->bus.write_io(machine->bus.ref, 0xAA, 0xFE);
        msx_step_frame(machine, MSX_FRAME_TICKS);
    }

    V9938 *vdp = (V9938 *)machine->vdp;
    R800 *cpu = (R800 *)machine->z80;
    unsigned nz = 0;
    for (unsigned i = 0; i < sizeof vdp->vram; i++) nz += vdp->vram[i] != 0;
    printf("PC=%04X R0=%02X R1=%02X R2=%02X R8=%02X R9=%02X R23=%02X "
           "R14=%02X R17=%02X R44=%02X R46=%02X VRAMnz=%u\n",
           cpu->regs.PC.W, vdp->reg[0], vdp->reg[1], vdp->reg[2],
           vdp->reg[8], vdp->reg[9], vdp->reg[23], vdp->reg[14],
           vdp->reg[17], vdp->reg[44], vdp->reg[46], nz);
#ifdef V9938_TRACE
    printf("command histogram:");
    for (int i = 0; i < 256; i++)
        if (v9938_trace_cmd[i]) printf(" %02X=%u", i, v9938_trace_cmd[i]);
    printf("\nindirect register histogram:");
    for (int i = 0; i < 64; i++)
        if (v9938_trace_indirect[i]) printf(" R%d=%u", i, v9938_trace_indirect[i]);
    printf("\nport9B writes=%u, R44 writes=%u (while transfer active=%u), "
           "completed transfers=%u, launches=%u\n",
           v9938_trace_port9b, v9938_trace_r44_total,
           v9938_trace_r44_stream, v9938_trace_complete,
           v9938_trace_launches);
    printf("launches: cmd lo arg (dx,dy)->(sx,sy) nx*ny  R44#\n");
    unsigned shown = v9938_trace_launches < 32 ? v9938_trace_launches : 32;
    for (unsigned i = 0; i < shown; i++) {
        struct V9938TraceLaunch *l = &v9938_trace_launch[i];
        printf("  %02X+%X arg=%02X (%u,%u)->(%u,%u) %ux%u r44=%u\n",
               l->cmd, l->lo, l->arg, l->dx, l->dy, l->sx, l->sy,
               l->nx, l->ny, l->r44);
    }
#endif

    /* Dump the current frame so it can be compared with a hardware capture. */
    {
        FILE *vf = fopen("host-test/.probe.vram", "wb");
        if (vf) {
            fwrite(v9938_get_vram(vdp), 1, 0x20000, vf);
            fclose(vf);
        }
    }
    static uint32_t frameBuf[256 * 192];
    v9938_render(vdp, frameBuf, 256 * 4);
    FILE *ppm = fopen("host-test/.probe.ppm", "wb");
    if (ppm) {
        fprintf(ppm, "P6\n256 192\n255\n");
        for (int i = 0; i < 256 * 192; i++) {
            unsigned c = frameBuf[i];
            fputc((c >> 16) & 0xFF, ppm);
            fputc((c >> 8) & 0xFF, ppm);
            fputc(c & 0xFF, ppm);
        }
        fclose(ppm);
        printf("frame written to host-test/.probe.ppm\n");
    }

    msx_destroy(machine);
    return 0;
}
