#ifndef V9938_H
#define V9938_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

/* V9938 MSX2 VDP */
typedef struct {
    uint8_t reg[64];
    uint8_t status[4];
    uint8_t vram[0x20000];
    uint8_t palette[16][3];
    uint16_t address;
    uint8_t readBuffer;
    uint8_t latch;
    uint8_t controlLatch;
    uint8_t controlPending;
    uint8_t statusSelect;
    uint8_t irq;
    uint8_t paletteIndex;
    uint8_t paletteFirst;
    uint8_t palettePending;
    uint8_t transferCommand, transferOp, transferMode;
    uint16_t transferX, transferY;
    uint16_t transferRowX, transferRowN;
    int16_t transferStepX, transferStepY;
    uint16_t transferRemainingX, transferRemainingY;
    uint16_t transferRowWidth;
    uint8_t transferActive;
    uint8_t transferData;
    uint8_t transferColorPending;
} V9938;

V9938* v9938_create(void);
void v9938_destroy(V9938 *vdp);
uint8_t v9938_read(V9938 *vdp, unsigned addr);
void v9938_write(V9938 *vdp, unsigned addr, uint8_t data);
uint8_t v9938_read_port(V9938 *vdp, unsigned port);
void v9938_write_port(V9938 *vdp, unsigned port, uint8_t data);
void v9938_gen_sync_irq(V9938 *vdp);
int v9938_irq_pending(const V9938 *vdp);

/* Render the current VDP screen as a 256x192 32bpp XRGB8888 frame into
 * *out (row pitch of pitch BYTES). */
void v9938_render(V9938 *vdp, uint32_t *out, int pitch);

/* Get pointer to the VRAM */
uint8_t *v9938_get_vram(V9938 *vdp);

/* Peek register value */
uint8_t v9938_peek_register(const V9938 *vdp, unsigned reg);
uint8_t v9938_peek_status(const V9938 *vdp, unsigned reg);

#ifdef __cplusplus
}
#endif

#endif /* V9938_H */
