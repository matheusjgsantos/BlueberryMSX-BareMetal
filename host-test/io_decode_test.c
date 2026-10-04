#include <assert.h>
#include <stdio.h>
#include "msx.h"
#include "R800.h"
#include "tms9918.h"

int main(void)
{
    MSX_Machine *m = msx_create();
    assert(m);
    TMS9918 *v = (TMS9918 *)m->vdp;
    R800 *cpu = (R800 *)m->z80;
    m->slots[0].subslots[0].size = SLOT_MAX_SIZE;
    m->bus.write_io(m, 0x99, 0x00);
    m->bus.write_io(m, 0x99, 0x60); /* write address 0x2000 */
    m->slots[0].subslots[0].data[0] = 0xED;
    m->slots[0].subslots[0].data[1] = 0xB3; /* OTIR */
    for (unsigned i = 0; i < 4; i++)
        m->slots[0].subslots[0].data[0x100 + i] = 0x81 + i;
    cpu->regs.PC.W = 0;
    cpu->regs.HL.W = 0x100;
    cpu->regs.BC.W = 0x0498;
    cpu->regs.iff1 = 0;
    for (unsigned i = 0; i < 4; i++) r800ExecuteInstruction(cpu);
    assert(cpu->regs.BC.B.h == 0 && cpu->regs.PC.W == 2);
    for (unsigned i = 0; i < 4; i++) assert(v->vram[0x2000 + i] == 0x81 + i);
    m->bus.write_io(m, 0xE499, 0xE4);
    m->bus.write_io(m, 0x8799, 0x87);
    assert(v->reg[7] == 0xE4);
    m->bus.write_io(m, 0x12A8, 0xC0);
    assert(m->bus.read_io(m, 0x34A8) == 0xC0);
    v->irq = 1;
    assert(m->bus.read_io(m, 0xFF99) == 0x80 && v->irq == 0);
    msx_destroy(m);
    puts("PASS: Z80 OTIR and VDP/PPI high-byte port aliases");
    return 0;
}
