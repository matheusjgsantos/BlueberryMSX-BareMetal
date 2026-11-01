# Test images: host-callback seam (2026-10-29) — SUPERSEDED

> **Do not use these images.** They were linked against a contaminated Circle
> library set left over from a Pi 4 build (mixed Pi 3/Pi 4 objects in the shared
> archives), which is the likely cause of the blank screen with a white cursor
> on the Pi 3A+. A clean rebuild of the same sources produces the v1.0 size
> (533,072 bytes) instead of the 540,752 bytes shipped here.
>
> Use `../2026-11-01-clean-build/` instead; it also contains a v1.0-source
> control image for A/B testing.

Branch: `feature/modular-emulation-architecture`
Commit: `0cf3608` + app wiring (this commit)
Status: **superseded, do not test**

These are test kernels, not a release. They are built from the modularization
branch on top of the v1.0 source and contain one runtime change: the Circle app
now installs the core's bus and diagnostic callbacks through
`msx_set_host_callbacks()` (`include/msx_host.h`) instead of assigning the
`MSX_Machine` fields one by one.

Behavior is intended to be identical to v1.0. The point of this test is to
prove the new seam on real hardware before more of the emulator is moved behind
it.

## Images

| File | Target | Size (bytes) | MD5 |
|---|---|---|---|
| `msx-pi3.img` | Pi 3A+/B+, Zero 2 W, Pi 2 (32-bit mode) | 540752 | `73de824cb711b13654cd8333bef6cce7` |
| `msx-pi4.img` | Pi 4, 400, CM4 | 579344 | `b8da39c33db2177177398525a72dc68d` |

`SHA256SUMS` and `MD5SUMS` are included. The images embed `__DATE__` /
`__TIME__`, so a rebuild produces different checksums even with identical
source.

## How to test

Use an existing v1.0 SD card (the two-partition layout documented in the main
`README.md`) and replace only the kernel images on the boot partition:

```sh
# boot partition mounted at /media/$USER/boot (adjust)
cp msx-pi3.img /media/$USER/boot/msx-pi3.img   # Pi 3 / Zero 2 W
cp msx-pi4.img /media/$USER/boot/msx-pi4.img   # Pi 4 / 400 / CM4
sync
```

Keep the v1.0 `config.txt`; it already selects `msx-pi3.img` or `msx-pi4.img`
by board. No other file on the card changes.

To roll back, copy the v1.0 `msx-pi3.img` / `msx-pi4.img` from
`release/v1.0/` back onto the card.

## What to check

Report results per board and configuration, with the serial log if possible.

### 1. Boot and diagnostics

- [ ] Banner and startup log appear as with v1.0 (same messages; no new
      failures).
- [ ] The diagnostic line budget still stops after ~200 lines (no runaway
      logging).
- [ ] C-BIOS boots to the MSX BASIC screen.

### 2. Embedded / ROM-from-file cartridge

- [ ] Load a 32 KiB ROM from the overlay file browser (F11) and run it.
- [ ] Load a Konami-SCC MegaROM (e.g. Gradius, Salamander, Nemesis 3) and
      confirm it boots and runs at the same speed as v1.0.
- [ ] Load an ASCII8/ASCII16 MegaROM and confirm banking still works.

### 3. Physical cartridges (RPMC bus, msxbus enabled)

- [ ] With `msxbus=on`, a physical cartridge in connector 1 boots.
- [ ] Cartridge writes work (game saves / mapper writes — e.g. a MegaFlashROM
      game that previously failed silently if `/WR` timing regressed).
- [ ] Port I/O to the board still works (SCC/FM music modules, if available).
- [ ] Banked boot dump still produces a correct `CART1.ROM` with
      `msxbus.dumpmapper=konamiscc` on a Konami-SCC cart.

### 4. Reset path

- [ ] Select a ROM from the overlay, play, then select another ROM: the
      machine resets and boots the new cart (this exercises the second
      `InstallHostCallbacks()` call in `DoReset()`).
- [ ] Reset from the menu several times; no crash, no lost keyboard input.

### 5. Audio / UI / SD

- [ ] PSG audio plays at correct pitch and speed.
- [ ] HDMI and VCHIQ audio destinations both work (menu toggle).
- [ ] Overlay menu navigation, file browser, and mapper selection work.
- [ ] Cart dump and diagnostic files are written to the data partition when
      enabled.

## Expected failure signatures

If the seam has a wiring bug, the likely symptoms are:

- no physical-cartridge reads/writes with `msxbus=on` (bus callbacks or slot
  routing not installed), or
- missing/duplicated CHKRAM diagnostics (diag context or budget regression).

Either is a real regression; please capture the serial log and `msx.ini`.

## Build provenance

```sh
# Pi 3
cd src/app && make clean RASPPI=3 && make RASPPI=3

# Pi 4 (Circle libs rebuilt with RASPPI=4 first)
cd src/app && make clean RASPPI=4 && make RASPPI=4
```

Host checks for this change:

```text
PASS: host callback table routes bus and diagnostics
PASS: Z80 OTIR, VDP/PPI high-byte port aliases, PSG port decode
```
