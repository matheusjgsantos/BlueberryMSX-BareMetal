// MSX1 owned slot-memory profile.

#include <msx_memory.h>

#include <string.h>

void msx_memory_init(MSX_Memory *memory)
{
    if (!memory) return;
    memset(memory, 0, sizeof *memory);
    for (int s = 0; s < NUM_SLOTS; s++)
        for (int ss = 0; ss < NUM_SUBSLOTS; ss++)
            memory->slots[s].subslots[ss].busSlot = -1;
}
