/* Device-level checks derived from blueMSX SpriteLine.h / openMSX's
 * SpriteChecker and SpriteConverter, not from any game's rendering choices. */
#include "v9938.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>

static uint32_t image[V9938_MAX_DISPLAY_WIDTH * V9938_MAX_DISPLAY_LINES + 1];

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
    unsigned height = v9938_render(v, image,
                                   V9938_MAX_DISPLAY_WIDTH * 4);
    assert(v9938_display_width(v) ==
           ((((v->reg[0] & 0x0E) == 0x08) || ((v->reg[0] & 0x0E) == 0x0A) ||
             ((v->reg[1] & 0x10) && (v->reg[0] & 0x04)))
            ? 512u : 256u));
    assert(height == ((v->reg[9] & 0x80) ? 212u : 192u));
    assert(image[V9938_MAX_DISPLAY_WIDTH * V9938_MAX_DISPLAY_LINES] ==
           0xA5A5A5A5u);
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
        assert(image[200 * V9938_MAX_DISPLAY_WIDTH + 32] == rgb(2));
        assert(image[190 * V9938_MAX_DISPLAY_WIDTH + 32] != rgb(2)); /* no stale +10 sprite crop */
        assert(image[211 * V9938_MAX_DISPLAY_WIDTH] == rgb(4));
        reg(v, 9, 0);
        draw(v);
        assert(image[192 * V9938_MAX_DISPLAY_WIDTH] == 0xA5A5A5A5u);
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
    assert(image[V9938_MAX_DISPLAY_WIDTH + 32] == rgb(2)); /* transparent high priority */

    sprite(v, 0, 0, 32, 0x41, 0xC0, 0); /* leading CC invisible */
    sprite(v, 1, 0, 33, 2, 0x80, 0);
    draw(v);
    assert(image[V9938_MAX_DISPLAY_WIDTH + 32] != rgb(1));
    assert(image[V9938_MAX_DISPLAY_WIDTH + 33] == rgb(2));

    sprite(v, 0, 0, 32, 4, 0xC0, 0);     /* outer layer */
    sprite(v, 1, 0, 32, 0x42, 0x80, 0);  /* inner/numeral layer */
    sprite(v, 2, 0, 32, 0x41, 0x40, 0);  /* consecutive CC layer */
    draw(v);
    assert(image[V9938_MAX_DISPLAY_WIDTH + 32] == rgb(6));
    assert(image[V9938_MAX_DISPLAY_WIDTH + 33] == rgb(5));
    assert(!(v->status[0] & 0x20)); /* CC never causes collision */

    /* Non-CC separates groups: a later CC must not OR into sprite 0. */
    sprite(v, 1, 0, 32, 2, 0x80, 0);
    draw(v);
    assert(image[V9938_MAX_DISPLAY_WIDTH + 32] == rgb(4));
    assert(image[V9938_MAX_DISPLAY_WIDTH + 33] == rgb(4));
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
    assert(image[V9938_MAX_DISPLAY_WIDTH + 128] != rgb(2));
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
    assert(image[3 * V9938_MAX_DISPLAY_WIDTH + 32] == rgb(2));
    v9938_destroy(v);

    v = setup(0);
    reg(v, 1, 0x43); /* 16x16 magnified */
    sprite(v, 0, 0, 32, 0x82, 0, 0); /* early clock X=0 */
    v->vram[0x800] = 0x80; /* top-left */
    v->vram[0x810] = 0x80; /* top-right, not swapped */
    v->vram[0x808] = 0x80; /* bottom-left */
    draw(v);
    assert(image[V9938_MAX_DISPLAY_WIDTH] == rgb(2) && image[V9938_MAX_DISPLAY_WIDTH + 1] == rgb(2));
    assert(image[V9938_MAX_DISPLAY_WIDTH + 16] == rgb(2) && image[V9938_MAX_DISPLAY_WIDTH + 17] == rgb(2));
    assert(image[17 * V9938_MAX_DISPLAY_WIDTH] == rgb(2));
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

static uint8_t pixel_of(V9938 *v, unsigned x, unsigned y)
{
    unsigned a = (y << 7) | (x >> 1);
    return (uint8_t)((v->vram[a] >> (((~x) & 1) << 2)) & 15);
}

static void set_command(V9938 *v, unsigned dx, unsigned dy, unsigned nx,
                        unsigned ny, uint8_t color, uint8_t arg)
{
    reg(v, 36, dx & 0xFF); reg(v, 37, (dx >> 8) & 3);
    reg(v, 38, dy & 0xFF); reg(v, 39, (dy >> 8) & 3);
    reg(v, 40, nx & 0xFF); reg(v, 41, (nx >> 8) & 3);
    reg(v, 42, ny & 0xFF); reg(v, 43, (ny >> 8) & 3);
    reg(v, 44, color);
    reg(v, 45, arg);
}

/* LINE: reference blueMSX LineEngine / openMSX executeLine. NX is the length
 * along the major axis minus one, ARG bit 0 picks the major axis, bits 2/3 the
 * direction. */
static void test_command_line(void)
{
    V9938 *v = setup(0);

    /* Horizontal run to the right: 11 dots at rows 20. */
    set_command(v, 10, 20, 10, 0, 7, 0x00);
    reg(v, 46, 0x70);
    for (unsigned x = 10; x <= 20; x++) assert(pixel_of(v, x, 20) == 7);
    assert(pixel_of(v, 9, 20) == 0);
    assert(pixel_of(v, 21, 20) == 0);
    assert(!(v->status[2] & 0x01));

    /* Horizontal run to the left. */
    set_command(v, 200, 100, 10, 0, 12, 0x04);
    reg(v, 46, 0x70);
    for (unsigned x = 190; x <= 200; x++) assert(pixel_of(v, x, 100) == 12);
    assert(pixel_of(v, 201, 100) == 0);

    /* 45-degree diagonal: one minor step per major step. */
    set_command(v, 0, 30, 16, 16, 9, 0x00);
    reg(v, 46, 0x70);
    for (unsigned i = 0; i <= 16; i++) assert(pixel_of(v, i, 30 + i) == 9);
    assert(pixel_of(v, 5, 36) == 0);
    assert(pixel_of(v, 16, 45) == 0);

    /* Y-major vertical run: NX is the major length, NY the minor extent. */
    set_command(v, 100, 60, 10, 0, 11, 0x01);
    reg(v, 46, 0x70);
    for (unsigned y = 60; y <= 70; y++) assert(pixel_of(v, 100, y) == 11);
    assert(pixel_of(v, 100, 71) == 0);
    assert(pixel_of(v, 101, 65) == 0);

    /* Moving above the top border stops the command instead of wrapping. */
    set_command(v, 50, 3, 20, 10, 13, 0x08);
    reg(v, 46, 0x70);
    assert(!(v->status[2] & 0x01));
    assert(pixel_of(v, 50, 3) == 13);

    v9938_destroy(v);
    puts("PASS: LINE major/minor axes, directions and border stop");
}

/* LMCM: one pixel per read of R#44 through the indirect port, with the TR/CE
 * handshake (reference LmcmEngine). */
static void test_command_lmcm(void)
{
    V9938 *v = setup(0);
    v->vram[0] = 0x12; /* row 0: x0=1 x1=2 */
    v->vram[1] = 0x34; /*      x2=3 x3=4 */
    reg(v, 32, 0); reg(v, 33, 0);
    reg(v, 34, 0); reg(v, 35, 0);
    reg(v, 40, 4); reg(v, 41, 0);
    reg(v, 42, 1); reg(v, 43, 0);
    reg(v, 44, 0);
    reg(v, 45, 0);
    reg(v, 46, 0xA0);

    assert(v->status[2] & 0x01); /* CE */
    assert(v->status[2] & 0x80); /* TR: first pixel ready */
    assert(v->reg[44] == 1);
    reg(v, 17, 0x80 | 44); /* keep the indirect pointer on R#44 */
    assert(v9938_read_port(v, 0x9B) == 1);
    assert(v->reg[44] == 2);
    assert(v9938_read_port(v, 0x9B) == 2);
    assert(v9938_read_port(v, 0x9B) == 3);
    assert(v9938_read_port(v, 0x9B) == 4);
    assert(!(v->status[2] & 0x01)); /* all four pixels handed over */

    v9938_destroy(v);
    puts("PASS: LMCM per-read pixel transfer with TR/CE sequencing");
}

/* SCREEN 6 scans out 512 native dots and each sprite dot covers two screen
 * dots (reference SpriteConverter GRAPHIC6 branch); collision coordinates are
 * therefore reported in the 512-dot grid. */
static void test_screen6_native_width(void)
{
    V9938 *v = setup(0);
    reg(v, 0, 0x08); /* SCREEN 6 */
    reg(v, 1, 0x40);
    /* Four 2-bit pixel pairs in one byte: x=500..503 = colours 3,2,1,0. */
    store(v, (3 << 7) | 125, 0xE4, 0);
    sprite(v, 0, 49, 10, 2, 0x80, 0); /* first pattern row shows on line 50 */
    sprite(v, 1, 49, 10, 5, 0x80, 0);
    draw(v);

    assert(v9938_display_width(v) == 512);
    assert(image[3 * V9938_MAX_DISPLAY_WIDTH + 500] == rgb(3));
    assert(image[3 * V9938_MAX_DISPLAY_WIDTH + 501] == rgb(2));
    assert(image[3 * V9938_MAX_DISPLAY_WIDTH + 502] == rgb(1));
    assert(image[3 * V9938_MAX_DISPLAY_WIDTH + 503] == 0);

    /* The sprite sits at dot 10, so it covers screen dots 20 and 21. */
    assert(image[50 * V9938_MAX_DISPLAY_WIDTH + 20] == rgb(2));
    assert(image[50 * V9938_MAX_DISPLAY_WIDTH + 21] == rgb(2));
    assert(image[50 * V9938_MAX_DISPLAY_WIDTH + 19] != rgb(2));
    assert(image[50 * V9938_MAX_DISPLAY_WIDTH + 22] != rgb(2));
    /* Collision at screen dot 20 is reported as 20 + 12. */
    assert(v->status[0] & 0x20);
    assert(v->status[3] == 32);
    v9938_destroy(v);
    puts("PASS: SCREEN 6 native 512-dot scanout, sprite duplication and collision X");
}

/* TEXT2 is the 80-column text mode (M1 = R#1 bit 4 plus R#0 bit 2). Each
 * character is a 6-dot glyph from the VRAM pattern generator, the 480 dots sit
 * between 8-dot background borders in the 512-dot line, R#3 selects the blink
 * table (one bit per character) and R#23 scrolls the text plane. Reference:
 * blueMSX RefreshLineTx80 and openMSX CharacterConverter::renderText2. */
static V9938 *text2_setup(void)
{
    V9938 *v = v9938_create();
    assert(v);
    reg(v, 0, 0x04);       /* TEXT2 with M1 below */
    reg(v, 1, 0x50);       /* M1 = text mode, display enabled */
    reg(v, 2, 0x08);       /* name table 0x2000, 4 KiB aligned */
    reg(v, 3, 0x00);       /* blink table 0x0000, 512-byte aligned */
    reg(v, 4, 0x10);       /* pattern generator 0x8000, 2 KiB aligned */
    reg(v, 7, 0xF4);       /* foreground 15, background 4 */
    reg(v, 12, 0x21);      /* blink foreground 2, blink background 1 */
    for (unsigned c = 0; c < 16; c++) {
        v->palette[c][0] = c & 7;
        v->palette[c][1] = (c >> 3) * 7;
        v->palette[c][2] = 0;
    }
    return v;
}

static void text2_glyph(V9938 *v, unsigned ch, const uint8_t *rows)
{
    for (unsigned py = 0; py < 8; py++)
        v->vram[0x8000 + ch * 8 + py] = rows[py];
}

static void test_text2_80_columns(void)
{
    static const uint8_t left[8]  = {0xC0, 0, 0, 0, 0, 0, 0, 0};
    static const uint8_t right[8] = {0x84, 0, 0, 0, 0, 0, 0, 0};
    V9938 *v = text2_setup();
    unsigned w = V9938_MAX_DISPLAY_WIDTH;
    uint32_t fg = rgb(15), bg = rgb(4);

    text2_glyph(v, 0x41, left);
    text2_glyph(v, 0x42, right);
    v->vram[0x2000 + 0]  = 0x41;
    v->vram[0x2000 + 79] = 0x42;
    draw(v);

    /* Column 0 covers dots 8..13, column 79 covers dots 482..487. */
    assert(image[0 * w + 8] == fg);
    assert(image[0 * w + 9] == fg);
    assert(image[0 * w + 10] == bg);
    assert(image[0 * w + 13] == bg);
    assert(image[0 * w + 482] == fg);
    assert(image[0 * w + 483] == bg);
    assert(image[0 * w + 487] == fg);
    for (unsigned x = 0; x < 8; x++)
        assert(image[0 * w + x] == bg);
    for (unsigned x = 488; x < 512; x++)
        assert(image[0 * w + x] == bg);

    /* Character row 1 walks the name table by 80 bytes. */
    v->vram[0x2000 + 80] = 0x41;
    draw(v);
    assert(image[8 * w + 8] == fg);
    assert(image[7 * w + 9] == bg);

    /* Text modes show no sprites: a sprite over the glyph must not appear. */
    reg(v, 5, 15);
    sprite(v, 0, 0, 8, 2, 0xFC, 0);
    draw(v);
    assert(image[0 * w + 8] == fg);
    assert(image[0 * w + 10] == bg);
    v9938_destroy(v);
    puts("PASS: TEXT2 80 columns, 6-dot glyphs, background borders and no sprites");
}

static void test_text2_blink(void)
{
    static const uint8_t block[8] = {0x80, 0, 0, 0, 0, 0, 0, 0};
    V9938 *v = text2_setup();
    unsigned w = V9938_MAX_DISPLAY_WIDTH;
    uint32_t fg = rgb(15), blinkFg = rgb(2), blinkBg = rgb(1);

    text2_glyph(v, 0x41, block);
    v->vram[0x2000 + 0] = 0x41;
    v->vram[0x2000 + 1] = 0x41;
    v->vram[0x0000] = 0x80; /* blink bit of column 0 in character row 0 */

    draw(v);
    assert(image[0 * w + 8] == fg); /* no blink phase before R#13 is written */

    reg(v, 13, 0x11); /* ten frames ON, ten frames OFF, renderer starts ON */
    draw(v);
    assert(image[0 * w + 8] == blinkFg);
    assert(image[0 * w + 9] == blinkBg);
    assert(image[0 * w + 14] == fg); /* column 1 has no blink bit */

    for (unsigned i = 0; i < 10; i++)
        v9938_frame_start(v);
    draw(v);
    assert(image[0 * w + 8] == fg); /* OFF half of the period */

    for (unsigned i = 0; i < 10; i++)
        v9938_frame_start(v);
    draw(v);
    assert(image[0 * w + 8] == blinkFg); /* ON again */

    reg(v, 13, 0x00); /* zero period = stable colour */
    draw(v);
    assert(image[0 * w + 8] == fg);
    for (unsigned i = 0; i < 40; i++)
        v9938_frame_start(v);
    draw(v);
    assert(image[0 * w + 8] == fg);
    v9938_destroy(v);
    puts("PASS: TEXT2 per-character blink (R#3 table, R#12 colours, R#13 period)");
}

static void test_text2_vertical_scroll(void)
{
    static const uint8_t part[8] = {0xC0, 0, 0, 0, 0, 0, 0, 0};
    static const uint8_t full[8] = {0xFC, 0xFC, 0xFC, 0xFC,
                                    0xFC, 0xFC, 0xFC, 0xFC};
    V9938 *v = text2_setup();
    unsigned w = V9938_MAX_DISPLAY_WIDTH;

    text2_glyph(v, 0x41, part);
    text2_glyph(v, 0x43, full);
    v->vram[0x2000 + 0]  = 0x41; /* character row 0 */
    v->vram[0x2000 + 80] = 0x43; /* character row 1 */

    draw(v);
    assert(image[0 * w + 8] == rgb(15));
    assert(image[0 * w + 10] == rgb(4));

    reg(v, 23, 8); /* one character row of vertical scroll */
    draw(v);
    assert(image[0 * w + 8] == rgb(15));
    assert(image[0 * w + 13] == rgb(15)); /* full block from character row 1 */
    v9938_destroy(v);
    puts("PASS: TEXT2 R#23 vertical scroll moves whole character rows");
}

/* TEXT1 (M1 only) has no blink table: unlike TEXT2, both reference renderers
 * use only R#7 for its colours. Its 240 active dots occupy x=8..247. */
static void test_text1_40_columns(void)
{
    V9938 *v = v9938_create();
    assert(v);
    reg(v, 0, 0x00);
    reg(v, 1, 0x50);  /* M1, display on */
    reg(v, 2, 0x08);  /* name table at 0x2000 */
    reg(v, 4, 0x10);  /* pattern table at 0x8000 */
    reg(v, 7, 0xF4);  /* foreground 15 / background 4 */
    for (unsigned c = 0; c < 16; c++) {
        v->palette[c][0] = c & 7;
        v->palette[c][1] = (c >> 3) * 7;
        v->palette[c][2] = 0;
    }
    unsigned w = V9938_MAX_DISPLAY_WIDTH;
    uint32_t fg = rgb(15), bg = rgb(4);
    v->vram[0x8000 + 0x41 * 8] = 0x80;  /* first dot */
    v->vram[0x8000 + 0x42 * 8] = 0x04;  /* sixth dot */
    v->vram[0x8000 + 0x42 * 8 + 7] = 0x04;
    v->vram[0x2000] = 0x41;
    v->vram[0x2000 + 39] = 0x42;
    v->vram[0x2000 + 40] = 0x42;
    v->vram[0x2000 + 23 * 40 + 39] = 0x42;
    draw(v);
    assert(v9938_display_width(v) == 256);
    for (unsigned x = 0; x < 8; x++) {
        assert(image[x] == bg);
        assert(image[248 + x] == bg);
    }
    assert(image[8] == fg && image[9] == bg);
    assert(image[242] == bg && image[247] == fg);
    assert(image[8 * w + 13] == fg);
    assert(image[191 * w + 247] == fg);
    assert(image[192 * w + 8] == 0xA5A5A5A5u);
    assert(image[256] == 0xA5A5A5A5u); /* never write the unused row tail */

    /* The 212-line selection preserves the final row and wraps the masked
     * name table at the reference TEXT1 address boundary. */
    v->vram[0x2037] = 0x42;
    v->vram[0x8000 + 0x42 * 8 + 3] = 0x04;
    reg(v, 9, 0x80);
    draw(v);
    assert(image[211 * w + 247] == fg);
    assert(image[211 * w + 248] == bg);
    assert(image[212 * w] == 0xA5A5A5A5u);
    reg(v, 9, 0);

    /* R#2 low page bits select a different name table in TEXT1. */
    v->vram[0x2400] = 0x42;
    reg(v, 2, 0x09);
    draw(v);
    assert(image[8] == bg && image[13] == fg);
    reg(v, 2, 0x08);

    /* BlueMSX scrolls the name row and glyph subrow together in TEXT1. */
    reg(v, 23, 8);
    draw(v);
    assert(image[8] == bg && image[13] == fg);
    reg(v, 23, 0);

    /* R#3/R#12/R#13 blink selection is TEXT2-only. */
    reg(v, 3, 0x20);
    reg(v, 12, 0x21);
    v->vram[0x800] = 0xFF;
    reg(v, 13, 0x11);
    draw(v);
    assert(image[8] == fg && image[9] == bg);
    for (unsigned i = 0; i < 10; i++) v9938_frame_start(v);
    draw(v);
    assert(image[8] == fg && image[9] == bg);

    /* A visible SAT entry must not paint over TEXT1 glyphs. */
    reg(v, 5, 0x0F);
    reg(v, 6, 0x01);
    v->vram[0x780] = 255;
    v->vram[0x781] = 8;
    v->vram[0x782] = 0;
    v->vram[0x783] = 0x0F;
    v->vram[0x784] = 208;
    draw(v);
    assert(image[8] == fg && image[9] == bg);
    v9938_destroy(v);
    puts("PASS: TEXT1 40 columns, borders, table masks, scroll, no blink/sprites");
}

int main(void)
{
    test_height_and_alignment();
    test_priority_and_cc();
    test_collision_and_limits();
    test_table_window_and_size();
    test_cpu_vram_and_latches();
    test_command_line();
    test_command_lmcm();
    test_screen6_native_width();
    test_text2_80_columns();
    test_text2_blink();
    test_text2_vertical_scroll();
    test_text1_40_columns();
    puts("All V9938 display/sprite conformance checks passed");
    return 0;
}
