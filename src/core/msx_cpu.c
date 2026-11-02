//
// msx_cpu.c
//
// BlueberryMSX - CPU/clock seam for the portable emulation core.
//
// The machine talks to a CPU through include/msx_cpu.h only: create, execute
// one instruction, read the master-tick clock, drive the interrupt line. This
// file is the first implementation of that seam and wraps the R800/Z80 core
// without changing its behavior.
//
// Keep this thin. Machine-specific policy (slot decoding, frame pacing, VDP
// sync) belongs in msx.c; CPU-specific behavior belongs in src/chips/<cpu>.
//

#include <msx_cpu.h>

#include "R800.h"

#include <stdlib.h>

struct MSX_CPU {
    R800 *r800;
};

/* The R800 core exposes debug/patch/timer hooks the MSX machine does not use.
 * They are installed as no-ops so the seam does not need R800 callbacks in its
 * public API. */
static void cpu_nop_patch(void *ref, CpuRegs *regs) { (void)ref; (void)regs; }
static void cpu_nop_timer(void *ref) { (void)ref; }
static void cpu_nop_breakpoint(void *ref, UInt16 pc) { (void)ref; (void)pc; }
static void cpu_nop_debug(void *ref, int cmd, const char *data)
{
    (void)ref; (void)cmd; (void)data;
}
static void cpu_nop_trap(void *ref, UInt8 val) { (void)ref; (void)val; }
static void cpu_nop_watch_mem(void *ref, UInt16 addr, UInt8 val)
{
    (void)ref; (void)addr; (void)val;
}
static void cpu_nop_watch_io(void *ref, UInt16 port, UInt8 val)
{
    (void)ref; (void)port; (void)val;
}

MSX_CPU *msx_cpu_create(unsigned options, const MSX_CPUBus *bus, void *bus_ref)
{
    if (!bus || !bus->read_mem || !bus->write_mem ||
        !bus->read_io || !bus->write_io) {
        return NULL;
    }

    MSX_CPU *cpu = (MSX_CPU *)calloc(1, sizeof(MSX_CPU));
    if (!cpu) return NULL;

    UInt32 flags = 0;
    if (options & MSX_CPU_OPTION_M1) flags |= CPU_ENABLE_M1;

    cpu->r800 = r800Create(flags,
                           bus->read_mem, bus->write_mem,
                           bus->read_io, bus->write_io,
                           cpu_nop_patch, cpu_nop_timer,
                           cpu_nop_breakpoint, cpu_nop_debug,
                           cpu_nop_trap, cpu_nop_watch_mem, cpu_nop_watch_io,
                           bus_ref);
    if (!cpu->r800) {
        free(cpu);
        return NULL;
    }

    return cpu;
}

void msx_cpu_destroy(MSX_CPU *cpu)
{
    if (!cpu) return;
    if (cpu->r800) r800Destroy(cpu->r800);
    free(cpu);
}

void msx_cpu_execute(MSX_CPU *cpu)
{
    if (!cpu || !cpu->r800) return;
    r800ExecuteInstruction(cpu->r800);
}

UInt32 msx_cpu_get_time(const MSX_CPU *cpu)
{
    if (!cpu || !cpu->r800) return 0;
    return (UInt32)r800GetSystemTime(cpu->r800);
}

void msx_cpu_set_irq(MSX_CPU *cpu)
{
    if (!cpu || !cpu->r800) return;
    r800SetInt(cpu->r800);
}

void msx_cpu_clear_irq(MSX_CPU *cpu)
{
    if (!cpu || !cpu->r800) return;
    r800ClearInt(cpu->r800);
}

void msx_cpu_set_nmi(MSX_CPU *cpu)
{
    if (!cpu || !cpu->r800) return;
    r800SetNmi(cpu->r800);
}

void msx_cpu_clear_nmi(MSX_CPU *cpu)
{
    if (!cpu || !cpu->r800) return;
    r800ClearNmi(cpu->r800);
}

UInt16 msx_cpu_get_pc(const MSX_CPU *cpu)
{
    if (!cpu || !cpu->r800) return 0;
    return cpu->r800->regs.PC.W;
}

void *msx_cpu_native_handle(MSX_CPU *cpu)
{
    return cpu ? (void *)cpu->r800 : NULL;
}
