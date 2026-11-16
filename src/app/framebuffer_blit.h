#ifndef MSX_FRAMEBUFFER_BLIT_H
#define MSX_FRAMEBUFFER_BLIT_H

#include <stdint.h>

/* Scale an XRGB8888 source to the physical framebuffer. Both source
 * dimensions are explicit: V9938 bitmap modes expose 192 or 212 active lines
 * and, in SCREEN 6/7, 512 dots instead of 256. Destination pitch is always in
 * bytes; Circle's 16-bit buffer uses RGB565 and its 32-bit buffer XRGB8888. */
static inline int msx_blit_frame_sized(void *dst, int width, int height, int pitch,
                                       int depth, const uint32_t *src,
                                       int src_width, int src_height)
{
    if (!dst || !src || width <= 0 || height <= 0 ||
        src_width <= 0 || src_height <= 0 ||
        (depth != 16 && depth != 32) || pitch <= 0 ||
        pitch % (depth / 8) || width > pitch / (depth / 8)) return 0;

    for (int y = 0; y < height; y++) {
        const uint32_t *row = src + (y * src_height / height) * src_width;
        uint8_t *out = (uint8_t *)dst + y * pitch;
        for (int x = 0; x < width; x++) {
            uint32_t rgb = row[x * src_width / width];
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

/* Compatibility wrapper for the MSX1/TMS9918 192-line source. */
static inline int msx_blit_frame(void *dst, int width, int height, int pitch,
                                int depth, const uint32_t *src)
{
    return msx_blit_frame_sized(dst, width, height, pitch, depth, src, 256, 192);
}

#endif
