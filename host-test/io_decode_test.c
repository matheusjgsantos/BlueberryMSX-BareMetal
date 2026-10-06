#include <assert.h>
#include <stdio.h>
#include "msx.h"
#include "R800.h"
#include "tms9918.h"
#include "psg.h"

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

    /* AY-3-8910 PSG decode (openMSX MSXPSG: A0 latches, A1 writes, A2 reads).
     * The high-byte aliases matter here too: the Z80 drives A8-A15 as well. */
    PSG *psg = (PSG *)m->sound;
    assert(psg);
    unsigned before = g_psg_writes;
    m->bus.write_io(m, 0xA0, 0x01);          /* latch register 1 */
    assert(psg_get_reg_latch(psg) == 1);
    m->bus.write_io(m, 0xA1, 0x5A);          /* R1 = coarse tune A */
    assert(psg_read(psg, 1) == 0x0A);        /* masked with 0x0F on read */
    assert(psg->tone_period[0] == 0x0A00);   /* fine 0 + 256*(0x5A & 0x0F) */
    assert(g_psg_writes == before + 2);
    assert(g_psg_last_reg == 1 && g_psg_last_val == 0x5A);
    m->bus.write_io(m, 0x12A0, 0x01);        /* A0 with high bytes set */
    m->bus.write_io(m, 0x12A1, 0x00);        /* clear R1 */
    m->bus.write_io(m, 0x12A0, 0x00);
    m->bus.write_io(m, 0x12A1, 0x0C);        /* R0 = fine tune A */
    assert(psg->tone_period[0] == 0x000C);
    assert(m->bus.read_io(m, 0xA2) == 0x0C); /* A2 reads the latched register */
    assert(m->bus.read_io(m, 0xA0) == 0xFF); /* A0/A1 are write-only */
    assert(m->bus.read_io(m, 0xA1) == 0xFF);

    /* Mixing: with tone and noise both off in R7 the output must be the full
     * channel volume, which proves the registers reached the mixer. */
    m->bus.write_io(m, 0xA0, 0x07);
    m->bus.write_io(m, 0xA1, 0x3F);
    m->bus.write_io(m, 0xA0, 0x08);
    m->bus.write_io(m, 0xA1, 0x0F);
    Int16 samples[8];
    assert(msx_psg_render(m, samples, 8, 8 * 16) == 8);
    assert(samples[0] == 32767);
    assert(msx_psg_render(m, samples, 8, 8 * 16) == 8);
    assert(samples[7] == 32767);

    msx_destroy(m);
    puts("PASS: Z80 OTIR, VDP/PPI high-byte port aliases, PSG port decode");
    return 0;
}
