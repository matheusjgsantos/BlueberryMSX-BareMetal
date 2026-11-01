#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "msx_cpu.h"
#include "R800.h"

typedef struct {
    UInt8 mem[0x10000];
} FlatBus;

static UInt8 flat_read(void *ref, UInt16 addr) { return ((FlatBus *)ref)->mem[addr]; }
static void flat_write(void *ref, UInt16 addr, UInt8 val) { ((FlatBus *)ref)->mem[addr] = val; }
static UInt8 flat_read_io(void *ref, UInt16 port) { (void)ref; (void)port; return 0xFF; }
static void flat_write_io(void *ref, UInt16 port, UInt8 val) { (void)ref; (void)port; (void)val; }

static const MSX_CPUBus kBus = {
    flat_read, flat_write, flat_read_io, flat_write_io
};

/* Small Z80 program, then NOPs: exercises operand fetches, immediate loads,
 * memory stores and flag-changing arithmetic. */
static void load_program(FlatBus *bus) {
    static const UInt8 program[] = {
        0x3E, 0x12,             /* 0000  LD A,0x12        */
        0x06, 0x34,             /* 0002  LD B,0x34        */
        0x21, 0x00, 0x80,       /* 0004  LD HL,0x8000     */
        0x77,                   /* 0007  LD (HL),A        */
        0x23,                   /* 0008  INC HL           */
        0x05,                   /* 0009  DEC B            */
        0xAF,                   /* 000A  XOR A            */
        0x3C,                   /* 000B  INC A            */
        0xFE, 0x02,             /* 000C  CP 0x02          */
        0x00, 0x00, 0x00, 0x00, /* 000E  NOPs             */
    };
    memset(bus->mem, 0x00, sizeof bus->mem); /* NOP is 0x00 */
    memcpy(bus->mem, program, sizeof program);
}

int main(void) {
    FlatBus bus_ref = {0};
    FlatBus bus_wrap = {0};
    load_program(&bus_ref);
    load_program(&bus_wrap);

    /* The seam must reject an incomplete bus instead of crashing later. */
    assert(msx_cpu_create(MSX_CPU_OPTION_M1, NULL, NULL) == NULL);

    MSX_CPU *cpu = msx_cpu_create(MSX_CPU_OPTION_M1, &kBus, &bus_wrap);
    assert(cpu != NULL);
    assert(msx_cpu_native_handle(cpu) != NULL);

    /* Reference: the R800 core driven directly with the same flags and bus. */
    R800 *ref = r800Create(CPU_ENABLE_M1,
                           flat_read, flat_write, flat_read_io, flat_write_io,
                           NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                           &bus_ref);
    assert(ref != NULL);

    /* Option mapping is the only thing the wrapper may change: with M1 the
     * two paths must be instruction-for-instruction identical. */
    for (unsigned i = 0; i < 5000; i++) {
        msx_cpu_execute(cpu);
        r800ExecuteInstruction(ref);
        if (i < 64) {
            assert(msx_cpu_get_pc(cpu) == ref->regs.PC.W);
            assert(msx_cpu_get_time(cpu) == (UInt32)r800GetSystemTime(ref));
        }
    }
    assert(msx_cpu_get_pc(cpu) == ref->regs.PC.W);
    assert(msx_cpu_get_time(cpu) == (UInt32)r800GetSystemTime(ref));
    assert(msx_cpu_get_time(cpu) != 0);

    /* The compatibility handle must expose the same CPU state the wrapper
     * reports (the app and existing tests read registers through it). */
    R800 *native = (R800 *)msx_cpu_native_handle(cpu);
    assert(native != NULL);
    assert(native->regs.PC.W == msx_cpu_get_pc(cpu));
    assert(bus_wrap.mem[0x8000] == 0x12); /* LD (HL),A executed */
    assert(bus_wrap.mem[0x8000] == bus_ref.mem[0x8000]);
    for (unsigned addr = 0; addr < 0x10000; addr += 0x400)
        assert(bus_wrap.mem[addr] == bus_ref.mem[addr]);

    /* IRQ line changes must not disturb the instruction stream or clock. */
    UInt16 pc_before = msx_cpu_get_pc(cpu);
    UInt32 time_before = msx_cpu_get_time(cpu);
    msx_cpu_set_irq(cpu);
    msx_cpu_clear_irq(cpu);
    assert(msx_cpu_get_pc(cpu) == pc_before);
    assert(msx_cpu_get_time(cpu) == time_before);

    msx_cpu_destroy(cpu);
    r800Destroy(ref);

    /* Without M1 the clock must run faster than with M1, and the seam must
     * map the option (not pass it through as a raw R800 flag). */
    FlatBus bus_plain = {0};
    load_program(&bus_plain);
    MSX_CPU *plain = msx_cpu_create(0, &kBus, &bus_plain);
    assert(plain != NULL);
    for (unsigned i = 0; i < 1000; i++) msx_cpu_execute(plain);
    UInt32 plain_time = msx_cpu_get_time(plain);
    msx_cpu_destroy(plain);

    FlatBus bus_m1 = {0};
    load_program(&bus_m1);
    MSX_CPU *m1 = msx_cpu_create(MSX_CPU_OPTION_M1, &kBus, &bus_m1);
    assert(m1 != NULL);
    for (unsigned i = 0; i < 1000; i++) msx_cpu_execute(m1);
    UInt32 m1_time = msx_cpu_get_time(m1);
    msx_cpu_destroy(m1);

    assert(m1_time > plain_time);

    msx_cpu_destroy(NULL); /* must be safe */

    puts("PASS: CPU seam matches direct R800 execution and maps M1");
    return 0;
}
