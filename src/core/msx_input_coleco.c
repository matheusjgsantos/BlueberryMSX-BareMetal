//
// msx_input_coleco.c
//
// BlueberryMSX - ColecoVision hand-controller adapter.
//
// Implements the MSX_Input seam (include/msx_input.h) for the ColecoVision
// controller ports. The machine (src/core/msx.c) owns the port ranges:
//   0x80-0x9F write: keypad mode
//   0xC0-0xDF write: joystick mode
//   0xE0-0xFF read : pad 1 (A1=0) / pad 2 (A1=1)
//
// Read format (active low):
//   joystick mode: bit 0 up, 1 right, 2 down, 3 left, 6 (left-hand) fire
//   keypad mode  : low nibble = key code (0x0F = none), bit 6 = right fire
// The unused bits read high (0x7F when idle), matching the hardware pull-ups.
//
// The controller protocol is separated from the PPI adapter so MSX1 behavior
// cannot regress when a Coleco detail changes.
//

#include <msx_input.h>

#include <stddef.h>
#include <stdlib.h>

#define COLE_PAD_COUNT 2

/* Internal joystick bits (active high). */
#define COLE_JOY_UP    0x01
#define COLE_JOY_RIGHT 0x02
#define COLE_JOY_DOWN  0x04
#define COLE_JOY_LEFT  0x08
#define COLE_JOY_FIRE  0x10

typedef struct {
    UInt8 joystick[COLE_PAD_COUNT];
    UInt8 keypad[COLE_PAD_COUNT];
    UInt8 fire2[COLE_PAD_COUNT];
    int joystick_mode;
} ColecoInput;

static UInt8 coleco_read_port(void *dev, UInt16 port)
{
    ColecoInput *c = (ColecoInput *)dev;
    int pad;
    UInt8 v;

    if (!c) return 0xFF;
    pad = (port & 0x02) ? MSX_COLECO_PAD_2 : MSX_COLECO_PAD_1;

    if (c->joystick_mode) {
        v = 0x7F;
        if (c->joystick[pad] & COLE_JOY_UP)    v &= (UInt8)~0x01;
        if (c->joystick[pad] & COLE_JOY_RIGHT) v &= (UInt8)~0x02;
        if (c->joystick[pad] & COLE_JOY_DOWN)  v &= (UInt8)~0x04;
        if (c->joystick[pad] & COLE_JOY_LEFT)  v &= (UInt8)~0x08;
        if (c->joystick[pad] & COLE_JOY_FIRE)  v &= (UInt8)~0x40;
        return v;
    }

    v = (UInt8)(0x70 | (c->keypad[pad] & 0x0F));
    if (c->fire2[pad]) v &= (UInt8)~0x40;
    return v;
}

static void coleco_write_port(void *dev, UInt16 port, UInt8 val)
{
    ColecoInput *c = (ColecoInput *)dev;
    (void)val;

    if (!c) return;
    if (port >= 0x80 && port <= 0x9F)
        c->joystick_mode = 0;
    else if (port >= 0xC0 && port <= 0xDF)
        c->joystick_mode = 1;
}

/* Keyboard fallback: the Circle app drives the direct setters, but mapping the
 * MSX EC arrows/space keeps the seam usable from generic key handlers and from
 * the host tests. */
static void coleco_set_key(void *dev, int ec, int pressed)
{
    ColecoInput *c = (ColecoInput *)dev;
    UInt8 bit = 0;

    if (!c) return;
    switch (ec) {
    case MSX_EC_UP:    bit = COLE_JOY_UP;    break;
    case MSX_EC_RIGHT: bit = COLE_JOY_RIGHT; break;
    case MSX_EC_DOWN:  bit = COLE_JOY_DOWN;  break;
    case MSX_EC_LEFT:  bit = COLE_JOY_LEFT;  break;
    case MSX_EC_SPACE:
    case MSX_EC_Z:     bit = COLE_JOY_FIRE;  break;
    default: return;
    }

    if (pressed)
        c->joystick[MSX_COLECO_PAD_1] |= bit;
    else
        c->joystick[MSX_COLECO_PAD_1] &= (UInt8)~bit;
}

static void *coleco_native(void *dev)
{
    return dev;
}

static void coleco_destroy(void *dev)
{
    free(dev);
}

static const MSX_InputOps s_coleco_ops = {
    coleco_read_port,
    coleco_write_port,
    coleco_set_key,
    coleco_native,
    coleco_destroy
};

int msx_input_init_coleco(MSX_Input *input)
{
    ColecoInput *c;
    int i;

    if (!input) return -1;
    input->ops = NULL;
    input->dev = NULL;

    c = (ColecoInput *)calloc(1, sizeof *c);
    if (!c) return -1;
    for (i = 0; i < COLE_PAD_COUNT; i++) {
        c->joystick[i] = 0;
        c->keypad[i] = MSX_COLECO_KEY_NONE;
        c->fire2[i] = 0;
    }
    /* The BIOS selects the mode before reading; defaulting to joystick is what
     * a pad with no keypad press reports on hardware. */
    c->joystick_mode = 1;

    input->dev = c;
    input->ops = &s_coleco_ops;
    return 0;
}

static ColecoInput *coleco_input(MSX_Input *input)
{
    if (!input || !input->ops || input->ops->native != coleco_native)
        return NULL;
    return (ColecoInput *)input->dev;
}

void msx_input_coleco_set_joystick(MSX_Input *input, int pad,
                                   int up, int right, int down, int left,
                                   int fire)
{
    ColecoInput *c = coleco_input(input);
    UInt8 bits = 0;

    if (!c || pad < 0 || pad >= COLE_PAD_COUNT) return;
    if (up)    bits |= COLE_JOY_UP;
    if (right) bits |= COLE_JOY_RIGHT;
    if (down)  bits |= COLE_JOY_DOWN;
    if (left)  bits |= COLE_JOY_LEFT;
    if (fire)  bits |= COLE_JOY_FIRE;
    c->joystick[pad] = bits;
}

void msx_input_coleco_set_keypad(MSX_Input *input, int pad, int code)
{
    ColecoInput *c = coleco_input(input);

    if (!c || pad < 0 || pad >= COLE_PAD_COUNT) return;
    c->keypad[pad] = (UInt8)(code & 0x0F);
}

void msx_input_coleco_set_fire2(MSX_Input *input, int pad, int pressed)
{
    ColecoInput *c = coleco_input(input);

    if (!c || pad < 0 || pad >= COLE_PAD_COUNT) return;
    c->fire2[pad] = pressed ? 1 : 0;
}
