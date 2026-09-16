#include "tms9918.h"
#include "msx_font.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Classic MSX1 16-color palette as 32bpp XRGB8888. */
static const uint32_t k_msx_palette[16] = {
    0x000000u, 0x000000u, 0x21C842u, 0x5EDC78u,
    0x5455EDu, 0x7D76F0u, 0xD45252u, 0x42EBF5u,
    0xFC5554u, 0xFF7974u, 0xD4C154u, 0xE6CE80u,
    0x21B05Bu, 0xC95BBAu, 0xCCCCCCu, 0xFFFFFFu
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
    vdp->reg[7] = 0xF1;      /* sensible default: white fg, black bg */
    vdp->addr = 0;
    vdp->write_mode = 1;
    vdp->pending = 0;
    vdp->irq = 0;

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
            /* Status register: bit 7 = sync flag. Reading clears it. */
            UInt8 s = vdp->irq ? 0x80u : 0x00u;
            vdp->irq = 0;
            return s;
        }
        default:
            return 0;
    }
}

void tms9918_write_reg(TMS9918 *vdp, UInt16 port, UInt8 val) {
    switch (port) {
        case 0x98:
            if (vdp->write_mode) {
                vdp->vram[vdp->addr & (vdp->vram_size - 1)] = val;
                vdp->addr = (vdp->addr + 1) & (vdp->vram_size - 1);
            }
            break;
        case 0x99:
            /* Two-byte control commands; the second byte decides the type.
             *   second & 0x80      -> register write: reg[second&0x0F]=first
             *   else               -> address set (0x40 bit = write mode) */
            if (!vdp->pending) {
                vdp->pending = val;
            } else {
                UInt8 first = vdp->pending;
                vdp->pending = 0;
                if (val & 0x80) {
                    vdp->reg[val & 0x0F] = first;
                } else {
                    vdp->addr = (UInt16)first | ((UInt16)(val & 0x3F) << 8);
                    vdp->write_mode = (val & 0x40) ? 1 : 0;
                }
            }
            break;
        default:
            break;   /* 0x9A-0x9F not present on a real MSX1 TMS9918 */
    }
}

void tms9918_gen_sync_irq(TMS9918 *vdp) {
    if (vdp->reg[1] & 0x40) vdp->irq = 1;
}

/* ------------------------------------------------------------------ */
/* Renderer. Each mode writes into a 256x192 32bpp target buffer with  */
/* row pitch in bytes; pixel (x, y) goes to out[y*pitch/4 + x].        */
/* ------------------------------------------------------------------ */

static void render_text(const TMS9918 *vdp, uint32_t *out, int pitch,
                        UInt16 name_ba, UInt16 pat_ba, int fg, int bg) {
    (void)pat_ba;   /* text mode uses the fixed ROM font, not a VRAM pattern base */
    const int cols = 40, rows = 24;
    for (int row = 0; row < rows; row++) {
        for (int col = 0; col < cols; col++) {
            UInt8 ch = vdp->vram[name_ba + row * cols + col];
            for (int py = 0; py < 8; py++) {
                /* Text-mode glyphs come from the fixed TMS9918A ROM font, not VRAM. */
                UInt8 byte = k_msx_font[ch * 8 + py];
                uint32_t *line = out + (row * 8 + py) * pitch;
                for (int px = 0; px < 6; px++) {
                    int c = (byte & (0x80u >> px)) ? fg : bg;
                    line[col * 6 + px] = k_msx_palette[c & 0x0F];
                }
            }
        }
    }
}

static void render_graphics1(const TMS9918 *vdp, uint32_t *out, int pitch,
                             UInt16 name_ba, UInt16 pat_ba, int fg, int bg) {
    const int cols = 32, rows = 24;
    for (int row = 0; row < rows; row++) {
        for (int col = 0; col < cols; col++) {
            UInt8 ch = vdp->vram[name_ba + row * cols + col];
            for (int py = 0; py < 8; py++) {
                UInt8 byte = vdp->vram[pat_ba + ch * 8 + py];
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
                             UInt16 name_ba, UInt16 pat_ba, UInt16 col_ba) {
    const int cols = 32, rows = 24;
    const UInt16 mask = vdp->vram_size - 1;
    for (int row = 0; row < rows; row++) {
        for (int col = 0; col < cols; col++) {
            UInt8 ch = vdp->vram[name_ba + row * cols + col];
            for (int py = 0; py < 8; py++) {
                UInt16 off = (UInt16)(ch * 8 + py);
                UInt8 byte = vdp->vram[(pat_ba + off) & mask];
                UInt8 color = vdp->vram[(col_ba + off) & mask];
                int fg = (color >> 4) & 0x0F;   /* high nibble = 1 pixels */
                int bg = color & 0x0F;          /* low nibble = 0 pixels */
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
                              UInt16 name_ba, UInt16 pat_ba) {
    const UInt16 mask = vdp->vram_size - 1;
    for (int line = 0; line < 192; line++) {
        uint32_t *dst = out + line * pitch;
        int nameRow = line / 8;
        int patRow = (line / 4) & 7;
        for (int col = 0; col < 64; col++) {
            UInt8 ch = vdp->vram[name_ba + nameRow * 32 + (col / 2)];
            UInt8 byte = vdp->vram[(pat_ba + (UInt16)(ch * 8 + patRow)) & mask];
            int cl = (byte >> 4) & 0x0F;
            int cr = byte & 0x0F;
            int sx = (col / 2) * 8;
            for (int k = 0; k < 4; k++) dst[sx + k] = k_msx_palette[cl];
            for (int k = 4; k < 8; k++) dst[sx + k] = k_msx_palette[cr];
        }
    }
}

void tms9918_render(const TMS9918 *vdp, uint32_t *out, int pitch) {
    int pitch_px = pitch / 4;
    UInt16 mask = vdp->vram_size - 1;
    int m1 = (vdp->reg[0] & 0x02) ? 1 : 0;
    int m2 = (vdp->reg[1] & 0x08) ? 1 : 0;
    int m3 = (vdp->reg[1] & 0x01) ? 1 : 0;
    int fg = vdp->reg[7] & 0x0F;
    int bg = (vdp->reg[7] >> 4) & 0x0F;

    UInt16 name_ba = (UInt16)((vdp->reg[2] & 0x0F) << 10) & mask;
    UInt16 pat_ba = (UInt16)((vdp->reg[4] & 0x07) << 11);
    UInt16 col_ba = (UInt16)((vdp->reg[3] & 0x7F) << 6);

    if (pitch_px < 256) return;

    if (m1 && !m2 && !m3) {
        /* Text mode: pattern base uses only 2 register bits. */
        pat_ba = (UInt16)((vdp->reg[4] & 0x03) << 11);
        render_text(vdp, out, pitch_px, name_ba, pat_ba, fg, bg);
    } else if (m3) {
        render_multicolor(vdp, out, pitch_px, name_ba, pat_ba);
    } else if (m2) {
        render_graphics2(vdp, out, pitch_px, name_ba, pat_ba, col_ba);
    } else {
        render_graphics1(vdp, out, pitch_px, name_ba, pat_ba, fg, bg);
    }
}