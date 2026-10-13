/* Isolated renderer test: GRAPHICS 2 with a known pattern.
 * Verifies tms9918_render() reads name/color/pattern from the correct VRAM
 * addresses (name 0x3800, color 0x0000, pattern 0x2000 for R2=0x0E R3=0x7F
 * R4=0x07) and paints a non-black, geometrically-correct image. */
#include <stdio.h>
#include <string.h>
#include "msx_types.h"
#include "tms9918.h"

#define W 256
#define H 192

int g_tms_trace = 0;

int main(void)
{
    static uint32_t fb[W * H];
    TMS9918 *vdp = tms9918_create();
    if (!vdp) { printf("create failed\n"); return 1; }

    /* Registers as observed in a game using GRAPHICS 2, name@0x3800. */
    vdp->reg[0] = 0x02; vdp->reg[1] = 0xE2; vdp->reg[2] = 0x0E;
    vdp->reg[3] = 0x7F; vdp->reg[4] = 0x07; vdp->reg[7] = 0xE4;

    memset(vdp->vram, 0, vdp->vram_size);

    /* Character 1: solid block. Color byte 0x1E (fg=black, bg=grey) for all 8 lines,
     * placed in the row-group-0 color window at charNum*8 + line7 = 8..15. */
    for (int l = 0; l < 8; l++) vdp->vram[0x0000 + 1 * 8 + l] = 0x1E;
    for (int l = 0; l < 8; l++) vdp->vram[0x2000 + 1 * 8 + l] = 0xFF;

    /* Name table at 0x3800: first 8 cells = char 1 (solid block). */
    for (int c = 0; c < 8; c++) vdp->vram[0x3800 + c] = 1;

    memset(fb, 0, sizeof(fb));
    tms9918_render(vdp, fb, W * 4);

    /* MSX palette: backdrop 4 is dark blue; foreground 1 is black. */
    const uint32_t BACKDROP = 0x5455EDu, FG = 0x000000u;
    int nfg = 0, nbg = 0;
    for (int i = 0; i < W * H; i++) {
        if (fb[i] == FG) nfg++; else if (fb[i] == BACKDROP) nbg++;
    }
    printf("fg(black) pixels = %d  (expect 8 cells * 8x8 = 512)\n", nfg);
    printf("bg(blue) pixels = %d  (expect 49152-512 = 48640)\n", nbg);

    /* Cells 0-7 of text row 0 are char 1 (solid 0xFF) -> x 0..63 black. */
    int row0_ok = 1;
    for (int x = 0; x < 64; x++) if (fb[x] != FG) row0_ok = 0;
    for (int x = 64; x < W; x++) if (fb[x] != BACKDROP) row0_ok = 0;
    printf("row 0: x0..63 fg, x64..255 bg -> %s\n", row0_ok ? "PASS" : "FAIL");

    /* Text row 1 (y 8..15) starts at name[32] = char 0 -> all backdrop. */
    int row1_ok = 1;
    for (int y = 8; y < 16; y++)
        for (int x = 0; x < W; x++)
            if (fb[y * W + x] != BACKDROP) row1_ok = 0;
    printf("row 1: all backdrop -> %s\n", row1_ok ? "PASS" : "FAIL");

    /* Name table must be read from 0x3800, not 0x0000. Poison 0x3800 cell 0
     * with char 1 and clear 0x0000's first name byte; output must go black. */
    vdp->vram[0x0000] = 0; vdp->vram[0x3800] = 1;
    for (int y = 0; y < 8; y++)
        for (int x = 0; x < 8; x++) fb[y * W + x] = BACKDROP;
    tms9918_render(vdp, fb, W * 4);
    int name_ok = fb[0] == FG;
    printf("name@0x3800 cell0 = char1 -> row0 x0 = %06x (%s)\n",
           fb[0], fb[0] == FG ? "PASS" : "FAIL");

    /* Colour window must be 0x0000, pattern window 0x2000. */
    vdp->vram[0x0008] = 0x1E; vdp->vram[0x2008] = 0xFF; /* restore solid */
    memset(fb, 0, sizeof(fb));
    tms9918_render(vdp, fb, W * 4);
    uint32_t before = fb[0];
    vdp->vram[0x2008] = 0x00; /* break the PATTERN byte */
    memset(fb, 0, sizeof(fb));
    tms9918_render(vdp, fb, W * 4);
    int pattern_ok = fb[0] != before;
    printf("pattern@0x2008 poison changes output -> %s\n",
           fb[0] != before ? "PASS" : "FAIL");
    vdp->vram[0x2008] = 0xFF;
    memset(fb, 0, sizeof(fb));
    tms9918_render(vdp, fb, W * 4);
    uint32_t base0 = fb[0];
    vdp->vram[0x0008] = 0x0F; /* break the COLOUR byte */
    memset(fb, 0, sizeof(fb));
    tms9918_render(vdp, fb, W * 4);
    printf("colour@0x0008 poison changes output -> %s\n",
           fb[0] != base0 ? "PASS" : "FAIL");

    int pass = (nfg == 512) && (nbg == 48640) && row0_ok && row1_ok &&
               name_ok && pattern_ok && (fb[0] != base0);
    printf("\nRESULT: %s\n", pass ? "PASS" : "FAIL");
    tms9918_destroy(vdp);
    return pass ? 0 : 1;
}
