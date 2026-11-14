#include "v9938.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define assert(cond) do { if (!(cond)) { fprintf(stderr, "Assertion failed: %s at %s:%d\n", #cond, __FILE__, __LINE__); exit(1); } } while(0)

static void write_register(V9938 *vdp, unsigned reg, uint8_t value)
{
    v9938_write_port(vdp, 0x99, value);
    v9938_write_port(vdp, 0x99, (uint8_t)(0x80 | reg));
}

static void test_v9938_ports_and_registers(void)
{
    V9938 *vdp = v9938_create();
    if (!vdp) {
        fprintf(stderr, "Failed to create V9938\n");
        exit(1);
    }

    write_register(vdp, 0, 0x06); /* SCREEN 5 */
    assert(v9938_peek_register(vdp, 0) == 0x06);

    /* The V9938 VRAM address uses R14 as its upper address bits. */
    v9938_write_port(vdp, 0x99, 0x34);
    v9938_write_port(vdp, 0x99, 0x40); /* write address */
    v9938_write_port(vdp, 0x98, 0xAA);
    assert(v9938_get_vram(vdp)[0x34] == 0xAA);
    assert(vdp->vramWriteCount == 1);
    assert(vdp->vramWritesByBank[0] == 1);

    /* Control-port read address setup preloads the data read buffer. */
    v9938_write_port(vdp, 0x99, 0x34);
    v9938_write_port(vdp, 0x99, 0x00);
    assert(v9938_read_port(vdp, 0x98) == 0xAA);
    assert(vdp->vramReadCount == 2); /* Address prefetch plus next-byte fetch. */
    assert(vdp->vramAccessHistoryCount == 3);
    assert(vdp->vramAccessHistory[0].write == 1);
    assert(vdp->vramAccessHistory[0].address == 0x34);
    assert(vdp->vramAccessHistory[0].data == 0xAA);
    assert(vdp->vramAccessHistory[1].write == 0);
    assert(vdp->vramAccessHistory[1].address == 0x34);

    v9938_destroy(vdp);
    printf("PASS: V9938 register and VRAM port protocol\n");
}

static void test_v9938_r45_and_irq(void)
{
    V9938 *vdp = v9938_create();
    if (!vdp) {
        fprintf(stderr, "Failed to create V9938\n");
        exit(1);
    }

    /* Test R45 read/write page masks */
    write_register(vdp, 45, 0x10);
    assert(v9938_peek_register(vdp, 45) == 0x10);
    write_register(vdp, 45, 0x20);
    assert(v9938_peek_register(vdp, 45) == 0x20);

    write_register(vdp, 1, 0x20); /* Enable vertical-sync interrupt. */
    v9938_gen_sync_irq(vdp);
    assert(v9938_irq_pending(vdp));
    assert(v9938_peek_status(vdp, 0) & 0x80);
    assert(v9938_read_port(vdp, 0x99) & 0x80);
    assert(!v9938_irq_pending(vdp));
    
    v9938_destroy(vdp);
    printf("PASS: V9938 R45 page masks test\n");
}

/* R#19 line interrupt (IE1). SCREEN 5 in 212-line mode puts display line 0 on
 * raster line 32 (3 vsync + 13 erase + 9 border + R#18 adjust 7), so R#19=8
 * must pulse on raster line 40, shifted by the R#23 vertical scroll. */
static void test_v9938_line_interrupt(void)
{
    const unsigned frame_ticks = 357954;
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);

    write_register(vdp, 0, 0x06); /* SCREEN 5, IE1 off. */
    write_register(vdp, 1, 0x00); /* No VBlank interrupt. */
    write_register(vdp, 9, 0x80); /* 212-line mode. */
    write_register(vdp, 18, 0x00);
    write_register(vdp, 19, 8);
    write_register(vdp, 23, 0);
    write_register(vdp, 15, 0);
    assert(!v9938_irq_pending(vdp));

    /* IE1 disabled: the beam passes the R#19 line, S#1 bit 0 shows the
     * H-blank flag there, and no CPU interrupt is generated. */
    v9938_frame_start(vdp);
    unsigned saw_hblank = 0;
    for (unsigned t = 0; t <= frame_ticks; t += 256) {
        v9938_set_frame_time(vdp, t, frame_ticks);
        assert(!v9938_irq_pending(vdp));
        if (vdp->currentLine == 40 && !saw_hblank) {
            saw_hblank = 1;
            write_register(vdp, 15, 1);
            assert(v9938_read_port(vdp, 0x99) & 0x01);
            write_register(vdp, 15, 0);
        }
    }
    assert(saw_hblank);

    /* IE1 enabled: one latched interrupt exactly at the R#19 line. */
    write_register(vdp, 0, 0x16);
    write_register(vdp, 15, 0);
    /* S#0 bit 7 (VR) is set at power-on and must be acknowledged too, or the
     * shared INT output would legitimately stay asserted. */
    assert(v9938_read_port(vdp, 0x99) & 0x80);
    assert(!v9938_irq_pending(vdp));
    v9938_frame_start(vdp);
    unsigned fired_line = 0;
    unsigned fired = 0;
    unsigned acked_at = frame_ticks + 1;
    for (unsigned t = 0; t <= frame_ticks; t += 256) {
        v9938_set_frame_time(vdp, t, frame_ticks);
        if (!fired && v9938_irq_pending(vdp)) {
            fired = 1;
            fired_line = vdp->currentLine;
        }
        if (fired && acked_at > frame_ticks) {
            /* The program's handler reads S#1 to acknowledge the line. */
            write_register(vdp, 15, 1);
            assert(v9938_read_port(vdp, 0x99) & 0x01);
            assert(!v9938_irq_pending(vdp));
            /* The latch is cleared, so S#1 reads 0 again on the same line. */
            assert(!(v9938_read_port(vdp, 0x99) & 0x01));
            write_register(vdp, 15, 0);
            acked_at = t;
        }
        if (acked_at <= frame_ticks)
            assert(!v9938_irq_pending(vdp));
    }
    assert(fired);
    assert(fired_line == 40);
    assert(acked_at <= frame_ticks);

    /* R#19 selects the visible line and R#23 shifts it with the scroll. */
    write_register(vdp, 19, 0);
    v9938_frame_start(vdp);
    fired = 0;
    for (unsigned t = 0; t <= frame_ticks && !fired; t += 256) {
        v9938_set_frame_time(vdp, t, frame_ticks);
        if (v9938_irq_pending(vdp)) { fired = 1; fired_line = vdp->currentLine; }
    }
    assert(fired && fired_line == 32);
    write_register(vdp, 15, 1);
    v9938_read_port(vdp, 0x99);
    assert(!v9938_irq_pending(vdp));

    write_register(vdp, 19, 8);
    write_register(vdp, 23, 4);
    v9938_frame_start(vdp);
    fired = 0;
    for (unsigned t = 0; t <= frame_ticks && !fired; t += 256) {
        v9938_set_frame_time(vdp, t, frame_ticks);
        if (v9938_irq_pending(vdp)) { fired = 1; fired_line = vdp->currentLine; }
    }
    assert(fired && fired_line == 36);
    write_register(vdp, 15, 1);
    assert(v9938_read_port(vdp, 0x99) & 0x01);
    assert(!v9938_irq_pending(vdp));

    /* The line interrupt shares the INT output with the VBlank interrupt: the
     * output stays asserted until both latches are acknowledged. */
    write_register(vdp, 23, 0);
    write_register(vdp, 1, 0x20);
    v9938_gen_sync_irq(vdp); /* VBlank latch. */
    write_register(vdp, 15, 1);
    assert(!(v9938_read_port(vdp, 0x99) & 0x01)); /* No line request pending. */
    assert(v9938_irq_pending(vdp)); /* VBlank still set. */
    write_register(vdp, 15, 0);
    assert(v9938_read_port(vdp, 0x99) & 0x80);
    assert(!v9938_irq_pending(vdp));

    /* Both latches at once: acking only the line keeps the output asserted. */
    v9938_frame_start(vdp);
    fired = 0;
    for (unsigned t = 0; t <= frame_ticks && !fired; t += 256) {
        v9938_set_frame_time(vdp, t, frame_ticks);
        if (v9938_irq_pending(vdp)) { fired = 1; fired_line = vdp->currentLine; }
    }
    assert(fired && fired_line == 40);
    v9938_gen_sync_irq(vdp); /* VBlank latches while the line request is up. */
    write_register(vdp, 15, 1);
    assert(v9938_read_port(vdp, 0x99) & 0x01);
    assert(v9938_irq_pending(vdp)); /* VBlank latch still holds the line. */
    write_register(vdp, 15, 0);
    v9938_read_port(vdp, 0x99);
    assert(!v9938_irq_pending(vdp));

    v9938_destroy(vdp);
    puts("PASS: V9938 R#19 line interrupt (IE1) and S#1 acknowledge");
}

static void test_v9938_screen5_render(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    write_register(vdp, 0, 0x06); /* SCREEN 5 */
    write_register(vdp, 16, 1);   /* Palette entry 1 */
    v9938_write_port(vdp, 0x9A, 0x70); /* full red, no blue */
    v9938_write_port(vdp, 0x9A, 0x00); /* no green */
    v9938_get_vram(vdp)[0] = 0x10; /* x=0 is the high nibble */

    uint32_t frame[256 * 192];
    memset(frame, 0, sizeof frame);
    v9938_render(vdp, frame, 256 * 4);
    assert(frame[0] == 0x00FF0000);

    /* The first palette byte's low bits are blue; the second byte is green. */
    write_register(vdp, 16, 2);
    v9938_write_port(vdp, 0x9A, 0x15); /* red=1, blue=5 */
    v9938_write_port(vdp, 0x9A, 0x06); /* green=6 */
    v9938_get_vram(vdp)[0] = 0x20; /* x=0 selects palette color 2. */
    v9938_render(vdp, frame, 256 * 4);
    assert(frame[0] == 0x0024DAB6); /* RGB=(1,6,5), rounded to 8-bit. */

    /* Zero bitmap pixels reveal the R#7 backdrop, not palette color zero. */
    write_register(vdp, 7, 15);
    v9938_get_vram(vdp)[0] = 0x00;
    v9938_render(vdp, frame, 256 * 4);
    assert(frame[0] == 0xFFFFFFu);

    v9938_destroy(vdp);
    puts("PASS: V9938 SCREEN 5 render and palette output");
}

static void test_v9938_screen8_rgb_render(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    write_register(vdp, 0, 0x0E); /* SCREEN 8 / Graphic 7. */
    write_register(vdp, 1, 0x00);
    write_register(vdp, 7, 0x0F); /* SCREEN 8 must ignore backdrop transparency. */
    vdp->vram[0] = 0x04;          /* R=1, G=0, B=0. */
    vdp->vram[0x10000] = 0xE3;    /* odd pixel: R=0, G=7, B=3. */

    uint32_t frame[256 * 192];
    memset(frame, 0xA5, sizeof frame);
    v9938_render(vdp, frame, 256 * 4);
    assert(frame[0] == 0x00240000u);
    assert(frame[1] == 0x0000FFFFu);
    assert(frame[2] == 0x00000000u); /* Zero is opaque black, not R#7 white. */

    v9938_destroy(vdp);
    puts("PASS: V9938 SCREEN 8 direct RGB and opaque color zero");
}

static void test_v9938_screen6_full_width_render(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    write_register(vdp, 0, 0x08); /* SCREEN 6 is 512 dots wide. */
    write_register(vdp, 1, 0x00);
    /* Pixels 254 and 256 straddle the 256-dot midpoint. If the renderer
     * merely displays x=0..255, output column 128 never reaches the second. */
    vdp->vram[63] = 0x0C; /* x=254 (index 3) in bits 3:2. */
    vdp->vram[64] = 0x80; /* x=256 (index 2) in bits 7:6. */
    uint32_t frame[256 * 192];
    memset(frame, 0, sizeof frame);
    v9938_render(vdp, frame, 256 * 4);
    assert(frame[127] == 0x6DFF6Du); /* palette color 3 */
    assert(frame[128] == 0x24DA24u); /* palette color 2 */
    v9938_destroy(vdp);
    puts("PASS: V9938 SCREEN 6 renders both 512-dot halves");
}

static void test_v9938_screen8_pixel_command(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    write_register(vdp, 0, 0x0E); /* SCREEN 8. */
    write_register(vdp, 1, 0x00);
    write_register(vdp, 36, 5); write_register(vdp, 37, 0);
    write_register(vdp, 38, 2); write_register(vdp, 39, 0);
    write_register(vdp, 40, 1); write_register(vdp, 41, 0);
    write_register(vdp, 42, 1); write_register(vdp, 43, 0);
    write_register(vdp, 44, 0xE3); write_register(vdp, 45, 0);
    write_register(vdp, 46, 0x80); /* LMMV one SCREEN 8 pixel. */
    assert(vdp->vram[0x10102] == 0xE3);
    assert(vdp->vram[0x00102] == 0x00);
    v9938_destroy(vdp);
    puts("PASS: V9938 SCREEN 8 logical pixel command");
}

static void test_v9938_point_pset_srch_commands(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    write_register(vdp, 0, 0x06); /* SCREEN 5. */
    write_register(vdp, 1, 0);
    write_register(vdp, 36, 4); write_register(vdp, 37, 0);
    write_register(vdp, 38, 2); write_register(vdp, 39, 0);
    write_register(vdp, 44, 0x0A);
    write_register(vdp, 46, 0x50); /* PSET, IMP. */
    assert((vdp->vram[2 * 128 + 2] >> 4) == 0x0A);

    write_register(vdp, 32, 4); write_register(vdp, 33, 0);
    write_register(vdp, 34, 2); write_register(vdp, 35, 0);
    write_register(vdp, 46, 0x40); /* POINT returns color through S#7. */
    write_register(vdp, 15, 7);
    assert(v9938_read_port(vdp, 0x99) == 0x0A);

    write_register(vdp, 32, 0); write_register(vdp, 33, 0);
    write_register(vdp, 44, 0x0A);
    write_register(vdp, 45, 0x02); /* EQ=1: find equal color to the right. */
    write_register(vdp, 46, 0x60);
    assert(vdp->reg[32] == 4);
    assert(v9938_peek_status(vdp, 2) & 0x10); /* BD */
    v9938_destroy(vdp);
    puts("PASS: V9938 POINT, PSET, SRCH and status results");
}

static void test_v9938_high_speed_fill_commands_modes6_to8(void)
{
    struct TestMode { uint8_t r0; unsigned dx, nx, address; } modes[] = {
        { 0x08, 8, 4, 3 * 128 + 2 },              /* SCREEN 6 */
        { 0x0A, 2, 2, 0x10000 + 3 * 128 },        /* SCREEN 7 */
        { 0x0E, 5, 1, 0x10000 + 3 * 128 + 2 }     /* SCREEN 8 */
    };
    for (unsigned i = 0; i < sizeof modes / sizeof modes[0]; ++i) {
        V9938 *vdp = v9938_create();
        assert(vdp != NULL);
        write_register(vdp, 0, modes[i].r0);
        write_register(vdp, 1, 0);
        write_register(vdp, 36, modes[i].dx); write_register(vdp, 37, 0);
        write_register(vdp, 38, 3); write_register(vdp, 39, 0);
        write_register(vdp, 40, modes[i].nx); write_register(vdp, 41, 0);
        write_register(vdp, 42, 1); write_register(vdp, 43, 0);
        write_register(vdp, 44, 0xA5); write_register(vdp, 45, 0);
        write_register(vdp, 46, 0xC0); /* HMMV single packed byte. */
        assert(vdp->vram[modes[i].address] == 0xA5);
        v9938_destroy(vdp);
    }
    puts("PASS: V9938 high-speed fill addressing in SCREEN 6-8");
}

static void test_v9938_screen4_graphic3_render(void)
{
    V9938 *vdp=v9938_create();
    assert(vdp!=NULL);
    uint32_t frame[256*192];
    memset(frame,0,sizeof frame);
    write_register(vdp,0,0x04); /* Graphic 3 / SCREEN 4. */
    write_register(vdp,1,0x62);
    write_register(vdp,2,0x30); /* Name table at C000. */
    write_register(vdp,3,0xFF);
    write_register(vdp,4,0x03); /* Pattern table at 1800. */
    write_register(vdp,7,1);    /* Backdrop color. */
    write_register(vdp,8,2);    /* Disable sprites for this background test. */
    vdp->vram[0xC000]=1;
    vdp->vram[0x0008]=0x80; /* R#4's masked Graphic 3 table index. */
    vdp->vram[0x2008]=0xF2; /* Foreground 15, background 2. */
    v9938_render(vdp,frame,256*4);
    assert(frame[0]==0xFFFFFFu);
    assert(frame[1]==0x24DA24u);
    v9938_destroy(vdp);
    puts("PASS: V9938 SCREEN 4 / Graphic 3 tile tables and palette");
}

static void test_v9938_screen5_vertical_scroll_wrap(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    write_register(vdp, 0, 0x06); /* SCREEN 5 */
    write_register(vdp, 2, 0x1F); /* bitmap page 0 */
    write_register(vdp, 23, 0xC0); /* scroll +192, modulo 256 lines */

    write_register(vdp, 16, 1);
    v9938_write_port(vdp, 0x9A, 0x70); v9938_write_port(vdp, 0x9A, 0x00);
    write_register(vdp, 16, 2);
    v9938_write_port(vdp, 0x9A, 0x00); v9938_write_port(vdp, 0x9A, 0x07);
    write_register(vdp, 16, 3);
    v9938_write_port(vdp, 0x9A, 0x07); v9938_write_port(vdp, 0x9A, 0x00);

    uint8_t *vram = v9938_get_vram(vdp);
    vram[192 * 128] = 0x10; /* output line 0 reads source line 192 */
    vram[0] = 0x20;         /* output line 64 wraps source line 256 to 0 */
    vram[0x8000] = 0x30;    /* catches erroneous 10-bit/page carry */

    uint32_t frame[256 * 192];
    v9938_render(vdp, frame, 256 * 4);
    assert(frame[0] == 0x00FF0000);
    assert(frame[64 * 256] == 0x0000FF00);

    v9938_destroy(vdp);
    puts("PASS: V9938 SCREEN 5 vertical scroll wraps at 256 lines");
}

static void test_v9938_screen5_hmmv_hmmc_hmmm(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    write_register(vdp, 0, 0x06); /* SCREEN 5 / Graphic 4. */
    write_register(vdp, 1, 0xE0);
    uint8_t *vram = v9938_get_vram(vdp);

    /* HMMV fills packed SCREEN 5 bytes with the full R44 byte. */
    write_register(vdp, 36, 10); write_register(vdp, 37, 0);
    write_register(vdp, 38, 10); write_register(vdp, 39, 0);
    write_register(vdp, 40, 4);  write_register(vdp, 41, 0);
    write_register(vdp, 42, 2);  write_register(vdp, 43, 0);
    write_register(vdp, 44, 0xA3);  write_register(vdp, 45, 0);
    write_register(vdp, 46, 0xC0);
    assert(vram[10 * 128 + 5] == 0xA3);
    assert(vram[11 * 128 + 5] == 0xA3);
    assert(vram[10 * 128 + 4] == 0x00);

    /* HMMC copies packed SCREEN 5 bytes. Its data arrives as writes to
     * R#44 (COL), exactly like real hardware: port 0x9B is only an indirect
     * register port, not a raw VRAM data port. */
    write_register(vdp, 36, 8); write_register(vdp, 38, 3);
    write_register(vdp, 40, 4); write_register(vdp, 42, 1);
    write_register(vdp, 46, 0xF0);
    assert(v9938_peek_status(vdp, 2) & 0x01); /* CE is S#2 bit 0. */
    assert(v9938_peek_status(vdp, 2) & 0x80); /* TR is S#2 bit 7. */
    v9938_set_trace_cpu_time(vdp, 123456u);
    write_register(vdp, 44, 0x12);
    assert(v9938_peek_status(vdp, 2) & 0x01);
    write_register(vdp, 44, 0x34);
    assert(vram[3 * 128 + 4] == 0x12);
    assert(vram[3 * 128 + 5] == 0x34);
    assert(!(v9938_peek_status(vdp, 2) & 0x01));
    assert(v9938_peek_status(vdp, 2) & 0x80);
    assert(v9938_peek_register(vdp, 44) == 0x34);
    assert(vdp->transferHistoryCount == 2);
    assert(vdp->transferHistory[0].command == 0xF0);
    assert(vdp->transferHistory[0].commandSequence == 2);
    assert(vdp->transferHistory[0].address == 3 * 128 + 4);
    assert(vdp->transferHistory[0].data == 0x12);
    assert(vdp->transferHistory[0].cpuTime == 123456u);
    assert(vdp->transferHistory[0].trReadyBefore == 1);
    assert(vdp->transferHistory[1].address == 3 * 128 + 5);
    assert(vdp->transferHistory[1].data == 0x34);

    /* The same stream through the indirect register port (R#17 -> R#44),
     * which is how real software feeds HMMC/LMMC. */
    write_register(vdp, 36, 8); write_register(vdp, 38, 9);
    write_register(vdp, 40, 4); write_register(vdp, 42, 1);
    write_register(vdp, 46, 0xF0);
    write_register(vdp, 17, 0xAC); /* R44, no auto-increment. */
    v9938_write_port(vdp, 0x9B, 0x5A);
    v9938_write_port(vdp, 0x9B, 0xA5);
    assert(vram[9 * 128 + 4] == 0x5A);
    assert(vram[9 * 128 + 5] == 0xA5);
    assert(!(v9938_peek_status(vdp, 2) & 0x01));

    /* LMMC's pre-command R#44 write is latched as the first transfer pixel. */
    vram[20 * 128 + 10] = 0x0F;
    vram[20 * 128 + 11] = 0x0F;
    write_register(vdp, 36, 20); write_register(vdp, 38, 20);
    write_register(vdp, 40, 4);  write_register(vdp, 42, 1);
    write_register(vdp, 44, 0x03); write_register(vdp, 45, 0);
    write_register(vdp, 46, 0xB8); /* LMMC, TIMP (transparent zero). */
    assert(v9938_peek_status(vdp, 2) & 0x01);
    write_register(vdp, 17, 0xAC);
    v9938_write_port(vdp, 0x9B, 0x00); /* x=21 transparent: leave 0xF. */
    assert(vram[20 * 128 + 10] == 0x3F);
    v9938_write_port(vdp, 0x9B, 0x05); /* x=22 -> byte 11 high nibble. */
    v9938_write_port(vdp, 0x9B, 0x07); /* x=23 -> byte 11 low nibble. */
    assert(vram[20 * 128 + 11] == 0x57);
    assert(!(v9938_peek_status(vdp, 2) & 0x01));

    /* LMMC with LO=0 must also write zero pixels (no transparency). */
    vram[21 * 128 + 10] = 0xFF;
    write_register(vdp, 36, 20); write_register(vdp, 38, 21);
    write_register(vdp, 40, 2);  write_register(vdp, 42, 1);
    write_register(vdp, 44, 0);  write_register(vdp, 45, 0);
    write_register(vdp, 46, 0xB0);
    write_register(vdp, 17, 0xAC);
    v9938_write_port(vdp, 0x9B, 0x00);
    assert(vram[21 * 128 + 10] == 0x00);

    /* MXS/MXD (R#45 bits 4/5) are V9958-only; a V9938 command must still
     * reach VRAM above 0xFFFF. */
    write_register(vdp, 36, 0); write_register(vdp, 38, 0);
    write_register(vdp, 37, 0); write_register(vdp, 39, 0x02); /* y=512 */
    write_register(vdp, 40, 2); write_register(vdp, 42, 1);
    write_register(vdp, 15, 2); /* Select S#2 for port reads. */
    write_register(vdp, 44, 0x0A); write_register(vdp, 45, 0x10); /* MXS set */
    write_register(vdp, 46, 0x80); /* LMMV IMP */
    assert(vram[0x10000] == 0xAA);
    write_register(vdp, 36, 0); write_register(vdp, 37, 0);
    write_register(vdp, 38, 0); write_register(vdp, 39, 0x02);
    write_register(vdp, 40, 2); write_register(vdp, 42, 1);
    write_register(vdp, 44, 0x5C); write_register(vdp, 45, 0x20); /* MXD set */
    write_register(vdp, 46, 0xC0); /* HMMV */
    assert(vram[0x10000] == 0x5C);

    /* HMMM copies packed bytes using distinct source/destination coordinates. */
    vram[2 * 128 + 1] = 0xAB;
    vram[2 * 128 + 2] = 0xCD;
    write_register(vdp, 32, 2); write_register(vdp, 33, 0);
    write_register(vdp, 34, 2); write_register(vdp, 35, 0);
    write_register(vdp, 36, 12); write_register(vdp, 37, 0);
    write_register(vdp, 38, 2);  write_register(vdp, 39, 0);
    write_register(vdp, 40, 4);  write_register(vdp, 41, 0);
    write_register(vdp, 42, 1);  write_register(vdp, 43, 0);
    write_register(vdp, 46, 0xD0);
    assert(vram[2 * 128 + 6] == 0xAB);
    assert(vram[2 * 128 + 7] == 0xCD);

    /* SCREEN 5 HMMM ignores the low bit of SX, DX, and NX. Five dots at
     * odd coordinates therefore copy two complete packed bytes. */
    vram[3 * 128 + 1] = 0x12;
    vram[3 * 128 + 2] = 0x34;
    write_register(vdp, 32, 3); write_register(vdp, 34, 3);
    write_register(vdp, 36, 13); write_register(vdp, 38, 3);
    write_register(vdp, 40, 5); write_register(vdp, 42, 1);
    write_register(vdp, 45, 0);
    write_register(vdp, 46, 0xD0);
    assert(vram[3 * 128 + 6] == 0x12);
    assert(vram[3 * 128 + 7] == 0x34);

    /* The command coordinate system is linear across SCREEN 5's 32 KiB
     * display pages: row 255 is followed by row 256 at VRAM 0x8000. */
    vram[255 * 128 + 4] = 0x56;
    vram[255 * 128 + 5] = 0x78;
    write_register(vdp, 32, 8); write_register(vdp, 33, 0);
    write_register(vdp, 34, 255); write_register(vdp, 35, 0);
    write_register(vdp, 36, 12); write_register(vdp, 37, 0);
    write_register(vdp, 38, 0); write_register(vdp, 39, 1);
    write_register(vdp, 40, 4); write_register(vdp, 42, 1);
    write_register(vdp, 45, 0);
    write_register(vdp, 46, 0xD0);
    assert(vram[0x8000 + 6] == 0x56);
    assert(vram[0x8000 + 7] == 0x78);

    /* Overlapping copy to the right must walk backwards (DIX=1). */
    vram[10 * 128 + 2] = 0xA2;
    vram[10 * 128 + 3] = 0xA3;
    vram[10 * 128 + 4] = 0xA4;
    write_register(vdp, 32, 8); write_register(vdp, 33, 0);
    write_register(vdp, 34, 10); write_register(vdp, 35, 0);
    write_register(vdp, 36, 10); write_register(vdp, 37, 0);
    write_register(vdp, 38, 10); write_register(vdp, 39, 0);
    write_register(vdp, 40, 6); write_register(vdp, 42, 1);
    write_register(vdp, 45, 0x04);
    write_register(vdp, 46, 0xD0);
    assert(vram[10 * 128 + 3] == 0xA2);
    assert(vram[10 * 128 + 4] == 0xA3);
    assert(vram[10 * 128 + 5] == 0xA4);

    /* The mirror case copies left with forward traversal (DIX=0). */
    vram[11 * 128 + 5] = 0xB5;
    vram[11 * 128 + 6] = 0xB6;
    vram[11 * 128 + 7] = 0xB7;
    write_register(vdp, 32, 10); write_register(vdp, 33, 0);
    write_register(vdp, 34, 11); write_register(vdp, 35, 0);
    write_register(vdp, 36, 8); write_register(vdp, 37, 0);
    write_register(vdp, 38, 11); write_register(vdp, 39, 0);
    write_register(vdp, 40, 6); write_register(vdp, 42, 1);
    write_register(vdp, 45, 0);
    write_register(vdp, 46, 0xD0);
    assert(vram[11 * 128 + 4] == 0xB5);
    assert(vram[11 * 128 + 5] == 0xB6);
    assert(vram[11 * 128 + 6] == 0xB7);

    /* YMMM ignores NX and copies from DX through the line edge at the same
     * X on successive source/destination rows. */
    memset(vram + 40 * 128, 0x5A, 128);
    memset(vram + 41 * 128, 0xA5, 128);
    memset(vram + 42 * 128, 0x3C, 128);
    write_register(vdp, 32, 0);  write_register(vdp, 34, 40); /* SY */
    write_register(vdp, 36, 4);  write_register(vdp, 38, 48); /* DX,DY */
    write_register(vdp, 40, 2);  write_register(vdp, 42, 3); /* NX ignored */
    write_register(vdp, 45, 0);
    write_register(vdp, 46, 0xE0);
    assert(vram[48 * 128 + 2] == 0x5A);
    assert(vram[48 * 128 + 127] == 0x5A);
    assert(vram[49 * 128 + 2] == 0xA5);
    assert(vram[50 * 128 + 127] == 0x3C);
    assert(!(v9938_peek_status(vdp, 2) & 0x01));

    /* LMMV and LMMM update individual SCREEN 5 pixels and preserve the
     * neighboring nibble, unlike the high-speed byte commands above. */
    vram[4 * 128 + 10] = 0x12;
    write_register(vdp, 36, 20); write_register(vdp, 38, 4);
    write_register(vdp, 40, 2);  write_register(vdp, 42, 1);
    write_register(vdp, 44, 0x0A); write_register(vdp, 45, 0);
    write_register(vdp, 46, 0x80);
    assert(vram[4 * 128 + 10] == 0xAA);

    vram[5 * 128 + 10] = 0x3C;
    write_register(vdp, 32, 20); write_register(vdp, 34, 4);
    write_register(vdp, 36, 21); write_register(vdp, 38, 5);
    write_register(vdp, 40, 2);  write_register(vdp, 42, 1);
    write_register(vdp, 45, 0);
    write_register(vdp, 46, 0x90);
    assert(vram[5 * 128 + 10] == 0x3A);
    assert(vram[5 * 128 + 11] == 0xA0);

    /* R#46 low nibble selects LO. LMMM with LO=8 is transparent: source
     * color zero must leave the destination pixels untouched. */
    vram[6 * 128 + 10] = 0x00;
    vram[7 * 128 + 10] = 0xBD;
    write_register(vdp, 32, 20); write_register(vdp, 34, 6);
    write_register(vdp, 36, 20); write_register(vdp, 38, 7);
    write_register(vdp, 40, 2);  write_register(vdp, 42, 1);
    write_register(vdp, 45, 0); /* ARG has no bearing on LO. */
    write_register(vdp, 46, 0x98);
    assert(vram[7 * 128 + 10] == 0xBD);
    vram[6 * 128 + 10] = 0x06; /* transparent zero, copy color six */
    write_register(vdp, 46, 0x98);
    assert(vram[7 * 128 + 10] == 0xB6);

    v9938_destroy(vdp);
    puts("PASS: V9938 SCREEN 5 logical and high-speed commands");
}

static void test_v9938_hmmc_trace_wrap(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    write_register(vdp, 0, 0x06);
    write_register(vdp, 1, 0xE0);
    write_register(vdp, 36, 0); write_register(vdp, 37, 0);
    write_register(vdp, 38, 0); write_register(vdp, 39, 0);
    write_register(vdp, 40, 0); write_register(vdp, 41, 2); /* 512 dots. */
    write_register(vdp, 42, 129); write_register(vdp, 43, 0);
    write_register(vdp, 46, 0xF0);
    write_register(vdp, 17, 0xAC); /* R#44, no auto-increment. */
    for (unsigned i = 0; i < V9938_TRANSFER_HISTORY_CAPACITY + 1; i++)
        v9938_write_port(vdp, 0x9B, (uint8_t)i);

    assert(vdp->transferDataSequence == V9938_TRANSFER_HISTORY_CAPACITY + 1);
    assert(vdp->transferHistoryCount == V9938_TRANSFER_HISTORY_CAPACITY);
    assert(vdp->transferHistoryNext == 1);
    assert(vdp->transferHistory[1].sequence == 2);
    assert(vdp->transferHistory[0].sequence ==
           V9938_TRANSFER_HISTORY_CAPACITY + 1);
    v9938_destroy(vdp);
    puts("PASS: V9938 HMMC payload trace wraps at configured capacity");
}

static void test_v9938_screen1_render(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    write_register(vdp, 1, 0x40); /* legacy graphics mode, display on */
    write_register(vdp, 2, 0x40); /* name table at 0x10000 */
    write_register(vdp, 3, 0x80);
    write_register(vdp, 10, 2);   /* color table page bits */
    write_register(vdp, 4, 0x10); /* pattern table at 0x8000 */
    uint8_t *vram = v9938_get_vram(vdp);
    vram[0x10000] = 1; /* first name-table character */
    vram[0x8008] = 0x80; /* first pattern row: one foreground pixel */
    vram[0xA000] = 0xF1; /* white foreground, blue background */

    uint32_t frame[256 * 192];
    memset(frame, 0, sizeof frame);
    v9938_render(vdp, frame, 256 * 4);
    assert(frame[0] != frame[1]);
    assert(frame[1] == frame[7]);
    v9938_destroy(vdp);
    puts("PASS: V9938 SCREEN 1 legacy tile rendering");
}

static void test_v9938_sprite_mode2_pattern_and_color(void)
{
    V9938 *vdp=v9938_create();
    assert(vdp!=NULL);
    write_register(vdp,0,0x06); /* SCREEN 5: mode-2 sprites over bitmap. */
    write_register(vdp,1,0x40); /* Display and sprites enabled; 8x8. */
    write_register(vdp,5,8);    /* SAT at 0x0400; color table at 0x0200. */
    write_register(vdp,6,1);    /* Sprite patterns at 0x0800. */
    uint8_t *vram=v9938_get_vram(vdp);
    vram[0x400]=0;              /* Sprite 0 Y. */
    vram[0x401]=32;             /* SAT X coordinate. */
    vram[0x402]=0;              /* Pattern 0. */
    vram[0x403]=0;
    vram[0x400+4]=216;          /* End marker. */
    vram[0x200]=2;              /* Row 0 uses palette color 2. */
    vram[0x800]=0x80;           /* One opaque pixel at the left. */
    uint32_t frame[256*192];
    memset(frame,0,sizeof frame);
    v9938_render(vdp,frame,256*4);
    assert(frame[1*256+32]==0x0024DA24); /* unchanged color; SAT X, Y+1. */
    assert(frame[1*256+33]==0x00000000); /* clear pattern bit remains background */
    v9938_destroy(vdp);
    puts("PASS: V9938 sprite mode 2 pattern/color fetch");
}

static void test_v9938_command_history(void)
{
    V9938 *vdp=v9938_create();
    assert(vdp!=NULL);
    v9938_set_trace_cpu_time(vdp, 123456u);
    v9938_set_trace_cpu_pc(vdp, 0x4567u);
    write_register(vdp,32,0x11);
    write_register(vdp,46,0x70); /* Unsupported LINE is still recorded. */
    write_register(vdp,32,0x22);
    write_register(vdp,46,0xE0); /* YMMM launch and register snapshot. */
    assert(vdp->commandSequence==2);
    assert(vdp->commandCounts[0x70]==1);
    assert(vdp->commandCounts[0xE0]==1);
    assert(vdp->commandHistoryCount==2);
    assert(vdp->commandHistory[0].sequence==1);
    assert(vdp->commandHistory[0].registers[0]==0x11);
    assert(vdp->commandHistory[0].registers[14]==0x70);
    assert(vdp->commandHistory[0].cpuTime==123456u);
    assert(vdp->commandHistory[0].cpuPc==0x4567u);
    assert(vdp->commandHistory[1].sequence==2);
    assert(vdp->commandHistory[1].registers[0]==0x22);
    assert(vdp->commandHistory[1].registers[14]==0xE0);

    write_register(vdp, 15, 2);
    assert(v9938_read_port(vdp, 0x99) == vdp->status[2]);
    assert(vdp->statusReadSequence == 1);
    assert(vdp->statusReadHistoryCount == 1);
    assert(vdp->statusReadHistory[0].cpuTime == 123456u);
    assert(vdp->statusReadHistory[0].cpuPc == 0x4567u);
    assert(vdp->statusReadHistory[0].value == vdp->status[2]);

    for(unsigned i=0;i<V9938_COMMAND_HISTORY_CAPACITY+2;i++)
        write_register(vdp,46,0x70);
    assert(vdp->commandHistoryCount==V9938_COMMAND_HISTORY_CAPACITY);
    assert(vdp->commandHistoryNext==4);
    assert(vdp->commandHistory[4].sequence==5); /* Oldest retained launch. */
    assert(vdp->commandHistory[3].sequence==
           V9938_COMMAND_HISTORY_CAPACITY+4); /* Most recent launch. */
    v9938_destroy(vdp);
    puts("PASS: V9938 command opcode counts and rolling history");
}

#ifdef V9938_DIAGNOSTIC_TIMED_D0_CE
static void test_v9938_d0_diagnostic_ce_timing(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    write_register(vdp, 0, 0x06); /* SCREEN 5. */
    write_register(vdp, 1, 0x00); /* HMMM off-display timing: 92 ticks/byte. */
    vdp->vram[0] = 0x5A;
    write_register(vdp, 32, 0); write_register(vdp, 34, 0);
    write_register(vdp, 36, 2); write_register(vdp, 38, 0);
    write_register(vdp, 40, 2); write_register(vdp, 42, 1);
    v9938_set_trace_cpu_time(vdp, 1000u);
    write_register(vdp, 46, 0xD0); /* One HMMM byte, 92 master ticks. */

    assert(vdp->vram[1] == 0x5A); /* A/B holds copy data immediate. */
    assert(v9938_peek_status(vdp, 2) & 0x01); /* CE remains busy. */
    assert((uint32_t)(vdp->commandBusyUntil - 1000u) >= 92u);
    v9938_set_trace_cpu_time(vdp, vdp->commandBusyUntil - 1u);
    assert(v9938_read_port(vdp, 0x99) & 0x01);
    v9938_set_trace_cpu_time(vdp, vdp->commandBusyUntil);
    assert(!(v9938_peek_status(vdp, 2) & 0x01));

    v9938_destroy(vdp);
    puts("PASS: diagnostic D0 CE delay leaves VRAM copy immediate");
}
#endif

static void test_v9938_address_set_preserves_r14(void)
{
    V9938 *vdp = v9938_create();
    assert(vdp != NULL);
    uint8_t *vram = v9938_get_vram(vdp);

    /* R#14 low bits are A16-A14.  Setting the 14-bit address pointer must
     * keep them, or every off-screen buffer above 0x3FFF becomes unreachable
     * (the bug that emptied the Space Manbow / V-Killer back buffers). */
    write_register(vdp, 14, 0x04); /* page 0x10000 */
    v9938_write_port(vdp, 0x99, 0x20);       /* low address byte */
    v9938_write_port(vdp, 0x99, 0x40 | 0x00); /* high byte, write mode */
    v9938_write_port(vdp, 0x98, 0x5A);
    assert(v9938_peek_register(vdp, 14) == 0x04);
    assert(vram[0x10020] == 0x5A);
    assert(vram[0x0020] == 0x00);

    /* The pointer now sits at 0x10021 and must keep incrementing there. */
    v9938_write_port(vdp, 0x98, 0x5B);
    assert(vram[0x10021] == 0x5B);

    /* Auto-increment across the 0x3FFF boundary bumps R#14 exactly once. */
    write_register(vdp, 14, 0x00);
    v9938_write_port(vdp, 0x99, 0xFE);
    v9938_write_port(vdp, 0x99, 0x40 | 0x3F); /* address 0x3FFE */
    v9938_write_port(vdp, 0x98, 0x11);        /* 0x3FFE */
    v9938_write_port(vdp, 0x98, 0x22);        /* 0x3FFF */
    assert(v9938_peek_register(vdp, 14) == 0x01); /* A14 set: 0x4000 */
    v9938_write_port(vdp, 0x98, 0x33);        /* 0x4000 */
    assert(v9938_peek_register(vdp, 14) == 0x01);
    assert(vram[0x3FFE] == 0x11);
    assert(vram[0x3FFF] == 0x22);
    assert(vram[0x4000] == 0x33);

    v9938_destroy(vdp);
    puts("PASS: V9938 address set preserves R#14 page bits");
}

int main()
{
    printf("Running V9938 tests...\n");
    
    test_v9938_ports_and_registers();
    test_v9938_address_set_preserves_r14();
    test_v9938_r45_and_irq();
    test_v9938_line_interrupt();
    test_v9938_screen1_render();
    test_v9938_screen5_render();
    test_v9938_screen8_rgb_render();
    test_v9938_screen6_full_width_render();
    test_v9938_screen8_pixel_command();
    test_v9938_point_pset_srch_commands();
    test_v9938_high_speed_fill_commands_modes6_to8();
    test_v9938_screen4_graphic3_render();
    test_v9938_screen5_vertical_scroll_wrap();
    test_v9938_screen5_hmmv_hmmc_hmmm();
    test_v9938_hmmc_trace_wrap();
    test_v9938_sprite_mode2_pattern_and_color();
    test_v9938_command_history();
#ifdef V9938_DIAGNOSTIC_TIMED_D0_CE
    test_v9938_d0_diagnostic_ce_timing();
#endif
    
    printf("All V9938 tests passed!\n");
    return 0;
}
