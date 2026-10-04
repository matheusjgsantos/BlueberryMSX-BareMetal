#ifndef MSX_H
#define MSX_H

#include "msx_types.h"
#include "bus.h"

#define NUM_SLOTS 4
#define NUM_SUBSLOTS 4
#define REGION_SIZE 0x4000
#define SLOT_MAX_SIZE 0x10000

typedef struct {
    uint8_t data[0x10000]; // 64KB per slot/subslot
    uint8_t rom[0x10000];  // read-only mask: 1 = ROM byte (writes ignored)
    int size;
} MSX_SubSlot;

typedef struct {
    MSX_SubSlot subslots[NUM_SUBSLOTS];
} MSX_Slot;

typedef struct {
    MSX_Bus bus;
    void *z80;
    void *vdp;
    void *sound;
    void *ppi;
    MSX_Slot slots[NUM_SLOTS];
    UInt8 slotReg;        // Current slot selection (from port 0xA8)
    int activeSlot[4];    // Active slot+subslot for each 16KB region

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
/* Non-blocking: execute one VDP frame's worth of Z80 instructions and fire the
 * sync IRQ + render hook once. For cooperative schedulers (e.g. Circle). */
int msx_step_frame(MSX_Machine *machine, int vdp_frame_instr);
int msx_load_rom(MSX_Machine *machine, const char *filename, UInt16 address);
void msx_set_slot(MSX_Machine *machine, int slot, int sslot, uint8_t *data, int size);
void msx_load_data(MSX_Machine *machine, int slot, int sslot, UInt16 offset, uint8_t *data, int size);

/* Emit one diagnostic line through diag_log (when set). Respects the budget. */
void msx_diag(MSX_Machine *machine, const char *fmt, ...);

#ifdef __cplusplus
}
#endif

#endif // MSX_H
