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
    v9938_write_port(vdp, 0x9A, 0x70); /* full red, no green */
    v9938_write_port(vdp, 0x9A, 0x00); /* no blue */
    v9938_get_vram(vdp)[0] = 0x10; /* x=0 is the high nibble */

    uint32_t frame[256 * 192];
    memset(frame, 0, sizeof frame);
    v9938_render(vdp, frame, 256 * 4);
    assert(frame[0] == 0x00FF0000);
    v9938_destroy(vdp);
    puts("PASS: V9938 SCREEN 5 render and palette output");
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

int main()
{
    printf("Running V9938 tests...\n");
    
    test_v9938_ports_and_registers();
    test_v9938_r45_and_irq();
    test_v9938_screen1_render();
    test_v9938_screen5_render();
    
    printf("All V9938 tests passed!\n");
    return 0;
}
