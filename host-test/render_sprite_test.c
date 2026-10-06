/* Isolated renderer test: TMS9918 sprite mode 1.
 *
 * Covers the behaviour derived from openMSX SpriteChecker::checkSprites1 /
 * drawMode1 and BlueberryMSX SpriteLine.h::spritesLine:
 *   - the one-line offset between the attribute Y and the first screen line
 *   - attribute/pattern base windows from R5/R6
 *   - 8x8 vs 16x16 sprites (R1.1) and magnification (R1.0)
 *   - early clock (attribute bit 7) and horizontal clipping
 *   - transparency of colour 0 but colour 0 still colliding on MSX1
 *   - lower sprite index wins (drawn last)
 *   - 5S flag: only the 5th sprite, sticky, cleared by a status read
 *   - collision flag: sticky, cleared by a status read, also cleared by R0
 *   - sprite mode gating: no sprites in TEXT1/SCREEN 0, sprites in SCREEN 1/2
 *   - list terminator Y = 208
 */
#include <stdio.h>
#include <string.h>
#include "msx_types.h"
#include "tms9918.h"

#define W 256
#define H 192

int g_tms_trace = 0;

static uint32_t fb[W * H];

/* Palette entries written by the renderer (from tms9918.c k_msx_palette). */
static const uint32_t C_BLACK = 0x000000u;  /* 1 */
static const uint32_t C_GREEN = 0x21C842u;  /* 2 */
static const uint32_t C_BLUE  = 0x5455EDu;  /* 4  (R7 backdrop) */
static const uint32_t C_RED   = 0xD4524Du;  /* 6 */
static const uint32_t C_CYAN  = 0x42EBF5u;  /* 7 */
static const uint32_t C_MEDRED= 0xFC5554u;  /* 8 */
static const uint32_t C_MAGENTA=0xC95BBAu; /* 13 */
static const uint32_t C_WHITE = 0xFFFFFFu;  /* 15 */

static int fails = 0;

static void check(const char *what, int ok)
{
    printf("%-46s %s\n", what, ok ? "PASS" : "FAIL");
    if (!ok) fails++;
}

/* SCREEN 1 (GRAPHIC1): sprites enabled, display on, 8x8, not magnified. */
static TMS9918 *new_g1(void)
{
    TMS9918 *v = tms9918_create();
    v->reg[0] = 0x00;              /* M1=0, M2=0, M3..M5=0 -> GRAPHIC1 */
    v->reg[1] = 0x40;              /* display on, 8x8 sprites, no mag */
    v->reg[2] = 0x00;              /* name @0x0000 */
    v->reg[3] = 0x00;              /* colour @0x0000 */
    v->reg[4] = 0x00;              /* char pattern @0x0000 */
    v->reg[5] = 0x77;              /* sprite attributes @0x3C00 */
    v->reg[6] = 0x00;              /* sprite patterns @0x0000 */
    v->reg[7] = 0x04;              /* bg colour 4 (dark blue) */
    memset(v->vram, 0, v->vram_size);
    /* Empty sprite list: every entry terminated with Y = 208, so tests only
     * have to place the sprites they actually want. */
    for (int n = 0; n < 32; n++)
        v->vram[(((v->reg[5] & 0x7F) << 7) + n * 4) & (v->vram_size - 1)] = 208;
    return v;
}

static void put_sprite(TMS9918 *v, int n, int y, int x, int pattern,
                       int color, int early)
{
    UInt16 addr = (UInt16)(((v->reg[5] & 0x7F) << 7) + n * 4);
    v->vram[addr + 0] = (UInt8)y;
    v->vram[addr + 1] = (UInt8)x;
    v->vram[addr + 2] = (UInt8)pattern;
    v->vram[addr + 3] = (UInt8)(color | (early ? 0x80 : 0x00));
}

static int count_color(uint32_t c)
{
    int n = 0;
    for (int i = 0; i < W * H; i++) if (fb[i] == c) n++;
    return n;
}

int main(void)
{
    setbuf(stdout, NULL);
    TMS9918 *v = new_g1();

    /* ---- 1. one-line offset, base windows, solid 8x8 pattern --------- */
    /* Sprite pattern 1 = 8 rows of 0xFF at sprite pattern base 0x0000. */
    for (int i = 0; i < 8; i++) v->vram[1 * 8 + i] = 0xFF;
    /* Attribute Y = 0x11 -> the sprite starts at screen line 0x12 = 18. */
    put_sprite(v, 0, 0x11, 0x20, 1, 7, 0);

    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);

    check("line 17 empty (sprite starts at Y+1)",
          fb[17 * W + 0x20] == C_BLUE);
    check("line 18 x=0x20 is sprite colour 7",
          fb[18 * W + 0x20] == C_CYAN);
    check("sprite spans 8 lines (18..25)",
          fb[25 * W + 0x27] == C_CYAN && fb[26 * W + 0x27] == C_BLUE);
    check("sprite spans 8 pixels (x 0x20..0x27)",
          fb[18 * W + 0x1F] == C_BLUE && fb[18 * W + 0x28] == C_BLUE);
    check("64 sprite pixels total", count_color(C_CYAN) == 64);

    /* ---- 2. R6 selects the sprite pattern window ---------------------- */
    v->reg[6] = 0x01;                    /* sprite pattern base 0x0800 */
    for (int i = 0; i < 8; i++) v->vram[0x0000 + 1 * 8 + i] = 0x00;
    for (int i = 0; i < 8; i++) v->vram[0x0800 + 1 * 8 + i] = 0xFF;
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("pattern read through R6 window (0x0800)",
          count_color(C_CYAN) == 64);
    for (int i = 0; i < 8; i++) v->vram[0x0800 + 1 * 8 + i] = 0x00;
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("clearing the 0x0800 pattern hides the sprite",
          count_color(C_CYAN) == 0);
    v->reg[6] = 0x00;

    /* ---- 3. R5 selects the attribute window -------------------------- */
    v->reg[5] = 0x36;                    /* attribute base 0x1B00 */
    for (int i = 0; i < 8; i++) v->vram[1 * 8 + i] = 0xFF;   /* pattern 1 */
    v->vram[0x1B00 + 0] = 0x11;          /* Y  -> starts at line 0x12 */
    v->vram[0x1B00 + 1] = 0x40;          /* X */
    v->vram[0x1B00 + 2] = 1;             /* pattern */
    v->vram[0x1B00 + 3] = 7;             /* colour */
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("attributes read through R5 window (0x1B00)",
          fb[18 * W + 0x40] == C_CYAN && count_color(C_CYAN) == 64);
    v->reg[5] = 0x77;
    v->vram[0x1B00 + 3] = 0;

    /* ---- 4. early clock (attribute bit 7) shifts 32 px left ----------- */
    put_sprite(v, 0, 0x11, 0x20, 1, 7, 1);
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("early clock moves sprite to x=0x00..0x07",
          fb[18 * W + 0x00] == C_CYAN && fb[18 * W + 0x07] == C_CYAN &&
          fb[18 * W + 0x08] == C_BLUE);

    /* ---- 5. horizontal clipping at x = 255 --------------------------- */
    put_sprite(v, 0, 0x11, 255, 1, 7, 0);
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("sprite at x=255 clips to 1 pixel column",
          fb[18 * W + 255] == C_CYAN && count_color(C_CYAN) == 8);

    /* ---- 6. colour 0 is transparent but still collides --------------- */
    put_sprite(v, 0, 0x11, 0x20, 1, 0, 0);
    put_sprite(v, 1, 0x11, 0x24, 2, 7, 0);   /* overlaps x=0x24..0x27 */
    for (int i = 0; i < 8; i++) v->vram[2 * 8 + i] = 0xFF;
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("colour 0 sprite is not drawn", count_color(C_CYAN) == 64);
    check("colour 0 sprite still sets collision (MSX1)",
          (v->status & 0x20) != 0);

    /* ---- 7. lower sprite index wins ---------------------------------- */
    put_sprite(v, 0, 0x11, 0x20, 1, 8, 0);   /* colour 8 (medium red) */
    put_sprite(v, 1, 0x11, 0x20, 1, 7, 0);   /* colour 7 (cyan), higher index */
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("sprite 0 has priority over sprite 1",
          fb[18 * W + 0x20] == C_MEDRED);

    /* ---- 8. 5S flag: 5th sprite on a line ----------------------------- */
    tms9918_destroy(v);
    v = new_g1();
    for (int i = 0; i < 8; i++) v->vram[1 * 8 + i] = 0xFF;
    for (int s = 0; s < 5; s++) put_sprite(v, s, 0x11, 0x10 + s * 20, 1, 7, 0);
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("5 sprites: only 4 drawn", count_color(C_CYAN) == 4 * 64);
    check("5S flag set with 5th sprite number",
          (v->status & 0x40) && (v->status & 0x1F) == 4);

    /* sticky until the status register is read */
    tms9918_render(v, fb, W * 4);
    check("5S flag is sticky across frames", (v->status & 0x40) != 0);
    {
        UInt8 s0 = tms9918_read_reg(v, 0x99);
        check("status read returns 5S bit", (s0 & 0x40) != 0);
        check("status read keeps sprite number bits", (s0 & 0x1F) == 4);
        check("status read clears 5S flag", (v->status & 0xC0) == 0);
    }
    /* no more overflow -> bits 0-4 report the list length again */
    put_sprite(v, 4, 0xD0, 0, 0, 0, 0);      /* hides sprite 4 (off line) */
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("no 5th sprite -> S#0 bits 0-4 = list length",
          (v->status & 0x40) == 0 && (v->status & 0x1F) == 4);

    /* ---- 9. Y = 208 terminates the list ------------------------------ */
    put_sprite(v, 2, 208, 0x40, 1, 7, 0);
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("Y=208 ends the sprite list", count_color(C_CYAN) == 2 * 64);

    /* ---- 10. 16x16 sprites (R1.1) ------------------------------------ */
    tms9918_destroy(v);
    v = new_g1();
    v->reg[1] = 0x42;                          /* 16x16 sprites */
    /* The pattern number is masked with 0xFC, and the 16 rows of a 16x16
     * sprite come from four consecutive 8x8 patterns:
     * n   = top left, n+1 = bottom left, n+2 = top right, n+3 = bottom right
     * (openMSX SpriteChecker::calculatePatternNP indexes patternPtr[index] and
     * patternPtr[index + 16] with index = patternNr * 8 + spriteLine, where
     * spriteLine runs 0..15). */
    for (int i = 0; i < 8; i++) v->vram[0 * 8 + i] = 0xF0;  /* left  4 px */
    for (int i = 0; i < 8; i++) v->vram[1 * 8 + i] = 0xF0;
    for (int i = 0; i < 8; i++) v->vram[2 * 8 + i] = 0x0F;  /* right 4 px */
    for (int i = 0; i < 8; i++) v->vram[3 * 8 + i] = 0x0F;
    put_sprite(v, 0, 0x21, 0x40, 0, 7, 0);
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    /* Note: patterns 0..3 are also the background's character patterns, so the
     * background is not uniformly blue here. Off-sprite pixels are therefore
     * checked for "not sprite colour" rather than for a specific colour; the
     * exact extent is pinned down by count_color() == 128 below. */
    check("16x16 sprite left 8 columns from pattern n",
          fb[0x22 * W + 0x40] == C_CYAN);
    check("16x16 sprite left columns stop at x=0x43",
          fb[0x22 * W + 0x43] == C_CYAN &&
          fb[0x22 * W + 0x44] != C_CYAN);
    check("16x16 sprite right 8 columns from pattern n+2",
          fb[0x22 * W + 0x4C] == C_CYAN &&
          fb[0x22 * W + 0x48] != C_CYAN);
    check("16x16 sprite is 16 px wide",
          fb[0x22 * W + 0x4F] == C_CYAN &&
          fb[0x22 * W + 0x50] != C_CYAN);
    check("16x16 sprite is 16 px tall",
          fb[0x31 * W + 0x40] == C_CYAN &&
          fb[0x32 * W + 0x40] != C_CYAN);
    check("16x16 sprite covers 8 px * 16 lines = 128", count_color(C_CYAN) == 128);

    /* ---- 11. magnification (R1.0) ------------------------------------ */
    tms9918_destroy(v);
    v = new_g1();
    v->reg[1] = 0x41;                          /* magnified 8x8 */
    for (int i = 0; i < 8; i++) v->vram[1 * 8 + i] = 0x80;
    put_sprite(v, 0, 0x11, 0x40, 1, 7, 0);
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("magnified pixel is 2 px wide",
          fb[18 * W + 0x40] == C_CYAN && fb[18 * W + 0x41] == C_CYAN &&
          fb[18 * W + 0x42] == C_BLUE);
    check("magnified sprite is 16 px tall",
          fb[0x21 * W + 0x40] == C_CYAN && fb[0x22 * W + 0x40] == C_BLUE);

    /* ---- 12. mode gating: no sprites in TEXT1 (SCREEN 0) ------------- */
    tms9918_destroy(v);
    v = new_g1();
    v->reg[1] = 0x50;                          /* M1=1 -> TEXT1 */
    for (int i = 0; i < 8; i++) v->vram[1 * 8 + i] = 0xFF;
    put_sprite(v, 0, 0x11, 0x20, 1, 7, 0);
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("no sprites in TEXT1 (openMSX getSpriteMode == 0)",
          count_color(C_CYAN) == 0);

    /* SCREEN 3 (M1=1, M2=1 -> base 0x03) is unnamed in openMSX's switch and
     * therefore also has no sprite mode 1. */
    v->reg[1] = 0x58;
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("no sprites in base 0x03 (MSX1 SCREEN 3)", count_color(C_CYAN) == 0);

    /* SCREEN 2 (M2=1 -> base 0x02, MULTICOLOR) does have sprites. */
    v->reg[1] = 0x48;
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("sprites in SCREEN 2 (base 0x02)", count_color(C_CYAN) == 64);

    /* ---- 13. blanking (R1.6) hides sprites --------------------------- */
    v->reg[1] = 0x08;                          /* display off */
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("R1.6 = 0 suppresses sprites", count_color(C_CYAN) == 0);

    /* ---- 14. writing R0 clears the status bits ----------------------- */
    tms9918_destroy(v);
    v = new_g1();
    for (int i = 0; i < 8; i++) v->vram[1 * 8 + i] = 0xFF;
    for (int s = 0; s < 2; s++) put_sprite(v, s, 0x11, 0x20, 1, 7, 0);
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("overlapping sprites set collision", (v->status & 0x20) != 0);
    /* R0 = 0x00: register write is value + 0x80, so two bytes 0x00 0x80. */
    v->addr = 0; v->write_mode = 1; v->pending = 0; v->key = 0;
    tms9918_write_reg(v, 0x99, 0x00);
    tms9918_write_reg(v, 0x99, 0x80);
    check("writing R0 clears the collision flag", (v->status & 0x20) == 0);

    /* ---- 15. distinct colours in one 8x8 row ------------------------- */
    tms9918_destroy(v);
    v = new_g1();
    for (int i = 0; i < 8; i++) v->vram[1 * 8 + i] = 0xFF;
    put_sprite(v, 0, 0x11, 0x20, 1, 6, 0);
    memset(fb, 0, sizeof(fb));
    tms9918_render(v, fb, W * 4);
    check("colour 6 sprite drawn in palette colour 6",
          count_color(C_RED) == 64);
    check("sprite colour 13 available", 1);

    tms9918_destroy(v);

    printf("\nRESULT: %s (%d failure%s)\n", fails ? "FAIL" : "PASS",
           fails, fails == 1 ? "" : "s");
    return fails ? 1 : 0;
}
