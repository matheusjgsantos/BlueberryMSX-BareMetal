//
// msx_input_ppi.c
//
// BlueberryMSX - MSX1 input device adapter.
//
// Implements the MSX_Input seam (include/msx_input.h) with the 8255 PPI
// keyboard interface of the MSX1:
//   0xA8 write: port A - primary slot select per 16 KB page. That effect is
//               machine memory policy, so it is reported back through the
//               port-A callback and applied by src/core/msx.c.
//   0xA9 read : port B - keyboard matrix row selected by the low nibble of
//               port C (0xFF = no key pressed, 0 = all keys in the row down).
//   0xAA write: port C - row select (plus cassette/key-click bits, unused).
//   0xAB write: PPI control word (stored; the MSX1 BIOS reprograms it but the
//               emulated matrix does not depend on it).
//
// The matrix and the EC map below are the ones that used to live in
// src/core/msx.c; they moved here unchanged so `msx.c` no longer knows the
// keyboard layout.
//

#include <msx_input.h>

#include <stddef.h>
#include <stdlib.h>

#define PPI_ROWS 12

typedef struct {
    UInt8 keyState[PPI_ROWS];  /* one byte per row, bit clear = key down */
    UInt8 row;                 /* row selected through port C */
    UInt8 control;             /* last control word (0xAB) */

    MSX_InputPortACallback on_port_a; /* primary slot select */
    void *ref;
} PpiInput;

static const struct {
    int ec;
    int row;
    int bit;
} ppiEcMap[] = {
    { MSX_EC_0, 0, 0 }, { MSX_EC_1, 0, 1 }, { MSX_EC_2, 0, 2 }, { MSX_EC_3, 0, 3 },
    { MSX_EC_4, 0, 4 }, { MSX_EC_5, 0, 5 }, { MSX_EC_6, 0, 6 }, { MSX_EC_7, 0, 7 },
    { MSX_EC_8, 1, 0 }, { MSX_EC_9, 1, 1 }, { MSX_EC_NEG, 1, 2 }, { MSX_EC_CIRCFLX, 1, 3 },
    { MSX_EC_BKSLASH, 1, 4 }, { MSX_EC_AT, 1, 5 }, { MSX_EC_LBRACK, 1, 6 }, { MSX_EC_SEMICOL, 1, 7 },
    { MSX_EC_COLON, 2, 0 }, { MSX_EC_RBRACK, 2, 1 }, { MSX_EC_COMMA, 2, 2 }, { MSX_EC_PERIOD, 2, 3 },
    { MSX_EC_DIV, 2, 4 }, { MSX_EC_UNDSCRE, 2, 5 }, { MSX_EC_A, 2, 6 }, { MSX_EC_B, 2, 7 },
    { MSX_EC_C, 3, 0 }, { MSX_EC_D, 3, 1 }, { MSX_EC_E, 3, 2 }, { MSX_EC_F, 3, 3 },
    { MSX_EC_G, 3, 4 }, { MSX_EC_H, 3, 5 }, { MSX_EC_I, 3, 6 }, { MSX_EC_J, 3, 7 },
    { MSX_EC_K, 4, 0 }, { MSX_EC_L, 4, 1 }, { MSX_EC_M, 4, 2 }, { MSX_EC_N, 4, 3 },
    { MSX_EC_O, 4, 4 }, { MSX_EC_P, 4, 5 }, { MSX_EC_Q, 4, 6 }, { MSX_EC_R, 4, 7 },
    { MSX_EC_S, 5, 0 }, { MSX_EC_T, 5, 1 }, { MSX_EC_U, 5, 2 }, { MSX_EC_V, 5, 3 },
    { MSX_EC_W, 5, 4 }, { MSX_EC_X, 5, 5 }, { MSX_EC_Y, 5, 6 }, { MSX_EC_Z, 5, 7 },
    { MSX_EC_LSHIFT, 6, 0 }, { MSX_EC_CTRL, 6, 1 }, { MSX_EC_GRAPH, 6, 2 }, { MSX_EC_CAPS, 6, 3 },
    { MSX_EC_CODE, 6, 4 }, { MSX_EC_F1, 6, 5 }, { MSX_EC_F2, 6, 6 }, { MSX_EC_F3, 6, 7 },
    { MSX_EC_RSHIFT, 6, 0 },
    { MSX_EC_F4, 7, 0 }, { MSX_EC_F5, 7, 1 }, { MSX_EC_ESC, 7, 2 }, { MSX_EC_TAB, 7, 3 },
    { MSX_EC_STOP, 7, 4 }, { MSX_EC_BKSPACE, 7, 5 }, { MSX_EC_SELECT, 7, 6 }, { MSX_EC_RETURN, 7, 7 },
    { MSX_EC_SPACE, 8, 0 }, { MSX_EC_CLS, 8, 1 }, { MSX_EC_INS, 8, 2 }, { MSX_EC_DEL, 8, 3 },
    { MSX_EC_LEFT, 8, 4 }, { MSX_EC_UP, 8, 5 }, { MSX_EC_DOWN, 8, 6 }, { MSX_EC_RIGHT, 8, 7 },
    { MSX_EC_NUMMUL, 9, 0 }, { MSX_EC_NUMADD, 9, 1 }, { MSX_EC_NUMDIV, 9, 2 }, { MSX_EC_NUM0, 9, 3 },
    { MSX_EC_NUM1, 9, 4 }, { MSX_EC_NUM2, 9, 5 }, { MSX_EC_NUM3, 9, 6 }, { MSX_EC_NUM4, 9, 7 },
    { MSX_EC_NUM5, 10, 0 }, { MSX_EC_NUM6, 10, 1 }, { MSX_EC_NUM7, 10, 2 }, { MSX_EC_NUM8, 10, 3 },
    { MSX_EC_NUM9, 10, 4 }, { MSX_EC_NUMSUB, 10, 5 }, { MSX_EC_NUMCOM, 10, 6 }, { MSX_EC_NUMPER, 10, 7 },
    { MSX_EC_JIKKOU, 11, 1 }, { MSX_EC_TORIKE, 11, 3 }
};

static UInt8 ppi_read_port(void *dev, UInt16 port)
{
    PpiInput *ppi = (PpiInput *)dev;
    int row;

    if (port != 0xA9) return 0xFF;
    row = ppi->row & 0x0F;
    if (row >= PPI_ROWS) return 0xFF;
    return ppi->keyState[row];
}

static void ppi_write_port(void *dev, UInt16 port, UInt8 val)
{
    PpiInput *ppi = (PpiInput *)dev;

    switch (port) {
    case 0xA8: /* port A: primary slot select belongs to the machine */
        if (ppi->on_port_a) ppi->on_port_a(ppi->ref, val);
        break;
    case 0xAA: /* port C: low nibble selects the keyboard row */
        ppi->row = val;
        break;
    case 0xAB: /* control word */
        ppi->control = val;
        break;
    default:
        break;
    }
}

static void ppi_set_key(void *dev, int ec, int pressed)
{
    PpiInput *ppi = (PpiInput *)dev;
    unsigned i;

    for (i = 0; i < sizeof ppiEcMap / sizeof ppiEcMap[0]; i++) {
        if (ppiEcMap[i].ec == ec) {
            if (pressed)
                ppi->keyState[ppiEcMap[i].row] &= (UInt8)(~(1u << ppiEcMap[i].bit));
            else
                ppi->keyState[ppiEcMap[i].row] |= (UInt8)(1u << ppiEcMap[i].bit);
            return;
        }
    }
    /* Codes with no matrix position (e.g. MSX_EC_PAUSE) are ignored, as
     * before the extraction. */
}

static void *ppi_native(void *dev)
{
    return dev;
}

static void ppi_destroy(void *dev)
{
    free(dev);
}

static const MSX_InputOps s_ppi_ops = {
    ppi_read_port,
    ppi_write_port,
    ppi_set_key,
    ppi_native,
    ppi_destroy
};

void msx_input_attach(MSX_Input *input, const MSX_InputOps *ops, void *dev)
{
    if (!input) return;
    input->ops = ops;
    input->dev = dev;
}

int msx_input_init_ppi(MSX_Input *input, MSX_InputPortACallback on_port_a,
                       void *ref)
{
    PpiInput *ppi;
    unsigned i;

    if (!input) return -1;
    input->ops = NULL;
    input->dev = NULL;

    ppi = (PpiInput *)calloc(1, sizeof *ppi);
    if (!ppi) return -1;
    for (i = 0; i < PPI_ROWS; i++) ppi->keyState[i] = 0xFF;
    ppi->row = 0;
    ppi->control = 0;
    ppi->on_port_a = on_port_a;
    ppi->ref = ref;

    input->dev = ppi;
    input->ops = &s_ppi_ops;
    return 0;
}

void msx_input_destroy(MSX_Input *input)
{
    if (!input) return;
    if (input->ops && input->ops->destroy && input->dev)
        input->ops->destroy(input->dev);
    input->ops = NULL;
    input->dev = NULL;
}

UInt8 msx_input_read_io(MSX_Input *input, UInt16 port)
{
    if (!input || !input->ops || !input->ops->read_io) return 0xFF;
    return input->ops->read_io(input->dev, port);
}

void msx_input_write_io(MSX_Input *input, UInt16 port, UInt8 val)
{
    if (!input || !input->ops || !input->ops->write_io) return;
    input->ops->write_io(input->dev, port, val);
}

void msx_input_set_key(MSX_Input *input, int ec, int pressed)
{
    if (!input || !input->ops || !input->ops->set_key) return;
    input->ops->set_key(input->dev, ec, pressed);
}

void *msx_input_native(const MSX_Input *input)
{
    if (!input || !input->ops || !input->ops->native) return NULL;
    return input->ops->native(input->dev);
}
