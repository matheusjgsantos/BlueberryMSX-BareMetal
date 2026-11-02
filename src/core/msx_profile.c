// Machine profile descriptors.
//
// Data only; src/core/msx.c composes the seams from these fields.

#include <msx_profile.h>

#include <stddef.h>
#include <string.h>
#include <strings.h>

static const MSX_MachineProfile s_profiles[MSX_PROFILE_COUNT] = {
    {
        MSX_PROFILE_MSX1,
        "MSX1",
        "msx1",
        MSX_PROFILE_IRQ,
        MSX_PROFILE_MEMORY_SLOTS,
        MSX_PROFILE_INPUT_PPI,
        MSX_PROFILE_AUDIO_AY,
        0x98,
        0x99,
    },
    {
        MSX_PROFILE_COLECOVISION,
        "COLECOVISION",
        "colecovision",
        MSX_PROFILE_NMI,
        MSX_PROFILE_MEMORY_FLAT,
        MSX_PROFILE_INPUT_COLECO,
        MSX_PROFILE_AUDIO_SN76489,
        0xBE,
        0xBF,
    },
};

const MSX_MachineProfile *msx_profile_get(MSX_ProfileId id)
{
    if ((int)id < 0 || (int)id >= MSX_PROFILE_COUNT) return NULL;
    return &s_profiles[id];
}

const char *msx_profile_name(MSX_ProfileId id)
{
    const MSX_MachineProfile *p = msx_profile_get(id);
    return p ? p->name : "UNKNOWN";
}

const MSX_MachineProfile *msx_profile_by_name(const char *name)
{
    if (!name) return NULL;
    for (int i = 0; i < MSX_PROFILE_COUNT; i++) {
        const MSX_MachineProfile *p = &s_profiles[i];
        if (strcasecmp(name, p->name) == 0 || strcasecmp(name, p->ini_name) == 0)
            return p;
        if (p->id == MSX_PROFILE_COLECOVISION && strcasecmp(name, "coleco") == 0)
            return p;
    }
    return NULL;
}

const MSX_MachineProfile *msx_profile_by_ini(const char *value)
{
    return msx_profile_by_name(value);
}
