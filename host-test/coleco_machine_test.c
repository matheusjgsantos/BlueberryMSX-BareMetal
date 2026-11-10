#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "msx.h"
#include "../../src/chips/sound/sn76489.h"
#include "tms9918.h"

static void io_write(MSX_Machine *m, unsigned p, unsigned char v)
{ m->bus.write_io(m->bus.ref, (UInt16)p, v); }
static unsigned char io_read(MSX_Machine *m, unsigned p)
{ return m->bus.read_io(m->bus.ref, (UInt16)p); }

int main(void)
{
    TMS9918 *test_vdp = tms9918_create();
    uint32_t *frame = calloc(256u * 192u, sizeof *frame);
    assert(test_vdp && frame);
    test_vdp->reg[1] = 0x40;
    test_vdp->reg[3] = 0xFF;
    test_vdp->reg[4] = 0;
    test_vdp->reg[7] = 1;
    test_vdp->vram[0] = 1;
    test_vdp->vram[8] = 0x80;
    test_vdp->vram[0x3FC0] = 0xF1;
    tms9918_render(test_vdp, frame, 256 * 4);
    assert(frame[0] != frame[1]); /* byte pitch is accepted and pixels render */
    free(frame);
    tms9918_destroy(test_vdp);

    MSX_Machine *m = msx_create_profile(MSX_MACHINE_COLECOVISION);
    assert(m && m->machineType == MSX_MACHINE_COLECOVISION);
    m->coleco_memory[0] = 0xC3;
    assert(m->bus.read_mem(m->bus.ref, 0) == 0xC3);
    assert(m->bus.read_mem(m->bus.ref, 0x2000) == 0xFF);
    m->bus.write_mem(m->bus.ref, 0x6001, 0x5A);
    assert(m->bus.read_mem(m->bus.ref, 0x6401) == 0x5A);
    m->coleco_memory[0x10000] = 0x42;
    assert(m->bus.read_mem(m->bus.ref, 0x8000) == 0x42);
    m->coleco_joystick = 1 | 0x10;
    io_write(m, 0xC0, 0);
    assert((io_read(m, 0xE0) & 0x4F) == 0x0E);
    io_write(m, 0x80, 0);
    msx_coleco_set_keypad(m, MSX_COLECO_KEY_7, 1);
    assert((io_read(m, 0xE0) & 0x0F) == MSX_COLECO_KEY_7);
    io_write(m, 0xBF, 0x00);
    io_write(m, 0xBF, 0x40);
    io_write(m, 0xBE, 0xA5);
    assert(((TMS9918*)m->vdp)->vram[0] == 0xA5);
    io_write(m, 0xE0, 0x90); /* SN76489 tone-0 latch */
    io_write(m, 0xE0, 0x01);
    Int16 samples[32];
    assert(msx_psg_render(m, samples, 32, 59659) == 32);
    msx_destroy(m);

    /* The legacy entry point must remain the MSX1/TMS9918 machine. */
    m = msx_create();
    assert(m && m->machineType == MSX_MACHINE_MSX1);
    assert(m->vdp != NULL && m->sound != NULL);
    msx_destroy(m);
    puts("PASS: ColecoVision profile and MSX1 fallback");
    return 0;
}
