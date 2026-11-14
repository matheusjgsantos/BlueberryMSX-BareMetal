#include "v9938.h"
#include "tms9918.h"
#include <string.h>
#include <stdlib.h>

static void sync_d0_command_busy(V9938 *v);

#define MAX(a, b) ((a) > (b) ? (a) : (b))

#ifdef V9938_TRACE
/* Diagnostic counters for host-test/vdp_usage_probe.c (compiled out of the
 * target build). */
unsigned v9938_trace_cmd[256];
unsigned v9938_trace_indirect[64];
unsigned v9938_trace_r44_stream;
unsigned v9938_trace_port9b;
unsigned v9938_trace_r44_total;
unsigned v9938_trace_complete;
unsigned v9938_trace_launches;
struct V9938TraceLaunch {
	uint8_t cmd, lo, arg;
	uint16_t dx, dy, sx, sy, nx, ny;
	unsigned r44;
} v9938_trace_launch[32];
#endif

static unsigned bitmap_mode(const V9938 *v)
{
    unsigned m = ((v->reg[0] & 0x0E) << 1) |
                 ((v->reg[1] & 0x08) >> 2) | ((v->reg[1] & 0x10) >> 4);
    return (m == 0x08 || m == 0x0C || m == 0x10 ||
            m == 0x14 || m == 0x1C) ? m : 0;
}

static void record_command(V9938 *v, uint8_t command)
{
	V9938_CommandEvent *event = &v->commandHistory[v->commandHistoryNext];
	event->sequence = ++v->commandSequence;
	event->cpuTime = v->traceCpuTime;
	event->cpuPc = v->traceCpuPc;
	memcpy(event->registers, &v->reg[32], sizeof event->registers);
	v->commandCounts[command]++;
	v->commandHistoryNext = (uint16_t)((v->commandHistoryNext + 1) %
					    V9938_COMMAND_HISTORY_CAPACITY);
	if (v->commandHistoryCount < V9938_COMMAND_HISTORY_CAPACITY)
		v->commandHistoryCount++;
}

static void record_status_read(V9938 *v, unsigned reg, uint8_t value)
{
	V9938_StatusEvent *event =
		&v->statusReadHistory[v->statusReadHistoryNext];
	event->sequence = ++v->statusReadSequence;
	event->cpuTime = v->traceCpuTime;
	event->cpuPc = v->traceCpuPc;
	event->reg = (uint8_t)reg;
	event->value = value;
	v->statusReadHistoryNext = (uint16_t)((v->statusReadHistoryNext + 1) %
						 V9938_STATUS_HISTORY_CAPACITY);
	if (v->statusReadHistoryCount < V9938_STATUS_HISTORY_CAPACITY)
		v->statusReadHistoryCount++;
}

static void record_vram_access(V9938 *v, unsigned address, uint8_t data,
				int isWrite)
{
	V9938_VramAccessEvent *event =
		&v->vramAccessHistory[v->vramAccessHistoryNext];
	event->sequence = ++v->vramAccessSequence;
	event->address = address & 0x1FFFF;
	event->data = data;
	event->write = (uint8_t)(isWrite != 0);
	if (isWrite)
	{
		v->vramWriteCount++;
		v->vramWritesByBank[event->address >> 14]++;
	}
	else
	{
		v->vramReadCount++;
		v->vramReadsByBank[event->address >> 14]++;
	}
	v->vramAccessHistoryNext = (uint16_t)((v->vramAccessHistoryNext + 1) %
					       V9938_VRAM_ACCESS_HISTORY_CAPACITY);
	if (v->vramAccessHistoryCount < V9938_VRAM_ACCESS_HISTORY_CAPACITY)
		v->vramAccessHistoryCount++;
}

static void record_transfer_data(V9938 *v, unsigned command,
				 unsigned address, uint8_t data, uint8_t trReadyBefore)
{
	V9938_TransferEvent *event = &v->transferHistory[v->transferHistoryNext];
	event->sequence = ++v->transferDataSequence;
	event->commandSequence = v->commandSequence;
	event->cpuTime = v->traceCpuTime;
	event->address = address & 0x1FFFFu;
	event->command = (uint8_t)command;
	event->data = data;
	event->trReadyBefore = trReadyBefore;
	v->transferHistoryNext = (uint16_t)((v->transferHistoryNext + 1) %
					    V9938_TRANSFER_HISTORY_CAPACITY);
	if (v->transferHistoryCount < V9938_TRANSFER_HISTORY_CAPACITY)
		v->transferHistoryCount++;
}

static unsigned mode_width(unsigned m) { return (m == 0x10 || m == 0x14) ? 512 : 256; }
static unsigned mode_mask(unsigned m) { return m == 0x10 ? 3 : (m == 0x1C ? 255 : 15); }

static unsigned pixel_addr(unsigned m, unsigned x, unsigned y)
{
    switch (m) {
    case 0x0C: return ((y & 1023) << 7) | ((x & 255) >> 1);
    case 0x10: return ((y & 1023) << 7) | ((x & 511) >> 2);
    case 0x14: return (((y & 511) << 7) | ((x & 511) >> 2) | ((x & 2) << 15)) & 0x1FFFF;
    default:   return (((y & 511) << 7) | ((x & 255) >> 1) | ((x & 1) << 16)) & 0x1FFFF;
    }
}

static unsigned pixel_shift(unsigned m, unsigned x)
{
    return m == 0x10 ? (((~x) & 3) << 1) : (m == 0x1C ? 0 : (((~x) & 1) << 2));
}

static uint8_t pixel_get(const V9938 *v, unsigned m, unsigned x, unsigned y)
{
    unsigned s = pixel_shift(m, x);
    /* MXS is a V9958 feature; a V9938 always addresses all 128 KiB. */
    unsigned address = pixel_addr(m, x, y) & 0x1FFFF;
    return (uint8_t)((v->vram[address] >> s) & mode_mask(m));
}

/* Raster origin of the display area. Mirrors the reference VDP
 * scheduleDisplayStart: 3 vsync + 13 top erase + 9 top border lines, ten
 * lines less in 212-line mode (212-line mode starts the active area ten
 * lines earlier), plus the R#18 vertical set-adjust. */
static unsigned display_line_zero(const V9938 *v)
{
    return 3u + 13u + 9u + ((v->reg[9] & 0x80) ? 0u : 10u) +
           (((v->reg[18] >> 4) ^ 0x07) & 0x0Fu);
}

/* Raster line where the R#19 line (H-blank) interrupt is pulsed. R#19 counts
 * visible lines from the top of the display area, so the R#23 vertical scroll
 * shifts it, exactly as the reference VDP does in scheduleHint(). */
static unsigned hint_line(const V9938 *v)
{
    return (display_line_zero(v) + ((v->reg[19] - v->reg[23]) & 0xFFu)) %
           V9938_FRAME_LINES;
}

static void line_state_current(const V9938 *v, V9938_LineState *ls)
{
    ls->r2 = v->reg[2];
    ls->r7 = v->reg[7];
    ls->r23 = v->reg[23];
    ls->r25 = v->reg[25];
    ls->r26 = v->reg[26];
    ls->r27 = v->reg[27];
}

/* A display register changed while the current raster line is being scanned:
 * the new value applies to this line and every line after it in the frame. */
static void line_state_record(V9938 *v)
{
    V9938_LineState ls;
    unsigned first;
    if (!v->lineStateValid) return;
    line_state_current(v, &ls);
    first = v->currentLine < V9938_FRAME_LINES ? v->currentLine : 0;
    for (unsigned i = first; i < V9938_FRAME_LINES; i++)
        v->lineState[i] = ls;
}

/* Raster line whose display state applies to framebuffer row y. The 192-line
 * framebuffer starts at the top of the display area in 192-line mode and ten
 * lines into it in 212-line mode; both start on the same raster line. */
static unsigned frame_line_for_row(const V9938 *v, unsigned y)
{
    unsigned line = display_line_zero(v) +
                    ((v->reg[9] & 0x80) ? 10u : 0u) + y;
    return line < V9938_FRAME_LINES ? line : V9938_FRAME_LINES - 1;
}

static const V9938_LineState *line_state_for_row(const V9938 *v, unsigned y,
                                                 V9938_LineState *fallback)
{
    if (!v->lineStateValid) {
        line_state_current(v, fallback);
        return fallback;
    }
    return &v->lineState[frame_line_for_row(v, y)];
}

void v9938_frame_start(V9938 *v)
{
    V9938_LineState ls;
    if (!v) return;
    line_state_current(v, &ls);
    for (unsigned i = 0; i < V9938_FRAME_LINES; i++) v->lineState[i] = ls;
    v->currentLine = (uint16_t)((display_line_zero(v) +
                      ((v->reg[9] & 0x80) ? 212u : 192u)) %
                      V9938_FRAME_LINES);
    v->lineStateValid = 1;
}

void v9938_set_frame_time(V9938 *v, unsigned elapsed, unsigned frameTicks)
{
    unsigned base, offset, previous;
    if (!v || !frameTicks) return;
    /* The vertical (frame) interrupt is raised when the display area ends, so
     * frame time zero is the bottom of the active area. */
    base = display_line_zero(v) + ((v->reg[9] & 0x80) ? 212u : 192u);
    /* frame_ticks is one NTSC frame (357954 master ticks), so the product
     * stays within 32 bits and this can be called at CPU instruction cadence. */
    unsigned scaled = elapsed * V9938_FRAME_LINES;
    offset = scaled / frameTicks;
    previous = v->currentLine;
    v->currentLine = (uint16_t)((base + offset) % V9938_FRAME_LINES);
    /* Line (H-blank) interrupt: latch when the beam reaches the line selected
     * by R#19, but only while R#0 bit 4 (IE1) enables it - the reference only
     * raises INT_IE1 from onHint() in that case. The flag is reported and
     * acknowledged by reading S#1 bit 0; with IE1 disabled S#1 bit 0 is the
     * live H-blank pulse instead of a latched request. */
    if ((v->reg[0] & 0x10) && v->currentLine != previous &&
        v->currentLine == hint_line(v)) {
        v->hintPending = 1;
        v->irq = 1;
    }
    /* openMSX VDP::getHR(): in graphics modes HR is high for 312 of the 1368
     * master clocks in each line. Frame time zero is VSCAN, aligned with the
     * display-start horizontal phase (HSYNC + left erase = 202 clocks). */
    unsigned remainder = scaled % frameTicks;
    unsigned horizontal = 202u + remainder * 1368u / frameTicks;
    horizontal %= 1368u;
    if ((horizontal + 1368u - 59u) % 1368u < 312u)
        v->status[2] |= 0x20;
    else
        v->status[2] &= (uint8_t)~0x20;
}

void v9938_set_trace_cpu_time(V9938 *v, uint32_t cpuTime)
{
	if (v)
	{
		v->traceCpuTime = cpuTime;
		sync_d0_command_busy(v);
	}
}

void v9938_set_trace_cpu_pc(V9938 *v, uint16_t cpuPc)
{
	if (v) v->traceCpuPc = cpuPc;
}

static unsigned display_line_at(const V9938 *v, const V9938_LineState *ls,
                                unsigned y)
{
    /* The application framebuffer is 192 lines high. In 212-line mode the
     * active display starts 10 raster lines earlier than in the 192-line
     * mode; keep the logical framebuffer centered on the V9938 active area. */
    /* Bitmap scanout wraps its display Y counter at 256 lines. R#23 is a
     * scroll offset, not part of the command engine's 10-bit VRAM Y. */
    return (y + ((v->reg[9] & 0x80) ? 10u : 0u) + ls->r23) & 0xFF;
}

static unsigned display_scroll_x_at(const V9938 *v, const V9938_LineState *ls,
                                    unsigned m)
{
    int scroll = ((int)(ls->r26 & 0x3F) << 3) - (int)(ls->r27 & 7);
    unsigned wide = (ls->r25 & ((ls->r2 >> 5) & 1)) != 0;
    unsigned width = mode_width(m);
    (void)v;
    if (!wide) scroll &= 0xFF;
    return (unsigned)scroll & (width - 1);
}

static uint8_t display_pixel_get(const V9938 *v, const V9938_LineState *ls,
                                 unsigned m, unsigned x, unsigned y)
{
    unsigned shift = pixel_shift(m, x);
    unsigned base = ((unsigned)ls->r2 << 10) & 0x1FFFF;
    unsigned line = display_line_at(v, ls, y);
    /* In bitmap modes the scanline address replaces R#2's low 15 bits.
     * R#2 bit 5 selects the 32 KiB bitmap page; R#25 bit 0 can select the
     * lower page on 128 KiB V9938s. Do not treat R#2 as a simple byte offset:
     * that exposes unrelated font/item tables when a game writes values such
     * as R#2=$1F. */
    base &= ~0x7FFFu;
    if (ls->r25 & 1) base &= ~0x8000u;
    unsigned address = (base | pixel_addr(m, x, line)) & 0x1FFFF;
    return (uint8_t)((v->vram[address] >> shift) & mode_mask(m));
}

static uint8_t logical_op(uint8_t d, uint8_t s, uint8_t keep, unsigned op)
{
    switch (op & 15) {
    case 0: return (uint8_t)((d & keep) | s);
    case 1: return (uint8_t)(d & (s | keep));
    case 2: return (uint8_t)(d | s);
    case 3: return (uint8_t)(d ^ s);
    case 4: return (uint8_t)((d & keep) | (~s & ~keep));
    case 8: return s ? (uint8_t)((d & keep) | s) : d;
    case 9: return s ? (uint8_t)(d & (s | keep)) : d;
    case 10:return s ? (uint8_t)(d | s) : d;
    case 11:return s ? (uint8_t)(d ^ s) : d;
    case 12:return s ? (uint8_t)((d & keep) | (~s & ~keep)) : d;
    default:return d;
    }
}

/* SCREEN 5 high-speed commands work on packed VRAM bytes, not individual
 * pixels: one command X step addresses two horizontal pixels. */
static unsigned command_x(const V9938 *v, unsigned low, unsigned high)
{
	return v->reg[low] | ((unsigned)(v->reg[high] & 1) << 8);
}

static unsigned command_y(const V9938 *v, unsigned low, unsigned high)
{
	return v->reg[low] | ((unsigned)(v->reg[high] & 3) << 8);
}

static unsigned command_pixels_per_byte(unsigned mode)
{
	switch (mode) {
	case 0x10: return 4; /* SCREEN 6: four 2-bit dots per byte. */
	case 0x14: return 2; /* SCREEN 7: two dots per byte, alternating pages. */
	case 0x1C: return 1; /* SCREEN 8: one 8-bit dot per byte. */
	default:   return 2; /* SCREEN 5. */
	}
}

static unsigned command_byte_width(const V9938 *v, unsigned mode)
{
	unsigned ppb = command_pixels_per_byte(mode);
	unsigned lineWidth = mode_width(mode);
	unsigned widthPixels = v->reg[40] | ((unsigned)(v->reg[41] & 3) << 8);
	if (!widthPixels) widthPixels = lineWidth;
	unsigned width = widthPixels / ppb;
	if (!width) width = 1;
	unsigned dx = command_x(v, 36, 37);
	unsigned sx = command_x(v, 32, 33);
	unsigned xbyte = dx / ppb;
	unsigned lineBytes = lineWidth / ppb;
	if ((v->reg[46] & 0xF0) == 0xD0)
	{
		unsigned sxbyte = sx / ppb;
		unsigned edge = (v->reg[45] & 0x04)
			? (xbyte < sxbyte ? xbyte : sxbyte) + 1
			: lineBytes - (xbyte > sxbyte ? xbyte : sxbyte);
		return width < edge ? width : edge;
	}
	if (v->reg[45] & 0x04)
		return width < xbyte + 1 ? width : xbyte + 1;
	return width < lineBytes - xbyte ? width : lineBytes - xbyte;
}

static unsigned command_y_width(const V9938 *v, unsigned dx, unsigned mode)
{
	unsigned ppb = command_pixels_per_byte(mode);
	unsigned xbyte = dx / ppb;
	unsigned lineBytes = mode_width(mode) / ppb;
	if (xbyte >= lineBytes) return 1;
	return (v->reg[45] & 0x04) ? xbyte + 1 : lineBytes - xbyte;
}

static unsigned command_height(const V9938 *v, unsigned dy, unsigned sy,
			      unsigned op)
{
	unsigned height = v->reg[42] | ((unsigned)(v->reg[43] & 3) << 8);
	if (!height) height = 1024;
	if (v->reg[45] & 0x08)
	{
		unsigned limit = (op == 0xD0 || op == 0xE0)
			? (dy < sy ? dy : sy) + 1 : dy + 1;
		if (height > limit) height = limit;
	}
	return height;
}

static unsigned command_read_mask(const V9938 *v)
{
	/* MXS/MXD page selection only exists on the V9958 (extended VRAM).
	 * On a V9938 both command windows always cover the full 128 KiB. */
	(void)v;
	return 0x1FFFFu;
}

static unsigned command_write_mask(const V9938 *v)
{
	(void)v;
	return 0x1FFFFu;
}

static unsigned command_pixel_width(const V9938 *v, unsigned dx,
				   unsigned sx, unsigned op)
{
	unsigned limit = mode_width(bitmap_mode(v));
	if (dx >= limit || (op == 0x90 && sx >= limit)) return 1;
	unsigned width = v->reg[40] | ((unsigned)(v->reg[41] & 3) << 8);
	if (!width) width = limit;
	unsigned reverse = (v->reg[45] & 0x04) != 0;
	unsigned edge = reverse ? dx + 1 : limit - dx;
	if (op == 0x90)
	{
		unsigned sourceEdge = reverse ? sx + 1 : limit - sx;
		if (edge > sourceEdge) edge = sourceEdge;
	}
	if (edge > limit) edge = 1;
	return width < edge ? width : edge;
}

static unsigned command_pixel_height(const V9938 *v, unsigned dy,
				    unsigned sy, unsigned op)
{
	unsigned height = v->reg[42] | ((unsigned)(v->reg[43] & 3) << 8);
	if (!height) height = 1024;
	if (v->reg[45] & 0x08)
	{
		unsigned edge = (op == 0x90 ? (dy < sy ? dy : sy) : dy) + 1;
		if (height > edge) height = edge;
	}
	return height;
}

static void command_logical_pixel(V9938 *v, unsigned mode,
				  unsigned x, unsigned y,
				  uint8_t source, unsigned op)
{
	unsigned raw = pixel_addr(mode, x, y) & 0x1FFFFu;
	unsigned readMask = command_read_mask(v);
	if (raw & ~readMask) return;
	unsigned shift = pixel_shift(mode, x);
	unsigned colorMask = mode_mask(mode);
	uint8_t mask = (uint8_t)(colorMask << shift);
	unsigned destination = raw & command_write_mask(v);
	uint8_t dest = (uint8_t)((v->vram[raw & readMask] >> shift) & colorMask);
	uint8_t result = logical_op(dest, source & colorMask, 0, op);
	v->vram[destination] = (uint8_t)((v->vram[destination] & ~mask) |
					  ((result & colorMask) << shift));
}

static void command_finish(V9938 *v)
{
#ifdef V9938_TRACE
	if (v->transferActive) v9938_trace_complete++;
#endif
	v->transferActive = 0;
	v->commandBusy = 0;
	/* S#2 CE (command executing). TR is left set: the reference clears it
	 * only on an S#7 colour read, not when the command completes. */
	v->status[2] &= (uint8_t)~0x01;
}

static void sync_d0_command_busy(V9938 *v)
{
#ifdef V9938_DIAGNOSTIC_TIMED_D0_CE
	if (v && v->commandBusy &&
	    (int32_t)(v->traceCpuTime - v->commandBusyUntil) >= 0)
		command_finish(v);
#else
	(void)v;
#endif
}

#ifdef V9938_DIAGNOSTIC_TIMED_D0_CE
static unsigned hmmm_timing_per_byte(const V9938 *v)
{
	static const uint8_t timing[4] = { 92, 136, 92, 97 };
	unsigned mode = v->reg[8] & 0x02;
	unsigned displayHeight = (v->reg[9] & 0x80) ? 212u : 192u;
	unsigned displayStart = display_line_zero(v);
	unsigned line = (v->currentLine + V9938_FRAME_LINES - displayStart) %
			V9938_FRAME_LINES;
	if ((v->reg[1] & 0x40) && line < displayHeight)
		mode |= 1;
	return timing[mode];
}
#endif

#ifdef V9938_TRACE
static void trace_launch(const V9938 *v, unsigned op, unsigned dx,
			 unsigned dy, unsigned sx, unsigned sy,
			 unsigned nx, unsigned ny)
{
	if (v9938_trace_launches < 32)
	{
		struct V9938TraceLaunch *l =
			&v9938_trace_launch[v9938_trace_launches];
		l->cmd = (uint8_t)op;
		l->lo = (uint8_t)(v->reg[46] & 0x0F);
		l->arg = v->reg[45];
		l->dx = (uint16_t)dx; l->dy = (uint16_t)dy;
		l->sx = (uint16_t)sx; l->sy = (uint16_t)sy;
		l->nx = (uint16_t)nx; l->ny = (uint16_t)ny;
		l->r44 = v9938_trace_r44_total;
	}
	v9938_trace_launches++;
}
#endif

/* LMMC (logical move CPU -> VRAM) and HMMC (high-speed move CPU -> VRAM)
 * take their data from writes to R#44 (COL): the colour register doubles as
 * the CPU data port. Every write to R#44 transfers one pixel (LMMC) or one
 * packed byte (HMMC). This follows openMSX VDPCmdEngine::executeLmmc /
 * executeHmmc and the blueMSX V9938 command engine; port 0x9B itself is
 * always an indirect register write and never a raw data port. */
static void command_color_write(V9938 *v, uint8_t data)
{
	if (!v->transferActive)
		return;
	uint8_t trReadyBefore = (uint8_t)((v->status[2] >> 7) & 1);
	if (v->transferCommand == 0xB0)
	{
		unsigned mode = v->transferMode;
		unsigned x = (v->transferX +
			      (int)v->transferRowX * v->transferStepX) &
			     (mode_width(mode) - 1);
		unsigned y = (v->transferY +
			      (int)v->transferRowN * v->transferStepY) & 0x3FF;
		command_logical_pixel(v, mode, x, y, data,
				      v->transferOp);
	}
	else if (v->transferCommand == 0xF0)
	{
		unsigned mode = v->transferMode;
		unsigned x = (v->transferX +
			      (int)v->transferRowX * v->transferStepX) &
			     (mode_width(mode) - 1);
		unsigned y = (v->transferY +
			      (int)v->transferRowN * v->transferStepY) & 0x3FF;
		unsigned raw = pixel_addr(mode, x, y) & 0x1FFFFu;
		if (!(raw & ~command_read_mask(v)))
		{
			v->vram[raw & command_write_mask(v)] = data;
			record_transfer_data(v, v->transferCommand, raw, data,
					     trReadyBefore);
		}
	}
	else
	{
		return;
	}

	v->transferRemainingX--;
	v->transferRowX++;
	if (!v->transferRemainingX)
	{
		if (++v->transferRowN >= v->transferRemainingY)
		{
			command_finish(v);
			return;
		}
		v->transferRemainingX = v->transferRowWidth;
		v->transferRowX = 0;
	}
	v->status[2] |= 0x80; /* TR: ready for the next data byte. */
}

static void command_start(V9938 *v, uint8_t command)
{
	unsigned op = command & 0xF0;
	/* A write to COL before CMD is latched as the first CPU->VDP transfer
	 * datum. Preserve that event across the R#46 command start. */
	uint8_t colorPending = v->transferColorPending;
	v->transferColorPending = 0;
	/* Any command write ends the previous one; CMD=0 is ABRT/STOP. */
	command_finish(v);
	unsigned mode = bitmap_mode(v);
	if ((op != 0x40 && op != 0x50 && op != 0x60 && op != 0x80 && op != 0x90 && op != 0xB0 && op != 0xC0 &&
	     op != 0xD0 && op != 0xE0 && op != 0xF0) ||
	    (mode != 0x0C && mode != 0x10 && mode != 0x14 && mode != 0x1C))
		return;

	unsigned dx = command_x(v, 36, 37);
	unsigned dy = command_y(v, 38, 39);
	unsigned sx = command_x(v, 32, 33);
	unsigned sy = command_y(v, 34, 35);
	unsigned pixelWidth = mode_width(mode);
	unsigned pixelMask = pixelWidth - 1;
	if (op == 0x40) /* POINT: result is returned in status register S#7. */
	{
		v->status[2] |= 0x01;
		v->status[7] = pixel_get(v, mode, sx, sy);
		command_finish(v);
		return;
	}
	if (op == 0x50) /* PSET */
	{
		v->status[2] |= 0x01;
		command_logical_pixel(v, mode, dx, dy, v->reg[44], command & 0x0F);
		command_finish(v);
		return;
	}
	if (op == 0x60) /* SRCH */
	{
		v->status[2] |= 0x01;
		v->status[2] &= (uint8_t)~0x10;
		int direction = (v->reg[45] & 0x04) ? -1 : 1;
		unsigned x = sx;
		uint8_t border = v->reg[44] & (uint8_t)mode_mask(mode);
		for (unsigned n = 0; n < pixelWidth; n++)
		{
			int equal = pixel_get(v, mode, x, sy) == border;
			if (equal == ((v->reg[45] & 0x02) != 0))
			{
				v->status[2] |= 0x10;
				break;
			}
			x = (unsigned)(x + direction) & pixelMask;
		}
		v->reg[32] = (uint8_t)x;
		v->reg[33] = (uint8_t)((v->reg[33] & 0xFE) | ((x >> 8) & 1));
		command_finish(v);
		return;
	}
	if (op == 0x80 || op == 0x90)
	{
		unsigned nx = command_pixel_width(v, dx, sx, op);
		unsigned ny = command_pixel_height(v, dy, sy, op);
		int stepX = (v->reg[45] & 0x04) ? -1 : 1;
		int stepY = (v->reg[45] & 0x08) ? -1 : 1;
#ifdef V9938_TRACE
		trace_launch(v, op, dx, dy, sx, sy, nx, ny);
#endif
		for (unsigned y = 0; y < ny; y++)
		{
			for (unsigned x = 0; x < nx; x++)
			{
				unsigned tx = (dx + (int)x * stepX) & pixelMask;
				unsigned ty = (dy + (int)y * stepY) & 0x3FF;
				uint8_t source = v->reg[44] & (uint8_t)mode_mask(mode);
				if (op == 0x90)
			{
				unsigned fromX = (sx + (int)x * stepX) & pixelMask;
				unsigned fromY = (sy + (int)y * stepY) & 0x3FF;
					source = pixel_get(v, mode, fromX, fromY);
			}
			/* LO occupies R#46's low nibble; R#45 is ARG (DIX/DIY/MXS/MXD). */
				command_logical_pixel(v, mode, tx, ty, source,
					      command & 0x0F);
			}
		}
		return;
	}
	if (op == 0xB0)
	{
		unsigned nx = command_pixel_width(v, dx, sx, op);
		unsigned ny = command_pixel_height(v, dy, sy, op);
		v->transferCommand = (uint8_t)op;
		v->transferOp = (uint8_t)(command & 0x0F);
		v->transferMode = (uint8_t)mode;
		v->transferX = (uint16_t)dx;
		v->transferY = (uint16_t)dy;
		v->transferRowWidth = (uint16_t)nx;
		v->transferRemainingX = (uint16_t)nx;
		v->transferRemainingY = (uint16_t)ny;
		v->transferRowX = 0;
		v->transferRowN = 0;
		v->transferStepX = (v->reg[45] & 0x04) ? -1 : 1;
		v->transferStepY = (v->reg[45] & 0x08) ? -1 : 1;
		v->transferActive = 1;
		v->status[2] = (uint8_t)((v->status[2] & (uint8_t)~0x81) | 0x81);
#ifdef V9938_TRACE
		trace_launch(v, op, dx, dy, sx, sy, nx, ny);
#endif
		if (colorPending)
			command_color_write(v, v->reg[44]);
		return;
	}
	if (op == 0xE0)
	{
		/* YMMM copies vertically at a fixed X. Unlike HMMM, NX is ignored;
		 * the command spans from DX to the horizontal edge in DIX direction. */
		unsigned nx = command_y_width(v, dx, mode);
		unsigned ny = command_height(v, dy, sy, op);
		unsigned ppb = command_pixels_per_byte(mode);
		int stepX = (v->reg[45] & 0x04) ? -(int)ppb : (int)ppb;
		int stepY = (v->reg[45] & 0x08) ? -1 : 1;
		for (unsigned y = 0; y < ny; y++)
		{
			unsigned fromY = (sy + (int)y * stepY) & 0x3FF;
			unsigned toY = (dy + (int)y * stepY) & 0x3FF;
			for (unsigned x = 0; x < nx; x++)
			{
				unsigned xPixel = (dx + (int)x * stepX) & pixelMask;
				unsigned src = pixel_addr(mode, xPixel, fromY) & 0x1FFFFu;
				unsigned dst = pixel_addr(mode, xPixel, toY) & 0x1FFFFu;
				if (!(src & ~command_read_mask(v)))
					v->vram[dst & command_write_mask(v)] =
						v->vram[src & command_read_mask(v)];
			}
		}
		command_finish(v);
		return;
	}

	unsigned ppb = command_pixels_per_byte(mode);
	unsigned nx = command_byte_width(v, mode);
	unsigned ny = command_height(v, dy, sy, op);
	v->transferCommand = (uint8_t)op;
	v->transferOp = command & 0x0F;
	v->transferMode = (uint8_t)mode;
	v->transferX = (uint16_t)dx;
	v->transferY = (uint16_t)dy;
	v->transferRowWidth = (uint16_t)nx;
	v->transferRemainingX = (uint16_t)nx;
	v->transferRemainingY = (uint16_t)ny;
	v->transferRowX = 0;
	v->transferRowN = 0;
	v->transferStepX = (v->reg[45] & 0x04) ? -(int16_t)ppb : (int16_t)ppb;
	v->transferStepY = (v->reg[45] & 0x08) ? -1 : 1;
	v->transferActive = 1;
	v->status[2] = (uint8_t)((v->status[2] & (uint8_t)~0x81) | 0x01);
	if (op == 0xF0)
	{
		v->status[2] |= 0x80; /* TR: transfer-ready. */
#ifdef V9938_TRACE
		trace_launch(v, op, dx, dy, sx, sy, nx, ny);
#endif
		if (colorPending)
			command_color_write(v, v->reg[44]);
		return;
	}

	for (unsigned y = 0; y < ny; y++)
	{
		for (unsigned x = 0; x < nx; x++)
		{
			unsigned tx = (dx + (int)x * v->transferStepX) & pixelMask;
			unsigned ty = (dy + (int)y * v->transferStepY) & 0x3FF;
			unsigned raw = pixel_addr(mode, tx, ty) & 0x1FFFFu;
			if (raw & ~command_read_mask(v)) continue;
			unsigned dst = raw & command_write_mask(v);
			if (op == 0xD0)
			{
				unsigned fromX = (sx + (int)x * v->transferStepX) & pixelMask;
				unsigned fromY = (sy + (int)y * v->transferStepY) & 0x3FF;
				unsigned src = pixel_addr(mode, fromX, fromY) & command_read_mask(v);
				v->vram[dst] = v->vram[src];
			}
			else
			{
				v->vram[dst] = v->reg[44];
			}
		}
	}
#ifdef V9938_DIAGNOSTIC_TIMED_D0_CE
	if (op == 0xD0 && nx && ny)
	{
		uint32_t duration = nx * ny * hmmm_timing_per_byte(v);
		v->commandBusyUntil = v->traceCpuTime + duration;
		v->commandBusy = 1;
		v->status[2] |= 0x01;
		return;
	}
#endif
	command_finish(v);
}

static uint32_t color(const V9938 *v, uint8_t index);

static void render_graphic3(V9938 *v, uint32_t *out, int pitch)
{
	unsigned mask = sizeof v->vram - 1;
	unsigned nameBase = ((unsigned)v->reg[2] << 10) &
			     ~((unsigned)(v->reg[25] & 1) << 15);
	unsigned colorBase = ((unsigned)v->reg[10] << 14) |
			     ((unsigned)v->reg[3] << 6) | 0x3F;
	unsigned patternBase = ((unsigned)v->reg[4] << 11) | 0x7FF;
	uint8_t backdrop = v->reg[7] & 0x0F;

	/* Graphic 3 (MSX SCREEN 4) uses the Graphic 2 character tables, but
	 * without the three-screen color/pattern split: each table is 8 KiB. */
	for (unsigned y = 0; y < 192; y++)
	{
		unsigned tileRow = y >> 3;
		unsigned rowInTile = y & 7;
		uint32_t *line = out + y * pitch;
		for (unsigned col = 0; col < 32; col++)
		{
			unsigned nameAddress = (nameBase + tileRow * 32 + col) & mask;
			unsigned character = v->vram[nameAddress];
			unsigned offset = ((tileRow >> 3) << 11) + character * 8 + rowInTile;
			unsigned patternAddress = ((patternBase & 0x1E000) |
						    (patternBase & offset)) & mask;
			unsigned colorAddress = ((colorBase & 0x1E000) |
					       (colorBase & offset)) & mask;
			uint8_t pattern = v->vram[patternAddress];
			uint8_t colors = v->vram[colorAddress];
			unsigned foreground = colors >> 4;
			unsigned background = colors & 0x0F;
			if (!foreground) foreground = backdrop;
			if (!background) background = backdrop;
			for (unsigned px = 0; px < 8; px++)
			{
				unsigned index = (pattern & (0x80u >> px))
					? foreground : background;
				line[col * 8 + px] = color(v, (uint8_t)index);
			}
		}
	}
}

static uint32_t color(const V9938 *v, uint8_t index)
{
    return ((uint32_t)(v->palette[index][0] * 255 / 7) << 16) |
           ((uint32_t)(v->palette[index][1] * 255 / 7) << 8) |
           (uint32_t)(v->palette[index][2] * 255 / 7);
}

/* SCREEN 8 stores direct 3:3:2 RGB pixels; unlike SCREEN 5-7 it does not
 * index the 16-entry V9938 palette, and color zero is opaque black. */
static uint32_t color_screen8(uint8_t pixel)
{
    unsigned red = (pixel >> 2) & 7;
    unsigned green = (pixel >> 5) & 7;
    unsigned blue = pixel & 3;
    blue = blue == 3 ? 7 : blue * 2;
    return ((uint32_t)(red * 255 / 7) << 16) |
           ((uint32_t)(green * 255 / 7) << 8) |
           (uint32_t)(blue * 255 / 7);
}

static void render_sprites2(V9938 *v, uint32_t *o, int pitch)
{
    if(!(v->reg[1]&0x40)||(v->reg[8]&2))return;
    int size=(v->reg[1]&2)?16:8,mag=(v->reg[1]&1)?2:1,span=size*mag;
    /* R#5 is an 8-bit register. Its bit 7 supplies the SAT address bit
     * immediately below the R#11 page bits; masking it loses the upper half
     * of the sprite table, which is where V-Killer stores its sprites. */
    unsigned table=((unsigned)(v->reg[11]&3)<<15)|((unsigned)v->reg[5]<<7);
    unsigned base=table&0x1FE00; /* SAT is aligned to 512 bytes. */
    /* In mode 2 the 512-byte color table immediately precedes the SAT. */
    unsigned colorBase=(base-512u)&0x1FFFF;
    unsigned pat=(unsigned)(v->reg[6]&0x3f)<<11,count=0;
    while(count<32&&v->vram[base+count*4]!=216)count++;
    for(int y=0;y<192;y++){
        uint8_t present[256]={0}, ccTop[256]={0}, sc[256]={0};
        unsigned visible=0;
        V9938_LineState fallback;
        const V9938_LineState *ls = line_state_for_row(v, (unsigned)y, &fallback);
        for(unsigned n=0;n<count;n++){
            unsigned a=base+n*4;const uint8_t *d=v->vram+(a&0x1ffff);int row=(y-d[0])&255;
            /* Hardware testing shows the active-area raster origin needs a
             * one-line correction relative to the SAT Y coordinate. */
            row=(row+((v->reg[9]&0x80)?10:0)+(ls->r23&255)-1)&255;
            if(row>=span) continue;
            if(visible++ == 8){
                v->status[0]=(uint8_t)((v->status[0]&0xA0)|0x40|(n&0x1F));
                break;
            }
            /* Mode-2 SAT entries are Y, X, pattern, reserved.  The old code
             * swapped X and pattern, producing misplaced sprites and fetching
             * unrelated pattern data.  The reference SpriteLine reads +1 for
             * X and +2 for the pattern number. */
            /* This framebuffer starts at the sprite's SAT X coordinate; do
             * not apply the reference rasterizer's internal -32/crop bias. */
            int sx=(int)d[1];
            uint8_t ca=v->vram[(colorBase+n*16u+(unsigned)(row/mag))&0x1FFFF];
            if(ca&0x80)sx-=32; /* EC: shift the complete sprite left 32 dots. */
            unsigned pattern=(unsigned)d[2];
            unsigned sourceRow=(unsigned)(row/mag);
            unsigned rowAddress;
            if(size==16){
                pattern &= 0xFC;
                rowAddress=pat+pattern*8u+sourceRow;
            }else rowAddress=pat+pattern*8u+sourceRow;
            for(int px=0;px<size;px++){
                unsigned byteAddress=rowAddress+(size==16&&px>=8?16u:0u);
                uint8_t bits=v->vram[byteAddress&0x1FFFF];
                if(!(bits&(0x80u>>(px&7))))continue;
                int screenX=sx+px*mag;
                for(int mx=0;mx<mag;mx++){
                    int xx=screenX+mx;
                    if(xx<0||xx>=256)continue;
                    if(present[xx]){
                        if(!(ca&0x20))v->status[0]|=0x20; /* IC disables collision. */
                        if((ca&0x40)&&!ccTop[xx])sc[xx]|=(uint8_t)(ca&0x0F);
                    }else{
                        present[xx]=1;
                        sc[xx]=(uint8_t)(ca&0x0F);
                        ccTop[xx]=(ca&0x40)!=0;
                    }
                }
            }
        }
        for(int x=0;x<256;x++){
            if(sc[x]&&present[x]){
                uint32_t c=color(v,sc[x]);
                o[y*pitch+x]=c;
            }
        }
    }
}

static void render_bitmap(V9938 *v, uint32_t *out, int pitch, unsigned m)
{
    for(int y=0;y<192;y++){
        V9938_LineState fallback;
        const V9938_LineState *ls = line_state_for_row(v, (unsigned)y, &fallback);
        unsigned wide = (ls->r25 & ((ls->r2 >> 5) & 1)) != 0;
        unsigned scroll = display_scroll_x_at(v, ls, m);
        for(int x=0;x<256;x++){
            /* SCREEN 6/7 are 512-dot modes. The platform framebuffer is
             * 256 pixels wide, so sample one pixel from each two-dot group
             * rather than silently displaying only the left half. */
            unsigned displayX = (m == 0x10 || m == 0x14) ? (unsigned)x * 2u
                                                         : (unsigned)x;
            unsigned sx = (displayX + scroll) &
                          ((wide || m == 0x10 || m == 0x14) ? 511u : 255u);
            uint8_t c = display_pixel_get(v, ls, m, sx, (unsigned)y);
            if (m == 0x1C) {
                out[y*pitch+x] = color_screen8(c);
                continue;
            }
            /* Color 0 is transparent in bitmap modes; show the backdrop. */
            if (c == 0) c = ls->r7 & 0x0F;
            out[y*pitch+x]=color(v,c);
        }
    }
}

V9938* v9938_create(void)
{
    V9938 *v = (V9938 *)calloc(1, sizeof *v);
    static const uint8_t colors[16][3] = {
        {0,0,0},{0,0,0},{1,6,1},{3,7,3},{1,1,7},{2,3,7},{5,1,1},{2,6,7},
        {7,1,1},{7,3,3},{6,6,1},{6,6,4},{1,4,1},{6,2,5},{5,5,5},{7,7,7}
    };
    if (!v) return NULL;
    memcpy(v->palette, colors, sizeof colors);
    v->status[0] = 0x9F;
    v->status[2] = 0x6C;
    return v;
}

void v9938_destroy(V9938 *v) { free(v); }

uint8_t v9938_read(V9938 *v, unsigned addr)
{
    if (!v) return 0xFF;
    if (addr < 64) return v->reg[addr];
    if (addr >= 0x98 && addr <= 0x9F) return v9938_read_port(v, addr);
    return 0xFF;
}

void v9938_write(V9938 *v, unsigned addr, uint8_t data)
{
    if (!v) return;
    if (addr < 64)
    {
#ifdef V9938_TRACE
		if (addr == 46) v9938_trace_cmd[data]++;
#endif
		v->reg[addr] = data;
		/* Display registers take effect from the raster line being scanned
		 * onwards; the split position is the CPU time of the write. */
		if (addr == 2 || addr == 7 || addr == 23 ||
		    addr == 25 || addr == 26 || addr == 27)
			line_state_record(v);
		if (addr == 44)
		{
			if (v->transferActive)
				command_color_write(v, data);
			else
				v->transferColorPending = 1;
		}
		if (addr == 46)
		{
			record_command(v, data);
			command_start(v, data);
		}
	}
    else if (addr >= 0x98 && addr <= 0x9F) v9938_write_port(v, addr, data);
}

static unsigned vram_address(const V9938 *v)
{
    return (((unsigned)(v->reg[14] & 7) << 14) | (v->address & 0x3FFF)) & 0x1FFFF;
}

static void vram_increment(V9938 *v)
{
    unsigned address = (vram_address(v) + 1) & 0x1FFFF;
    v->reg[14] = (uint8_t)((v->reg[14] & 0xF8) | (address >> 14));
    v->address = (uint16_t)(address & 0x3FFF);
}

uint8_t v9938_read_port(V9938 *v, unsigned port)
{
    if (!v) return 0xFF;
    switch (port & 3) {
    case 0: {
        uint8_t value = v->readBuffer;
        unsigned address = vram_address(v);
        v->readBuffer = v->vram[address];
        record_vram_access(v, address, v->readBuffer, 0);
        vram_increment(v);
        return value;
    }
    case 1: {
        unsigned status = v->reg[15] & 0x0F;
        uint8_t value;
        if (status == 1) {
            /* S#1 bit 0 = FH. With the line interrupt enabled it reports and
             * acknowledges the latched R#19 interrupt; with IE1 disabled it is
             * the H-blank flag of the line selected by R#19 (reference
             * VDP.c readStatus/peekStatus). */
            value = v->status[1];
            if (v->reg[0] & 0x10) {
                if (v->hintPending) {
                    value |= 0x01;
                    v->hintPending = 0;
                    if (!(v->status[0] & 0x80)) v->irq = 0;
                }
            } else if (v->currentLine == hint_line(v)) {
                value |= 0x01;
            }
        } else {
            value = status < 10 ? v->status[status] : 0xFF;
        }
        record_status_read(v, status, value);
        if (status == 7) v->status[2] &= (uint8_t)~0x80;
        if (status == 0) {
            v->status[0] &= 0x7F;
            v->irq = (v->hintPending && (v->reg[0] & 0x10)) ? 1 : 0;
        }
        return value;
    }
    case 2:
        return 0xFF;
    default: {
        unsigned reg = v->reg[17] & 0x3F;
        uint8_t value = v->reg[reg];
        if (!(v->reg[17] & 0x80)) v->reg[17] = (uint8_t)((v->reg[17] & 0xC0) | ((reg + 1) & 0x3F));
        return value;
    }
    }
}

void v9938_write_port(V9938 *v, unsigned port, uint8_t data)
{
    if (!v) return;
    switch (port & 3) {
    case 0: {
        unsigned address = vram_address(v);
        record_vram_access(v, address, data, 1);
        v->vram[address] = data;
        vram_increment(v);
        break;
    }
    case 1:
        if (!v->controlPending) {
            v->controlLatch = data;
            v->controlPending = 1;
            break;
        }
        v->controlPending = 0;
        if (data & 0x80) {
            v9938_write(v, data & 0x3F, v->controlLatch);
        } else {
            /* Setting the 14-bit address pointer must not modify R#14:
             * its low three bits carry A16-A14 and are only changed by a
             * register write or when the pointer wraps past 0x3FFF.  The
             * reference blueMSX writeLatch() and openMSX executeCpuVramAccess()
             * both preserve controlRegs[14] here; clearing it silently forced
             * every addressed access back into the first 16 KiB. */
            v->address = (uint16_t)(((data & 0x3F) << 8) | v->controlLatch);
            if (!(data & 0x40)) {
                unsigned address = vram_address(v);
                v->readBuffer = v->vram[address];
                record_vram_access(v, address, v->readBuffer, 0);
                vram_increment(v);
            }
        }
        break;
    case 2:
        if (!v->palettePending) {
            v->paletteFirst = data;
            v->palettePending = 1;
        } else {
            unsigned index = v->reg[16] & 0x0F;
            v->palette[index][0] = (uint8_t)((v->paletteFirst >> 4) & 7);
            /* V9938 palette bytes are RRR in the first byte's upper
             * bits, B in its lower bits, then G in the second byte. */
            v->palette[index][1] = (uint8_t)(data & 7);
            v->palette[index][2] = (uint8_t)(v->paletteFirst & 7);
            v->palettePending = 0;
            v->reg[16] = (uint8_t)((index + 1) & 0x0F);
        }
        break;
    case 3: {
#ifdef V9938_TRACE
		v9938_trace_port9b++;
		v9938_trace_indirect[v->reg[17] & 0x3F]++;
		if ((v->reg[17] & 0x3F) == 44) {
			v9938_trace_r44_total++;
			if (v->transferActive) v9938_trace_r44_stream++;
		}
#endif
		/* Port 0x9B is always an indirect register write. LMMC/HMMC data
		 * arrives as writes to R#44, so no raw data-port special case. */
        unsigned reg = v->reg[17] & 0x3F;
        v9938_write(v, reg, data);
        if (!(v->reg[17] & 0x80)) v->reg[17] = (uint8_t)((v->reg[17] & 0xC0) | ((reg + 1) & 0x3F));
        break;
    }
    }
}

void v9938_gen_sync_irq(V9938 *v)
{
    if (v && (v->reg[1] & 0x20)) {
        v->status[0] |= 0x80;
        v->irq = 1;
    }
}

int v9938_irq_pending(const V9938 *v)
{
    return v && v->irq;
}

void v9938_render(V9938 *vdp, uint32_t *out, int pitch)
{
    if (!vdp || !out || pitch < 256 * 4) return;
    int pitch_px = pitch / 4;
    unsigned m = bitmap_mode(vdp);
    if (m == 0x08)
    {
        render_graphic3(vdp, out, pitch_px);
        render_sprites2(vdp, out, pitch_px);
        return;
    }
    if (!m) {
        /* SCREEN 0-3 share the TMS9918 tile/text and legacy-sprite layout.
         * Present a 16 KiB window and the compatible registers to that
         * renderer; the MSX2-specific bitmap and sprite modes stay below. */
        TMS9918 legacy;
        memset(&legacy, 0, sizeof legacy);
        legacy.vram = vdp->vram;
        legacy.vram_size = sizeof vdp->vram;
        legacy.extended_vram = 1;
        memcpy(legacy.reg, vdp->reg, sizeof vdp->reg);
        legacy.irq = vdp->irq;
        tms9918_render(&legacy, out, pitch);
        return;
    }
    render_bitmap(vdp, out, pitch_px, m);
    render_sprites2(vdp, out, pitch_px);
}

uint8_t *v9938_get_vram(V9938 *v)
{
    return v->vram;
}

uint8_t v9938_peek_register(const V9938 *v, unsigned reg)
{
    return v && reg < 64 ? v->reg[reg] : 0;
}

uint8_t v9938_peek_status(const V9938 *v, unsigned reg)
{
    return v && reg < 10 ? v->status[reg] : 0;
}
