#ifndef BUS_H
#define BUS_H

#include "msx_types.h"

typedef struct {
    UInt8 (*read_mem)(void *ref, UInt16 addr);
    void (*write_mem)(void *ref, UInt16 addr, UInt8 val);
    UInt8 (*read_io)(void *ref, UInt16 port);
    void (*write_io)(void *ref, UInt16 port, UInt8 val);
    void *ref;
} MSX_Bus;

#endif // BUS_H
