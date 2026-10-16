/* konami_emu_test.c -- validate the *emulated* (non-bus) Konami and
 * Konami-SCC MegaROM mappers added to src/core/msx.c, and the AUTO mapper
 * heuristic msx_guess_mapper().
 *
 * Konami:     page 0x4000 fixed; 0x6000/0x8000/0xA000 select windows 1/2/3.
 * Konami-SCC: 0x5000/0x7000/0x9000/0xB000 select windows 0/1/2/3; the
 *             0x9800-0x9FFF SCC register window is ignored (no SCC chip).
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
		printf ("  FAIL %-40s got %02X want %02X\n", what, got, want);
	}
}

#define IMG_BANKS 16
#define IMG_SIZE  (IMG_BANKS * 0x2000)

static uint8_t *make_image (void)
{
	uint8_t *img = malloc (IMG_SIZE);
	for (int b = 0; b < IMG_BANKS; b++)
	{
		memset (img + b * 0x2000, b, 0x2000);
	}
	return img;
}

static void test_konami (MSX_Machine *m)
{
	msx_load_rom_image (m, 3, 0, make_image (), IMG_SIZE, MSX_MAPPER_KONAMI);
	for (int r = 0; r < 4; r++) m->activeSlot[r] = (3 | (0 << 2));

	UInt8 (*rd) (void *, UInt16) = m->bus.read_mem;
	void  (*wr) (void *, UInt16, UInt8) = m->bus.write_mem;
	void   *ref = m->bus.ref;

	check ("KONAMI initial win0=bank0", rd (ref, 0x4000), 0x00);
	check ("KONAMI initial win1=bank1", rd (ref, 0x6000), 0x01);
	check ("KONAMI initial win2=bank2", rd (ref, 0x8000), 0x02);
	check ("KONAMI initial win3=bank3", rd (ref, 0xA000), 0x03);

	/* Page 0x4000 is fixed at segment 0. */
	wr (ref, 0x4000, 0x0C);
	check ("KONAMI 0x4000 write ignored", rd (ref, 0x4000), 0x00);
	/* 0x5000 is not a register here. */
	wr (ref, 0x5000, 0x0B);
	check ("KONAMI 0x5000 write ignored", rd (ref, 0x4000), 0x00);

	wr (ref, 0x6000, 5);
	check ("KONAMI win1 via 0x6000", rd (ref, 0x6000), 0x05);
	wr (ref, 0x8000, 7);
	check ("KONAMI win2 via 0x8000", rd (ref, 0x8000), 0x07);
	wr (ref, 0xA000, 9);
	check ("KONAMI win3 via 0xA000", rd (ref, 0xA000), 0x09);
	/* Any address inside the page is a valid register. */
	wr (ref, 0xBFFF, 0x0C);
	check ("KONAMI win3 via 0xBFFF", rd (ref, 0xA000), 0x0C);
	/* 0xC000 and up are not registers for the Konami mapper. */
	wr (ref, 0xC000, 0x0A);
	check ("KONAMI win3 unchanged by 0xC000", rd (ref, 0xA000), 0x0C);
	/* Bank numbers wrap through romMask (16 banks -> 0x0F). */
	wr (ref, 0x6000, 0x20);
	check ("KONAMI win1 wraps 0x20->0", rd (ref, 0x6000), 0x00);
}

static void test_konami_scc (MSX_Machine *m)
{
	msx_load_rom_image (m, 3, 0, make_image (), IMG_SIZE, MSX_MAPPER_KONAMI_SCC);
	for (int r = 0; r < 4; r++) m->activeSlot[r] = (3 | (0 << 2));

	UInt8 (*rd) (void *, UInt16) = m->bus.read_mem;
	void  (*wr) (void *, UInt16, UInt8) = m->bus.write_mem;
	void   *ref = m->bus.ref;

	check ("SCC initial win0=bank0", rd (ref, 0x4000), 0x00);
	check ("SCC initial win1=bank1", rd (ref, 0x6000), 0x01);
	check ("SCC initial win2=bank2", rd (ref, 0x8000), 0x02);
	check ("SCC initial win3=bank3", rd (ref, 0xA000), 0x03);

	wr (ref, 0x5000, 5);
	check ("SCC win0 via 0x5000", rd (ref, 0x4000), 0x05);
	/* Full 0x800-wide register range. */
	wr (ref, 0x57FF, 6);
	check ("SCC win0 via 0x57FF", rd (ref, 0x4000), 0x06);

	wr (ref, 0x7000, 7);
	check ("SCC win1 via 0x7000", rd (ref, 0x6000), 0x07);
	wr (ref, 0x9000, 9);
	check ("SCC win2 via 0x9000", rd (ref, 0x8000), 0x09);
	wr (ref, 0xB000, 0x0A);
	check ("SCC win3 via 0xB000", rd (ref, 0xA000), 0x0A);

	/* 0x9800-0x9FFF is the SCC register window: must NOT switch the bank. */
	wr (ref, 0x9800, 0xFF);
	check ("SCC 0x9800 does not switch", rd (ref, 0x8000), 0x09);

	/* 0x6000 is not a register in the SCC map. */
	wr (ref, 0x6000, 0x0D);
	check ("SCC 0x6000 ignored", rd (ref, 0x6000), 0x07);
}

static void test_guess (void)
{
	/* Put a bank-select idiom every 3 bytes. */
	uint8_t *img = malloc (IMG_SIZE);
	#define FILL(v0, v1) do { for (unsigned i = 0; i + 3 <= IMG_SIZE; i += 3) { \
		img[i] = 0x32; img[i+1] = (v0); img[i+2] = (v1); } } while (0)

	FILL (0x00, 0x50); /* LD (0x5000),A */
	check ("guess 0x5000 -> KONAMI-SCC",
	       msx_guess_mapper (img, IMG_SIZE), MSX_MAPPER_KONAMI_SCC);

	FILL (0x00, 0x40); /* LD (0x4000),A */
	check ("guess 0x4000 -> KONAMI",
	       msx_guess_mapper (img, IMG_SIZE), MSX_MAPPER_KONAMI);

	FILL (0x00, 0x68); /* LD (0x6800),A */
	check ("guess 0x6800 -> ASCII8",
	       msx_guess_mapper (img, IMG_SIZE), MSX_MAPPER_ASCII8);

	/* No recognizable idiom still yields ASCII8 for a large image. */
	memset (img, 0x00, IMG_SIZE);
	check ("guess unknown large -> ASCII8",
	       msx_guess_mapper (img, IMG_SIZE), MSX_MAPPER_ASCII8);

	/* Under 64KB -> plain. */
	check ("guess <64KB -> NONE",
	       msx_guess_mapper (img, 0x8000), MSX_MAPPER_NONE);

	free (img);
	#undef FILL
}

int main (void)
{
	MSX_Machine *m = msx_create ();
	if (!m) { printf ("msx_create failed\n"); return 2; }

	test_konami (m);
	test_konami_scc (m);
	test_guess ();

	msx_destroy (m);

	printf ("konami_emu_test: %d checks, %d failures\n", g_checks, g_fail);
	printf ("RESULT: %s\n", g_fail ? "FAIL" : "PASS");
	return g_fail ? 1 : 0;
}
