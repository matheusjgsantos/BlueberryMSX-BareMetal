#ifndef MSX_H
#define MSX_H

#include "msx_types.h"
#include "bus.h"
#include "msx_host.h"
#include "msx_cpu.h"
#include "msx_memory.h"
#include "msx_video.h"
#include "msx_audio.h"
#include "msx_input.h"

typedef struct {
    MSX_Bus bus;
    /* CPU context (include/msx_cpu.h): execution, master-tick clock and the
     * interrupt line. Machines must use this, not a concrete CPU type. */
    MSX_CPU *cpu;
    /* Compatibility alias: msx_cpu_native_handle(cpu), i.e. the R800* the
     * Circle app and old host tests still read registers from. */
    void *z80;
    /* Video device behind the seam (include/msx_video.h). */
    MSX_Video video;
    /* Compatibility alias: machine->video.dev, i.e. the TMS9918* the Circle
     * renderer (vdpblit.cpp, msx_task.cpp) and older tests still use. */
    void *vdp;
    /* Audio device behind the seam (include/msx_audio.h). */
    MSX_Audio audio;
    /* Compatibility alias: machine->audio.dev, i.e. the PSG* diagnostics and
     * older tests still use. */
    void *sound;
    /* Input device behind the seam (include/msx_input.h). */
    MSX_Input input;
    /* Compatibility alias: msx_input_native(), the PPI state pointer. */
    void *ppi;
    /* Memory profile owns slots and page selection; these pointers preserve
     * the old machine->slots[] / machine->activeSlot[] source interface. */
    MSX_Memory memory;
    MSX_Slot *slots;
    UInt8 slotReg;        // Current slot selection (from port 0xA8)
    int *activeSlot;      // Active slot+subslot for each 16KB region

    /* Live RPMC cartridge bus. Set by the app when msxbus is enabled: a
     * subslot whose busSlot >= 0 routes its memory accesses here. The
     * function pointers keep the core host-testable (no link dependency on
     * the bare-metal GPIO driver): when NULL, bus-backed subslots read 0xFF
     * and ignore writes. */
    void *bus_ref;
    UInt8 (*bus_read)(void *ref, int nBusSlot, UInt16 addr);
    void (*bus_write)(void *ref, int nBusSlot, UInt16 addr, UInt8 val);
    UInt8 (*bus_read_io)(void *ref, UInt16 port);
    void (*bus_write_io)(void *ref, UInt16 port, UInt8 val);

    /* Optional diagnostic line logger. When non-NULL, core emits
     * CHKRAM-related messages through this hook (which on the app side is
     * bridged to CKernel::LogLine -> UART serial + log ring buffer).
     * Must not allocate or lock in the callback; one line per invocation. */
    void (*diag_log)(const char *line, void *opaque);
    void *diag_user;
    int   diag_log_count;   /* number of lines emitted (used to cap output)  */
    int   diag_log_budget;  /* hard cap; 0 = uncapped                        */

} MSX_Machine;


#ifdef __cplusplus
extern "C" {
#endif

MSX_Machine* msx_create();
void msx_destroy(MSX_Machine *machine);

/* Install the host expansion/diagnostic callbacks as one unit. Existing
 * direct MSX_Machine callback assignment remains supported for compatibility.
 * Passing NULL clears the host callbacks and diagnostic budget. */
void msx_set_host_callbacks(MSX_Machine *machine,
                            const MSX_HostCallbacks *callbacks);

/* Install or clear only the expansion-bus transport (bus_ref plus the four
 * bus callbacks), leaving the diagnostic sink and its budget untouched.
 *
 * Unclaimed I/O ports are forwarded to bus_read_io/bus_write_io whenever those
 * pointers are installed, independent of any slot routing. A host must
 * therefore install them only once the physical bus is initialized - never at
 * machine creation. Passing NULL detaches the bus again. */
void msx_set_bus_callbacks(MSX_Machine *machine,
                           const MSX_HostCallbacks *callbacks);
/* Non-blocking: run the CPU for one video frame's worth of R800 master-clock
 * time (frame_ticks, see MSX_FRAME_TICKS) and fire the sync IRQ + render hook
 * once. For cooperative schedulers (e.g. Circle). Returns the number of
 * instructions executed. Driving by time (not a fixed instruction count)
 * matches the reference blueMSX MSX board and keeps CPU-bound games at the
 * correct speed. */
#define MSX_FRAME_TICKS 357954   /* R800_MASTER_FREQUENCY (21477270) / 60 */
int msx_step_frame(MSX_Machine *machine, int frame_ticks);

/* AY-3-8910 PSG. Master clock is 3579545 Hz; one MSX frame (1/60 s) is
 * 59659 clocks. Render nSamples mono samples for the given number of master
 * clocks and return the sample count written (0 on failure). */
#define MSX_PSG_MASTER_CLOCK 3579545
#define MSX_PSG_CLOCKS_PER_FRAME (MSX_PSG_MASTER_CLOCK / 60)
unsigned msx_psg_render(MSX_Machine *machine, Int16 *out, unsigned nSamples,
                        unsigned nMasterCycles);

/* PSG port activity, for the serial diagnostics. */
extern unsigned g_psg_writes;
extern unsigned g_psg_last_reg;
extern unsigned g_psg_last_val;
void msx_set_slot(MSX_Machine *machine, int slot, int sslot, uint8_t *data, int size);
void msx_load_data(MSX_Machine *machine, int slot, int sslot, UInt16 offset, uint8_t *data, int size);
void msx_load_rom_image(MSX_Machine *machine, int slot, int sslot, uint8_t *pImage, unsigned nSize, MSX_MapperType mapper);
/* Set mapper for an emulated subslot (applied at load/reset time). */
void msx_set_mapper(MSX_Machine *machine, int slot, int sslot, MSX_MapperType type);

/* Heuristic mapper detection for ROM images, following openMSX's own guesser:
 * scan for LD (nn),A bank-select idioms to the known mapper register windows.
 * Returns MSX_MAPPER_NONE for images smaller than 64KB and a best-guess
 * MegaROM mapper otherwise (defaulting to ASCII8 when nothing stands out). */
MSX_MapperType msx_guess_mapper(const uint8_t *pImage, unsigned nSize);

/* Slot/MFR event log for the on-SD diagnostic dump: records page-1 slot
 * transitions (port 0xA8) and every write to the MegaFlashROM current-slot
 * markers 0xE200/0xE210, each with the store PC. Shows how often the cartridge
 * INIT runs and which page 1 selects. Port tag: 0=A8, 1=0xE200, 2=0xE210. */
#define MSX_SLOT_EVT_MAX 512
unsigned msx_slot_event_count(void);
int msx_slot_event_get(unsigned nIndex, unsigned *nPc, unsigned *nPort, unsigned *nVal);

/* Route a whole (slot, subslot) to a physical RPMC board connector:
 * nBusSlot 0 = connector 1, 1 = connector 3; -1 restores the emulated buffer.
 * All four 16KB regions of that subslot then live on the bus, so the caller
 * must not have loaded ROM/RAM into it. */
void msx_slot_set_bus(MSX_Machine *machine, int slot, int sslot, int nBusSlot);

/* Emit one diagnostic line through diag_log (when set). Respects the budget. */
void msx_diag(MSX_Machine *machine, const char *fmt, ...);

/* PPI keyboard interface */
void msx_ppi_init(MSX_Machine *machine);
void msx_ppi_set_ec(MSX_Machine *machine, int ecCode, int pressed);

#ifdef __cplusplus
}
#endif

#endif // MSX_H
