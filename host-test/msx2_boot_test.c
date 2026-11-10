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
    char path[128];
    snprintf(path, sizeof path, "%s%s", BIOS_DIR, name);
    FILE *file = fopen(path, "rb");
    if (!file) {
        perror(path);
        exit(1);
    }
    uint8_t image[0x10000];
    size_t size = fread(image, 1, sizeof image, file);
    int readError = ferror(file);
    fclose(file);
    if (size == 0 || readError) {
        fprintf(stderr, "failed to read %s\n", path);
        exit(1);
    }
    msx_load_data(machine, slot, subslot, (UInt16)offset, image, (int)size);
}

int main(void)
{
    MSX_Machine *machine = msx_create_profile(MSX_MACHINE_MSX2);
    if (!machine) return 1;

    uint8_t zero = 0;
    msx_set_slot(machine, 3, 2, &zero, 0);
    memset(machine->slots[3].subslots[2].data, 0, SLOT_MAX_SIZE);
    load_rom(machine, 0, 0, 0x0000, "cbios_main_msx2.rom");
    load_rom(machine, 0, 0, 0x8000, "cbios_logo_msx2.rom");
    load_rom(machine, 3, 0, 0x0000, "cbios_sub.rom");
    machine->bus.write_io(machine->bus.ref, 0xA8, 0xC0);

    for (unsigned frame = 0; frame < 600; frame++)
        msx_step_frame(machine, MSX_FRAME_TICKS);

    R800 *cpu = (R800 *)machine->z80;
    V9938 *vdp = (V9938 *)machine->vdp;
    printf("MSX2 C-BIOS boot: PC=%04X SP=%04X VDP R0=%02X R1=%02X R14=%02X\n",
           cpu->regs.PC.W, cpu->regs.SP.W,
           vdp->reg[0], vdp->reg[1], vdp->reg[14]);
    if (cpu->regs.PC.W == 0 || machine->machineType != MSX_MACHINE_MSX2) {
        fprintf(stderr, "MSX2 boot did not make progress\n");
        msx_destroy(machine);
        return 1;
    }

    msx_destroy(machine);
    puts("PASS: MSX2 C-BIOS profile runs for 600 frames");
    return 0;
}
