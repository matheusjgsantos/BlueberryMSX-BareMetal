#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "msx.h"
#include "R800.h"

#define R800_INT_HIGH 2

/* Machine profile layer: MSX1 stays the default, the ColecoVision profile gets
 * a flat memory map, the VDP on 0xBE/0xBF, NMI frame interrupts and the
 * hand-controller protocol. */

static void test_profile_registry(void)
{
    const MSX_MachineProfile *p = msx_profile_get(MSX_PROFILE_MSX1);
    assert(p && strcmp(p->name, "MSX1") == 0);
    assert(p->interrupt_mode == MSX_PROFILE_IRQ);
    assert(p->memory == MSX_PROFILE_MEMORY_SLOTS);
    assert(p->input == MSX_PROFILE_INPUT_PPI);
    assert(p->video_data_port == 0x98 && p->video_ctrl_port == 0x99);

    p = msx_profile_get(MSX_PROFILE_COLECOVISION);
    assert(p && strcmp(p->name, "COLECOVISION") == 0);
    assert(p->interrupt_mode == MSX_PROFILE_NMI);
    assert(p->memory == MSX_PROFILE_MEMORY_FLAT);
    assert(p->input == MSX_PROFILE_INPUT_COLECO);
    assert(p->audio == MSX_PROFILE_AUDIO_SN76489);
    assert(p->video_data_port == 0xBE && p->video_ctrl_port == 0xBF);

    assert(msx_profile_get((MSX_ProfileId)99) == NULL);
    assert(msx_profile_by_name("msx1") == msx_profile_get(MSX_PROFILE_MSX1));
    assert(msx_profile_by_name("coleco") == msx_profile_get(MSX_PROFILE_COLECOVISION));
    assert(msx_profile_by_ini("colecovision") == msx_profile_get(MSX_PROFILE_COLECOVISION));
    assert(msx_profile_by_name("no-such-machine") == NULL);
    assert(strcmp(msx_profile_name(MSX_PROFILE_COLECOVISION), "COLECOVISION") == 0);
}

static void test_msx1_default(void)
{
    MSX_Machine *m = msx_create();
    assert(m != NULL);
    assert(msx_machine_profile(m) == msx_profile_get(MSX_PROFILE_MSX1));
    assert(m->memory.ops == msx_memory_ops_msx());
    assert(m->ppi != NULL);
    msx_destroy(m);

    m = msx_create_profile(MSX_PROFILE_MSX1);
    assert(m != NULL);
    assert(m->memory.ops == msx_memory_ops_msx());
    msx_destroy(m);
}

static void test_coleco_memory(void)
{
    MSX_Machine *m = msx_create_profile(MSX_PROFILE_COLECOVISION);
    UInt8 bios[0x2000];
    UInt8 cart[0x100];

    assert(m != NULL);
    assert(msx_machine_profile(m) == msx_profile_get(MSX_PROFILE_COLECOVISION));
    assert(m->memory.ops == msx_memory_ops_flat());
    assert(m->memory.ctx == &m->flat);
    assert(m->ppi == NULL);

    memset(bios, 0x3E, sizeof bios);
    msx_flat_load(&m->flat, 0x0000, bios, sizeof bios);
    assert(m->bus.read_mem(m, 0x0000) == 0x3E);
    assert(m->bus.read_mem(m, 0x1FFF) == 0x3E);

    /* BIOS write is ignored. */
    m->bus.write_mem(m, 0x0000, 0x00);
    assert(m->bus.read_mem(m, 0x0000) == 0x3E);

    /* Expansion space is open bus, not a BIOS mirror. */
    assert(m->bus.read_mem(m, 0x2000) == 0xFF);
    assert(m->bus.read_mem(m, 0x5FFF) == 0xFF);
    m->bus.write_mem(m, 0x2000, 0x00);
    assert(m->bus.read_mem(m, 0x2000) == 0xFF);

    /* 1 KB RAM, mirrored across 0x6000-0x7FFF. */
    m->bus.write_mem(m, 0x6000, 0x11);
    assert(m->bus.read_mem(m, 0x6000) == 0x11);
    assert(m->bus.read_mem(m, 0x6400) == 0x11);
    assert(m->bus.read_mem(m, 0x7C00) == 0x11);
    m->bus.write_mem(m, 0x7C00, 0x22);
    assert(m->bus.read_mem(m, 0x6000) == 0x22);

    /* Cartridge window at 0x8000-0xFFFF, read-only. */
    memset(cart, 0x5A, sizeof cart);
    msx_flat_load(&m->flat, 0x10000, cart, sizeof cart);
    assert(m->bus.read_mem(m, 0x8000) == 0x5A);
    assert(m->bus.read_mem(m, 0x80FF) == 0x5A);
    m->bus.write_mem(m, 0x8000, 0x00);
    assert(m->bus.read_mem(m, 0x8000) == 0x5A);

    /* The MSX MegaFlashROM markers must not fire in a flat profile. */
    assert(msx_slot_event_count() == 0);
    m->bus.write_mem(m, 0xE210, 1);
    assert(msx_slot_event_count() == 0);

    msx_destroy(m);
}

static void test_coleco_vdp_ports(void)
{
    MSX_Machine *m = msx_create_profile(MSX_PROFILE_COLECOVISION);
    assert(m != NULL);

    /* VDP control: set register 1 with INTEN (0x20), through 0xBF. */
    m->bus.write_io(m, 0xBF, 0x20);
    m->bus.write_io(m, 0xBF, 0x81);

    /* Status read through 0xBF. */
    (void) m->bus.read_io(m, 0xBF);

    /* VRAM write/read through 0xBE after setup. */
    m->bus.write_io(m, 0xBF, 0x00);       /* addr low  = 0 */
    m->bus.write_io(m, 0xBF, 0x40);       /* write mode, addr high = 0 */
    m->bus.write_io(m, 0xBE, 0xA7);
    m->bus.write_io(m, 0xBF, 0x00);       /* addr low  = 0 */
    m->bus.write_io(m, 0xBF, 0x00);       /* read setup */
    assert(m->bus.read_io(m, 0xBE) == 0xA7);

    /* VDP port aliases: 0xA0/0xA1 behave like 0xBE/0xBF. */
    m->bus.write_io(m, 0xA1, 0x01);
    m->bus.write_io(m, 0xA1, 0x40);
    m->bus.write_io(m, 0xA0, 0x5C);
    m->bus.write_io(m, 0xA1, 0x01);
    m->bus.write_io(m, 0xA1, 0x00);
    assert(m->bus.read_io(m, 0xA0) == 0x5C);

    msx_destroy(m);
}

static void test_coleco_nmi(void)
{
    MSX_Machine *m = msx_create_profile(MSX_PROFILE_COLECOVISION);
    R800 *cpu;

    assert(m != NULL);
    cpu = (R800 *) m->z80;
    memset(m->flat.storage, 0x00, 0x2000);  /* NOPs at the reset vector */

    /* Enable VDP interrupts (R1 bit 5). */
    m->bus.write_io(m, 0xBF, 0x20);
    m->bus.write_io(m, 0xBF, 0x81);
    assert(msx_video_irq_pending(&m->video) == 0);

    msx_step_frame(m, 64);
    assert(msx_video_irq_pending(&m->video) != 0);
    assert(cpu->nmiEdge == 1);

    /* The CPU accepts the edge and vectors to 0x0066. */
    msx_cpu_execute(m->cpu);
    assert(cpu->nmiEdge == 0);
    assert(cpu->regs.PC.W == 0x0066);

    /* Reading the VDP status clears the source and re-arms the NMI line. */
    (void) m->bus.read_io(m, 0xBF);
    assert(cpu->nmiState == R800_INT_HIGH);
    assert(msx_video_irq_pending(&m->video) == 0);

    /* The next frame produces a fresh edge. */
    msx_step_frame(m, 64);
    assert(cpu->nmiEdge == 1);
    assert(msx_video_irq_pending(&m->video) != 0);

    msx_destroy(m);
}

static void test_coleco_controllers(void)
{
    MSX_Machine *m = msx_create_profile(MSX_PROFILE_COLECOVISION);
    assert(m != NULL);

    /* Default is joystick mode, idle: 0x7F. */
    assert(m->bus.read_io(m, 0xFC) == 0x7F);
    assert(m->bus.read_io(m, 0xFF) == 0x7F);

    msx_input_coleco_set_joystick(&m->input, MSX_COLECO_PAD_1,
                                  1, 0, 0, 1, 1);
    assert(m->bus.read_io(m, 0xFC) == 0x36); /* up+left+fire low */
    assert(m->bus.read_io(m, 0xFF) == 0x7F); /* pad 2 untouched */

    /* Keypad mode selected by a write to 0x80-0x9F. */
    m->bus.write_io(m, 0x80, 0x00);
    msx_input_coleco_set_keypad(&m->input, MSX_COLECO_PAD_1,
                                MSX_COLECO_KEY_5);
    assert(m->bus.read_io(m, 0xFC) == 0x73);

    msx_input_coleco_set_fire2(&m->input, MSX_COLECO_PAD_1, 1);
    assert(m->bus.read_io(m, 0xFC) == 0x33);

    /* Back to joystick mode. */
    m->bus.write_io(m, 0xC0, 0x00);
    assert(m->bus.read_io(m, 0xFC) == 0x36);

    /* Generic EC fallback drives pad 1 only. */
    msx_input_set_key(&m->input, MSX_EC_RIGHT, 1);
    assert(m->bus.read_io(m, 0xFC) == 0x34);
    assert(m->bus.read_io(m, 0xFF) == 0x7F);

    msx_destroy(m);
}

int main(void)
{
    test_profile_registry();
    test_msx1_default();
    test_coleco_memory();
    test_coleco_vdp_ports();
    test_coleco_nmi();
    test_coleco_controllers();
    printf("PASS: machine profiles, ColecoVision map/ports/NMI/controllers\n");
    return 0;
}
