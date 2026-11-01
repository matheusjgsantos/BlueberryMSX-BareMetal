#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "msx.h"

typedef struct {
    unsigned reads;
    unsigned writes;
    unsigned io_reads;
    unsigned io_writes;
    unsigned last_slot;
    UInt16 last_addr;
    UInt8 last_value;
    unsigned diagnostics;
    char last_line[160];
} FakeHost;

static UInt8 fake_bus_read(void *ref, int nBusSlot, UInt16 addr) {
    FakeHost *host = (FakeHost *)ref;
    host->reads++;
    host->last_slot = (unsigned)nBusSlot;
    host->last_addr = addr;
    return (UInt8)(0x40u + (unsigned)nBusSlot + (addr & 0x0Fu));
}

static void fake_bus_write(void *ref, int nBusSlot, UInt16 addr, UInt8 val) {
    FakeHost *host = (FakeHost *)ref;
    host->writes++;
    host->last_slot = (unsigned)nBusSlot;
    host->last_addr = addr;
    host->last_value = val;
}

static UInt8 fake_bus_read_io(void *ref, UInt16 port) {
    FakeHost *host = (FakeHost *)ref;
    host->io_reads++;
    host->last_addr = port;
    return 0xA5;
}

static void fake_bus_write_io(void *ref, UInt16 port, UInt8 val) {
    FakeHost *host = (FakeHost *)ref;
    host->io_writes++;
    host->last_addr = port;
    host->last_value = val;
}

static void fake_diag(const char *line, void *ref) {
    FakeHost *host = (FakeHost *)ref;
    host->diagnostics++;
    strncpy(host->last_line, line, sizeof(host->last_line) - 1);
    host->last_line[sizeof(host->last_line) - 1] = '\0';
}

int main(void) {
    FakeHost host = {0};
    MSX_HostCallbacks callbacks = {0};
    callbacks.ref = &host;
    callbacks.bus_read = fake_bus_read;
    callbacks.bus_write = fake_bus_write;
    callbacks.bus_read_io = fake_bus_read_io;
    callbacks.bus_write_io = fake_bus_write_io;
    callbacks.diag_log = fake_diag;
    callbacks.diag_ref = &host;
    callbacks.diag_log_budget = 2;

    MSX_Machine *machine = msx_create();
    assert(machine != NULL);

    /* A host that provides everything at once installs bus and diagnostics. */
    msx_set_host_callbacks(machine, &callbacks);

    /* Route page 1 to physical slot 1, then exercise memory and I/O paths. */
    msx_slot_set_bus(machine, 1, 0, 0);
    machine->activeSlot[1] = 1;
    assert(machine->bus.read_mem(machine, 0x4000) == 0x40);
    machine->bus.write_mem(machine, 0x4000, 0x5A);
    assert(host.reads == 1 && host.writes == 1);
    assert(host.last_slot == 0 && host.last_addr == 0x4000);
    assert(host.last_value == 0x5A);

    assert(machine->bus.read_io(machine, 0x30) == 0xA5);
    machine->bus.write_io(machine, 0x30, 0xC3);
    assert(host.io_reads == 1 && host.io_writes == 1);
    assert(host.last_addr == 0x30 && host.last_value == 0xC3);

    /* Detaching the expansion bus must stop forwarding unmapped ports even
     * though the diagnostic sink stays installed. The machine answers the
     * port itself instead (0xFF for an unclaimed port). This is the v1.0
     * behavior when msxbus is off: no bus, no GPIO access from port I/O. */
    msx_set_bus_callbacks(machine, NULL);
    assert(machine->bus_ref == NULL);
    assert(machine->bus_read_io == NULL);
    assert(machine->diag_log == fake_diag);

    assert(machine->bus.read_io(machine, 0x30) == 0xFF);
    machine->bus.write_io(machine, 0x30, 0x11);
    assert(host.io_reads == 1 && host.io_writes == 1);

    /* Diagnostics keep their budget; re-attaching the bus does not reset it. */
    msx_diag(machine, "first %u", 1u);
    assert(host.diagnostics == 1);

    msx_set_bus_callbacks(machine, &callbacks);
    assert(machine->bus_read_io == fake_bus_read_io);
    assert(machine->diag_log_count == 1);

    msx_diag(machine, "second %u", 2u);
    msx_diag(machine, "budgeted out");
    assert(host.diagnostics == 2);
    assert(strcmp(host.last_line, "second 2") == 0);

    /* The bus is live again for unmapped ports. */
    assert(machine->bus.read_io(machine, 0x31) == 0xA5);
    machine->bus.write_io(machine, 0x31, 0x7E);
    assert(host.io_reads == 2 && host.io_writes == 2);

    msx_set_host_callbacks(machine, NULL);
    assert(machine->bus_ref == NULL);
    assert(machine->diag_log == NULL);
    msx_destroy(machine);

    puts("PASS: host callback table routes bus and diagnostics");
    return 0;
}
