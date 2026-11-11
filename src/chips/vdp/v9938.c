#include "v9938.h"
#include "tms9918.h"
#include <string.h>
#include <stdlib.h>

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
    return (m == 0x0C || m == 0x10 || m == 0x14 || m == 0x1C) ? m : 0;
}

static unsigned mode_width(unsigned m) { return (m == 0x10 || m == 0x14) ? 512 : 256; }
static unsigned mode_shift(unsigned m) { return m == 0x10 ? 2 : (m == 0x1C ? 0 : 1); }
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

static unsigned display_line(const V9938 *v, unsigned y)
{
    /* The application framebuffer is 192 lines high. In 212-line mode the
     * active display starts 10 raster lines earlier than the 192-line mode;
     * keep the logical framebuffer centered on the V9938 active area. */
    /* Bitmap scanout wraps its display Y counter at 256 lines. R#23 is a
     * scroll offset, not part of the command engine's 10-bit VRAM Y. */
    return (y + ((v->reg[9] & 0x80) ? 10u : 0u) + v->reg[23]) & 0xFF;
}

static unsigned display_scroll_x(const V9938 *v, unsigned m)
{
    int scroll = ((int)(v->reg[26] & 0x3F) << 3) - (int)(v->reg[27] & 7);
    unsigned wide = (v->reg[25] & ((v->reg[2] >> 5) & 1)) != 0;
    unsigned width = mode_width(m);
    if (!wide) scroll &= 0xFF;
    return (unsigned)scroll & (width - 1);
}

static uint8_t pixel_get(const V9938 *v, unsigned m, unsigned x, unsigned y)
{
    unsigned s = pixel_shift(m, x);
    /* MXS is a V9958 feature; a V9938 always addresses all 128 KiB. */
    unsigned address = pixel_addr(m, x, y) & 0x1FFFF;
    return (uint8_t)((v->vram[address] >> s) & mode_mask(m));
}

static void pixel_put(V9938 *v, unsigned m, unsigned x, unsigned y, uint8_t c, unsigned op)
{
    unsigned s = pixel_shift(m, x), raw = pixel_addr(m, x, y) & 0x1FFFF;
    (void)op;
    /* MXS/MXD are V9958 features; a V9938 always addresses all 128 KiB. */
    uint8_t mask = (uint8_t)(mode_mask(m) << s);
    uint8_t src = (uint8_t)((c << s) & mask);
    uint8_t dst = v->vram[raw];
    v->vram[raw] = (dst & ~mask) | (src & mask);
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

static unsigned command_byte_width(const V9938 *v)
{
	unsigned width = (v->reg[40] | ((unsigned)(v->reg[41] & 3) << 8)) >> 1;
	if (!width) width = 128;
	unsigned xbyte = command_x(v, 36, 37) >> 1;
	if ((v->reg[46] & 0xF0) == 0xD0)
	{
		unsigned sxbyte = command_x(v, 32, 33) >> 1;
		unsigned edge = (v->reg[45] & 0x04)
			? (xbyte < sxbyte ? xbyte : sxbyte) + 1
			: 128 - (xbyte > sxbyte ? xbyte : sxbyte);
		return width < edge ? width : edge;
	}
	if (v->reg[45] & 0x04)
		return width < xbyte + 1 ? width : xbyte + 1;
	return width < 128 - xbyte ? width : 128 - xbyte;
}

static unsigned command_height(const V9938 *v, unsigned dy, unsigned sy,
			      unsigned op)
{
	unsigned height = v->reg[42] | ((unsigned)(v->reg[43] & 3) << 8);
	if (!height) height = 1024;
	if (v->reg[45] & 0x08)
	{
		unsigned limit = op == 0xD0 ? (dy < sy ? dy : sy) + 1 : dy + 1;
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

static unsigned command_byte_address(unsigned xbyte, unsigned y)
{
	return ((y & 1023) << 7) | (xbyte & 127);
}

static unsigned command_pixel_width(const V9938 *v, unsigned dx,
				   unsigned sx, unsigned op)
{
	if (dx >= 256 || (op == 0x90 && sx >= 256)) return 1;
	unsigned width = v->reg[40] | ((unsigned)(v->reg[41] & 3) << 8);
	if (!width) width = 256;
	unsigned reverse = (v->reg[45] & 0x04) != 0;
	unsigned edge = reverse ? dx + 1 : 256 - dx;
	if (op == 0x90)
	{
		unsigned sourceEdge = reverse ? sx + 1 : 256 - sx;
		if (edge > sourceEdge) edge = sourceEdge;
	}
	if (edge > 256) edge = 1;
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

static void command_logical_pixel(V9938 *v, unsigned x, unsigned y,
				  uint8_t source, unsigned op)
{
	unsigned raw = pixel_addr(0x0C, x, y);
	unsigned readMask = command_read_mask(v);
	if (raw & ~readMask) return;
	unsigned shift = pixel_shift(0x0C, x);
	uint8_t mask = (uint8_t)(0x0F << shift);
	unsigned destination = raw & command_write_mask(v);
	uint8_t dest = (uint8_t)((v->vram[raw & readMask] >> shift) & 0x0F);
	uint8_t result = logical_op(dest, source & 0x0F, 0, op);
	v->vram[destination] = (uint8_t)((v->vram[destination] & ~mask) |
					  ((result & 0x0F) << shift));
}

static void command_finish(V9938 *v)
{
#ifdef V9938_TRACE
	if (v->transferActive) v9938_trace_complete++;
#endif
	v->transferActive = 0;
	/* S#2 CE (command executing). TR is left set: the reference clears it
	 * only on an S#7 colour read, not when the command completes. */
	v->status[2] &= (uint8_t)~0x01;
}

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
	if (v->transferCommand == 0xB0)
	{
		unsigned x = (v->transferX +
			      (int)v->transferRowX * v->transferStepX) & 0x1FF;
		unsigned y = (v->transferY +
			      (int)v->transferRowN * v->transferStepY) & 0x3FF;
		command_logical_pixel(v, x, y, (uint8_t)(data & 0x0F),
				      v->transferOp);
	}
	else if (v->transferCommand == 0xF0)
	{
		unsigned xbyte = (v->transferX +
				  (int)v->transferRowX * v->transferStepX) & 127;
		unsigned y = (v->transferY +
			      (int)v->transferRowN * v->transferStepY) & 0x3FF;
		unsigned raw = command_byte_address(xbyte, y);
		if (!(raw & ~command_read_mask(v)))
			v->vram[raw & command_write_mask(v)] = data;
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
	if ((op != 0x80 && op != 0x90 && op != 0xB0 && op != 0xC0 &&
	     op != 0xD0 && op != 0xF0) || bitmap_mode(v) != 0x0C)
		return;

	unsigned dx = command_x(v, 36, 37);
	unsigned dy = command_y(v, 38, 39);
	unsigned sx = command_x(v, 32, 33);
	unsigned sy = command_y(v, 34, 35);
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
				unsigned tx = (dx + (int)x * stepX) & 0x1FF;
				unsigned ty = (dy + (int)y * stepY) & 0x3FF;
				uint8_t source = v->reg[44] & 0x0F;
				if (op == 0x90)
			{
				unsigned fromX = (sx + (int)x * stepX) & 0x1FF;
				unsigned fromY = (sy + (int)y * stepY) & 0x3FF;
				source = pixel_get(v, 0x0C, fromX, fromY);
			}
			/* LO occupies R#46's low nibble; R#45 is ARG (DIX/DIY/MXS/MXD). */
			command_logical_pixel(v, tx, ty, source, command & 0x0F);
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

	unsigned nx = command_byte_width(v);
	unsigned ny = command_height(v, dy, sy, op);
	v->transferCommand = (uint8_t)op;
	v->transferOp = command & 0x0F;
	v->transferX = (uint16_t)(dx >> 1);
	v->transferY = (uint16_t)dy;
	v->transferRowWidth = (uint16_t)nx;
	v->transferRemainingX = (uint16_t)nx;
	v->transferRemainingY = (uint16_t)ny;
	v->transferRowX = 0;
	v->transferRowN = 0;
	v->transferStepX = (v->reg[45] & 0x04) ? -1 : 1;
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
			unsigned tx = ((dx >> 1) + (int)x * v->transferStepX) & 127;
			unsigned ty = (dy + (int)y * v->transferStepY) & 0x3FF;
			unsigned raw = command_byte_address(tx, ty);
			if (raw & ~command_read_mask(v)) continue;
			unsigned dst = raw & command_write_mask(v);
			if (op == 0xD0)
			{
				unsigned fromX = ((sx >> 1) + (int)x * v->transferStepX) & 127;
				unsigned fromY = (sy + (int)y * v->transferStepY) & 0x3FF;
				unsigned src = command_byte_address(fromX, fromY) & command_read_mask(v);
				v->vram[dst] = v->vram[src];
			}
			else
			{
				v->vram[dst] = v->reg[44];
			}
		}
	}
	command_finish(v);
}

static uint8_t display_pixel_get(const V9938 *v, unsigned m, unsigned x, unsigned y)
{
    unsigned shift = pixel_shift(m, x);
    unsigned base = ((unsigned)v->reg[2] << 10) & 0x1FFFF;
    unsigned line = display_line(v, y);
    /* In bitmap modes the scanline address replaces R#2's low 15 bits.
     * R#2 bit 5 selects the 32 KiB bitmap page; R#25 bit 0 can select the
     * lower page on 128 KiB V9938s. Do not treat R#2 as a simple byte offset:
     * that exposes unrelated font/item tables when a game writes values such
     * as R#2=$1F. */
    base &= ~0x7FFFu;
    if (v->reg[25] & 1) base &= ~0x8000u;
    unsigned address = (base | pixel_addr(m, x, line)) & 0x1FFFF;
    return (uint8_t)((v->vram[address] >> shift) & mode_mask(m));
}

static uint32_t color(const V9938 *v, uint8_t index)
{
    return ((uint32_t)(v->palette[index][0] * 255 / 7) << 16) |
           ((uint32_t)(v->palette[index][1] * 255 / 7) << 8) |
           (uint32_t)(v->palette[index][2] * 255 / 7);
}

static uint16_t reg_pair(const V9938 *v, unsigned a, unsigned b, unsigned shift)
{
    return (uint16_t)((v->reg[a] & 0xFF) | ((v->reg[b] & 0xFF) << shift));
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
        for(unsigned n=0;n<count;n++){
            unsigned a=base+n*4;const uint8_t *d=v->vram+(a&0x1ffff);int row=(y-d[0])&255;
            /* Hardware testing shows the active-area raster origin needs a
             * one-line correction relative to the SAT Y coordinate. */
            row=(row+((v->reg[9]&0x80)?10:0)+(v->reg[23]&255)-1)&255;
            if(row>=span) continue;
            if(visible++ == 8){
                v->status[0]=(uint8_t)((v->status[0]&0xA0)|0x40|(n&0x1F));
                break;
            }
            /* Mode-2 SAT entries are Y, X, pattern, reserved.  The old code
             * swapped X and pattern, producing misplaced sprites and fetching
             * unrelated pattern data.  The reference SpriteLine reads +1 for
             * X and +2 for the pattern number. */
            /* Hardware captures show the active-area sprite origin needs a
             * two-pixel rightward correction. Keep this separate from color. */
            int sx=(int)d[1]-32+2;
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
    unsigned wide = (v->reg[25] & ((v->reg[2] >> 5) & 1)) != 0;
    unsigned scroll = display_scroll_x(v, m);
    for(int y=0;y<192;y++){
        for(int x=0;x<256;x++){
            unsigned sx = (x + scroll) & (wide ? 511 : 255);
            uint8_t c = display_pixel_get(v, m, sx, y);
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
		if (addr == 44)
		{
			if (v->transferActive)
				command_color_write(v, data);
			else
				v->transferColorPending = 1;
		}
		if (addr == 46) command_start(v, data);
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
        v->readBuffer = v->vram[vram_address(v)];
        vram_increment(v);
        return value;
    }
    case 1: {
        unsigned status = v->reg[15] & 0x0F;
        uint8_t value = status < 4 ? v->status[status] : 0xFF;
        if (status == 0) {
            v->status[0] &= 0x7F;
            v->irq = 0;
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
    case 0:
        v->vram[vram_address(v)] = data;
        vram_increment(v);
        break;
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
                v->readBuffer = v->vram[vram_address(v)];
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
    return v && reg < 4 ? v->status[reg] : 0;
}
