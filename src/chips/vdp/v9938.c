#include "v9938.h"
#include "tms9918.h"
#include <string.h>
#include <stdlib.h>

#define MAX(a, b) ((a) > (b) ? (a) : (b))

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
    return y + ((v->reg[9] & 0x80) ? 10u : 0u) + v->reg[23];
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
    unsigned mask = (v->reg[45] & 0x10) ? 0x0FFFFu : 0x1FFFFu;
    unsigned address = pixel_addr(m, x, y) & mask;
    return (uint8_t)((v->vram[address] >> s) & mode_mask(m));
}

static void pixel_put(V9938 *v, unsigned m, unsigned x, unsigned y, uint8_t c, unsigned op)
{
    unsigned s = pixel_shift(m, x), raw = pixel_addr(m, x, y);
    unsigned readMask = (v->reg[45] & 0x10) ? 0x0FFFFu : 0x1FFFFu;
    unsigned writeMask = (v->reg[45] & 0x20) ? 0x0FFFFu : 0x1FFFFu;
    /* The reference write macros reject pixels outside the selected read
     * window, then apply the independently selected write-page mask. */
    if (raw & ~readMask) return;
    unsigned a = raw & writeMask;
    uint8_t mask = (uint8_t)(mode_mask(m) << s);
    uint8_t src = (uint8_t)((c << s) & mask);
    uint8_t dst = v->vram[raw & readMask];
    v->vram[a] = (dst & ~mask) | (src & mask);
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
    unsigned colorBase=table&0x1FC00; /* colour rows are aligned to 1 KiB. */
    unsigned pat=(unsigned)(v->reg[6]&0x3f)<<11,count=0;
    while(count<32&&v->vram[base+count*4]!=216)count++;
    for(int y=0;y<192;y++){
        uint8_t present[256]={0}, topIsCC[256]={0}, sc[256]={0}, coll[256]={0};unsigned visible=0;
        for(unsigned n=0;n<count;n++){
            unsigned a=base+n*4;const uint8_t *d=v->vram+(a&0x1ffff);int row=(y-d[0])&255;
            row=(row+((v->reg[9]&0x80)?10:0)+(v->reg[23]&255))&255;
            if(row>=span) continue;
            int sx=(d[2]-32)*mag;int sy=(row)*mag;int dx=0,dy=0;
            for(int x=0;x<256;x++){
                int xx=sx+x*mag;if(xx<0||xx>=256)continue;
                uint8_t ca=d[3];
                if(ca&0x40){
                    /* CC combines a lower-priority sprite's color with the
                     * winning non-CC sprite using palette-index OR. The
                     * reference's doubled line-buffer encoding and final
                     * shift cancel, so ORing these raw nibbles is equivalent.
                     * A higher-priority CC sprite still wins normally, and
                     * a CC sprite with no prior sprite remains visible. */
                    if(!present[xx]){
                        sc[xx]=(uint8_t)ca;present[xx]=1;topIsCC[xx]=1;
                    }else if(!topIsCC[xx]){
                        sc[xx]|=(uint8_t)ca;
                    }
                }else{
                    if(ca&&!(ca&0x20)){if(coll[xx])v->status[0]|=0x20;coll[xx]=1;}
                    if(!present[xx]){present[xx]=1;topIsCC[xx]=0;sc[xx]=(uint8_t)ca;}
                }
            }
        }
        for(int x=0;x<256;x++){
            if(sc[x]&&present[x]){
                uint32_t c=color(v,sc[x]&15);
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
    if (addr < 64) v->reg[addr] = data;
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
            v->address = (uint16_t)(((data & 0x3F) << 8) | v->controlLatch);
            v->reg[14] &= 0xF8;
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
            v->palette[index][1] = (uint8_t)(v->paletteFirst & 7);
            v->palette[index][2] = (uint8_t)(data & 7);
            v->palettePending = 0;
            v->reg[16] = (uint8_t)((index + 1) & 0x0F);
        }
        break;
    case 3: {
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
