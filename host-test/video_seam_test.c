#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "msx.h"
#include "msx_video.h"
#include "tms9918.h"

/* Fake device: proves the seam is device-agnostic (a future machine can
 * install a different video chip without touching the machine code). */
typedef struct {
    int writes;
    int reads;
    int syncs;
    int irq;
    int destroyed;
    UInt8 last_port;
    UInt8 last_val;
} FakeVideo;

static UInt8 fake_read(void *dev, UInt16 port)
{
    FakeVideo *f = (FakeVideo *)dev;
    f->reads++;
    f->last_port = (UInt8)port;
    return 0x5A;
}

static void fake_write(void *dev, UInt16 port, UInt8 val)
{
    FakeVideo *f = (FakeVideo *)dev;
    f->writes++;
    f->last_port = (UInt8)port;
    f->last_val = val;
}

static void fake_sync(void *dev) { ((FakeVideo *)dev)->syncs++; }
static int fake_irq(void *dev) { return ((FakeVideo *)dev)->irq; }
static void fake_destroy(void *dev) { ((FakeVideo *)dev)->destroyed++; }

static const MSX_VideoOps kFakeOps = {
    fake_read, fake_write, fake_sync, fake_irq, fake_destroy
};

static void test_seam_is_device_agnostic(void)
{
    MSX_Video video = {0};
    FakeVideo fake = {0};

    msx_video_attach(&video, &kFakeOps, &fake);

    msx_video_write_io(&video, 0x98, 0x42);
    assert(fake.writes == 1 && fake.last_port == 0x98 && fake.last_val == 0x42);
    assert(msx_video_read_io(&video, 0x99) == 0x5A);
    assert(fake.reads == 1 && fake.last_port == 0x99);

    assert(msx_video_irq_pending(&video) == 0);
    msx_video_sync_irq(&video);
    assert(fake.syncs == 1);
    fake.irq = 1;
    assert(msx_video_irq_pending(&video) == 1);

    msx_video_destroy(&video);
    assert(fake.destroyed == 1);
    assert(video.ops == NULL && video.dev == NULL);

    /* Calls after destroy are inert, not crashes. */
    msx_video_write_io(&video, 0x98, 0x00);
    assert(msx_video_read_io(&video, 0x99) == 0xFF);
    assert(msx_video_irq_pending(&video) == 0);
    msx_video_destroy(&video); /* idempotent */
    msx_video_sync_irq(NULL);
    msx_video_write_io(NULL, 0x98, 0);
    assert(msx_video_read_io(NULL, 0x98) == 0xFF);
    assert(msx_video_irq_pending(NULL) == 0);
}

static void vdp_write_reg(TMS9918 *vdp, UInt8 reg, UInt8 val)
{
    tms9918_write_reg(vdp, 0x99, val);
    tms9918_write_reg(vdp, 0x99, (UInt8)(0x80 | reg));
}

static void test_tms9918_adapter_matches_chip(void)
{
    MSX_Video video = {0};
    TMS9918 *raw = tms9918_create();
    assert(raw != NULL);
    assert(msx_video_init_tms9918(&video) == 0);
    assert(video.dev != NULL && video.ops != NULL);

    /* A register + VRAM sequence through both paths must produce identical
     * chip state: the adapter is a pure forwarder, not a reimplementation. */
    vdp_write_reg(raw, 1, 0x20); /* enable the sync interrupt */
    vdp_write_reg((TMS9918 *)video.dev, 1, 0x20);

    /* Point both VRAM latches at 0x0000 for writing. */
    tms9918_write_reg(raw, 0x99, 0x00);
    tms9918_write_reg(raw, 0x99, 0x40);
    tms9918_write_reg((TMS9918 *)video.dev, 0x99, 0x00);
    tms9918_write_reg((TMS9918 *)video.dev, 0x99, 0x40);

    const UInt8 seq[] = { 0x00, 0x11, 0x22, 0x33, 0x44, 0x55 };
    for (unsigned i = 0; i < sizeof seq; i++) {
        msx_video_write_io(&video, 0x98, seq[i]);
        tms9918_write_reg(raw, 0x98, seq[i]);
    }
    for (unsigned i = 0; i < sizeof seq; i++) {
        assert(((TMS9918 *)video.dev)->vram[0x0000 + i] == raw->vram[0x0000 + i]);
        assert(((TMS9918 *)video.dev)->vram[0x0000 + i] == seq[i]);
    }
    for (unsigned r = 0; r < 8; r++)
        assert(((TMS9918 *)video.dev)->reg[r] == raw->reg[r]);

    /* Sync IRQ: latched by both, visible through the seam, cleared by a status
     * read through the seam exactly like a direct chip read. */
    msx_video_sync_irq(&video);
    tms9918_gen_sync_irq(raw);
    assert(msx_video_irq_pending(&video) == 1);
    assert(raw->irq == 1);

    UInt8 st_seam = msx_video_read_io(&video, 0x99);
    UInt8 st_raw = tms9918_read_reg(raw, 0x99);
    assert(st_seam == st_raw);
    assert((st_seam & 0x80) != 0);
    assert(msx_video_irq_pending(&video) == 0);
    assert(raw->irq == 0);

    msx_video_destroy(&video);
    tms9918_destroy(raw);
}

static void test_machine_alias(void)
{
    MSX_Machine *m = msx_create();
    assert(m != NULL);
    assert(m->video.dev != NULL && m->video.ops != NULL);
    /* The Circle renderer and older tests read the chip pointer directly. */
    assert(m->video.dev == m->vdp);

    msx_video_write_io(&m->video, 0x99, 0x03); /* two-byte command, byte 1 */
    msx_video_write_io(&m->video, 0x99, 0x80 | 3); /* register 3 <- 0x03 */
    assert(((TMS9918 *)m->vdp)->reg[3] == 0x03);
    msx_destroy(m);
}

int main(void)
{
    test_seam_is_device_agnostic();
    test_tms9918_adapter_matches_chip();
    test_machine_alias();
    puts("PASS: video seam forwards to the TMS9918 and accepts other devices");
    return 0;
}
