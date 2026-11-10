#ifndef MSX_CPU_H
#define MSX_CPU_H

#include "msx_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* CPU-facing memory and I/O bus. The machine owns decoding and passes this
 * table at CPU creation; the CPU implementation only calls the callbacks.
 *
 * This is the boundary a future CPU core implements against (LR35902 for
 * Game Boy, 6502 for other machines). It is deliberately narrower than the
 * MSX slot model: bank/slot policy stays in the machine. */
typedef struct {
    UInt8 (*read_mem)(void *ref, UInt16 addr);
    void  (*write_mem)(void *ref, UInt16 addr, UInt8 val);
    UInt8 (*read_io)(void *ref, UInt16 port);
    void  (*write_io)(void *ref, UInt16 port, UInt8 val);
} MSX_CPUBus;

/* Creation options. */
#define MSX_CPU_OPTION_M1 0x0001u  /* count the opcode-fetch (M1) cycle */

/* Opaque CPU context: state, clock and interrupt line behind one handle.
 * The current implementation wraps the R800/Z80 core in src/chips/z80; the
 * API is what the machine depends on, not the implementation. */
typedef struct MSX_CPU MSX_CPU;

/* Create a CPU bound to a memory/I/O bus. Returns NULL on failure or when the
 * bus table is incomplete. */
MSX_CPU *msx_cpu_create(unsigned options, const MSX_CPUBus *bus, void *bus_ref);
void msx_cpu_destroy(MSX_CPU *cpu);

/* Execute exactly one instruction (the frame pacer decides how many). */
void msx_cpu_execute(MSX_CPU *cpu);

/* Emulated time in CPU master ticks (wrapping UInt32, same unit and epoch the
 * R800 core uses). Hosts must compare with unsigned subtraction. */
UInt32 msx_cpu_get_time(const MSX_CPU *cpu);

/* Interrupt line. The machine raises it when a device requests an IRQ and the
 * CPU acknowledges it through its normal interrupt sequence. */
void msx_cpu_set_irq(MSX_CPU *cpu);
void msx_cpu_clear_irq(MSX_CPU *cpu);
void msx_cpu_set_nmi(MSX_CPU *cpu);
void msx_cpu_clear_nmi(MSX_CPU *cpu);

/* Current program counter, for machine-level diagnostics only. */
UInt16 msx_cpu_get_pc(const MSX_CPU *cpu);

/* Escape hatch to the implementation-specific state (currently R800*).
 * Compatibility only: the Circle app and the host tests still read registers
 * directly, and MSX_Machine.z80 aliases this pointer. New machine code must
 * use the functions above instead. */
void *msx_cpu_native_handle(MSX_CPU *cpu);

#ifdef __cplusplus
}
#endif

#endif /* MSX_CPU_H */
