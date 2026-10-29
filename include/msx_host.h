#ifndef MSX_HOST_H
#define MSX_HOST_H

#include "msx_types.h"

/*
 * Host services used by the emulation core for machine-expansion accesses and
 * diagnostics. The callback signatures intentionally match the existing
 * MSX_Machine fields so this table can be introduced without changing the
 * current MSX1 routing or ABI users that assign those fields directly.
 *
 * A host implementation owns ref. The core never allocates, frees, blocks, or
 * interprets the object behind it. Callback affinity and blocking rules are
 * defined by the host adapter (Circle currently routes these to core 0 / the
 * physical RPMC bus).
 */
typedef struct {
    void *ref;

    UInt8 (*bus_read)(void *ref, int nBusSlot, UInt16 addr);
    void (*bus_write)(void *ref, int nBusSlot, UInt16 addr, UInt8 val);
    UInt8 (*bus_read_io)(void *ref, UInt16 port);
    void (*bus_write_io)(void *ref, UInt16 port, UInt8 val);

    void (*diag_log)(const char *line, void *ref);
    void *diag_ref;
    int diag_log_budget;
} MSX_HostCallbacks;

#endif /* MSX_HOST_H */
