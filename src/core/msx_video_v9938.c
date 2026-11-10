#include "../include/msx.h"
#include "../include/msx_memory.h"
#include "../chips/vdp/v9938.h"
#include <string.h>
#include <stdlib.h>

// Video device interface for V9938
typedef struct {
    V9938 *vdp;
    MSX_Machine *machine;
} V9938_Device;

static void v9938_write_register(V9938_Device *device, unsigned reg, uint8_t value)
{
    if (device && device->vdp) {
        v9938_write(device->vdp, reg, value);
    }
}

static uint8_t v9938_read_register(V9938_Device *device, unsigned reg)
{
    if (device && device->vdp) {
        return v9938_peek_register(device->vdp, reg);
    }
    return 0;
}

// Implementation of V9938 video device interface functions
void v9938_init(MSX_Machine *machine)
{
    V9938_Device *device = (V9938_Device *)calloc(1, sizeof(V9938_Device));
    if (!device) return;
    
    device->vdp = v9938_create();
    if (!device->vdp) {
        free(device);
        return;
    }
    
    device->machine = machine;
    
    // Store the device in the machine structure
    machine->vdp = device;
}

void v9938_destroy(MSX_Machine *machine)
{
    if (machine && machine->vdp) {
        V9938_Device *device = (V9938_Device *)machine->vdp;
        if (device->vdp) {
            v9938_destroy(device->vdp);
        }
        free(device);
        machine->vdp = NULL;
    }
}

void v9938_write_io(MSX_Machine *machine, uint16_t port, uint8_t value)
{
    if (machine && machine->vdp) {
        V9938_Device *device = (V9938_Device *)machine->vdp;
        if (device->vdp) {
            v9938_write(device->vdp, port & 0x0F, value);
        }
    }
}

uint8_t v9938_read_io(MSX_Machine *machine, uint16_t port)
{
    if (machine && machine->vdp) {
        V9938_Device *device = (V9938_Device *)machine->vdp;
        if (device->vdp) {
            return v9938_peek_register(device->vdp, port & 0x0F);
        }
    }
    return 0;
}

void v9938_write_vram(MSX_Machine *machine, uint16_t addr, uint8_t value)
{
    if (machine && machine->vdp) {
        V9938_Device *device = (V9938_Device *)machine->vdp;
        if (device->vdp) {
            v9938_write_vram(device->vdp, addr, value);
        }
    }
}

uint8_t v9938_read_vram(MSX_Machine *machine, uint16_t addr)
{
    if (machine && machine->vdp) {
        V9938_Device *device = (V9938_Device *)machine->vdp;
        if (device->vdp) {
            return v9938_peek_vram(device->vdp, addr);
        }
    }
    return 0;
}