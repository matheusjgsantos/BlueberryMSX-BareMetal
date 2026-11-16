#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "framebuffer_blit.h"

int main(void)
{
    static uint32_t src[256 * 192];
    const uint32_t colors[] = {0xFF0000, 0x00FF00, 0x0000FF, 0xFFFFFF};
    const uint16_t packed[] = {0xF800, 0x07E0, 0x001F, 0xFFFF};
    for (int y = 0; y < 192; y++)
        for (int x = 0; x < 256; x++)
            src[y * 256 + x] = colors[(y >= 96) * 2 + (x >= 128)];
    for (int depth = 16; depth <= 32; depth += 16) {
        int bytes = depth / 8;
        for (int padding = 0; padding <= 16; padding += 16) {
            int pitch = 800 * bytes + padding;
            size_t size = (size_t)pitch * 480;
            uint8_t *mem = malloc(size + 32);
            assert(mem);
            memset(mem, 0xA5, size + 32);
            assert(msx_blit_frame(mem + 16, 800, 480, pitch, depth, src));
            for (int y = 0; y < 480; y++) {
                uint8_t *row = mem + 16 + y * pitch;
                for (int x = 0; x < 800; x++) {
                    int c = (y >= 240) * 2 + (x >= 400);
                    if (depth == 16) assert(((uint16_t *)row)[x] == packed[c]);
                    else assert(((uint32_t *)row)[x] == colors[c]);
                }
                for (int p = 800 * bytes; p < pitch; p++) assert(row[p] == 0xA5);
            }
            for (int i = 0; i < 16; i++) {
                assert(mem[i] == 0xA5);
                assert(mem[16 + size + i] == 0xA5);
            }
            free(mem);
        }
    }
    uint32_t guard = 0x12345678;
    assert(!msx_blit_frame(&guard, 800, 480, 1600, 32, src));
    assert(!msx_blit_frame(&guard, 800, 480, 800, 8, src));
    assert(guard == 0x12345678);
    static uint32_t tall[256 * 212];
    static uint32_t scaled[256 * 480];
    for (int y = 0; y < 212; y++)
        for (int x = 0; x < 256; x++) tall[y * 256 + x] = (uint32_t)y;
    assert(msx_blit_frame_sized(scaled, 256, 480, 256 * 4, 32, tall, 256, 212));
    for (int y = 0; y < 480; y++)
        assert(scaled[y * 256] == (uint32_t)(y * 212 / 480));
    assert(scaled[479 * 256] == 211); /* includes bottom active row */
    assert(!msx_blit_frame_sized(scaled, 256, 480, 256 * 4, 32, tall, 256, 0));

    /* A 512-dot SCREEN 6/7 source keeps its horizontal detail instead of
     * sampling only the left half. */
    static uint32_t wide[512 * 212];
    static uint32_t wide_out[800 * 480];
    for (int y = 0; y < 212; y++)
        for (int x = 0; x < 512; x++)
            wide[y * 512 + x] = (uint32_t)(x / 64); /* eight 64-dot bands */
    assert(msx_blit_frame_sized(wide_out, 800, 480, 800 * 4, 32, wide,
                                512, 212));
    for (int x = 0; x < 800; x++)
        assert(wide_out[x] == (uint32_t)((x * 512 / 800) / 64));
    assert(wide_out[799] == 7u); /* the far right band is visible */
    puts("PASS: RGB565/XRGB8888 scaling, row padding, bounds and invalid pitch");
    return 0;
}
