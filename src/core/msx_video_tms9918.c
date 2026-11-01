//
// msx_video_tms9918.c
//
// BlueberryMSX - MSX1 video device adapter.
//
// Implements the MSX_Video seam (include/msx_video.h) over the TMS9918 chip
// model in src/chips/vdp/tms9918.c. This is where the MSX port map for video
// lives: src/core/msx.c routes 0x98-0x9F here and does not include the chip
// header any more.
//
// A future machine with another video chip (or the same chip on different
// ports, e.g. ColecoVision 0xBE/0xBF) installs its own ops table instead; nothing
// in this file is MSX-specific except the fact that the machine routes
// 0x98-0x9F to it.
//

#include <msx_video.h>

#include <stddef.h>

#include "tms9918.h"

static UInt8 tms_read(void *dev, UInt16 port)
{
    return tms9918_read_reg((TMS9918 *)dev, port);
}

static void tms_write(void *dev, UInt16 port, UInt8 val)
{
    tms9918_write_reg((TMS9918 *)dev, port, val);
}

static void tms_sync_irq(void *dev)
{
    tms9918_gen_sync_irq((TMS9918 *)dev);
}

static int tms_irq_pending(void *dev)
{
    return ((TMS9918 *)dev)->irq != 0;
}

static void tms_destroy(void *dev)
{
    tms9918_destroy((TMS9918 *)dev);
}

static const MSX_VideoOps s_tms9918_ops = {
    tms_read,
    tms_write,
    tms_sync_irq,
    tms_irq_pending,
    tms_destroy
};

void msx_video_attach(MSX_Video *video, const MSX_VideoOps *ops, void *dev)
{
    if (!video) return;
    video->ops = ops;
    video->dev = dev;
}

int msx_video_init_tms9918(MSX_Video *video)
{
    if (!video) return -1;
    video->ops = NULL;
    video->dev = tms9918_create();
    if (!video->dev) return -1;
    video->ops = &s_tms9918_ops;
    return 0;
}

void msx_video_destroy(MSX_Video *video)
{
    if (!video) return;
    if (video->ops && video->ops->destroy && video->dev)
        video->ops->destroy(video->dev);
    video->ops = NULL;
    video->dev = NULL;
}

UInt8 msx_video_read_io(MSX_Video *video, UInt16 port)
{
    if (!video || !video->ops || !video->ops->read_io) return 0xFF;
    return video->ops->read_io(video->dev, port);
}

void msx_video_write_io(MSX_Video *video, UInt16 port, UInt8 val)
{
    if (!video || !video->ops || !video->ops->write_io) return;
    video->ops->write_io(video->dev, port, val);
}

void msx_video_sync_irq(MSX_Video *video)
{
    if (!video || !video->ops || !video->ops->sync_irq) return;
    video->ops->sync_irq(video->dev);
}

int msx_video_irq_pending(const MSX_Video *video)
{
    if (!video || !video->ops || !video->ops->irq_pending) return 0;
    return video->ops->irq_pending(video->dev) != 0;
}
