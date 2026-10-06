#ifndef TMS9918_H
#define TMS9918_H

#ifdef __cplusplus
extern "C" {
#endif

#include "msx_types.h"

/* TMS9918A MSX1 VDP. Port protocol matches real hardware (see
 * Docs/TMS9918_MSX1_VDP.md):
 *   - 0x98: VRAM data port (auto-increment, direction from last addr set)
 *   - 0x99: two-byte control commands (register write = value + 0x80|reg;
 *           address set = low byte + (high&0x3F)|0x40 for write, no 0x40
 *           for read); second byte decides the command type.
 *   - 0x99 read: status register (S#0): bit 7 = sync flag, bit 6 = 5S flag,
 *           bit 5 = collision, bits 4-0 = number of the first sprite that
 *           exceeded the 4-sprites-per-line limit. Reading clears the sync
 *           flag, the 5S flag and the collision flag (but not bits 4-0);
 *           writing register 0 clears them as well. */
typedef struct {
    uint8_t *vram;
    UInt16 vram_size;      /* 16384 (16 KB) */
    uint8_t reg[16];       /* VDP registers 0-15 (0-7 used on MSX1) */
    UInt16 addr;           /* current VRAM latch address */
    int write_mode;        /* 1 = VRAM write, 0 = VRAM read */
    int pending;           /* first byte of a two-byte control command */
    int key;               /* 1 = first byte already latched (R3 vdpKey) */
    int irq;               /* sync IRQ pending; cleared on status read */
    UInt8 status;          /* S#0 sprite bits: 6 = 5S, 5 = collision,
                              4-0 = 5th sprite number. Bit 7 (sync flag)
                              lives in `irq`. The 5S/collision bits are sticky
                              and only cleared by a status read or an R0
                              write. */
    int fifth_sprite;      /* Index of the first sprite exceeding the 4-sprite
                              per-line limit, on the earliest line where that
                              happens; -1 when there was none. Scratch value
                              of one render pass. */
} TMS9918;

TMS9918* tms9918_create(void);
void tms9918_destroy(TMS9918 *vdp);
UInt8 tms9918_read_reg(TMS9918 *vdp, UInt16 port);
void tms9918_write_reg(TMS9918 *vdp, UInt16 port, UInt8 val);

/* Assert the sync IRQ if INTEN (register 1, bit 5 = 0x20) is set. Called
 * once per display frame by the run loop. */
void tms9918_gen_sync_irq(TMS9918 *vdp);

/* Render the current VDP screen as a 256x192 32bpp XRGB8888 frame into
 * *out (row pitch of pitch BYTES). Handles text mode (screen 0),
 * Graphics I (screen 1), Graphics II (screen 2) and multicolor (screen 3),
 * and draws sprite mode 1 sprites on top of the background.
 * Not const because the sprite pass updates the S#0 5S/collision flags. */
void tms9918_render(TMS9918 *vdp, uint32_t *out, int pitch);

#ifdef __cplusplus
}
#endif

#endif /* TMS9918_H */