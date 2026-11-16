/* Device-level checks derived from blueMSX SpriteLine.h / openMSX's
 * SpriteChecker and SpriteConverter, not from any game's rendering choices. */
#include "v9938.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>

static uint32_t image[256 * V9938_MAX_DISPLAY_LINES + 1];

static void reg(V9938 *v, unsigned n, uint8_t value)
{
    v9938_write_port(v, 0x99, value);
    v9938_write_port(v, 0x99, (uint8_t)(0x80 | n));
}

static unsigned map(unsigned a, int planar)
{
    return planar ? ((a >> 1) | ((a & 1) << 16)) & 0x1FFFF : a;
}

static void store(V9938 *v, unsigned a, unsigned value, int planar)
{
    v->vram[map(a, planar)] = (uint8_t)value;
}

static V9938 *setup(int planar)
{
    V9938 *v = v9938_create();
    assert(v);
    reg(v, 0, planar ? 0x0A : 0x06); /* SCREEN 7 / 5 */
    reg(v, 1, 0x40);
    reg(v, 5, 15); /* SAT 0x600; colour window 0x400; all index bits enabled */
    reg(v, 6, 1);
    for (unsigned c = 0; c < 16; c++) {
        v->palette[c][0] = c & 7;
        v->palette[c][1] = (c >> 3) * 7;
        v->palette[c][2] = 0;
    }
    store(v, 0x600, 216, planar);
    return v;
}

static uint32_t rgb(unsigned c)
{
    return ((c & 7) * 255 / 7 << 16) | ((c >> 3) * 255 << 8);
}

static void sprite(V9938 *v, unsigned n, unsigned y, unsigned x,
                   unsigned attr, uint8_t bits, int planar)
{
    store(v, 0x600 + n * 4, y, planar);
    store(v, 0x601 + n * 4, x, planar);
    store(v, 0x602 + n * 4, n, planar);
    store(v, 0x604 + n * 4, 216, planar);
    for (unsigned row = 0; row < 16; row++)
        store(v, 0x400 + n * 16 + row, attr, planar);
    for (unsigned row = 0; row < 8; row++)
        store(v, 0x800 + n * 8 + row, bits, planar);
}

static void draw(V9938 *v)
{
    memset(image, 0xA5, sizeof image);
    unsigned height = v9938_render(v, image, 256 * 4);
    assert(height == ((v->reg[9] & 0x80) ? 212u : 192u));
    assert(image[256 * V9938_MAX_DISPLAY_LINES] == 0xA5A5A5A5u);
}

static void test_height_and_alignment(void)
{
    for (int planar = 0; planar <= 1; planar++) {
        V9938 *v = setup(planar);
        reg(v, 9, 0x80);
        sprite(v, 0, 199, 32, 2, 0x80, planar);
        /* Final active row, and a sprite below the old 192-row boundary. */
        v->vram[211 * 128] = 0x44;
        draw(v);
        assert(image[200 * 256 + 32] == rgb(2));
        assert(image[190 * 256 + 32] != rgb(2)); /* no stale +10 sprite crop */
        assert(image[211 * 256] == rgb(4));
        reg(v, 9, 0);
        draw(v);
        assert(image[192 * 256] == 0xA5A5A5A5u);
        v9938_destroy(v);
    }
    puts("PASS: native 192/212 rows, final active row, sprite/bitmap origin and planar tables");
}

static void test_priority_and_cc(void)
{
    V9938 *v = setup(0);
    sprite(v, 0, 0, 32, 0, 0x80, 0);
    sprite(v, 1, 0, 32, 2, 0x80, 0);
    draw(v);
    assert(image[256 + 32] == rgb(2)); /* transparent high priority */

    sprite(v, 0, 0, 32, 0x41, 0xC0, 0); /* leading CC invisible */
    sprite(v, 1, 0, 33, 2, 0x80, 0);
    draw(v);
    assert(image[256 + 32] != rgb(1));
    assert(image[256 + 33] == rgb(2));

    sprite(v, 0, 0, 32, 4, 0xC0, 0);     /* outer layer */
    sprite(v, 1, 0, 32, 0x42, 0x80, 0);  /* inner/numeral layer */
    sprite(v, 2, 0, 32, 0x41, 0x40, 0);  /* consecutive CC layer */
    draw(v);
    assert(image[256 + 32] == rgb(6));
    assert(image[256 + 33] == rgb(5));
    assert(!(v->status[0] & 0x20)); /* CC never causes collision */

    /* Non-CC separates groups: a later CC must not OR into sprite 0. */
    sprite(v, 1, 0, 32, 2, 0x80, 0);
    draw(v);
    assert(image[256 + 32] == rgb(4));
    assert(image[256 + 33] == rgb(4));
    v9938_destroy(v);
    puts("PASS: transparent priority, leading CC suppression and consecutive CC colour groups");
}

static void test_collision_and_limits(void)
{
    V9938 *v = setup(0);
    sprite(v, 0, 0, 32, 1, 0x80, 0);
    sprite(v, 1, 0, 32, 0x22, 0x80, 0); /* IC excludes both participants */
    draw(v);
    assert(!(v->status[0] & 0x20));
    sprite(v, 1, 0, 32, 2, 0x80, 0);
    draw(v);
    assert(v->status[0] & 0x20);
    assert(v->status[3] == 44 && v->status[5] == 9);
    reg(v, 15, 0);
    assert(v9938_read_port(v, 0x99) & 0x20);
    assert(!(v->status[0] & 0x60));
    for (unsigned n = 0; n < 9; n++)
        sprite(v, n, 0, n * 16, n < 8 ? 0x41 : 2, 0x80, 0);
    draw(v);
    assert((v->status[0] & 0x5F) == 0x48); /* leading CC counts toward limit */
    assert(image[256 + 128] != rgb(2));
    v9938_destroy(v);
    puts("PASS: IC/CC collision exclusion, first collision coordinates, S#0 clear and ninth sprite");
}

static void test_table_window_and_size(void)
{
    V9938 *v = setup(0);
    reg(v, 5, 8); /* SAT 0x400, colour table in SAME 1 KiB window */
    v->vram[0x400] = 2; /* Y=2 doubles as row-0 colour at this unusual mask */
    v->vram[0x401] = 32;
    v->vram[0x402] = 0;
    v->vram[0x404] = 216;
    v->vram[0x800] = 0x80;
    v->vram[0x200] = 3; /* trap for the old unconditional SAT-512 decode */
    draw(v);
    assert(image[3 * 256 + 32] == rgb(2));
    v9938_destroy(v);

    v = setup(0);
    reg(v, 1, 0x43); /* 16x16 magnified */
    sprite(v, 0, 0, 32, 0x82, 0, 0); /* early clock X=0 */
    v->vram[0x800] = 0x80; /* top-left */
    v->vram[0x810] = 0x80; /* top-right, not swapped */
    v->vram[0x808] = 0x80; /* bottom-left */
    draw(v);
    assert(image[256] == rgb(2) && image[256 + 1] == rgb(2));
    assert(image[256 + 16] == rgb(2) && image[256 + 17] == rgb(2));
    assert(image[17 * 256] == rgb(2));
    v9938_destroy(v);
    puts("PASS: masked table window, early clock, 16x16 quadrants and magnification");
}

static void test_cpu_vram_and_latches(void)
{
    V9938 *v = setup(1);
    reg(v, 14, 0);
    v9938_write_port(v, 0x99, 0);
    v9938_write_port(v, 0x99, 0x40);
    v9938_write_port(v, 0x98, 0xAB);
    v9938_write_port(v, 0x98, 0xCD);
    v9938_write_port(v, 0x98, 0xEF);
    assert(v->vram[0] == 0xAB && v->vram[0x10000] == 0xCD);
    assert(v->vram[1] == 0xEF);
    v9938_write_port(v, 0x99, 0);
    v9938_write_port(v, 0x99, 0);
    assert(v9938_read_port(v, 0x98) == 0xAB);
    assert(v9938_read_port(v, 0x98) == 0xCD);
    assert(v9938_read_port(v, 0x98) == 0xEF);

    /* A status read / data write cancels the first control byte. */
    v9938_write_port(v, 0x99, 0x77);
    (void)v9938_read_port(v, 0x99);
    reg(v, 7, 3);
    assert(v->reg[7] == 3 && !v->controlPending);
    v9938_write_port(v, 0x99, 0x77);
    v9938_write_port(v, 0x98, 0);
    reg(v, 7, 4);
    assert(v->reg[7] == 4 && !v->controlPending);

    /* R#16 restarts palette byte pairing. */
    v9938_write_port(v, 0x9A, 0x11);
    reg(v, 16, 2);
    v9938_write_port(v, 0x9A, 0x73);
    v9938_write_port(v, 0x9A, 0x05);
    assert(v->palette[2][0] == 7 && v->palette[2][1] == 5 && v->palette[2][2] == 3);

    reg(v, 14, 2);
    v9938_write_port(v, 0x99, 0xFF);
    v9938_write_port(v, 0x99, 0x7F);
    v9938_write_port(v, 0x98, 1);
    assert(v->reg[14] == 3); /* extended-mode 16 KiB pointer wrap */
    reg(v, 0, 0); /* legacy mode wraps pointer within its R#14 bank */
    reg(v, 14, 2);
    v9938_write_port(v, 0x99, 0xFF);
    v9938_write_port(v, 0x99, 0x7F);
    v9938_write_port(v, 0x98, 1);
    assert(v->reg[14] == 2);
    v9938_destroy(v);
    puts("PASS: CPU planar uploads/readback, pointer wrap and control/palette latch cancellation");
}

int main(void)
{
    test_height_and_alignment();
    test_priority_and_cc();
    test_collision_and_limits();
    test_table_window_and_size();
    test_cpu_vram_and_latches();
    puts("All V9938 display/sprite conformance checks passed");
    return 0;
}
