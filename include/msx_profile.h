#ifndef MSX_PROFILE_H
#define MSX_PROFILE_H

#include "msx_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Machine profiles: the composition a machine needs before it can run.
 *
 * A profile is data, not behavior: the machine builds CPU, memory and device
 * seams from it in src/core/msx.c. Device implementations still live behind
 * the existing seams (memory ops, video/audio/input ops), so adding a machine
 * does not fork the frame loop or the CPU wiring.
 *
 * MSX1 is the verified profile. ColecoVision uses the same Z80 core and
 * TMS9918 chip but a flat memory map, NMI instead of IRQ, and the VDP on
 * 0xBE/0xBF. Its SN76489 audio and full hand-controller protocol are separate
 * device steps; the profile currently installs the AY device (silent on the
 * Coleco ports) and a basic controller-1 joystick adapter. */

typedef enum {
    MSX_PROFILE_MSX1 = 0,
    MSX_PROFILE_COLECOVISION,
    MSX_PROFILE_COUNT
} MSX_ProfileId;

typedef enum {
    MSX_PROFILE_IRQ = 0,   /* VDP sync asserts the maskable interrupt line */
    MSX_PROFILE_NMI        /* VDP sync asserts NMI (ColecoVision) */
} MSX_ProfileInterrupt;

typedef enum {
    MSX_PROFILE_MEMORY_SLOTS = 0,
    MSX_PROFILE_MEMORY_FLAT
} MSX_ProfileMemory;

typedef enum {
    MSX_PROFILE_INPUT_PPI = 0,
    MSX_PROFILE_INPUT_COLECO
} MSX_ProfileInput;

typedef enum {
    MSX_PROFILE_AUDIO_AY = 0,
    MSX_PROFILE_AUDIO_SN76489
} MSX_ProfileAudio;

typedef struct {
    MSX_ProfileId id;
    const char *name;        /* overlay label, e.g. "MSX1" */
    const char *ini_name;    /* msx.ini value, e.g. "msx1" */

    MSX_ProfileInterrupt interrupt_mode;
    MSX_ProfileMemory memory;
    MSX_ProfileInput input;
    MSX_ProfileAudio audio;

    /* Canonical device ports after the machine's decode (the chip adapters
     * always see their native port numbers). */
    UInt16 video_data_port;
    UInt16 video_ctrl_port;
} MSX_MachineProfile;

const MSX_MachineProfile *msx_profile_get(MSX_ProfileId id);
const MSX_MachineProfile *msx_profile_by_name(const char *name);
const MSX_MachineProfile *msx_profile_by_ini(const char *value);
const char *msx_profile_name(MSX_ProfileId id);

#ifdef __cplusplus
}
#endif

#endif /* MSX_PROFILE_H */
