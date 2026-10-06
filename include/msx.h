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

enum {
    MSX_EC_NONE = 0,
    MSX_EC_F1 = 1,
    MSX_EC_F2 = 2,
    MSX_EC_F3 = 3,
    MSX_EC_F4 = 4,
    MSX_EC_F5 = 5,
    MSX_EC_STOP = 6,
    MSX_EC_CLS = 7,
    MSX_EC_SELECT = 8,
    MSX_EC_INS = 9,
    MSX_EC_DEL = 10,
    MSX_EC_ESC = 11,
    MSX_EC_1 = 12,
    MSX_EC_2 = 13,
    MSX_EC_3 = 14,
    MSX_EC_4 = 15,
    MSX_EC_5 = 16,
    MSX_EC_6 = 17,
    MSX_EC_7 = 18,
    MSX_EC_8 = 19,
    MSX_EC_9 = 20,
    MSX_EC_0 = 21,
    MSX_EC_NEG = 22,
    MSX_EC_CIRCFLX = 23,
    MSX_EC_BKSLASH = 24,
    MSX_EC_BKSPACE = 25,
    MSX_EC_TAB = 26,
    MSX_EC_Q = 27,
    MSX_EC_W = 28,
    MSX_EC_E = 29,
    MSX_EC_R = 30,
    MSX_EC_T = 31,
    MSX_EC_Y = 32,
    MSX_EC_U = 33,
    MSX_EC_I = 34,
    MSX_EC_O = 35,
    MSX_EC_P = 36,
    MSX_EC_AT = 37,
    MSX_EC_LBRACK = 38,
    MSX_EC_RETURN = 39,
    MSX_EC_CTRL = 40,
    MSX_EC_A = 41,
    MSX_EC_S = 42,
    MSX_EC_D = 43,
    MSX_EC_F = 44,
    MSX_EC_G = 45,
    MSX_EC_H = 46,
    MSX_EC_J = 47,
    MSX_EC_K = 48,
    MSX_EC_L = 49,
    MSX_EC_SEMICOL = 50,
    MSX_EC_COLON = 51,
    MSX_EC_RBRACK = 52,
    MSX_EC_LSHIFT = 53,
    MSX_EC_Z = 54,
    MSX_EC_X = 55,
    MSX_EC_C = 56,
    MSX_EC_V = 57,
    MSX_EC_B = 58,
    MSX_EC_N = 59,
    MSX_EC_M = 60,
    MSX_EC_COMMA = 61,
    MSX_EC_PERIOD = 62,
    MSX_EC_DIV = 63,
    MSX_EC_UNDSCRE = 64,
    MSX_EC_RSHIFT = 65,
    MSX_EC_CAPS = 66,
    MSX_EC_GRAPH = 67,
    MSX_EC_TORIKE = 68,
    MSX_EC_SPACE = 69,
    MSX_EC_JIKKOU = 70,
    MSX_EC_CODE = 71,
    MSX_EC_PAUSE = 72,
    MSX_EC_LEFT = 73,
    MSX_EC_UP = 74,
    MSX_EC_DOWN = 75,
    MSX_EC_RIGHT = 76,
    MSX_EC_NUM7 = 77,
    MSX_EC_NUM8 = 78,
    MSX_EC_NUM9 = 79,
    MSX_EC_NUMDIV = 80,
    MSX_EC_NUM4 = 81,
    MSX_EC_NUM5 = 82,
    MSX_EC_NUM6 = 83,
    MSX_EC_NUMMUL = 84,
    MSX_EC_NUM1 = 85,
    MSX_EC_NUM2 = 86,
    MSX_EC_NUM3 = 87,
    MSX_EC_NUMSUB = 88,
    MSX_EC_NUM0 = 89,
    MSX_EC_NUMPER = 90,
    MSX_EC_NUMCOM = 91,
    MSX_EC_NUMADD = 92,
    MSX_EC_PRINT = 93
};

#ifdef __cplusplus
extern "C" {
#endif

MSX_Machine* msx_create();
void msx_destroy(MSX_Machine *machine);
/* Non-blocking: execute one VDP frame's worth of Z80 instructions and fire the
 * sync IRQ + render hook once. For cooperative schedulers (e.g. Circle). */
int msx_step_frame(MSX_Machine *machine, int vdp_frame_instr);

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
int msx_load_rom(MSX_Machine *machine, const char *filename, UInt16 address);
void msx_set_slot(MSX_Machine *machine, int slot, int sslot, uint8_t *data, int size);
void msx_load_data(MSX_Machine *machine, int slot, int sslot, UInt16 offset, uint8_t *data, int size);

/* Emit one diagnostic line through diag_log (when set). Respects the budget. */
void msx_diag(MSX_Machine *machine, const char *fmt, ...);

/* PPI keyboard interface */
void msx_ppi_init(MSX_Machine *machine);
void msx_ppi_set_ec(MSX_Machine *machine, int ecCode, int pressed);

#ifdef __cplusplus
}
#endif

#endif // MSX_H
