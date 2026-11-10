#include "msx.h"
#include "v9938.h"

#include <stdio.h>
#include <stdlib.h>

#define CHECK(condition) do { \
    if (!(condition)) { \
        fprintf(stderr, "FAIL %s:%d: %s\n", __FILE__, __LINE__, #condition); \
        exit(1); \
    } \
} while (0)

int main(void)
{
    MSX_Machine *msx1 = msx_create();
    CHECK(msx1 != NULL);
    CHECK(msx1->machineType == MSX_MACHINE_MSX1);
    msx_destroy(msx1);

    MSX_Machine *msx2 = msx_create_profile(MSX_MACHINE_MSX2);
    CHECK(msx2 != NULL);
    CHECK(msx2->machineType == MSX_MACHINE_MSX2);
    CHECK(msx2->expandedSlotMask == (1u << 3));

    /* Port A selects primary slot 3; FFFF is its secondary-slot register. */
    msx2->bus.write_io(msx2->bus.ref, 0xA8, 0xFF);
    CHECK(msx2->bus.read_mem(msx2->bus.ref, 0xFFFF) == 0xFF);
    msx2->bus.write_mem(msx2->bus.ref, 0xFFFF, 0xAA);
    CHECK(msx2->bus.read_mem(msx2->bus.ref, 0xFFFF) == 0x55);

    /* Select expanded subslot 2 on every 16 KiB page and verify it is RAM. */
    uint8_t scratch = 0;
    msx_set_slot(msx2, 3, 2, &scratch, 0);
    msx2->bus.write_mem(msx2->bus.ref, 0xFFFF, 0xAA);
    msx2->bus.write_mem(msx2->bus.ref, 0x1234, 0x5A);
    CHECK(msx2->slots[3].subslots[2].data[0x1234] == 0x5A);
    CHECK(msx2->bus.read_mem(msx2->bus.ref, 0x1234) == 0x5A);

    /* MSX2 machine I/O reaches the V9938 control-port register protocol. */
    msx2->bus.write_io(msx2->bus.ref, 0x99, 0x06);
    msx2->bus.write_io(msx2->bus.ref, 0x99, 0x80);
    CHECK(v9938_peek_register((V9938 *)msx2->vdp, 0) == 0x06);

    msx_destroy(msx2);
    puts("PASS: MSX1 default, MSX2 V9938 selection, expanded slots, and I/O");
    return 0;
}
