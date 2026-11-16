#ifndef MSX_FRAMEBUFFER_BLIT_H
#define MSX_FRAMEBUFFER_BLIT_H

#include <stdint.h>

/* The renderer reserves a 512-dot row even in 256-dot modes. Keep the source
 * stride separate from its visible width when scaling or packing a capture. */
static inline int msx_blit_frame_strided(void *dst, int width, int height, int pitch,
                                         int depth, const uint32_t *src,
                                         int src_stride, int src_width, int src_height)
{
    if (!dst || !src || width <= 0 || height <= 0 ||
        src_width <= 0 || src_height <= 0 || src_stride < src_width ||
        (depth != 16 && depth != 32) || pitch <= 0 ||
        pitch % (depth / 8) || width > pitch / (depth / 8)) return 0;

    for (int y = 0; y < height; y++) {
        const uint32_t *row = src + (y * src_height / height) * src_stride;
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

/* Convert a strided source into packed RGB888 for PPM capture. The caller
 * allocates at least src_width * src_height * 3 bytes. */
static inline int msx_pack_rgb888(uint8_t *dst, const uint32_t *src,
                                   int src_stride, int src_width, int src_height)
{
    if (!dst || !src || src_width <= 0 || src_height <= 0 ||
        src_stride < src_width) return 0;
    for (int y = 0; y < src_height; y++) {
        const uint32_t *row = src + y * src_stride;
        for (int x = 0; x < src_width; x++) {
            uint32_t rgb = row[x];
            int p = (y * src_width + x) * 3;
            dst[p + 0] = (uint8_t)(rgb >> 16);
            dst[p + 1] = (uint8_t)(rgb >> 8);
            dst[p + 2] = (uint8_t)rgb;
        }
    }
    return 1;
}

/* Compatibility for callers whose source is tightly packed. Destination
 * pitch is in bytes; Circle uses RGB565 at depth 16 and XRGB8888 at 32. */
static inline int msx_blit_frame_sized(void *dst, int width, int height, int pitch,
                                       int depth, const uint32_t *src,
                                       int src_width, int src_height)
{
    return msx_blit_frame_strided(dst, width, height, pitch, depth, src,
                                   src_width, src_width, src_height);
}

/* Compatibility wrapper for the MSX1/TMS9918 192-line source. */
static inline int msx_blit_frame(void *dst, int width, int height, int pitch,
                                int depth, const uint32_t *src)
{
    return msx_blit_frame_sized(dst, width, height, pitch, depth, src, 256, 192);
}

#endif
