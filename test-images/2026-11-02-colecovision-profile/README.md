# Test images: ColecoVision machine profile (2026-11-02)

Branch: `main` (working tree, pending commit)  
Status: **hardware verification pending** (MSX1 regression + ColecoVision boot)

This step adds the first non-MSX machine to the platform: a ColecoVision
profile on the same Z80 core (R800) and TMS9918 video chip. MSX1 remains the
default and the verified fallback — the `MACHINE:` overlay row and `machine=`
in `msx.ini` select between them.

## What is in this build

- `include/msx_profile.h` / `src/core/msx_profile.c`: machine-profile
  registry (interrupt mode, memory backend, input backend) and
  `msx_create_profile()`; `msx_create()` is exactly MSX1.
- `src/core/msx_memory_flat.c` + `include/msx_memory.h` (`MSX_FlatMemory`):
  ordered region map with mirroring, used by the Coleco profile.
- `src/core/msx.c`: Coleco composition — flat map
  (`0x0000-0x1FFF` 8 KB BIOS ROM, `0x2000-0x5FFF` open bus,
  `0x6000-0x7FFF` 1 KB RAM mirrored, `0x8000-0xFFFF` 32 KB cart window),
  I/O decode (keypad write `0x80-0x9F`, joystick write `0xC0-0xDF`,
  VDP `0xA0-0xBF` with control at `0xBE/0xBF`, SN76489 placeholder
  `0xE0-0xFF` write, pad reads `0xE0-0xFF`), and NMI frame delivery
  (re-armed on VDP status reads).
- `src/core/msx_input_coleco.c`: two hand controllers (joystick + keypad,
  fire buttons) behind the input seam.
- `src/core/msx_cpu.c` / `include/msx_cpu.h`: edge-triggered NMI seam
  (`msx_cpu_set_nmi` / `msx_cpu_clear_nmi`).
- App: `msx.ini` `machine=colecovision` (or `coleco`) / `msx1`; overlay
  `MACHINE:` row cycles the machine and requests a reset; Coleco BIOS from
  `BIOS/colecovision.rom` (fallback `BIOS/coleco.rom`); Coleco boots a
  cartridge file only (RPMC bus, MSX DIAG and cart dump are skipped);
  HID arrows/space/Z drive pad 1, digits drive the pad-2 keypad,
  `-`/`=` map to `#`/`*`, X is the pad-2 fire.

## Images

| File | Target | Size | MD5 |
|---|---|---:|---|
| `msx-pi3.img` | Pi 3 / 3A+ / 3B+ / Zero 2 W | 541840 | `fa8ddcf7fccc886dc1333a866b2a5cf8` |
| `msx-pi4.img` | Pi 4 / 400 / CM4 | 588240 | `47855c66cd8d062073086451b3d2be71` |

Both built the clean-circle way: Circle libraries purged and rebuilt with
`./configure -r N --multicore -f`, then `make clean RASPPI=N && make RASPPI=N`
in `src/app`. `msx.img` embeds `__DATE__`/`__TIME__`, so the MD5 is the one of
*this* image, not of a rebuild.

## SD card extras (Coleco only — not in this bundle)

- `BIOS/colecovision.rom` (or `BIOS/coleco.rom`) on the data partition:
  the 8 KiB ColecoVision BIOS. It is not in the repository (license) and must
  be supplied by the tester.
- A Coleco cart ROM (`.col` or `.rom`) in `CARTRIDGE/` — the file browser
  accepts both. The image is mirrored into the 32 KB window when it is a
  power-of-two size below 32 KiB (16 KiB games work).

## Host verification

All 28 host tests pass:

- 23 build and run with the standard core source list (MSX1 seams,
  CPU/timing, mapper, cart dump, PSG, video, input, memory profile/ops,
  frame pacer, UI, I/O decode, and the new `flat_memory_test` and
  `coleco_machine_test` which cover the profile registry, flat map,
  Coleco I/O decode, NMI re-arm and controller reads).
- `render_g2_test` / `render_sprite_test` pass with their special list
  (no `msx.c`, because they define `g_tms_trace` themselves).
- `mfr_bank_test` / `mfr_run_test` / `cbios_ram_test` pass when linked
  with the C++ `src/app/cbios_roms.cpp` (they need `cbios_logo_rom`).

## Hardware checklist

MSX1 regression (both images, both Pis):

- [ ] C-BIOS BASIC and keyboard input.
- [ ] 32 KB ROMs and Konami/ASCII8/ASCII16/SCC MegaROM games.
- [ ] `ROM FROM FILE` and physical slot behavior.
- [ ] Cartridge writes and bank switching (MegaFlashROM cart).
- [ ] Reset, PSG audio, video, overlay/browser and F-keys.
- [ ] The `MACHINE:` overlay row appears and cycles MSX1 <-> ColecoVision
      (label updates, reset follows).

ColecoVision (both images, both Pis):

- [ ] `machine=colecovision` boots the Coleco BIOS (logo / BASIC) on the
      TMS9918 display with the MSX palette.
- [ ] A 16 KiB Coleco cart ROM runs from `CARTRIDGE/`.
- [ ] Pad 1: arrows + space/Z fire respond in a game.
- [ ] Pad 2 keypad (digits) and fire (X) respond where the game uses them.
- [ ] Switching machine in the overlay and back keeps both machines working.

Known deferred (do not test as working): SN76489 audio (silent placeholder),
full keypad/SAC protocol, MegaCart banking, Coleco-specific palette.

Rollback: `release/v1.0/`.
