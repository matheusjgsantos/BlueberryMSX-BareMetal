#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "msx.h"

static void test_owned_profile(void)
{
    MSX_Machine *m = msx_create();
    assert(m != NULL);
    assert(m->slots == m->memory.slots);
    assert(m->activeSlot == m->memory.activeSlot);
    assert(m->memory.slotReg == 0);

    /* Existing source-level access remains valid, but storage belongs to the
     * embedded MSX_Memory profile. */
    m->slots[2].subslots[1].data[0x1234] = 0xA5;
    assert(m->memory.slots[2].subslots[1].data[0x1234] == 0xA5);
    m->activeSlot[3] = 2;
    assert(m->memory.activeSlot[3] == 2);

    /* Slot selection updates both the profile and the legacy scalar mirror. */
    m->bus.write_io(m, 0xA8, 0xE4);
    assert(m->memory.slotReg == 0xE4 && m->slotReg == 0xE4);
    assert(m->memory.activeSlot[0] == 0 && m->memory.activeSlot[1] == 1 &&
           m->memory.activeSlot[2] == 2 && m->memory.activeSlot[3] == 3);
    assert(m->bus.read_io(m, 0xA8) == 0xE4);

    msx_destroy(m);
}

static void test_profile_initializer(void)
{
    MSX_Memory memory;
    memset(&memory, 0xCC, sizeof memory);
    msx_memory_init(&memory);
    assert(memory.slotReg == 0);
    for (int r = 0; r < 4; r++) assert(memory.activeSlot[r] == 0);
    for (int s = 0; s < NUM_SLOTS; s++)
        for (int ss = 0; ss < NUM_SUBSLOTS; ss++)
            assert(memory.slots[s].subslots[ss].busSlot == -1);
}

int main(void)
{
    test_owned_profile();
    test_profile_initializer();
    puts("PASS: MSX memory profile owns slots and preserves compatibility aliases");
    return 0;
}
