#include "tms9918.h"
#include "msx_font.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Classic MSX1 16-color palette as 32bpp XRGB8888. */
static const uint32_t k_msx_palette[16] = {
    0x000000u, /* 0  black */
    0x000000u, /* 1  black */
    0x21C842u, /* 2  medium green */
    0x5EDC78u, /* 3  light green */
    0x5455EDu, /* 4  dark blue */
    0x7D76FCu, /* 5  light blue */
    0xD4524Du, /* 6  dark red */
    0x42EBF5u, /* 7  cyan */
    0xFC5554u, /* 8  medium red */
    0xFF7978u, /* 9  light red */
    0xD4C154u, /* 10 dark yellow */
    0xE6CE80u, /* 11 light yellow */
    0x21B03Bu, /* 12 dark green */
    0xC95BBAu, /* 13 magenta */
    0xCCCCCCu, /* 14 grey */
    0xFFFFFFu, /* 15 white */
};

TMS9918* tms9918_create(void) {
    TMS9918 *vdp = (TMS9918*)malloc(sizeof(TMS9918));
    if (!vdp) return NULL;

    vdp->vram_size = 16384;
    vdp->vram = (uint8_t*)calloc(1, vdp->vram_size);
    if (!vdp->vram) {
        free(vdp);
        return NULL;
    }

    memset(vdp->reg, 0, sizeof(vdp->reg));
    vdp->reg[7] = 0xF1;      /* default: white fg, black bg */
    vdp->addr = 0;
    vdp->write_mode = 1;
    vdp->pending = 0;
    vdp->key = 0;
    vdp->irq = 0;
    vdp->status = 0;
    vdp->fifth_sprite = -1;

    return vdp;
}

void tms9918_destroy(TMS9918 *vdp) {
    if (!vdp) return;
    free(vdp->vram);
    free(vdp);
}

UInt8 tms9918_read_reg(TMS9918 *vdp, UInt16 port) {
    switch (port) {
        case 0x98:
            /* Reading VRAM data only delivers data in read mode. */
            if (!vdp->write_mode) {
                UInt8 v = vdp->vram[vdp->addr & (vdp->vram_size - 1)];
                vdp->addr = (vdp->addr + 1) & (vdp->vram_size - 1);
                return v;
            }
            return 0;
        case 0x99: {
            /* Status register S#0. Reading clears the sync flag (bit 7), the
             * 5S flag (bit 6) and the collision flag (bit 5) but keeps bits
             * 4-0 (openMSX SpriteChecker::resetStatus -> statusReg0 & 0x1F). */
            UInt8 s = (UInt8)((vdp->irq ? 0x80u : 0x00u) | (vdp->status & 0x7Fu));
            vdp->irq = 0;
            vdp->status &= 0x1Fu;
            return s;
        }
        default:
            return 0;
    }
}

unsigned tms9918_w98 = 0;   /* host instrumentation: count of 0x98 data writes */
unsigned tms9918_w99 = 0;   /* host instrumentation: count of 0x99 control writes */
unsigned tms9918_w98_dropped = 0;   /* 0x98 writes seen with write_mode==0 */

void tms9918_write_reg(TMS9918 *vdp, UInt16 port, UInt8 val) {
    extern int g_tms_trace;
    switch (port) {
        case 0x98:
            tms9918_w98++;
            /* MSX1 TMS99x8A convention (R3 reference, VDP.c:1184-1224):
             * 0x98 data writes are UNCONDITIONAL — no "write mode" gate.
             * The address is set by a two-byte 0x99 command; the 0x98 data
             * port just stores at vramAddress[addr] and increments. */
            vdp->vram[vdp->addr & (vdp->vram_size - 1)] = val;
            if (g_tms_trace)
                printf("    [TMS-98] addr=%04X = %02X\n", vdp->addr, val);
            vdp->addr = (vdp->addr + 1) & (vdp->vram_size - 1);
            break;
        case 0x99:
            tms9918_w99++;
            /* Two-byte control commands, MSX1 TMS99x8A semantics. Mirrors the
             * R3 reference (BlueberryMSX-2.0plus/Src/VideoChips/VDP.c:1189-1203,
             * case VDP_TMS9929A: VDP_TMS99x8A) exactly:
             *
             *   first byte B1:  addr low  = B1,  latch B1, key = 1
             *   second byte B2: addr high = (B2 & 0x3fff) >> 8
             *       if !(B2 & 0x40):
             *           if B2 & 0x80  -> register write reg[B2 & 0x0F] = B1
             *           else           -> read setup (0x98 reads return VRAM)
             *       else               -> address set (write mode)
             *
             * The key flag (not "pending == 0") tracks the latch state, which
             * is essential: 0x00 is a legal B1 (address low=0 / reg value=0).
             * The previous code used pending==0 as "no latch", so any command
             * whose first byte was 0x00 desynced the byte stream one byte late
             * and scrambled all subsequent register/address decode. */
            if (!vdp->key) {
                vdp->addr = (vdp->addr & 0x3F00) | val;
                vdp->pending = val;
                vdp->key = 1;
            } else {
                vdp->addr = (((UInt16)val << 8) | (vdp->addr & 0xFF)) & 0x3FFF;
                if (!(val & 0x40)) {
                    if (val & 0x80) {
                        vdp->reg[val & 0x0F] = vdp->pending;
                        /* Writing R0 clears the sync flag, the 5S/collision
                         * status bits and the vertical interrupt latch
                         * (openMSX VDP::writeRegister case 0 ->
                         * SpriteChecker::resetStatus()). */
                        if ((val & 0x0F) == 0) {
                            vdp->status &= 0x1Fu;
                            vdp->irq = 0;
                        }
                        if (g_tms_trace)
                            printf("    [TMS-99] REG R%d = %02X (B1=%02X B2=%02X)\n",
                                   val & 0x0F, vdp->pending, vdp->pending, val);
                    } else {
                        vdp->write_mode = 0;   /* read setup */
                        if (g_tms_trace)
                            printf("    [TMS-99] READ-set (B1=%02X B2=%02X) addr=%04X\n",
                                   vdp->pending, val, vdp->addr);
                    }
                } else {
                    vdp->write_mode = 1;       /* address set -> write mode */
                    if (g_tms_trace)
                        printf("    [TMS-99] ADDR = %04X (B1=%02X B2=%02X)\n",
                               vdp->addr, vdp->pending, val);
                }
                vdp->key = 0;
            }
            break;
        default:
            break;   /* 0x9A-0x9F not present on a real MSX1 TMS9918 */
    }
}

void tms9918_gen_sync_irq(TMS9918 *vdp) {
    /* INTEN = R1 bit 5 (0x20). R1 bit 6 (0x40) is BLANK (display on/off),
     * NOT the interrupt-enable bit. Confirmed against openMSX
     * (VDP.cc: controlRegs[1] & 0x20 -> irqVertical.set()) and
     * BlueberryMSX-2.0plus (VDP.c: vdpRegs[1] & 0x20 -> boardSetInt). */
    if (vdp->reg[1] & 0x20) vdp->irq = 1;
}

/* ------------------------------------------------------------------ */
/* Renderer. Each mode writes into a 256x192 32bpp target buffer with  */
/* row pitch in bytes; pixel (x, y) goes to out[y*pitch/4 + x].        */
/* ------------------------------------------------------------------ */

static void render_text(const TMS9918 *vdp, uint32_t *out, int pitch,
                        UInt16 name_ba, int cols, int gpx, int fg, int bg) {
    const UInt16 mask = vdp->vram_size - 1;
    const int rows = 24;
    for (int row = 0; row < rows; row++) {
        for (int col = 0; col < cols; col++) {
            /* Text-mode glyphs come from the fixed TMS9918A ROM font, not VRAM. */
            UInt8 ch = vdp->vram[(name_ba + (UInt16)(row * cols + col)) & mask];
            for (int py = 0; py < 8; py++) {
                UInt8 byte = k_msx_font[ch * 8 + py];
                uint32_t *line = out + (row * 8 + py) * pitch;
                for (int px = 0; px < gpx; px++) {
                    int c = (byte & (0x80u >> px)) ? fg : bg;
                    line[col * gpx + px] = k_msx_palette[c & 0x0F];
                }
            }
        }
    }
}

static void render_graphics1(const TMS9918 *vdp, uint32_t *out, int pitch,
                             UInt16 name_ba, UInt16 pat_ba, UInt16 col_ba,
                             int backdrop) {
    const int cols = 32, rows = 24;
    const UInt16 mask = vdp->vram_size - 1;
    for (int row = 0; row < rows; row++) {
        for (int col = 0; col < cols; col++) {
            UInt8 ch = vdp->vram[(name_ba + (UInt16)(row * cols + col)) & mask];
            /* Graphics1 color table: one byte per 8 chars, high nibble = fg. */
            UInt8 color = vdp->vram[(col_ba + (UInt16)(ch >> 3)) & mask];
            int fg = (color >> 4) & 0x0F;
            int bg = color & 0x0F;
            if (fg == 0) fg = backdrop;   /* transparent -> backdrop */
            if (bg == 0) bg = backdrop;
            for (int py = 0; py < 8; py++) {
                UInt8 byte = vdp->vram[(pat_ba + (UInt16)(ch * 8 + py)) & mask];
                uint32_t *line = out + (row * 8 + py) * pitch;
                for (int px = 0; px < 8; px++) {
                    int c = (byte & (0x80u >> px)) ? fg : bg;
                    line[col * 8 + px] = k_msx_palette[c & 0x0F];
                }
            }
        }
    }
}

static void render_graphics2(const TMS9918 *vdp, uint32_t *out, int pitch,
                             UInt16 name_ba, int backdrop, int reg3, int reg4) {
    const int cols = 32, rows = 24;
    const UInt16 mask = vdp->vram_size - 1;
    /* GRAPHICS 2 window decode, following openMSX VDP::updateColorBase /
     * updatePatternBase.  Each table is a setMask() window whose address is
     *
     *     addr = effectiveBaseMask & (indexMask | index)
     *
     * with indexMask == ~0 << 13, so bits 0-12 come from `index` and bit 13+
     * from the base.  On TMS99XX the color base register R3 leaks into the
     * pattern base, so both windows are built from R3 *and* R4. */
    const UInt16 col_eff = (UInt16)((((UInt16)reg3 << 6) | 0x003F) & mask);
    const UInt16 pat_eff = (UInt16)((((UInt16)reg4 << 11) |
                                     (((UInt16)reg3 & 0x1F) << 6) | 0x003F) & mask);
    for (int row = 0; row < rows; row++) {
        for (int col = 0; col < cols; col++) {
            /* openMSX renderGraphic2 (CharacterConverter.cc):
             *   quarter8 = (((line / 8) * 32) & ~0xFF) * 8   -> (row / 8) << 11
             *   line7    = line & 7                          -> py
             * The color byte is indexed exactly like the pattern byte, i.e.
             * GRAPHICS 2 keeps one color byte per character *per scanline*, and
             * the three row-groups live in separate 0x800 regions. */
            UInt16 ch = vdp->vram[(name_ba + (UInt16)(row * cols + col)) & mask];
            for (int py = 0; py < 8; py++) {
                UInt16 off = (UInt16)(((UInt16)(row >> 3) << 11) + (UInt16)(ch * 8) + py);
                UInt8 byte = vdp->vram[((pat_eff & 0xE000) | (pat_eff & off)) & mask];
                UInt8 color = vdp->vram[((col_eff & 0xE000) | (col_eff & off)) & mask];
                int fg = (color >> 4) & 0x0F;   /* high nibble = 1 pixels */
                int bg = color & 0x0F;          /* low nibble = 0 pixels */
                if (fg == 0) fg = backdrop;
                if (bg == 0) bg = backdrop;
                uint32_t *line = out + (row * 8 + py) * pitch;
                for (int px = 0; px < 8; px++) {
                    int c = (byte & (0x80u >> px)) ? fg : bg;
                    line[col * 8 + px] = k_msx_palette[c & 0x0F];
                }
            }
        }
    }
}

static void render_multicolor(const TMS9918 *vdp, uint32_t *out, int pitch,
                              UInt16 name_ba, UInt16 pat_ba, int backdrop) {
    const UInt16 mask = vdp->vram_size - 1;
    for (int line = 0; line < 192; line++) {
        uint32_t *dst = out + line * pitch;
        int nameRow = line / 8;
        int patRow = (line / 4) & 7;
        for (int col = 0; col < 64; col++) {
            UInt8 ch = vdp->vram[(name_ba + (UInt16)(nameRow * 32 + (col / 2))) & mask];
            UInt8 byte = vdp->vram[(pat_ba + (UInt16)(ch * 8 + patRow)) & mask];
            int cl = byte & 0x0F;            /* lower nibble = left block */
            int cr = (byte >> 4) & 0x0F;     /* upper nibble = right block */
            if (cl == 0) cl = backdrop;
            if (cr == 0) cr = backdrop;
            int sx = (col / 2) * 8;
            for (int k = 0; k < 4; k++) dst[sx + k] = k_msx_palette[cl];
            for (int k = 4; k < 8; k++) dst[sx + k] = k_msx_palette[cr];
        }
    }
}

/* ------------------------------------------------------------------ */
/* Sprites, sprite mode 1.                                             */
/* ------------------------------------------------------------------ */

/* openMSX DisplayMode: the display mode byte is YAE YJK M5..M1, assembled as
 *   ((R0 & 0x0E) << 1) | ((R1 & 0x08) >> 2) | ((R1 & 0x10) >> 4)
 * of which only M5..M1 (the low five bits) select the base mode.
 * DisplayMode::getSpriteMode() returns 0 (no sprite engine) for TEXT1 (0x01),
 * TEXT1Q (0x05), TEXT2 (0x09), the unnamed base 0x03 (MSX1 SCREEN 3) and every
 * V9938 bitmap base, and 1 for GRAPHIC1 (0x00), MULTICOLOR (0x02), GRAPHIC2
 * (0x04) and MULTIQ (0x06). A TMS9918 has no R0 bits 1-3, so only the bases
 * 0..3 are reachable in practice. */
static int sprite_mode1(const TMS9918 *vdp) {
    int base = ((vdp->reg[0] & 0x0E) << 1)
             | ((vdp->reg[1] & 0x08) >> 2)
             | ((vdp->reg[1] & 0x10) >> 4);
    switch (base) {
        case 0x00:   /* GRAPHIC1   */
        case 0x02:   /* MULTICOLOR */
        case 0x04:   /* GRAPHIC2   */
        case 0x06:   /* MULTIQ     */
            return 1;
        default:     /* TEXT1, TEXT1Q, TEXT2, 0x03 and all bitmap modes */
            return 0;
    }
}

static void render_sprites(TMS9918 *vdp, uint32_t *out, int pitch_px) {
    /* openMSX VDP::spritesEnabled(): the display mode must support sprites,
     * blanking (R1.6) must be off, and the VDP-level sprite enable (R8.1)
     * must be set. R8 does not exist on a TMS9918, so reg[8] stays 0. */
    if (((vdp->reg[1] & 0x40) == 0) || (vdp->reg[8] & 0x02) ||
        !sprite_mode1(vdp))
        return;

    const UInt16 mask = vdp->vram_size - 1;
    const int size     = (vdp->reg[1] & 0x02) ? 16 : 8;  /* R1.1: 16x16 */
    const int scale    = (vdp->reg[1] & 0x01) ?  2 : 1;  /* R1.0: magnified */
    const int width    = size * scale;                    /* pixels per row */
    const int pat_mask = (size == 16) ? 0xFC : 0xFF;
    /* Windowed base addresses: base = (reg << shift) | ~(~0 << shift), then
     * & indexMask, so the register's low bits fall into the index and only
     * bits 7-12 (attribute) resp. 11-13 (pattern) survive. R11 does not exist
     * on a TMS9918, so the attribute base is (R5 & 0x7F) << 7. */
    const UInt16 attr_ba = (UInt16)((vdp->reg[5] & 0x7F) << 7);
    const UInt16 pat_ba  = (UInt16)((vdp->reg[6] & 0x07) << 11);

    /* The sprite list ends at Y = 208 (0xD0). Its length is what ends up in
     * S#0 bits 0-4 when no 5th sprite condition occurred. */
    int n_sprites = 0;
    while (n_sprites < 32 &&
           vdp->vram[(attr_ba + n_sprites * 4) & mask] != 208)
        n_sprites++;

    vdp->fifth_sprite = -1;
    int collision = 0;

    for (int line = 0; line < 192; line++) {
        uint32_t *dst = out + line * pitch_px;
        /* Pixels already taken by a sprite on this line, for the collision
         * flag. openMSX compares every sprite pair and ignores off-screen
         * pixels, which is what the clipping below does. */
        UInt64 occ[4] = { 0, 0, 0, 0 };
        /* Visible sprites of this line, at most 4. */
        const UInt8 *draw[4];
        int rows[4];
        int visible = 0;

        for (int s = 0; s < n_sprites; s++) {
            const UInt8 *a = vdp->vram + ((attr_ba + s * 4) & mask);
            /* The VDP evaluates sprites one line before they appear, so the
             * attribute Y is one less than the first screen line of the
             * sprite (openMSX SpriteChecker::checkSprites1: "This is the line
             * sprites are checked at; the line they are displayed at is one
             * lower"). */
            int row = (line - 1 - a[0]) & 0xFF;
            if (row >= width) continue;          /* not on this line */

            if (visible == 4) {
                /* Fifth sprite on one line. Only the earliest such line counts,
                 * and only while neither F (bit 7) nor 5S (bit 6) is set. */
                if (vdp->fifth_sprite < 0 &&
                    ((vdp->status & 0x40u) | (vdp->irq ? 0x80u : 0u)) == 0)
                    vdp->fifth_sprite = s;
                break;                            /* max 4 sprites per line */
            }
            draw[visible] = a;
            rows[visible] = row;
            visible++;
        }

        /* Draw the highest sprite index first so that the lowest index ends up
         * on top (BlueberryMSX SpriteLine.h: `while (visibleCnt--)`; openMSX
         * drawMode1 walks the visible span backwards). */
        while (visible--) {
            const UInt8 *a = draw[visible];
            int row = rows[visible];
            int pattern = a[2] & pat_mask;
            int pat_row = row / scale;            /* magnified: rows doubled */
            /* One scanline of the sprite as `size` bits, bit (size-1) being
             * the leftmost pixel. A 16x16 sprite takes its left 8 columns from
             * pattern n and its right 8 columns from pattern n+2, i.e. 16
             * bytes further in the pattern generator (openMSX
             * SpriteChecker::calculatePatternNP puts the left byte at bit 24
             * and the right byte at bit 16 of a 32-bit pattern whose bit 31 is
             * the leftmost pixel; SpriteConverter::drawMode1 walks it with
             * `pattern & 0x8000'0000`). */
            UInt16 bits;
            if (size == 16) {
                bits = (UInt16)(vdp->vram[(pat_ba + pattern * 8 +
                                          pat_row) & mask] << 8);
                bits |= vdp->vram[(pat_ba + pattern * 8 + pat_row + 16) & mask];
            } else {
                bits = vdp->vram[(pat_ba + pattern * 8 + pat_row) & mask];
            }

            /* Expand to `width` pixels, doubling each source pixel when
             * magnified (openMSX SpriteChecker::doublePattern). */
            UInt32 pat = 0;
            UInt32 block = (UInt32)(1u << scale) - 1;
            for (int i = 0; i < size; i++)
                if (bits & (1u << (size - 1 - i)))
                    pat |= block << (width - scale - i * scale);

            /* Attribute bit 7 = early clock, i.e. shifted 32 pixels left. */
            int x = a[1] - ((a[3] & 0x80) ? 32 : 0);
            int color = a[3] & 0x0F;

            for (int i = 0; i < width; i++) {
                if (!(pat & (1u << (width - 1 - i)))) continue;
                int px = x + i;
                if (px < 0 || px > 255) continue;
                if (occ[px >> 6] & ((UInt64)1 << (px & 63))) collision = 1;
                occ[px >> 6] |= (UInt64)1 << (px & 63);
                /* Color 0 is transparent in sprite mode 1, but on MSX1 it
                 * still takes part in collision detection
                 * (openMSX VDP::canSpriteColor0Collide: isMSX1VDP() true). */
                if (color) dst[px] = k_msx_palette[color];
            }
        }
    }

    /* S#0 sprite bits, following the tail of openMSX SpriteChecker::
     * checkSprites1. The 5S and collision bits are sticky: they survive until
     * the CPU reads the status register or writes R0. */
    UInt8 status = vdp->status & 0x7Fu;
    if (vdp->fifth_sprite >= 0 && !(status & 0x40u) && !vdp->irq)
        status = (UInt8)(0x40 | (status & 0x20) | vdp->fifth_sprite);
    if (!(status & 0x40))
        status = (UInt8)((status & 0x20) | (n_sprites > 31 ? 31 : n_sprites));
    if (collision) status |= 0x20;
    vdp->status = status;
}

void tms9918_render(TMS9918 *vdp, uint32_t *out, int pitch) {
    int pitch_px = pitch / 4;
    if (pitch_px < 256) return;

    /* R7 color bits: high nibble = foreground (text color), low nibble =
     * background (backdrop).  In graphics modes the per-character colors come
     * from the color table; R7 supplies the backdrop when a color is 0. */
    int bg = vdp->reg[7] & 0x0F;
    int r0 = vdp->reg[0], r1 = vdp->reg[1];

    /* Base address decode, following openMSX VDP::updateNameBase /
     * updateColorBase / updatePatternBase (and identically BlueberryMSX
     * VDP.c chrTabBase / colTabBase):
     *   base = (reg << shift) | ~(~0 << shift)      then & vramMask
     * The register's low bits land in the index (acting as a mask); only the
     * high bits survive & indexMask to become the window base. */
    int is_text = (r1 & 0x10) != 0;   /* M1: 1 = text, 0 = graphics */
    UInt16 name_ba = is_text ? (UInt16)((vdp->reg[2] & 0x0C) << 10)
                             : (UInt16)((vdp->reg[2] & 0x0F) << 10);
    UInt16 col_ba  = (UInt16)(((vdp->reg[3] << 6) | 0x003F) & 0x3FC0);
    UInt16 pat_ba  = (UInt16)((vdp->reg[4] & 0x07) << 11);

    /* Mode decode per openMSX DisplayMode:
     *   M1 = R1.4, M2 = R1.3, G2 = R0.1, TEXT2 = R0.2 (with M1 set).
     *   M1=1            -> text (R0.2 picks 80-col TEXT2 vs 40-col TEXT1)
     *   M1=0, M2=1      -> multicolor
     *   M1=0, M2=0, G2=1-> graphics 2
     *   M1=0, M2=0, G2=0-> graphics 1
     * Note R1.6 is *display enable* (not blank) and R1.5 is the VBlank IRQ. */
    if (is_text) {
        int fg = (vdp->reg[7] >> 4) & 0x0F;
        if (r0 & 0x04)
            render_text(vdp, out, pitch_px, name_ba, 80, 3, fg, bg);
        else
            render_text(vdp, out, pitch_px, name_ba, 40, 6, fg, bg);
    } else if (r1 & 0x08) {
        render_multicolor(vdp, out, pitch_px, name_ba, pat_ba, bg);
    } else if (r0 & 0x02) {
        render_graphics2(vdp, out, pitch_px, name_ba, bg,
                         vdp->reg[3], vdp->reg[4]);
    } else {
        render_graphics1(vdp, out, pitch_px, name_ba, pat_ba, col_ba, bg);
    }

    /* Sprites are drawn on top of the background. */
    render_sprites(vdp, out, pitch_px);
}
