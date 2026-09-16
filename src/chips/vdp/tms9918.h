#ifndef TMS9918_H
#define TMS9918_H

#include "msx_types.h"

/* TMS9918A MSX1 VDP. Port protocol matches real hardware (see
 * Docs/TMS9918_MSX1_VDP.md):
 *   - 0x98: VRAM data port (auto-increment, direction from last addr set)
 *   - 0x99: two-byte control commands (register write = value + 0x80|reg;
 *           address set = low byte + (high&0x3F)|0x40 for write, no 0x40
 *           for read); second byte decides the command type.
 *   - 0x99 read: status register, bit 7 = sync flag; clears the IRQ latch. */
typedef struct {
    uint8_t *vram;
    UInt16 vram_size;      /* 16384 (16 KB) */
    uint8_t reg[16];       /* VDP registers 0-15 (0-7 used on MSX1) */
    UInt16 addr;           /* current VRAM latch address */
    int write_mode;        /* 1 = VRAM write, 0 = VRAM read */
    int pending;           /* first byte of a two-byte control command */
    int irq;               /* sync IRQ pending; cleared on status read */
} TMS9918;

TMS9918* tms9918_create(void);
void tms9918_destroy(TMS9918 *vdp);
UInt8 tms9918_read_reg(TMS9918 *vdp, UInt16 port);
void tms9918_write_reg(TMS9918 *vdp, UInt16 port, UInt8 val);

/* Assert the sync IRQ if enabled (register 1, bit 6). Called once per
 * display frame by the run loop. */
void tms9918_gen_sync_irq(TMS9918 *vdp);

/* Render the current VDP screen as a 256x192 32bpp XRGB8888 frame into
 * *out (row pitch of pitch BYTES). Handles text mode (screen 0),
 * Graphics I (screen 1), Graphics II (screen 2) and multicolor (screen 3). */
void tms9918_render(const TMS9918 *vdp, uint32_t *out, int pitch);

#endif /* TMS9918_H */