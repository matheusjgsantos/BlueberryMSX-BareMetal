/* Offline scanout of a captured VDS and its recorded raster-state CMD file.
 * No CPU/game execution or game-specific geometry. Useful for distinguishing
 * a VRAM-state divergence from a renderer divergence against a reference. */
#include "v9938.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t image[256 * V9938_MAX_DISPLAY_LINES];

int main(int argc, char **argv)
{
    if (argc != 4) {
        fprintf(stderr, "usage: %s CAPTURE.VDS CAPTURE.CMD OUTPUT.PPM\n", argv[0]);
        return 2;
    }
    FILE *fp = fopen(argv[1], "rb");
    if (!fp) { perror(argv[1]); return 1; }
    unsigned char header[140];
    V9938 *v = v9938_create();
    if (!v) { fclose(fp); return 1; }
    if (fread(header, 1, sizeof header, fp) != sizeof header ||
        memcmp(header, "MSXVDPS1", 8) || header[8] != 1 ||
        fread(v->vram, 1, sizeof v->vram, fp) != sizeof v->vram) {
        fprintf(stderr, "invalid or truncated VDS\n");
        fclose(fp); v9938_destroy(v); return 1;
    }
    fclose(fp);
    memcpy(v->reg, header + 24, sizeof v->reg);
    memcpy(v->status, header + 88, 4);
    memcpy(v->palette, header + 92, sizeof v->palette);
    v9938_frame_start(v);
    fp = fopen(argv[2], "r");
    if (!fp) { perror(argv[2]); v9938_destroy(v); return 1; }
    char line[512];
    unsigned transitions = 0;
    while (fgets(line, sizeof line, fp)) {
        unsigned y, r2, r7, r23, r25, r26, r27;
        if (sscanf(line, "raster %u R2=%x R7=%x R23=%x R25=%x R26=%x R27=%x",
                   &y, &r2, &r7, &r23, &r25, &r26, &r27) != 7) continue;
        if (y >= V9938_FRAME_LINES) {
            fprintf(stderr, "invalid raster line %u\n", y);
            fclose(fp); v9938_destroy(v); return 1;
        }
        V9938_LineState state = {r2, r7, r23, r25, r26, r27};
        for (unsigned i = y; i < V9938_FRAME_LINES; i++) v->lineState[i] = state;
        transitions++;
    }
    fclose(fp);
    if (!transitions) {
        fprintf(stderr, "no raster states in CMD; refusing a final-register-only replay\n");
        v9938_destroy(v); return 1;
    }
    unsigned height = v9938_render(v, image, 256 * 4);
    fp = fopen(argv[3], "wb");
    if (!fp) { perror(argv[3]); v9938_destroy(v); return 1; }
    int ok = fprintf(fp, "P6\n256 %u\n255\n", height) > 0;
    for (unsigned i = 0; ok && i < 256 * height; i++) {
        uint8_t rgb[3] = {(uint8_t)(image[i] >> 16),
                          (uint8_t)(image[i] >> 8), (uint8_t)image[i]};
        ok = fwrite(rgb, 1, 3, fp) == 3;
    }
    if (fclose(fp)) ok = 0;
    v9938_destroy(v);
    if (!ok) { fprintf(stderr, "PPM write failed\n"); return 1; }
    printf("replayed %u raster states at 256x%u\n", transitions, height);
    return 0;
}
