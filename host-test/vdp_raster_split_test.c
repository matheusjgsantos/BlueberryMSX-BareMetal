/* Regression test: a frame that rewrites the display address while it is
 * being scanned (raster split) must render each line with the register state
 * that was in effect while that line was scanned.
 *
 * Space Manbow does exactly this in SCREEN 5: it keeps a fixed HUD at the top
 * and switches R#23 (vertical scroll) at display line 32 for the playfield.
 * Rendering the whole frame from the end-of-frame registers put the playfield
 * address on the HUD rows, which is the corruption this test guards against.
 *
 * Reference semantics (openMSX VDP::scheduleDisplayStart / PixelRenderer):
 *   display area starts at raster line
 *       3 + 13 + topBorder + (212-line ? 0 : 10) + verticalAdjust
 *   the frame interrupt is raised when the display area ends
 *   the displayed line is (frameRow + R#23) & 255
 * Native output starts at active line zero and retains all 192/212 lines.
 * Framebuffer row y is scanned at raster line lineZero + y.
 */
#include "v9938.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define assert(cond) do { \
    if (!(cond)) { \
        fprintf(stderr, "Assertion failed: %s at %s:%d\n", \
                #cond, __FILE__, __LINE__); \
        exit(1); \
    } \
} while (0)

#define FRAME_TICKS 357954u          /* R800_MASTER_FREQUENCY / 60 */
#define ROWS V9938_MAX_DISPLAY_LINES
#define COLS 256
#define PITCH (COLS * 4)
#define LINE_ZERO 32u                /* NTSC, 212-line mode, set adjust 7 */
#define FRAME_IRQ_LINE (LINE_ZERO + 212u)   /* 244 */

static uint32_t s_img[ROWS * COLS];
static uint32_t s_a[ROWS * COLS];
static uint32_t s_b[ROWS * COLS];

static void write_register(V9938 *vdp, unsigned reg, uint8_t value)
{
    v9938_write_port(vdp, 0x99, value);
    v9938_write_port(vdp, 0x99, (uint8_t)(0x80 | reg));
}

static void setup_screen5(V9938 *vdp)
{
    /* GRAPHIC 4 (SCREEN 5): R#0 = 0x06 selects the bitmap mode, R#1 = 0x62
     * keeps the 8x8 sprite mode with display enabled. R#2 = 0x20 puts the
     * page at 0x8000; R#8 disables sprites in the raster test fixture. */
    write_register(vdp, 0, 0x06);
    write_register(vdp, 1, 0x62);
    write_register(vdp, 8, 0x02);
    write_register(vdp, 2, 0x20);
    write_register(vdp, 7, 0x00);
    write_register(vdp, 9, 0x80);   /* 212-line mode */
    write_register(vdp, 18, 0x00);  /* vertical set adjust 7 (default) */
    write_register(vdp, 23, 0x00);
    write_register(vdp, 25, 0x00);
    write_register(vdp, 26, 0x00);
    write_register(vdp, 27, 0x00);
    for (unsigned a = 0; a < 0x20000u; a++)
        vdp->vram[a] = (uint8_t)(a ^ (a >> 5) ^ (a >> 9));
}

/* Frame time (master ticks) at which the given raster line is scanned. */
static unsigned frame_time_for_raster(unsigned raster)
{
    unsigned offset = (raster + V9938_FRAME_LINES - FRAME_IRQ_LINE)
                      % V9938_FRAME_LINES;
    return (offset * FRAME_TICKS + V9938_FRAME_LINES - 1) / V9938_FRAME_LINES;
}

static void render(V9938 *vdp, uint32_t *out)
{
    memset(out, 0, ROWS * PITCH);
    v9938_render(vdp, out, PITCH);
}

static unsigned differing_pixels(const uint32_t *lhs, const uint32_t *rhs,
                                 unsigned row)
{
    unsigned n = 0;
    for (unsigned x = 0; x < COLS; x++)
        if (lhs[row * COLS + x] != rhs[row * COLS + x]) n++;
    return n;
}

static void test_frame_time_mapping(V9938 *vdp)
{
    v9938_frame_start(vdp);
    v9938_set_frame_time(vdp, 0, FRAME_TICKS);
    assert(vdp->currentLine == FRAME_IRQ_LINE);

    /* Display line 32 of the active area -> raster 64, 82 lines after the
     * interrupt: the split Space Manbow programs. */
    v9938_set_frame_time(vdp, frame_time_for_raster(LINE_ZERO + 32u),
                         FRAME_TICKS);
    assert(vdp->currentLine == LINE_ZERO + 32u);

    /* An arbitrary later line, and the wrap back to the top of the frame. */
    v9938_set_frame_time(vdp, frame_time_for_raster(200), FRAME_TICKS);
    assert(vdp->currentLine == 200);
    v9938_set_frame_time(vdp, frame_time_for_raster(20), FRAME_TICKS);
    assert(vdp->currentLine == 20);
    v9938_set_frame_time(vdp, FRAME_TICKS, FRAME_TICKS);
    assert(vdp->currentLine == FRAME_IRQ_LINE);
}

static void test_horizontal_retrace_status(V9938 *vdp)
{
    /* V9938 S#2 bit 5 is HR (horizontal retrace). For SCREEN 5 it is high
     * for 312 of 1368 master clocks per line; time zero is VSCAN at horizontal
     * phase 202. These edges are what Space Manbow polls around its split. */
    v9938_frame_start(vdp);
    write_register(vdp, 15, 0x02);

    v9938_set_frame_time(vdp, 0, FRAME_TICKS);
    assert((vdp->status[2] & 0x20) != 0);
    v9938_set_frame_time(vdp, 168, FRAME_TICKS);
    assert((vdp->status[2] & 0x20) != 0);
    v9938_set_frame_time(vdp, 169, FRAME_TICKS);
    assert((vdp->status[2] & 0x20) == 0);

    v9938_set_frame_time(vdp, 1225, FRAME_TICKS);
    assert((vdp->status[2] & 0x20) != 0);
    assert((v9938_read_port(vdp, 0x99) & 0x20) != 0);
    v9938_set_frame_time(vdp, 169, FRAME_TICKS);
    assert((v9938_read_port(vdp, 0x99) & 0x20) == 0);
    write_register(vdp, 15, 0x00);
}

static void test_vertical_scroll_split(V9938 *vdp)
{
    /* Baselines: the whole frame rendered with one scroll value. */
    write_register(vdp, 23, 0x00);
    v9938_frame_start(vdp);
    render(vdp, s_a);
    write_register(vdp, 23, 0x01);
    v9938_frame_start(vdp);
    render(vdp, s_b);

    /* Baseline difference has to be visible, otherwise the split below could
     * pass trivially. */
    for (unsigned y = 0; y < ROWS; y += 16)
        assert(differing_pixels(s_a, s_b, y) > 32);

    /* The split frame: HUD scroll 0 at the frame interrupt, playfield scroll 1
     * from display line 32 (raster 64) onwards. */
    write_register(vdp, 23, 0x00);
    v9938_frame_start(vdp);
    v9938_set_frame_time(vdp, 0, FRAME_TICKS);
    write_register(vdp, 23, 0x00);
    v9938_set_frame_time(vdp, frame_time_for_raster(LINE_ZERO + 32u),
                         FRAME_TICKS);
    assert(vdp->currentLine == 64);
    write_register(vdp, 23, 0x01);
    render(vdp, s_img);

    /* Framebuffer row y is scanned at raster line LINE_ZERO + y, so the split
     * lands on row 32 (raster 64 = LINE_ZERO + 32). */
    unsigned split_row = 64u - LINE_ZERO;
    assert(split_row == 32);
    for (unsigned y = 0; y < ROWS; y++) {
        const uint32_t *expect = (y < split_row) ? s_a : s_b;
        unsigned bad = 0;
        for (unsigned x = 0; x < COLS; x++)
            if (s_img[y * COLS + x] != expect[y * COLS + x]) bad++;
        if (bad) {
            fprintf(stderr, "row %u: %u/%u pixels differ from the expected "
                            "phase (%s)\n", y, bad, COLS,
                    y < split_row ? "HUD" : "playfield");
            exit(1);
        }
    }

    /* Rows above the split must not have picked up the playfield scroll and
     * rows below must not have kept the HUD scroll. */
    for (unsigned y = 0; y < split_row; y += 4) {
        if (differing_pixels(s_img, s_b, y) == 0) {
            fprintf(stderr, "row %u above the split used the playfield "
                            "scroll\n", y);
            exit(1);
        }
    }
    for (unsigned y = split_row; y < ROWS; y += 4) {
        if (differing_pixels(s_img, s_a, y) == 0) {
            fprintf(stderr, "row %u below the split kept the HUD scroll\n", y);
            exit(1);
        }
    }
}

static void test_display_page_split(V9938 *vdp)
{
    write_register(vdp, 23, 0x00);
    write_register(vdp, 2, 0x20);
    v9938_frame_start(vdp);
    render(vdp, s_a);
    write_register(vdp, 2, 0x40);   /* page 2, 0x10000 */
    v9938_frame_start(vdp);
    render(vdp, s_b);
    for (unsigned y = 0; y < ROWS; y += 16)
        assert(differing_pixels(s_a, s_b, y) > 32);

    /* Switch the display page at raster 100 -> framebuffer row 68. */
    write_register(vdp, 2, 0x20);
    v9938_frame_start(vdp);
    v9938_set_frame_time(vdp, 0, FRAME_TICKS);
    write_register(vdp, 2, 0x20);
    v9938_set_frame_time(vdp, frame_time_for_raster(100), FRAME_TICKS);
    assert(vdp->currentLine == 100);
    write_register(vdp, 2, 0x40);
    render(vdp, s_img);

    unsigned split_row = 100u - LINE_ZERO;
    assert(split_row == 68);
    for (unsigned y = 0; y < ROWS; y++) {
        const uint32_t *expect = (y < split_row) ? s_a : s_b;
        for (unsigned x = 0; x < COLS; x++)
            assert(s_img[y * COLS + x] == expect[y * COLS + x]);
    }
    write_register(vdp, 2, 0x20);
}

static void test_aleste_vblank_hud_state(V9938 *vdp)
{
    /* openMSX trace of Aleste: at VBlank (display line 214) the game writes
     * R#2=$3F and R#23=0 for the HUD; at the following line interrupt it
     * writes R#2=$1F and the new playfield scroll. The VBlank writes happen at
     * frame time zero, before raster wraps to the top of the next display. */
    write_register(vdp, 23, 0x00);
    write_register(vdp, 2, 0x3F);       /* HUD on page 1, 0x8000 */
    v9938_frame_start(vdp);
    render(vdp, s_b);

    write_register(vdp, 2, 0x1F);       /* previous frame ended on the game */
    write_register(vdp, 23, 0x37);
    v9938_frame_start(vdp);
    v9938_set_frame_time(vdp, 0, FRAME_TICKS);
    assert(vdp->currentLine == FRAME_IRQ_LINE);
    write_register(vdp, 2, 0x3F);       /* Aleste VBlank handler */
    write_register(vdp, 23, 0x00);

    /* Aleste programs R#19=8. The interrupt's raster line is measured from
     * active display line zero; framebuffer row 0 is LINE_ZERO, not LINE_ZERO
     * plus a mode-dependent crop. Rows 0-7 must therefore still be the HUD. */
    unsigned splitRaster = LINE_ZERO + 8u;
    v9938_set_frame_time(vdp, frame_time_for_raster(splitRaster), FRAME_TICKS);
    write_register(vdp, 2, 0x1F);       /* Aleste line-interrupt handler */
    write_register(vdp, 23, 0x12);

    assert(vdp->lineState[LINE_ZERO].r2 == 0x3F);
    assert(vdp->lineState[LINE_ZERO].r23 == 0x00);
    assert(vdp->lineState[splitRaster].r2 == 0x1F);
    assert(vdp->lineState[splitRaster].r23 == 0x12);

    render(vdp, s_img);
    unsigned splitRow = splitRaster - LINE_ZERO;
    assert(splitRow == 8);
    for (unsigned y = 0; y < splitRow; y++) {
        unsigned bad = differing_pixels(s_img, s_b, y);
        if (bad) {
            fprintf(stderr, "Aleste HUD row %u: %u pixels do not use the "
                            "VBlank page/scroll state\n", y, bad);
            exit(1);
        }
    }
}

static void test_sprite_register_split(void)
{
    V9938 *v = v9938_create();
    assert(v);
    setup_screen5(v);
    memset(v->vram, 0, sizeof v->vram);
    write_register(v, 1, 0x60); /* display on, 8x8 sprites */
    write_register(v, 5, 0x07); /* SAT at 0x200, colours at 0 */
    write_register(v, 6, 0x01); /* pattern at 0x800 */
    write_register(v, 8, 0x00);
    write_register(v, 11, 0x00);
    v->vram[0x200] = 0; v->vram[0x201] = 30;
    v->vram[0x204] = 216;
    v->vram[0x8600] = 0; v->vram[0x8601] = 90;
    v->vram[0x8604] = 216;
    for (unsigned row = 0; row < 8; row++) {
        v->vram[row] = 4;
        v->vram[0x8400 + row] = 6;
        v->vram[0x800 + row] = 0x80;
        v->vram[0x1000 + row] = 0xC0;
    }
    v9938_frame_start(v);
    render(v, s_a);
    assert(s_a[1 * COLS + 30] != s_a[1 * COLS + 90]);

    write_register(v, 1, 0x61); /* magnification */
    write_register(v, 5, 0x0F);
    write_register(v, 6, 0x02);
    write_register(v, 8, 0x20); /* solid colour 0 */
    write_register(v, 11, 0x01);
    v9938_frame_start(v);
    render(v, s_b);
    assert(s_b[1 * COLS + 90] != s_a[1 * COLS + 90]);

    write_register(v, 1, 0x60);
    write_register(v, 5, 0x07);
    write_register(v, 6, 0x01);
    write_register(v, 8, 0x00);
    write_register(v, 11, 0x00);
    v9938_frame_start(v);
    v9938_set_frame_time(v, frame_time_for_raster(LINE_ZERO + 4), FRAME_TICKS);
    write_register(v, 1, 0x61);
    write_register(v, 5, 0x0F);
    write_register(v, 6, 0x02);
    write_register(v, 8, 0x20);
    write_register(v, 11, 0x01);
    v9938_set_frame_time(v, frame_time_for_raster(LINE_ZERO + 6), FRAME_TICKS);
    write_register(v, 8, 0x02); /* disable sprites from this row onward */
    render(v, s_img);
    for (unsigned y = 0; y < 8; y++) {
        const uint32_t *expected = y < 4 ? s_a : s_b;
        for (unsigned x = 0; x < COLS; x++) {
            if (y >= 6) continue;
            assert(s_img[y * COLS + x] == expected[y * COLS + x]);
        }
    }
    assert(s_img[7 * COLS + 90] != s_b[7 * COLS + 90]);
    assert(s_img[7 * COLS + 30] == s_a[7 * COLS + 200]);
    assert(v->lineState[LINE_ZERO + 3].r5 == 0x07);
    assert(v->lineState[LINE_ZERO + 4].r5 == 0x0F);
    assert(v->lineState[LINE_ZERO + 6].r8 == 0x02);

    /* A blanking-time sprite-table change also carries across raster wrap. */
    v9938_frame_start(v);
    v9938_set_frame_time(v, 0, FRAME_TICKS);
    write_register(v, 8, 0x00);
    write_register(v, 5, 0x07);
    write_register(v, 6, 0x01);
    write_register(v, 11, 0x00);
    write_register(v, 1, 0x60);
    v9938_set_frame_time(v, frame_time_for_raster(LINE_ZERO + 4), FRAME_TICKS);
    write_register(v, 5, 0x0F);
    write_register(v, 6, 0x02);
    write_register(v, 11, 0x01);
    assert(v->lineState[LINE_ZERO + 1].r5 == 0x07);
    assert(v->lineState[LINE_ZERO + 4].r5 == 0x0F);
    render(v, s_img);
    assert(s_img[1 * COLS + 30] == s_a[1 * COLS + 30]);
    assert(s_img[5 * COLS + 90] != s_a[5 * COLS + 90]);
    v9938_destroy(v);
}

static void test_blanking_and_tp_split(void)
{
    V9938 *v = v9938_create();
    assert(v);
    setup_screen5(v);
    write_register(v, 1, 0x60); /* display and 8x8 sprites */
    write_register(v, 7, 0x03);
    write_register(v, 8, 0x02); /* no sprites, TP clear */
    memset(v->vram, 0, sizeof v->vram);
    for (unsigned y = 0; y < 16; y++)
        v->vram[0x8000 + y * 128] = 0x10; /* palette 1, then colour 0 */
    v9938_frame_start(v);
    render(v, s_a);
    assert(s_a[0] != s_a[1]);
    write_register(v, 8, 0x22); /* solid zero */
    v9938_frame_start(v);
    render(v, s_b);
    assert(s_b[0] == s_a[0] && s_b[1] != s_a[1]);

    write_register(v, 8, 0x02);
    v9938_frame_start(v);
    v9938_set_frame_time(v, frame_time_for_raster(LINE_ZERO + 4), FRAME_TICKS);
    write_register(v, 1, 0x20); /* blank at row 4 */
    v9938_set_frame_time(v, frame_time_for_raster(LINE_ZERO + 8), FRAME_TICKS);
    write_register(v, 1, 0x60); /* resume at row 8 */
    write_register(v, 8, 0x22); /* solid colour zero from row 8 */
    render(v, s_img);
    for (unsigned y = 0; y < 12; y++) {
        assert(s_img[y * COLS] == (y < 4 ? s_a[y * COLS] :
                                  y < 8 ? s_a[y * COLS + 1] : s_b[y * COLS]));
        assert(s_img[y * COLS + 1] == (y < 4 ? s_a[y * COLS + 1] :
                                      y < 8 ? s_a[y * COLS + 1] : s_b[y * COLS + 1]));
    }
    assert(v->lineState[LINE_ZERO + 3].r1 == 0x60);
    assert(v->lineState[LINE_ZERO + 4].r1 == 0x20);
    assert(v->lineState[LINE_ZERO + 7].r8 == 0x02);
    assert(v->lineState[LINE_ZERO + 8].r8 == 0x22);

    /* Writes during VBlank carry to the following active line zero. */
    v9938_frame_start(v);
    v9938_set_frame_time(v, 0, FRAME_TICKS);
    write_register(v, 1, 0x20);
    write_register(v, 8, 0x02);
    render(v, s_img);
    assert(s_img[0] == s_a[1] && s_img[0] != s_a[0]);
    assert(s_img[10 * COLS] == s_a[10 * COLS + 1]);
    v9938_destroy(v);
}

/* Without v9938_frame_start() the VDP keeps its single-snapshot behaviour, so
 * existing callers and tests are unaffected. */
static void test_legacy_single_snapshot(void)
{
    V9938 *vdp = v9938_create();
    if (!vdp) {
        fprintf(stderr, "Failed to create V9938\n");
        exit(1);
    }
    setup_screen5(vdp);
    write_register(vdp, 23, 0x00);
    render(vdp, s_a);
    write_register(vdp, 23, 0x01);
    render(vdp, s_b);
    /* Every row used the last written scroll value. */
    for (unsigned y = 0; y < ROWS; y += 8)
        assert(differing_pixels(s_a, s_b, y) > 32);

    /* A frame time reported outside a started frame latches nothing per line:
     * the frame stays a single snapshot of the current registers. */
    v9938_set_frame_time(vdp, frame_time_for_raster(64), FRAME_TICKS);
    write_register(vdp, 23, 0x00);
    render(vdp, s_img);
    for (unsigned y = 0; y < ROWS; y++)
        for (unsigned x = 0; x < COLS; x++)
            assert(s_img[y * COLS + x] == s_a[y * COLS + x]);
    v9938_destroy(vdp);
}

int main(void)
{
    V9938 *vdp = v9938_create();
    if (!vdp) {
        fprintf(stderr, "Failed to create V9938\n");
        return 1;
    }
    setup_screen5(vdp);

    test_frame_time_mapping(vdp);
    test_horizontal_retrace_status(vdp);
    test_vertical_scroll_split(vdp);
    test_display_page_split(vdp);
    test_aleste_vblank_hud_state(vdp);
    v9938_destroy(vdp);
    test_sprite_register_split();
    test_blanking_and_tp_split();
    test_legacy_single_snapshot();

    printf("vdp_raster_split_test: all checks passed\n");
    return 0;
}
