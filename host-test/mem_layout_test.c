/*
 * mem_layout_test.c
 *
 * Guards the MSX1 memory layout the emulator presents to a real cartridge:
 *   slot 0 = BIOS/logo ROM (read-only),
 *   slot 1 = cartridge ROM (read-only),
 *   slot 3 = 64KB system RAM (fully writable).
 *
 * The bug this locks out: msx_load_data() used to mark only the *loaded* ROM
 * range read-only, leaving the rest of a ROM subslot writable. A memory scan
 * then counted that as RAM, so MSX Diag reported 112KB instead of 64KB and
 * MegaFlashROM's 64KB check failed.
 */

#include <stdio.h>
#include <string.h>
#include <stdint.h>

#include "msx.h"

extern const uint8_t cbios_main_rom[];
extern const uint32_t cbios_main_rom_size;
extern const uint8_t cbios_logo_rom[];
extern const uint32_t cbios_logo_rom_size;
extern const uint8_t knightmare_rom[];
extern const uint32_t knightmare_rom_size;

static int s_fail = 0;

static void check(const char *what, int got, int want)
{
	int ok = (got == want);
	if (!ok) s_fail++;
	printf("  [%s] %s: got %d want %d\n", ok ? "PASS" : "FAIL", what, got, want);
}

/* Write 0xA8 to route the given 16KB region to a primary slot, preserving the
 * other regions (exactly what a program/BIOS does to page slots in/out). */
static void map_page(MSX_Machine *m, int region, int slot)
{
	UInt8 reg = m->slotReg;
	reg &= (UInt8) ~(0x03 << (2 * region));
	reg |= (UInt8) ((slot & 3) << (2 * region));
	m->bus.write_io(m->bus.ref, 0xA8, reg);
}

/* Write a marker through the bus and read it back. Returns 1 if the byte
 * stuck (writable memory), 0 if it read back something else (ROM / absent). */
static int writable(MSX_Machine *m, UInt16 addr)
{
	m->bus.write_mem(m->bus.ref, addr, 0x5A);
	return m->bus.read_mem(m->bus.ref, addr) == 0x5A;
}

int main(void)
{
	MSX_Machine *m = msx_create();
	if (!m) { printf("msx_create failed\n"); return 2; }

	/* Same setup as CKernel::msx_load_cbios + msx_load_cart. */
	msx_set_slot(m, 3, 0, 0, 0);
	memset(m->slots[3].subslots[0].data, 0, SLOT_MAX_SIZE);
	msx_load_data(m, 0, 0, 0x0000, (uint8_t *) cbios_main_rom, (int) cbios_main_rom_size);
	msx_load_data(m, 0, 0, 0x8000, (uint8_t *) cbios_logo_rom, (int) cbios_logo_rom_size);
	msx_load_data(m, 1, 0, 0x4000, (uint8_t *) knightmare_rom, 16384);
	msx_load_data(m, 1, 0, 0x8000, (uint8_t *) knightmare_rom + 16384, 16384);
	m->bus.write_io(m->bus.ref, 0xA8, 0xC0);

	printf("Boot map 0xC0 (pages 0-2 = slot0 ROM, page 3 = slot3 RAM):\n");
	check("0x0000 slot0 ROM read-only", writable(m, 0x0000), 0);
	check("0x4000 slot0 ROM read-only", writable(m, 0x4000), 0);
	check("0x8000 slot0 logo ROM read-only", writable(m, 0x8000), 0);
	check("0xC000 slot3 RAM writable", writable(m, 0xC000), 1);

	printf("Slot 0 (BIOS) on every page must be read-only:\n");
	for (int r = 0; r < 4; r++) {
		map_page(m, r, 0);
		UInt16 a = (UInt16) (r * REGION_SIZE);
		char b[48]; snprintf(b, sizeof b, "slot0 page %d read-only", r);
		check(b, writable(m, a), 0);
	}

	printf("Slot 1 (cartridge) on every page must be read-only:\n");
	for (int r = 0; r < 4; r++) {
		map_page(m, r, 1);
		UInt16 a = (UInt16) (r * REGION_SIZE);
		char b[48]; snprintf(b, sizeof b, "slot1 page %d read-only", r);
		check(b, writable(m, a), 0);
	}

	printf("Slot 3 must be 64KB of RAM (all four pages writable):\n");
	for (int r = 0; r < 4; r++) {
		map_page(m, r, 3);
		UInt16 a = (UInt16) (r * REGION_SIZE);
		char b[48]; snprintf(b, sizeof b, "slot3 page %d writable", r);
		check(b, writable(m, a), 1);
	}

	printf("Slot 2 (not installed) must be absent:\n");
	for (int r = 0; r < 4; r++) {
		map_page(m, r, 2);
		UInt16 a = (UInt16) (r * REGION_SIZE);
		char b[48]; snprintf(b, sizeof b, "slot2 page %d absent", r);
		check(b, writable(m, a), 0);
	}

	msx_destroy(m);
	printf("\nRESULT: %s\n", s_fail ? "FAIL" : "PASS");
	return s_fail ? 1 : 0;
}
