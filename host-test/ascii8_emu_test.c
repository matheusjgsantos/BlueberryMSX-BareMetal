/* ascii8_emu_test.c -- validate the *emulated* (non-bus) ASCII8 MegaROM mapper
 * added to src/core/msx.c: msx_load_rom_image() + slot_read_mem/slot_write_mem.
 *
 * It builds a 128KB image where 8KB bank b is filled with byte b, loads it into
 * primary slot 3 / subslot 0, selects that slot for all cartridge regions and
 * drives the bank registers through the bus read/write callbacks.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "msx.h"

static int g_fail = 0;
static int g_checks = 0;

static void check (const char *what, unsigned got, unsigned want)
{
	g_checks++;
	if (got != want)
	{
		g_fail++;
		printf ("  FAIL %-34s got %02X want %02X\n", what, got, want);
	}
}

#define IMG_BANKS 16
#define IMG_SIZE  (IMG_BANKS * 0x2000)

int main (void)
{
	MSX_Machine *m = msx_create ();
	if (!m)
	{
		printf ("msx_create failed\n");
		return 2;
	}

	uint8_t *img = malloc (IMG_SIZE);
	if (!img)
	{
		printf ("malloc failed\n");
		return 2;
	}
	for (int b = 0; b < IMG_BANKS; b++)
	{
		memset (img + b * 0x2000, b, 0x2000);
	}
	/* A within-bank sentinel so offset math is exercised too. */
	img[0x2000 * 5 + 0x123] = 0xAB;

	/* Primary slot 3, subslot 0. */
	msx_load_rom_image (m, 3, 0, img, IMG_SIZE, MSX_MAPPER_ASCII8);

	/* Select the cartridge subslot in every 16KB region. activeSlot packs
	 * (slot | (sslot << 2)). */
	for (int r = 0; r < 4; r++)
	{
		m->activeSlot[r] = (3 | (0 << 2));
	}

	UInt8 (*rd) (void *, UInt16) = m->bus.read_mem;
	void  (*wr) (void *, UInt16, UInt8) = m->bus.write_mem;
	void   *ref = m->bus.ref;

	/* Initial banks: 0x4000->0, 0x6000->1, 0x8000->2, 0xA000->3. */
	check ("initial win0 (0x4000) = bank0", rd (ref, 0x4000), 0x00);
	check ("initial win1 (0x6000) = bank1", rd (ref, 0x6000), 0x01);
	check ("initial win2 (0x8000) = bank2", rd (ref, 0x8000), 0x02);
	check ("initial win3 (0xA000) = bank3", rd (ref, 0xA000), 0x03);

	/* Bank register write at 0x6000-0x67FF selects the 0x4000 window. */
	wr (ref, 0x6000, 5);
	check ("win0 after 0x6000=5", rd (ref, 0x4000), 0x05);
	check ("win0 sentinel offset", rd (ref, 0x4123), 0xAB);

	/* 0x6800-0x6FFF selects the 0x6000 window. */
	wr (ref, 0x6800, 7);
	check ("win1 after 0x6800=7", rd (ref, 0x6000), 0x07);

	/* 0x7000-0x77FF selects the 0x8000 window. */
	wr (ref, 0x7000, 9);
	check ("win2 after 0x7000=9", rd (ref, 0x8000), 0x09);

	/* 0x7800-0x7FFF selects the 0xA000 window. */
	wr (ref, 0x7800, 15);
	check ("win3 after 0x7800=15", rd (ref, 0xA000), 0x0F);

	/* Bank numbers wrap via romMask (16 banks -> mask 0x0F). */
	wr (ref, 0x6000, 0x20);
	check ("win0 wraps 0x20 -> 0", rd (ref, 0x4000), 0x00);

	/* 0xBFFF top of window 3 still resolves inside the bank. */
	check ("win3 top byte", rd (ref, 0xBFFF), 0x0F);

	/* Region 3 at 0xC000.. is window 4 -> out of ROM -> 0xFF. */
	check ("0xC000 out of range = 0xFF", rd (ref, 0xC000), 0xFF);

	/* Writing outside the bank register ranges must not change banks. */
	wr (ref, 0x4000, 0xEE);
	check ("write 0x4000 does not switch", rd (ref, 0x4000), 0x00);

	msx_destroy (m);

	printf ("ascii8_emu_test: %d checks, %d failures\n", g_checks, g_fail);
	printf ("RESULT: %s\n", g_fail ? "FAIL" : "PASS");
	return g_fail ? 1 : 0;
}
