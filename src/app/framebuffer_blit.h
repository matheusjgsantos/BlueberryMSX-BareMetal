#ifndef MSX_FRAMEBUFFER_BLIT_H
#define MSX_FRAMEBUFFER_BLIT_H

#include <stdint.h>

/* Source is 256x192 XRGB8888; destination pitch is always in bytes.
 * Circle's 16-bit framebuffer uses RGB565, its 32-bit buffer XRGB8888. */
static inline int msx_blit_frame(void *dst, int width, int height, int pitch,
                               int depth, const uint32_t *src)
{
    if (!dst || !src || width <= 0 || height <= 0 ||
        (depth != 16 && depth != 32) || pitch <= 0 ||
        pitch % (depth / 8) || width > pitch / (depth / 8)) return 0;

    for (int y = 0; y < height; y++) {
        const uint32_t *row = src + (y * 192 / height) * 256;
        uint8_t *out = (uint8_t *)dst + y * pitch;
        for (int x = 0; x < width; x++) {
            uint32_t rgb = row[x * 256 / width];
            if (depth == 16)
                ((uint16_t *)out)[x] = (uint16_t)(((rgb >> 8) & 0xF800) |
                                                ((rgb >> 5) & 0x07E0) |
                                                ((rgb >> 3) & 0x001F));
            else
                ((uint32_t *)out)[x] = rgb;
        }
    }
    return 1;
}

#endif
