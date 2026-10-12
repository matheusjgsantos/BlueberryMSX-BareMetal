/*
 * megarom_bus_test.c
 *
 * Guards the MegaROM path: a real cartridge on the RPMC bus is bank-switched
 * by its own CPLD, so the emulator must simply forward memory accesses in the
 * cartridge windows (0x4000..0xBFFF) and, critically, forward the *writes* to
 * the bank registers too -- otherwise a mapper never switches.
 *
 * Two mappers are modelled, matching the cartridges on the bus:
 *   ASCII8 : reg 0x6000 -> window 0 (0x4000-0x5FFF)
 *            reg 0x6800 -> window 1 (0x6000-0x7FFF)
 *            reg 0x7000 -> window 2 (0x8000-0x9FFF)
 *            reg 0x7800 -> window 3 (0xA000-0xBFFF)
 *   Konami : reg 0x6000 -> window 0
 *            reg 0x8000 -> window 1
 *            reg 0xA000 -> window 2
 *            reg 0xC000 -> window 3
 *
 * The fake ROM is filled so byte value == bank number: a read tells us exactly
 * which 8KB bank is visible, without a per-bank signature table.
 *
 * It also runs the whole thing behind a byte-cache layer that replicates the
 * production policy in msxbus.c (cache a connector, flush that connector's
 * whole 64KB on ANY write) -- a write-triggered mapper must still switch banks
 * correctly under that policy.
 */

#include <stdio.h>
#include <string.h>
#include <stdint.h>

#include "msx.h"
#include "msx_types.h"

#define BANK_SZ   0x2000
#define N_BANKS   32            /* 32 * 8KB = 256KB image */
#define CART_ADDR 0x4000        /* first cartridge window */

typedef struct {
	uint8_t rom[N_BANKS * BANK_SZ];
	int     bank[4];            /* 8KB bank -> window 0..3 */
	int     konami;             /* 0 = ASCII8, 1 = Konami */
} FakeCart;

/* Production cache policy, replicated for the test. 2 connectors max here. */
static uint8_t s_cache[2][0x10000];
static uint8_t s_valid[2][0x10000];
static int     s_cache_on = 0;

static int window_of(UInt16 addr)
{
	return (addr - CART_ADDR) / BANK_SZ;
}

static uint8_t fake_read(void *ref, int nSlot, UInt16 addr)
{
	FakeCart *c = (FakeCart *) ref;
	if (addr < CART_ADDR || addr >= 0xC000) return 0xFF;
	int w = window_of(addr);
	return c->rom[c->bank[w] * BANK_SZ + (addr & (BANK_SZ - 1))];
}

static void fake_write(void *ref, int nSlot, UInt16 addr, UInt8 val)
{
	FakeCart *c = (FakeCart *) ref;
	int w = -1;

	if (c->konami) {
		if ((addr & 0xE000) == 0x6000) w = 0;        /* 0x6000 */
		else if ((addr & 0xE000) == 0x8000) w = 1;   /* 0x8000 */
		else if ((addr & 0xE000) == 0xA000) w = 2;   /* 0xA000 */
		else if ((addr & 0xE000) == 0xC000) w = 3;   /* 0xC000 */
	} else {
		if ((addr & 0xF800) == 0x6000) w = 0;        /* 0x6000 */
		else if ((addr & 0xF800) == 0x6800) w = 1;   /* 0x6800 */
		else if ((addr & 0xF800) == 0x7000) w = 2;   /* 0x7000 */
		else if ((addr & 0xF800) == 0x7800) w = 3;   /* 0x7800 */
	}

	if (w >= 0) c->bank[w] = val % N_BANKS;
}

static uint8_t bus_read(void *ref, int nSlot, UInt16 addr)
{
	if (s_cache_on && s_valid[nSlot][addr]) return s_cache[nSlot][addr];
	UInt8 b = fake_read(ref, nSlot, addr);
	if (s_cache_on) { s_cache[nSlot][addr] = b; s_valid[nSlot][addr] = 1; }
	return b;
}

static void bus_write(void *ref, int nSlot, UInt16 addr, UInt8 val)
{
	fake_write(ref, nSlot, addr, val);
	if (s_cache_on) memset(s_valid[nSlot], 0, 0x10000);
}

static int s_fail = 0;

static void check(const char *what, int got, int want)
{
	int ok = (got == want);
	if (!ok) s_fail++;
	printf("  [%s] %s: got %d want %d\n", ok ? "PASS" : "FAIL", what, got, want);
}

/* Route page slots through the real port-0xA8 handler (updates activeSlot[]). */
static void map_pages(MSX_Machine *m, int page1_slot, int page2_slot, int page3_slot)
{
	UInt8 reg = (UInt8) (0 | (page1_slot << 2) | (page2_slot << 4) | (page3_slot << 6));
	m->bus.write_io(m->bus.ref, 0xA8, reg);
}

static void cart_init(FakeCart *c, int konami)
{
	for (unsigned i = 0; i < sizeof c->rom; i++) c->rom[i] = (uint8_t) (i / BANK_SZ);
	c->bank[0] = 0; c->bank[1] = 1; c->bank[2] = 2; c->bank[3] = 3;
	c->konami = konami;
	memset(s_cache, 0, sizeof s_cache);
	memset(s_valid, 0, sizeof s_valid);
}

int main(void)
{
	MSX_Machine *m = msx_create();
	if (!m) { printf("msx_create failed\n"); return 2; }

	/* System RAM is slot 3. The cartridge lives on bus connector 1, wired to
	 * emulated slot 2 (same mapping the app uses: connector1->slot1,
	 * connector3->slot2; here slot2 for clarity). */
	msx_set_slot(m, 3, 0, 0, 0);
	memset(m->slots[3].subslots[0].data, 0, SLOT_MAX_SIZE);
	msx_slot_set_bus(m, 2, 0, /*nBusSlot*/ 1);

	FakeCart cart;

	for (int pass = 0; pass < 2; pass++) {
		int konami = pass;
		s_cache_on = 0;
		cart_init(&cart, konami);
		m->bus_ref = &cart;
		m->bus_read = bus_read;
		m->bus_write = bus_write;

		/* ASCII8 keeps every register in page 1, so page 3 stays system
		 * RAM. Konami's 4th register sits at 0xC000, so that pass maps page
		 * 3 to the bus as well (a Konami cart really does span pages 1-3). */
		printf("%s mapper, pages 1/2 = bus slot, page 3 = %s:\n",
		       konami ? "Konami" : "ASCII8", konami ? "bus" : "RAM");
		map_pages(m, 2, 2, konami ? 2 : 3);

		/* Bank registers live in page 1 for ASCII8 (0x6000..0x7800) and in
		 * pages 1/2 for Konami (0x6000/0x8000/0xA000). */
		static const UInt16 reg[4] = { 0x6000, 0x6800, 0x7000, 0x7800 };
		static const UInt16 kreg[4] = { 0x6000, 0x8000, 0xA000, 0xC000 };
		static const UInt16 win[4] = { 0x4000, 0x6000, 0x8000, 0xA000 };
		int val[4] = { 5, 7, 9, 11 };

		for (int w = 0; w < 4; w++) {
			UInt16 a = konami ? kreg[w] : reg[w];
			m->bus.write_mem(m->bus.ref, a, (UInt8) val[w]);
			char b[48];
			snprintf(b, sizeof b, "bank reg %04X -> window %d", a, w);
			check(b, m->bus.read_mem(m->bus.ref, win[w]), val[w]);
		}

		/* Write-isolation: writing the ROM window must not alter what the
		 * cart returns, and must never touch its emulated buffer. */
		m->bus.write_mem(m->bus.ref, 0x4000, 0xAB);
		check("ROM window write ignored by cart",
		      m->bus.read_mem(m->bus.ref, 0x4000), 5);
		check("bus slot emulated buffer untouched",
		      m->slots[2].subslots[0].data[0x4000], 0xFF);

		/* RAM isolation: page 3 writes hit slot 3, not the cart. (Only
		 * meaningful when page 3 is not itself the bus.) */
		if (!konami) {
			m->bus.write_mem(m->bus.ref, 0xC000, 0x5A);
			check("slot3 page3 RAM writable",
			      m->bus.read_mem(m->bus.ref, 0xC000), 0x5A);
		}

		/* Now repeat with the production cache policy enabled: bank writes
		 * must still switch (cache flushed on write), and a re-read after a
		 * switch must see the new bank. */
		s_cache_on = 1;
		s_valid[1][0x4000] = 1; s_cache[1][0x4000] = 5;   /* pretend window 0 cached */
		m->bus.write_mem(m->bus.ref, 0x6000, 3);
		check("cached window invalidated by bank write",
		      m->bus.read_mem(m->bus.ref, 0x4000), 3);
		s_cache_on = 0;
	}

	msx_destroy(m);
	printf("\nRESULT: %s\n", s_fail ? "FAIL" : "PASS");
	return s_fail ? 1 : 0;
}
