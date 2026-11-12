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

    /* Control-port read address setup preloads the data read buffer. */
    v9938_write_port(vdp, 0x99, 0x34);
    v9938_write_port(vdp, 0x99, 0x00);
    assert(v9938_read_port(vdp, 0x98) == 0xAA);

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
    v9938_destroy(vdp);
    puts("PASS: V9938 SCREEN 5 render and palette output");
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
    write_register(vdp, 44, 0x12);
    assert(v9938_peek_status(vdp, 2) & 0x01);
    write_register(vdp, 44, 0x34);
    assert(vram[3 * 128 + 4] == 0x12);
    assert(vram[3 * 128 + 5] == 0x34);
    assert(!(v9938_peek_status(vdp, 2) & 0x01));
    assert(v9938_peek_status(vdp, 2) & 0x80);
    assert(v9938_peek_register(vdp, 44) == 0x34);

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
    assert(frame[1*256+34]==0x0024DA24); /* unchanged color; SAT X+2, Y+1. */
    assert(frame[1*256+35]==0x00000000); /* clear pattern bit remains background */
    v9938_destroy(vdp);
    puts("PASS: V9938 sprite mode 2 pattern/color fetch");
}

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
    test_v9938_screen1_render();
    test_v9938_screen5_render();
    test_v9938_screen5_vertical_scroll_wrap();
    test_v9938_screen5_hmmv_hmmc_hmmm();
    test_v9938_sprite_mode2_pattern_and_color();
    
    printf("All V9938 tests passed!\n");
    return 0;
}
