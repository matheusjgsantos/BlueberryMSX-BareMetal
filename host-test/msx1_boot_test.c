#include "msx.h"
#include "R800.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void load_rom(MSX_Machine *m, unsigned offset, const char *name)
{
    char path[128];
    snprintf(path, sizeof path, "release/v1.0/BIOS/%s", name);
    FILE *f = fopen(path, "rb");
    if (!f) { perror(path); exit(1); }
    unsigned char image[0x10000];
    size_t n = fread(image, 1, sizeof image, f);
    fclose(f);
    if (!n) { fprintf(stderr, "empty BIOS image: %s\n", path); exit(1); }
    msx_load_data(m, 0, 0, (UInt16)offset, image, (int)n);
}

int main(void)
{
    MSX_Machine *m = msx_create();
    if (!m || m->machineType != MSX_MACHINE_MSX1) return 1;
    unsigned char zero = 0;
    msx_set_slot(m, 3, 0, &zero, 0);
    memset(m->slots[3].subslots[0].data, 0, SLOT_MAX_SIZE);
    load_rom(m, 0, "cbios_main_msx1.rom");
    load_rom(m, 0x8000, "cbios_logo_msx1.rom");
    m->bus.write_io(m->bus.ref, 0xA8, 0xC0);
    for (unsigned frame = 0; frame < 600; ++frame)
        msx_step_frame(m, MSX_FRAME_TICKS);
    R800 *cpu = (R800 *)m->z80;
    printf("MSX1 C-BIOS boot: PC=%04X SP=%04X\n", cpu->regs.PC.W, cpu->regs.SP.W);
    int ok = cpu->regs.PC.W != 0 && m->machineType == MSX_MACHINE_MSX1;
    msx_destroy(m);
    if (!ok) return 1;
    puts("PASS: MSX1 C-BIOS profile runs for 600 frames");
    return 0;
}
