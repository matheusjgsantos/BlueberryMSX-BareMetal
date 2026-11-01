#ifndef MSX_AUDIO_H
#define MSX_AUDIO_H

#include "msx_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Audio device seam.
 *
 * The machine owns an MSX_Audio (ops + device instance) and drives it through
 * these functions; it does not include the sound chip header. The MSX1 profile
 * installs the AY-3-8910 adapter from src/core/msx_audio_psg.c, which also owns
 * the PSG port protocol (0xA0 latch, 0xA1 data, 0xA2 read).
 *
 * Frame-timed writes
 * ------------------
 * The R800 core has no cycle counter, so the machine timestamps each sound
 * write with its position inside the frame (frac16 = 0..65535 of the frame's
 * instruction budget) and hands it to the device, which keeps its own log.
 * The device renders the frame in segments, applying each write at its
 * recorded position. Rendering a whole frame with only the final register
 * state audibly roughens fast passages (see the reference note in
 * Docs/ARCHITECTURE_AUDIT.md); the log belongs to the device so a future
 * machine can keep it or ignore frac16.
 */

typedef struct {
    /* Port access. The machine only calls these for ports it routed to the
     * audio device. */
    UInt8 (*read_io)(void *dev, UInt16 port);
    void  (*write_io)(void *dev, UInt16 port, UInt8 val);

    /* Write with its position in the current frame (0..65535). */
    void  (*write_io_at)(void *dev, UInt16 port, UInt8 val, UInt16 frac16);

    /* What the frame's write log holds (diagnostics). */
    UInt8 (*latched_register)(void *dev);

    /* Drop the pending frame write log (frame boundary / rebuild). */
    void  (*log_reset)(void *dev);

    /* Render `samples` mono samples covering `masterCycles` master clocks.
     * Returns the number of samples written. */
    unsigned (*render)(void *dev, Int16 *out, unsigned samples,
                       UInt32 masterCycles);

    /* The concrete chip pointer the adapter wraps (compatibility alias for
     * diagnostics and older tests, e.g. the PSG* behind the MSX1 device). */
    void *(*native)(void *dev);

    /* Release the device instance. */
    void  (*destroy)(void *dev);
} MSX_AudioOps;

typedef struct {
    const MSX_AudioOps *ops;
    void *dev;
} MSX_Audio;

/* Install an arbitrary device implementation. */
void msx_audio_attach(MSX_Audio *audio, const MSX_AudioOps *ops, void *dev);

/* Create the MSX1 audio device (AY-3-8910 PSG). Returns 0 on success. */
int msx_audio_init_psg(MSX_Audio *audio);

void msx_audio_destroy(MSX_Audio *audio);

UInt8 msx_audio_read_io(MSX_Audio *audio, UInt16 port);
void msx_audio_write_io(MSX_Audio *audio, UInt16 port, UInt8 val);
void msx_audio_write_io_at(MSX_Audio *audio, UInt16 port, UInt8 val,
                           UInt16 frac16);
UInt8 msx_audio_latched_register(const MSX_Audio *audio);
void *msx_audio_native(const MSX_Audio *audio);
void msx_audio_log_reset(MSX_Audio *audio);
unsigned msx_audio_render(MSX_Audio *audio, Int16 *out, unsigned samples,
                          UInt32 masterCycles);

#ifdef __cplusplus
}
#endif

#endif /* MSX_AUDIO_H */
