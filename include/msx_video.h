#ifndef MSX_VIDEO_H
#define MSX_VIDEO_H

#include "msx_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Video device seam.
 *
 * The machine no longer calls the TMS9918 directly: it owns an MSX_Video
 * (ops + device instance) and drives it through these functions. A machine
 * profile installs the device it needs; the MSX1 profile installs the
 * TMS9918 adapter from src/core/msx_video_tms9918.c, which also owns the MSX
 * port map (0x98-0x9F).
 *
 * The ops table is deliberately about device actions, not port arithmetic:
 * the machine decides which ports belong to the video device, and the frame
 * sequencer (msx_step_frame) decides when to latch the sync IRQ and render.
 */

typedef struct {
    /* Port access. The machine only calls these for ports it routed to the
     * video device. */
    UInt8 (*read_io)(void *dev, UInt16 port);
    void  (*write_io)(void *dev, UInt16 port, UInt8 val);

    /* Latch the VBlank/sync interrupt for the frame that just ran. */
    void  (*sync_irq)(void *dev);

    /* Non-zero while the device is asserting its interrupt line. */
    int   (*irq_pending)(void *dev);

    /* Release the device instance. */
    void  (*destroy)(void *dev);
} MSX_VideoOps;

typedef struct {
    const MSX_VideoOps *ops;
    void *dev;
} MSX_Video;

/* Install an arbitrary device implementation. */
void msx_video_attach(MSX_Video *video, const MSX_VideoOps *ops, void *dev);

/* Create the MSX1 video device (TMS9918). Returns 0 on success. */
int msx_video_init_tms9918(MSX_Video *video);

void msx_video_destroy(MSX_Video *video);

UInt8 msx_video_read_io(MSX_Video *video, UInt16 port);
void msx_video_write_io(MSX_Video *video, UInt16 port, UInt8 val);
void msx_video_sync_irq(MSX_Video *video);
int msx_video_irq_pending(const MSX_Video *video);

#ifdef __cplusplus
}
#endif

#endif /* MSX_VIDEO_H */
