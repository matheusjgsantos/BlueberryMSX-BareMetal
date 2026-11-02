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

void msx_memory_set_ops(MSX_Memory *memory, const MSX_MemoryOps *ops, void *ctx)
{
    if (!memory) return;
    memory->ops = ops;
    memory->ctx = ctx;
}

UInt8 msx_memory_read(MSX_Memory *memory, UInt16 addr)
{
    if (!memory || !memory->ops || !memory->ops->read) return 0xFF;
    return memory->ops->read(memory, memory->ctx, addr);
}

void msx_memory_write(MSX_Memory *memory, UInt16 addr, UInt8 val)
{
    if (!memory || !memory->ops || !memory->ops->write) return;
    memory->ops->write(memory, memory->ctx, addr, val);
}
