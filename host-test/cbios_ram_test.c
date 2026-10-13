/*
 * cbios_ram_test.c -- temporary probe: run C-BIOS (no cartridge) and report
 * the main-RAM size the machine presents to software, plus what the memory
 * mapper ports (0xFC-0xFF) respond.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "msx.h"

extern const uint8_t cbios_main_rom[];
extern const uint32_t cbios_main_rom_size;
extern const uint8_t cbios_logo_rom[];
extern const uint32_t cbios_logo_rom_size;

int main(int argc, char **argv)
{
	int frames = (argc > 1) ? atoi(argv[1]) : 600;
	MSX_Machine *m = msx_create();
	if (!m) { printf("msx_create failed\n"); return 2; }

	msx_set_slot(m, 3, 0, 0, 0);
	memset(m->slots[3].subslots[0].data, 0, SLOT_MAX_SIZE);
	msx_load_data(m, 0, 0, 0x0000, (uint8_t *) cbios_main_rom, (int) cbios_main_rom_size);
	msx_load_data(m, 0, 0, 0x8000, (uint8_t *) cbios_logo_rom, (int) cbios_logo_rom_size);
	m->bus.write_io(m->bus.ref, 0xA8, 0xC0);

	for (int f = 0; f < frames; f++) msx_step_frame(m, 12000);

	printf("slotReg=%02X active=[%d %d %d %d]\n", m->slotReg,
	       m->activeSlot[0], m->activeSlot[1], m->activeSlot[2], m->activeSlot[3]);
	printf("work area 0xFC40..0xFC5F:\n");
	for (int a = 0xFC40; a <= 0xFC5F; a += 16) {
		printf("  %04X:", a);
		for (int i = 0; i < 16; i++) printf(" %02X", m->bus.read_mem(m->bus.ref, a + i));
		printf("\n");
	}

	/* Standard MSX RAM-search shape: map each slot to page 1 and test whether
	 * the byte at 0x4000 is writable RAM; then map it to pages 0/2/3 and test
	 * for mirroring (=> size). */
	printf("per-slot RAM probe (map to page1, write 0xA5/0x5A and read back):\n");
	for (int slot = 0; slot < 4; slot++) {
		UInt8 reg = (UInt8)((slot << 2) | (slot << 4) | (slot << 6));
		m->bus.write_io(m->bus.ref, 0xA8, reg);
		m->bus.write_mem(m->bus.ref, 0x4000, 0xA5);
		UInt8 a = m->bus.read_mem(m->bus.ref, 0x4000);
		m->bus.write_mem(m->bus.ref, 0x4000, 0x5A);
		UInt8 b = m->bus.read_mem(m->bus.ref, 0x4000);
		printf("  slot %d: A5->%02X 5A->%02X  %s\n", slot, a, b,
		       (a == 0xA5 && b == 0x5A) ? "RAM" : "not RAM");
	}
	m->bus.write_io(m->bus.ref, 0xA8, 0xC0);

	/* Memory mapper ports: write a segment, read back. A real mapper returns
	 * value|~mask. No mapper => 0xFF typically. */
	printf("mapper ports 0xFC-0xFF (write seg, read back):\n");
	for (int p = 0xFC; p <= 0xFF; p++) {
		m->bus.write_io(m->bus.ref, (UInt16)p, (UInt8)(p & 3));
		printf("  port %02X -> %02X\n", p, m->bus.read_io(m->bus.ref, (UInt16)p));
	}

	msx_destroy(m);
	return 0;
}
