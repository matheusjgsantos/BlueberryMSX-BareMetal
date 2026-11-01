#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "msx_mapper.h"

/* Each 8 KB bank is filled with its own bank number, so a window read proves
 * exactly which bank the mapper selected. */
#define BANKS 8
#define ROM_SIZE (BANKS * 0x2000)

static void make_image(uint8_t *img) {
    for (unsigned b = 0; b < BANKS; b++) memset(img + b * 0x2000, (int)b, 0x2000);
}

static void init_slot(MSX_SubSlot *ss, MSX_MapperType type, uint8_t *img,
                      unsigned size) {
    memset(ss, 0, sizeof *ss);
    ss->busSlot = -1;
    ss->mapperType = type;
    ss->pRomImage = img;
    ss->romSize = size;
    ss->romMask = (size / 0x2000) - 1;
    ss->bank[0] = 0;
    ss->bank[1] = 1;
    ss->bank[2] = 2;
    ss->bank[3] = 3;
}

static unsigned window_of(MSX_SubSlot *ss, UInt16 addr) {
    return msx_mapper_read(ss, addr);
}

static void test_is_mapped(void) {
    assert(msx_mapper_is_mapped(MSX_MAPPER_ASCII8));
    assert(msx_mapper_is_mapped(MSX_MAPPER_ASCII16));
    assert(msx_mapper_is_mapped(MSX_MAPPER_KONAMI));
    assert(msx_mapper_is_mapped(MSX_MAPPER_KONAMI_SCC));
    assert(!msx_mapper_is_mapped(MSX_MAPPER_NONE));
    assert(!msx_mapper_is_mapped(MSX_MAPPER_NOMAPPER));
    assert(!msx_mapper_is_mapped(MSX_MAPPER_AUTO));
}

static void test_ascii8(void) {
    uint8_t *img = calloc(1, ROM_SIZE);
    MSX_SubSlot ss;
    assert(img);
    make_image(img);
    init_slot(&ss, MSX_MAPPER_ASCII8, img, ROM_SIZE);

    /* Power-on windows: 0,1,2,3. */
    assert(window_of(&ss, 0x4000) == 0);
    assert(window_of(&ss, 0x6000) == 1);
    assert(window_of(&ss, 0x8000) == 2);
    assert(window_of(&ss, 0xA000) == 3);

    /* Register writes: 0x6000/w0, 0x6800/w1, 0x7000/w2, 0x7800/w3. */
    msx_mapper_write(&ss, 0x6000, 5);
    msx_mapper_write(&ss, 0x6800, 6);
    msx_mapper_write(&ss, 0x7000, 7);
    msx_mapper_write(&ss, 0x7800, 4);
    assert(window_of(&ss, 0x4000) == 5);
    assert(window_of(&ss, 0x6000) == 6);
    assert(window_of(&ss, 0x8000) == 7);
    assert(window_of(&ss, 0xA000) == 4);
    assert(ss.bank[0] == 5 && ss.bank[1] == 6 && ss.bank[2] == 7 && ss.bank[3] == 4);

    /* Bank numbers are masked to the image size (8 banks -> mask 7). */
    msx_mapper_write(&ss, 0x6000, 0x0A);
    assert(ss.bank[0] == 2);
    assert(window_of(&ss, 0x4000) == 2);

    /* Writes outside the ASCII8 registers do not select banks. */
    msx_mapper_write(&ss, 0x8000, 1);
    msx_mapper_write(&ss, 0xA000, 1);
    assert(ss.bank[0] == 2 && ss.bank[1] == 6 && ss.bank[2] == 7 && ss.bank[3] == 4);

    /* Addresses above the four windows read as idle bus, not as ROM. */
    assert(window_of(&ss, 0xC000) == 0xFF);
    assert(window_of(&ss, 0xFFFF) == 0xFF);

    /* A window whose computed offset is past the image reads 0xFF. */
    ss.romSize = 0x8000;  /* 4 banks */
    ss.romMask = 3;
    ss.bank[0] = 1;
    assert(window_of(&ss, 0x4000) == 1);
    ss.bank[0] = 5;       /* masked to bank 1 */
    assert(window_of(&ss, 0x4000) == 1);

    /* data[] fallback when no heap image is attached (small dumps). */
    free(img);
    memset(&ss, 0, sizeof ss);
    ss.busSlot = -1;
    ss.mapperType = MSX_MAPPER_ASCII8;
    ss.romSize = 0x4000;
    ss.romMask = 1;
    ss.bank[0] = 0;
    ss.bank[1] = 1;
    memset(ss.data + 0x0000, 0xAA, 0x2000);
    memset(ss.data + 0x2000, 0xBB, 0x2000);
    assert(window_of(&ss, 0x4000) == 0xAA);
    assert(window_of(&ss, 0x6000) == 0xBB);
}

static void test_konami(void) {
    uint8_t *img = calloc(1, ROM_SIZE);
    MSX_SubSlot ss;
    assert(img);
    make_image(img);
    init_slot(&ss, MSX_MAPPER_KONAMI, img, ROM_SIZE);

    /* 0x4000 is fixed at bank 0 and ignores bank-register writes. */
    msx_mapper_write(&ss, 0x4000, 7);
    assert(ss.bank[0] == 0);
    assert(window_of(&ss, 0x4000) == 0);

    msx_mapper_write(&ss, 0x6000, 5);
    msx_mapper_write(&ss, 0x8000, 6);
    msx_mapper_write(&ss, 0xA000, 7);
    assert(window_of(&ss, 0x6000) == 5);
    assert(window_of(&ss, 0x8000) == 6);
    assert(window_of(&ss, 0xA000) == 7);

    /* Writes below 0x6000 and above 0xBFFF are not registers. */
    msx_mapper_write(&ss, 0x5FFF, 3);
    msx_mapper_write(&ss, 0xC000, 3);
    assert(window_of(&ss, 0x6000) == 5 && window_of(&ss, 0x8000) == 6);

    free(img);
}

static void test_konami_scc(void) {
    uint8_t *img = calloc(1, ROM_SIZE);
    MSX_SubSlot ss;
    assert(img);
    make_image(img);
    init_slot(&ss, MSX_MAPPER_KONAMI_SCC, img, ROM_SIZE);

    /* Unlike plain Konami, 0x4000 IS switchable: 0x5000 selects window 0. */
    msx_mapper_write(&ss, 0x5000, 5);
    assert(window_of(&ss, 0x4000) == 5);

    msx_mapper_write(&ss, 0x7000, 6);
    msx_mapper_write(&ss, 0x9000, 7);
    msx_mapper_write(&ss, 0xB000, 4);
    assert(window_of(&ss, 0x6000) == 6);
    assert(window_of(&ss, 0x8000) == 7);
    assert(window_of(&ss, 0xA000) == 4);

    /* The SCC register window (0x9800-0x9FFF) must not select banks. */
    unsigned char w2 = ss.bank[2];
    msx_mapper_write(&ss, 0x9800, 1);
    msx_mapper_write(&ss, 0x9FFF, 2);
    assert(ss.bank[2] == w2);

    /* Off-register addresses in the same range are ignored too. */
    msx_mapper_write(&ss, 0x5800, 3);
    assert(window_of(&ss, 0x4000) == 5);

    free(img);
}

static void test_guess(void) {
    uint8_t *img = calloc(1, 0x10000);
    assert(img);

    /* Too small to be a MegaROM: no mapper even with a stray LD (nn),A. */
    img[0] = 0x32; img[1] = 0x00; img[2] = 0x50;
    assert(msx_mapper_guess(img, 0x8000) == MSX_MAPPER_NONE);

    /* Plain 64 KB image with no bank idiom: ASCII8 fallback. */
    memset(img, 0, 0x10000);
    assert(msx_mapper_guess(img, 0x10000) == MSX_MAPPER_ASCII8);

    /* Konami-SCC idiom only (0x5000/0x9000/0xB000). */
    memset(img, 0, 0x10000);
    img[0x100] = 0x32; img[0x101] = 0x00; img[0x102] = 0x50;
    assert(msx_mapper_guess(img, 0x10000) == MSX_MAPPER_KONAMI_SCC);

    /* Konami idiom only (0x8000/0xA000). */
    memset(img, 0, 0x10000);
    img[0x100] = 0x32; img[0x101] = 0x00; img[0x102] = 0x80;
    assert(msx_mapper_guess(img, 0x10000) == MSX_MAPPER_KONAMI);

    /* Null image. */
    assert(msx_mapper_guess(NULL, 0x10000) == MSX_MAPPER_NONE);

    free(img);
}

int main(void) {
    test_is_mapped();
    test_ascii8();
    test_konami();
    test_konami_scc();
    test_guess();
    puts("PASS: mapper policy (ASCII8/16, Konami, Konami-SCC, guess)");
    return 0;
}
