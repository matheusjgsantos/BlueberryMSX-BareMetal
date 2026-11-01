# Test images: input device seam (2026-11-01)

Branch: `main`  
Status: **hardware verified 2026-11-01** (keyboard input passed on Pi 3A+ and Pi 4)

Sixth extraction step. The MSX1 PPI keyboard matrix is now behind
`MSX_Input`; port-A slot selection remains machine memory policy and is
reported back through a callback.

## Images

| File | Target | Size | MD5 |
|---|---|---:|---|
| `msx-pi3.img` | Pi 3 / 3A+ / 3B+ / Zero 2 W | 537232 | `d2dff0ea9e00a67f1bc0a7c7fe20e45d` |
| `msx-pi4.img` | Pi 4 / 400 / CM4 | 583376 | `54b1982249d3624a7406b1b2c4323dc5` |

## Changes

- `include/msx_input.h`: input device ops table and standard MSX EC codes.
- `src/core/msx_input_ppi.c`: MSX1 PPI/keyboard adapter, matrix and host-key
  mapping; supports foreign input devices through `msx_input_attach()`.
- `src/core/msx.c`: PPI reads/writes and host key updates go through the seam;
  primary slot selection remains in the machine via the port-A callback.
- `MSX_Machine.input` is the handle; `machine->ppi` remains the native-device
  compatibility alias.

## Host verification

All 13 host tests pass, including the new `input_seam_test.c`: fake-device
forwarding, all matrix rows, key press/release, shared Shift-bit legacy
semantics, PPI control writes, high-byte port aliases, and machine slot
selection. The existing video and audio seam tests, CPU/timing tests, mapper
tests, cart dump (31/31), and I/O regression also pass.

## Hardware checklist

- [ ] C-BIOS keyboard typing and BASIC commands.
- [ ] Cursor keys, Shift/Ctrl/Graph/Caps, function keys and numeric keypad.
- [ ] STOP/SELECT/RETURN/SPACE and joystick/game controls.
- [ ] High-byte I/O aliases do not affect keyboard reads.
- [ ] Slot selection and ROM loading remain unchanged.
- [ ] Audio on HDMI and phone jack remains correct (control check).
- [ ] Pi 3A+ and Pi 4 both pass.

Rollback: `release/v1.0/`.
