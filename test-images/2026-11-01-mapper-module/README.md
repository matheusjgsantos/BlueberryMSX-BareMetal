# Test images: MegaROM mapper module (2026-11-01)

Branch: `feature/modular-emulation-architecture`
Status: **hardware verification pending**

Third extraction step. Behavior is intended to be identical to
`../2026-11-01-cpu-seam/` (which is hardware-verified on Pi 3A+ and Pi 4); the
cartridge mapper decode moved into its own module and the machine's memory
function now only routes addresses.

## What changed

- `include/msx_memory.h` (new): the slot storage (`MSX_SubSlot`, `MSX_Slot`,
  `NUM_SLOTS`, `REGION_SIZE`, ...) and `MSX_MapperType` moved out of `msx.h`
  so the decoder and the mapper policy share them without the whole machine.
  Ownership is unchanged: the slot array still lives in `MSX_Machine`.
- `include/msx_mapper.h` + `src/core/msx_mapper.c` (new): the MegaROM bank
  policy, moved verbatim out of `msx.c`:
  `msx_mapper_is_mapped()`, `msx_mapper_read()`, `msx_mapper_write()`,
  `msx_mapper_guess()`.
- `src/core/msx.c`: the CPU memory callbacks now only select the subslot,
  route the physical RPMC bus, and delegate ROM windows and bank-register
  writes to the mapper module. `msx_guess_mapper()` stays as the public
  wrapper. `msx.c` shrank from 853 to 760 lines.
- Preserved exactly: Konami `0x4000` fixed / write decode `0x6000-0xBFFF`;
  Konami-SCC `(addr & 0x1800) == 0x1000` decode in `0x5000-0xBFFF` (so `0x4000`
  is switchable) with the SCC window `0x9800-0x9FFF` ignored; ASCII8
  `0x6000/0x6800/0x7000/0x7800`; ASCII16 approximated with the ASCII8 decode;
  bank mask wrapping; `0xC000-0xFFFF` reading `0xFF` for mapped ROMs;
  `LD (nn),A` guess heuristic with the openMSX ASCII8 bias.

Host checks before packaging:

```text
PASS: mapper policy (ASCII8/16, Konami, Konami-SCC, guess)  (host-test/mapper_policy_test.c)
PASS: CPU seam matches direct R800 execution and maps M1
0 timing mismatch(es)
PASS: host callback table routes bus and diagnostics
PASS: Z80 OTIR, VDP/PPI high-byte port aliases, PSG port decode
RESULT: PASS                                               (konami_emu_test, ascii8_emu_test)
RESULT: PASS                                               (megarom_bus_test)
31 checks, 0 failed: PASS                                  (cartdump_test)
PASS: 60 Hz deadlines, variable work, wraparound, overload and resume
```

## Images

| File | Target | Size | MD5 |
|---|---|---|---|
| `msx-pi3.img` | Pi 3 / 3A+ / 3B+ / Zero 2 W | 534736 | `b4d2dfdcb8c4dd2301c40ca954c16200` |
| `msx-pi4.img` | Pi 4 / 400 / CM4 | 580688 | `f2359a8624dd953ccf416e3c0eaf4c39` |

Both are +192 bytes versus the CPU-seam bundle, which is the new module's
symbols plus the wrapper. `MD5SUMS` and `SHA256SUMS` are included; images embed
`__DATE__`/`__TIME__`, so checksums change on every rebuild.

## How to test

```sh
cp msx-pi3.img /media/$USER/boot/msx-pi3.img    # Pi 3 family
cp msx-pi4.img /media/$USER/boot/msx-pi4.img    # Pi 4 family
```

Boot should be indistinguishable from the CPU-seam images. Rollback:
`release/v1.0/msx-pi3.img` / `msx-pi4.img`.

## Regression checklist (merge gate)

- [ ] C-BIOS BASIC screen appears; keyboard input works.
- [ ] 32 KiB ROM (Goonies, PacMan) runs at v1.0 speed.
- [ ] Konami-SCC MegaROM (Gradius, Salamander, Nemesis 3) boots and runs at
      v1.0 speed.
- [ ] ASCII8/ASCII16 MegaROM boots; mapper menu can override the guess.
- [ ] `ROM FROM FILE` and the same ROM from the physical slot behave alike.
- [ ] Physical cart in connector 1 (`msxbus=on`): reads work, cartridge
      writes move pages (`MFRPROBE.TXT` changes), board port I/O works.
- [ ] Reset between two ROMs from the overlay (exercises `DoReset()`).
- [ ] PSG audio on HDMI and on VCHIQ.
- [ ] Overlay, browser, mapper menu and F-key bindings behave as in v1.0.
- [ ] Pi 3A+ and Pi 4 both pass the same checks.

## Not in this step (deliberately)

- The slot array still lives in `MSX_Machine`, because the Circle app
  (`biosrom.cpp`, `kernel.cpp`) and several host tests read `slots[]`,
  `slotReg` and `activeSlot` directly. Moving it behind an `MSX_Memory`
  handle goes together with the machine-profile layer, where a profile has to
  install either the MSX slot map or a flat map.
- The I/O decode (`src/core/msx.c` `slot_read_io`/`slot_write_io`) still mixes
  VDP/PSG/PPI dispatch with bus forwarding. It should be split when the device
  interfaces land, otherwise the new module would just re-import the same
  device coupling.

## Provenance

Same procedure as the previous bundles: purge every Circle archive/object,
`./configure -r N --multicore -f`, rebuild libs and add-ons, then `make clean`
and `make RASPPI=N` in `src/app`.
