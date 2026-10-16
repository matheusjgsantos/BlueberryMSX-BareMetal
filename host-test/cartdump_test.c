/* cartdump_test.c -- validate the shared banked-cartridge dump walk
 * (src/app/cartdump.h) used by CKernel::DumpCartridges.
 *
 * The old firmware dump read 0x4000+i linearly and never wrote a bank
 * register, so any MegaROM larger than 32 KiB came out wrapped: only the four
 * 8 KiB banks visible at power-on, repeated. This test models a MegaROM whose
 * bank register masks to its real size, runs the walk for each mapper, and
 * checks it reconstructs the exact image and auto-sizes correctly.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include "cartdump.h"

#define BANK_SZ 0x2000

typedef struct {
	uint8_t rom[64 * BANK_SZ];	/* byte value == bank index; up to 512 KiB */
	int     n_banks;
	int     bank[4];
	int     mapper;			/* 0=konamiscc 1=konami 2=ascii8 */
} FakeCart;

/* Production cache policy (msxbus.c): cache any read, flush the whole 64 KiB
 * connector on ANY write. Bank writes must still switch correctly. */
static uint8_t s_cache[0x10000];
static uint8_t s_valid[0x10000];
static int     s_cache_on = 0;

static FakeCart *g_cart;

static int win_of(uint16_t a) { return (a - 0x4000) / BANK_SZ; }

static uint8_t cart_read(void *ref, uint16_t addr)
{
	FakeCart *c = (FakeCart *) ref;
	if (addr < 0x4000 || addr >= 0xC000) return 0xFF;
	int w = win_of(addr);
	return c->rom[(c->bank[w] * BANK_SZ) + (addr & (BANK_SZ - 1))];
}

static void cart_write(void *ref, uint16_t addr, uint8_t val)
{
	FakeCart *c = (FakeCart *) ref;
	int w = -1;
	if (c->mapper == 0) {			/* Konami-SCC */
		if ((addr & 0x1800) == 0x1000 && addr < 0x9800) {
			w = (addr >> 13) - 2;	/* 0x5000->0,0x7000->1,0x9000->2,0xB000->3 */
		}
	} else if (c->mapper == 1) {		/* Konami: window 0 fixed */
		if ((addr & 0xE000) == 0x6000) w = 1;
		else if ((addr & 0xE000) == 0x8000) w = 2;
		else if ((addr & 0xE000) == 0xA000) w = 3;
	} else {				/* ASCII8 */
		if ((addr & 0xF800) == 0x6000) w = 0;
		else if ((addr & 0xF800) == 0x6800) w = 1;
		else if ((addr & 0xF800) == 0x7000) w = 2;
		else if ((addr & 0xF800) == 0x7800) w = 3;
	}
	if (w >= 0) c->bank[w] = val & (c->n_banks - 1);	/* register wrap */
}

static uint8_t bus_read(int nSlot, uint16_t addr)
{
	(void) nSlot;
	if (s_cache_on && s_valid[addr]) return s_cache[addr];
	uint8_t b = cart_read(g_cart, addr);
	if (s_cache_on) { s_cache[addr] = b; s_valid[addr] = 1; }
	return b;
}
static void bus_write(int nSlot, uint16_t addr, uint8_t val)
{
	(void) nSlot;
	cart_write(g_cart, addr, val);
	if (s_cache_on) memset(s_valid, 0, sizeof s_valid);
}

static int g_fail = 0, g_checks = 0;

static void check(const char *what, int got, int want)
{
	g_checks++;
	if (got != want) { g_fail++; printf("  FAIL %-46s got %d want %d\n", what, got, want); }
	else printf("  PASS %s\n", what);
}

static void cart_init(FakeCart *c, int mapper, int n_banks)
{
	memset(c, 0, sizeof *c);
	c->mapper = mapper;
	c->n_banks = n_banks;
	for (int b = 0; b < n_banks; b++)
		memset(c->rom + b * BANK_SZ, b & 0xFF, BANK_SZ);
	c->bank[0] = 0; c->bank[1] = 1; c->bank[2] = 2; c->bank[3] = 3;
	memset(s_valid, 0, sizeof s_valid);
}

int main(void)
{
	FakeCart cart;
	g_cart = &cart;
	uint8_t *buf = malloc(64 * BANK_SZ);

	struct { const char *name; int mapper; uint16_t reg, base; } m[] = {
		{ "konamiscc", 0, 0x5000, 0x4000 },
		{ "konami",    1, 0x8000, 0x8000 },
		{ "ascii8",    2, 0x6000, 0x4000 },
	};

	for (int pass = 0; pass < 2; pass++) {
		s_cache_on = pass;
		printf("cache %s:\n", pass ? "on" : "off");

		for (unsigned i = 0; i < sizeof m / sizeof m[0]; i++) {
			/* exact size: 16 banks = 128 KiB */
			cart_init(&cart, m[i].mapper, 16);
			memset(buf, 0xAA, 64 * BANK_SZ);
			unsigned n = CartDump_Banked(bus_read, bus_write, 0,
						     m[i].reg, m[i].base, buf, 0x20000);
			char b[64];
			snprintf(b, sizeof b, "%s dump size (cap 128K)", m[i].name);
			check(b, (int) n, 0x20000);
			snprintf(b, sizeof b, "%s dump matches ROM", m[i].name);
			check(b, memcmp(buf, cart.rom, 0x20000) == 0, 1);

			/* oversized cap: must auto-size to 128 KiB */
			cart_init(&cart, m[i].mapper, 16);
			n = CartDump_Banked(bus_read, bus_write, 0,
					    m[i].reg, m[i].base, buf, 0x80000);
			snprintf(b, sizeof b, "%s auto-size to 128K", m[i].name);
			check(b, (int) n, 0x20000);
			snprintf(b, sizeof b, "%s auto-size matches ROM", m[i].name);
			check(b, memcmp(buf, cart.rom, 0x20000) == 0, 1);

			/* 32-bank (256 KiB) cart: full reconstruction */
			cart_init(&cart, m[i].mapper, 32);
			n = CartDump_Banked(bus_read, bus_write, 0,
					    m[i].reg, m[i].base, buf, 0x40000);
			snprintf(b, sizeof b, "%s 256K dump matches ROM", m[i].name);
			check(b, (int) n == 0x40000 && memcmp(buf, cart.rom, 0x40000) == 0, 1);
		}
	}
	s_cache_on = 0;

	/* Document the old bug: a linear 0x4000+i read of a 128 KiB cart cannot
	 * reconstruct it (bank 0..3 repeated, not banks 4..15). */
	cart_init(&cart, 0, 16);
	for (unsigned i = 0; i < 0x20000; i++)
		buf[i] = cart_read(&cart, (uint16_t) (0x4000u + i));
	check("linear read does NOT match 128K ROM",
	      memcmp(buf, cart.rom, 0x20000) == 0, 0);

	free(buf);
	printf("\n%d checks, %d failed: %s\n", g_checks, g_fail, g_fail ? "FAIL" : "PASS");
	return g_fail ? 1 : 0;
}
