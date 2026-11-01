#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "msx.h"
#include "msx_input.h"

/* Fake device: proves the seam is device-agnostic (a future machine can
 * install a different keyboard/joypad without touching the machine code). */
typedef struct {
    int writes;
    int reads;
    int keys;
    int destroyed;
    UInt8 last_port;
    UInt8 last_val;
    int last_ec;
    int last_pressed;
} FakeInput;

static UInt8 fake_read(void *dev, UInt16 port)
{
    FakeInput *f = (FakeInput *)dev;
    f->reads++;
    f->last_port = (UInt8)port;
    return 0x77;
}

static void fake_write(void *dev, UInt16 port, UInt8 val)
{
    FakeInput *f = (FakeInput *)dev;
    f->writes++;
    f->last_port = (UInt8)port;
    f->last_val = val;
}

static void fake_set_key(void *dev, int ec, int pressed)
{
    FakeInput *f = (FakeInput *)dev;
    f->keys++;
    f->last_ec = ec;
    f->last_pressed = pressed;
}

static void *fake_native(void *dev) { return dev; }
static void fake_destroy(void *dev) { ((FakeInput *)dev)->destroyed++; }

static const MSX_InputOps kFakeOps = {
    fake_read, fake_write, fake_set_key, fake_native, fake_destroy
};

static void test_seam_is_device_agnostic(void)
{
    MSX_Input input = {0};
    FakeInput fake = {0};

    msx_input_attach(&input, &kFakeOps, &fake);

    msx_input_write_io(&input, 0xAA, 0x03);
    assert(fake.writes == 1 && fake.last_port == 0xAA && fake.last_val == 0x03);

    assert(msx_input_read_io(&input, 0xA9) == 0x77);
    assert(fake.reads == 1 && fake.last_port == 0xA9);

    msx_input_set_key(&input, MSX_EC_A, 1);
    assert(fake.keys == 1 && fake.last_ec == MSX_EC_A && fake.last_pressed == 1);
    assert(msx_input_native(&input) == &fake);

    msx_input_destroy(&input);
    assert(fake.destroyed == 1);
    assert(input.ops == NULL && input.dev == NULL);

    /* Calls after destroy are inert, not crashes. */
    msx_input_write_io(&input, 0xAA, 0x00);
    assert(msx_input_read_io(&input, 0xA9) == 0xFF);
    assert(msx_input_native(&input) == NULL);
    msx_input_destroy(&input); /* idempotent */
    msx_input_set_key(NULL, MSX_EC_A, 1);
    msx_input_write_io(NULL, 0xAA, 0);
    assert(msx_input_read_io(NULL, 0xA9) == 0xFF);
}

static int g_portA_calls;
static UInt8 g_portA_val;

static void port_a(void *ref, UInt8 val)
{
    assert(ref == (void *)&g_portA_calls);
    g_portA_calls++;
    g_portA_val = val;
}

static void test_ppi_matrix(void)
{
    MSX_Input input = {0};
    assert(msx_input_init_ppi(&input, port_a, &g_portA_calls) == 0);
    assert(input.ops != NULL && msx_input_native(&input) != NULL);

    /* Port A goes to the machine, not to the matrix. */
    msx_input_write_io(&input, 0xA8, 0x1B);
    assert(g_portA_calls == 1 && g_portA_val == 0x1B);

    /* No key down: every row reads 0xFF. */
    for (UInt8 row = 0; row < 12; row++) {
        msx_input_write_io(&input, 0xAA, row);
        assert(msx_input_read_io(&input, 0xA9) == 0xFF);
    }
    /* Rows 12-15 do not exist: reads float high. */
    msx_input_write_io(&input, 0xAA, 0x0C);
    assert(msx_input_read_io(&input, 0xA9) == 0xFF);
    msx_input_write_io(&input, 0xAA, 0x0F);
    assert(msx_input_read_io(&input, 0xA9) == 0xFF);

    /* MSX matrix positions for a spread of keys (row, bit). */
    struct { int ec; UInt8 row; UInt8 bit; } cases[] = {
        { MSX_EC_1, 0, 1 }, { MSX_EC_A, 2, 6 }, { MSX_EC_RETURN, 7, 7 },
        { MSX_EC_SPACE, 8, 0 }, { MSX_EC_LEFT, 8, 4 }, { MSX_EC_RIGHT, 8, 7 },
        { MSX_EC_NUM4, 9, 7 }, { MSX_EC_NUMPER, 10, 7 },
        { MSX_EC_JIKKOU, 11, 1 }, { MSX_EC_TORIKE, 11, 3 }
    };
    for (unsigned i = 0; i < sizeof cases / sizeof cases[0]; i++) {
        msx_input_set_key(&input, cases[i].ec, 1);
        msx_input_write_io(&input, 0xAA, cases[i].row);
        assert(msx_input_read_io(&input, 0xA9) == (UInt8)~(1u << cases[i].bit));
        msx_input_set_key(&input, cases[i].ec, 0);
        assert(msx_input_read_io(&input, 0xA9) == 0xFF);
    }

    /* Shift keys share one matrix bit on MSX (both map to row 6 bit 0).
     * Preserve the legacy matrix's direct bit-store semantics: pressing either
     * clears the bit and releasing either sets it. */
    msx_input_set_key(&input, MSX_EC_LSHIFT, 1);
    msx_input_write_io(&input, 0xAA, 6);
    assert(msx_input_read_io(&input, 0xA9) == 0xFE);
    msx_input_set_key(&input, MSX_EC_LSHIFT, 0);
    assert(msx_input_read_io(&input, 0xA9) == 0xFF);

    /* Several keys in one row and codes with no matrix position. */
    msx_input_set_key(&input, MSX_EC_C, 1);
    msx_input_set_key(&input, MSX_EC_E, 1);
    msx_input_write_io(&input, 0xAA, 3);
    assert(msx_input_read_io(&input, 0xA9) == (UInt8)~(0x01 | 0x04));
    msx_input_set_key(&input, MSX_EC_PAUSE, 1);
    msx_input_set_key(&input, MSX_EC_PRINT, 1);
    assert(msx_input_read_io(&input, 0xA9) == (UInt8)~(0x01 | 0x04));
    msx_input_set_key(&input, MSX_EC_C, 0);
    msx_input_set_key(&input, MSX_EC_E, 0);
    assert(msx_input_read_io(&input, 0xA9) == 0xFF);

    /* Control word writes are stored and do not disturb the matrix. */
    msx_input_write_io(&input, 0xAB, 0x5A);
    msx_input_set_key(&input, MSX_EC_D, 1);
    msx_input_write_io(&input, 0xAA, 3);
    assert(msx_input_read_io(&input, 0xA9) == 0xFD);
    msx_input_set_key(&input, MSX_EC_D, 0);

    msx_input_destroy(&input);
}

static void test_machine_integration(void)
{
    MSX_Machine *m = msx_create();
    assert(m != NULL);
    assert(m->input.dev != NULL && m->input.ops != NULL);
    /* Diagnostics and older tests read the device pointer directly. */
    assert(m->ppi == msx_input_native(&m->input));

    /* Port A write still selects primary slots (machine memory policy). */
    m->bus.write_io(m, 0xA8, 0x1B);
    assert(m->slotReg == 0x1B);
    assert(m->activeSlot[0] == 3 && m->activeSlot[1] == 2 &&
           m->activeSlot[2] == 1 && m->activeSlot[3] == 0);

    /* High-byte aliases reach the same matrix. */
    msx_ppi_set_ec(m, MSX_EC_A, 1);
    m->bus.write_io(m, 0x12AA, 0x02);
    assert(m->bus.read_io(m, 0x34A9) == 0xBF);
    msx_ppi_set_ec(m, MSX_EC_A, 0);
    assert(m->bus.read_io(m, 0xA9) == 0xFF);

    msx_destroy(m);
}

int main(void)
{
    test_seam_is_device_agnostic();
    test_ppi_matrix();
    test_machine_integration();
    puts("PASS: input seam routes the PPI keyboard matrix and accepts other devices");
    return 0;
}
