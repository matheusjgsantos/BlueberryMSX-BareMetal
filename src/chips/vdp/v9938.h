#ifndef V9938_H
#define V9938_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#define V9938_COMMAND_HISTORY_CAPACITY 1024
#define V9938_STATUS_HISTORY_CAPACITY 1024
#define V9938_VRAM_ACCESS_HISTORY_CAPACITY 2048
#define V9938_TRANSFER_HISTORY_CAPACITY 16384

/* NTSC V9938 frame height in raster lines. */
#define V9938_FRAME_LINES 262

/* Display registers latched per raster line. A program may rewrite the
 * display address while the frame is being scanned (a raster split, e.g. a
 * fixed HUD followed by a scrolled playfield); the renderer must draw each
 * line with the values that were in effect while that line was scanned. */
typedef struct {
    uint8_t r2;  /* R#2 display page / name table base */
    uint8_t r7;  /* R#7 backdrop (colour 0) */
    uint8_t r23; /* R#23 vertical scroll */
    uint8_t r25; /* R#25 horizontal scroll high + page select */
    uint8_t r26; /* R#26 horizontal scroll high bits */
    uint8_t r27; /* R#27 horizontal scroll low bits */
} V9938_LineState;

typedef struct {
    uint32_t sequence;
    uint32_t cpuTime;
    uint16_t cpuPc;
    uint8_t registers[15]; /* R#32 through R#46, inclusive. */
} V9938_CommandEvent;

typedef struct {
    uint32_t sequence;
    uint32_t cpuTime;
    uint16_t cpuPc;
    uint8_t reg;   /* status register selected by R#15 (0-9). */
    uint8_t value;
} V9938_StatusEvent;

typedef struct {
    uint32_t sequence;
    uint32_t address;
    uint8_t data;
    uint8_t write;
} V9938_VramAccessEvent;

typedef struct {
    uint32_t sequence;
    uint32_t commandSequence;
    uint32_t cpuTime;
    uint32_t address;
    uint8_t command;
    uint8_t data;
    uint8_t trReadyBefore;
} V9938_TransferEvent;

/* V9938 MSX2 VDP */
typedef struct {
    uint8_t reg[64];
    uint8_t status[10];
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
    uint8_t commandColor;
    uint8_t commandBusy;
    uint32_t commandBusyUntil;
    /* R#19 line (H-blank) interrupt: latched when the beam reaches the
     * selected line, reported and acknowledged by reading S#1 bit 0. */
    uint8_t hintPending;
    uint32_t commandCounts[256];
    uint32_t commandSequence;
    uint32_t traceCpuTime;
    uint16_t traceCpuPc;
    V9938_CommandEvent commandHistory[V9938_COMMAND_HISTORY_CAPACITY];
    uint16_t commandHistoryNext;
    uint16_t commandHistoryCount;
    uint32_t statusReadSequence;
    V9938_StatusEvent statusReadHistory[V9938_STATUS_HISTORY_CAPACITY];
    uint16_t statusReadHistoryNext;
    uint16_t statusReadHistoryCount;
    uint32_t vramAccessSequence;
    uint32_t vramReadCount;
    uint32_t vramWriteCount;
    uint32_t vramReadsByBank[8];
    uint32_t vramWritesByBank[8];
    V9938_VramAccessEvent vramAccessHistory[V9938_VRAM_ACCESS_HISTORY_CAPACITY];
    uint16_t vramAccessHistoryNext;
    uint16_t vramAccessHistoryCount;
    uint32_t transferDataSequence;
    V9938_TransferEvent transferHistory[V9938_TRANSFER_HISTORY_CAPACITY];
    uint16_t transferHistoryNext;
    uint16_t transferHistoryCount;
    /* Per-raster-line display state for the frame currently being scanned.
     * lineStateValid is cleared until the host announces a frame boundary, so
     * a bare v9938_write/render sequence keeps using one register snapshot. */
    V9938_LineState lineState[V9938_FRAME_LINES];
    uint8_t lineStateValid;
    uint16_t currentLine;
} V9938;

V9938* v9938_create(void);
void v9938_destroy(V9938 *vdp);
uint8_t v9938_read(V9938 *vdp, unsigned addr);
void v9938_write(V9938 *vdp, unsigned addr, uint8_t data);
uint8_t v9938_read_port(V9938 *vdp, unsigned port);
void v9938_write_port(V9938 *vdp, unsigned port, uint8_t data);
void v9938_gen_sync_irq(V9938 *vdp);
int v9938_irq_pending(const V9938 *vdp);

/* Announce the start of a scanned frame: the per-raster-line display state is
 * seeded from the current registers and subsequent register writes are
 * latched for the lines that have not been scanned yet. Call once per frame,
 * before the CPU runs, for correct raster-split rendering. */
void v9938_frame_start(V9938 *vdp);

/* Report the CPU's position inside the frame (elapsed/frame in master ticks)
 * so register writes can be attributed to the raster line being scanned.
 * Call before dispatching a VDP port write. */
void v9938_set_frame_time(V9938 *vdp, unsigned elapsed, unsigned frameTicks);
/* Record the CPU's current emulated master-clock time for the next VDP I/O. */
void v9938_set_trace_cpu_time(V9938 *vdp, uint32_t cpuTime);
void v9938_set_trace_cpu_pc(V9938 *vdp, uint16_t cpuPc);

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
