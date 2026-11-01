#ifndef MSX_INPUT_H
#define MSX_INPUT_H

#include "msx_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Input device seam.
 *
 * The machine owns an MSX_Input (ops + device instance) and routes its PPI /
 * joystick ports here; it does not know the keyboard matrix layout. The MSX1
 * profile installs the 8255 PPI adapter from src/core/msx_input_ppi.c, which
 * owns the keyboard matrix and the PPI port protocol:
 *   0xA8 write: port A - primary slot select (machine policy, reported back
 *               through the port-A callback so the memory map stays in the
 *               machine)
 *   0xA9 read : port B - keyboard matrix row (low nibble of port C selects it)
 *   0xAA write: port C - row select / cassette / key-click bits (row used here)
 *   0xAB write: PPI control word (stored, not otherwise used on MSX1)
 *
 * Host input arrives through msx_input_set_key() with the standard MSX EC code
 * (see the enum below), which is also what the Circle keyboard handler maps
 * keys to.
 */

/* Port A write callback: the machine applies it to its own memory map. */
typedef void (*MSX_InputPortACallback)(void *ref, UInt8 val);

typedef struct {
    /* Port access. The machine only calls these for ports it routed to the
     * input device. */
    UInt8 (*read_io)(void *dev, UInt16 port);
    void  (*write_io)(void *dev, UInt16 port, UInt8 val);

    /* Host key press (pressed != 0) / release for one MSX EC code. */
    void  (*set_key)(void *dev, int ec, int pressed);

    /* The concrete device pointer (compatibility alias, e.g. the PPI state
     * behind the MSX1 device). */
    void *(*native)(void *dev);

    /* Release the device instance. */
    void  (*destroy)(void *dev);
} MSX_InputOps;

typedef struct {
    const MSX_InputOps *ops;
    void *dev;
} MSX_Input;

/* Standard MSX keyboard EC (keyboard matrix) codes. */
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

/* Install an arbitrary device implementation. */
void msx_input_attach(MSX_Input *input, const MSX_InputOps *ops, void *dev);

/* Create the MSX1 input device (8255 PPI + keyboard matrix). Port A writes
 * (primary slot select) are reported through on_port_a, which the machine
 * applies to its own memory map. Returns 0 on success. */
int msx_input_init_ppi(MSX_Input *input, MSX_InputPortACallback on_port_a,
                       void *ref);

void msx_input_destroy(MSX_Input *input);

UInt8 msx_input_read_io(MSX_Input *input, UInt16 port);
void msx_input_write_io(MSX_Input *input, UInt16 port, UInt8 val);
void msx_input_set_key(MSX_Input *input, int ec, int pressed);
void *msx_input_native(const MSX_Input *input);

#ifdef __cplusplus
}
#endif

#endif /* MSX_INPUT_H */
