# Test images: CPU/clock seam (2026-11-01)

Branch: `feature/modular-emulation-architecture`
Status: **hardware verification pending**

Second extraction step after the host-callback seam. Behavior is intended to be
identical to `../2026-11-01-clean-build/` (which is boot-verified on Pi 3A+ and
Pi 4); only the CPU access path changed.

## What changed

- New seam `include/msx_cpu.h` + `src/core/msx_cpu.c`: the machine now creates,
  paces, interrupts and destroys the CPU through one `MSX_CPU` handle
  (`msx_cpu_create/execute/get_time/set_irq/clear_irq/get_pc/native_handle`)
  instead of calling `r800*` directly from `src/core/msx.c`.
- `MSX_CPU_OPTION_M1` maps to `CPU_ENABLE_M1`, so frame pacing and instruction
  timing are unchanged (`MSX_FRAME_TICKS` = 357954 stays the frame budget).
- `MSX_Machine.z80` is kept as a compatibility alias to the native R800 handle
  for the Circle app and existing tests. No emulator behavior was rewritten.

Host checks before packaging:

```text
PASS: CPU seam matches direct R800 execution and maps M1   (host-test/cpu_seam_test.c)
0 timing mismatch(es)                                      (host-test/r800_timing_test.c)
PASS: host callback table routes bus and diagnostics
PASS: Z80 OTIR, VDP/PPI high-byte port aliases, PSG port decode
RESULT: PASS                                               (konami_emu_test, ascii8_emu_test)
31 checks, 0 failed: PASS                                  (cartdump_test)
PASS: 60 Hz deadlines, variable work, wraparound, overload and resume
```

## Images

| File | Target | Size | MD5 |
|---|---|---|---|
| `msx-pi3.img` | Pi 3 / 3A+ / 3B+ / Zero 2 W | 534544 | `c55e151d97f0f0cb476ffabd7e0e7979` |
| `msx-pi4.img` | Pi 4 / 400 / CM4 | 580496 | `56550ac7eb69343222c11d0e58dafcc2` |

Previous round for comparison: `../2026-11-01-clean-build/` (Pi 3 534096,
Pi 4 580048). `MD5SUMS` and `SHA256SUMS` are included; images embed
`__DATE__`/`__TIME__`, so checksums change on every rebuild.

## How to test

Replace only the kernel on the v1.0 card and `sync`:

```sh
cp msx-pi3.img /media/$USER/boot/msx-pi3.img    # Pi 3 family
cp msx-pi4.img /media/$USER/boot/msx-pi4.img    # Pi 4 family
```

Boot should look like the previous round (brief `boot: ...` lines, then
C-BIOS). Rollback: `release/v1.0/msx-pi3.img` / `msx-pi4.img`.

## Regression checklist (this is the merge gate)

- [ ] C-BIOS BASIC screen appears; keyboard input works.
- [ ] 32 KiB ROM from the browser (e.g. Goonies, PacMan) runs at v1.0 speed.
- [ ] Konami-SCC MegaROM (Gradius, Salamander, Nemesis 3) boots and runs at
      v1.0 speed.
- [ ] ASCII8/ASCII16 MegaROM boots; mapper menu can override the guess.
- [ ] `ROM FROM FILE` and the same ROM from the physical slot behave alike.
- [ ] Physical cart in connector 1 (`msxbus=on`): reads work, cartridge
      writes move pages (`MFRPROBE.TXT` changes), board port I/O works.
- [ ] Reset between two ROMs from the overlay (exercises `DoReset()`).
- [ ] PSG audio on HDMI and on VCHIQ; volume/balance still work.
- [ ] Overlay, browser, mapper menu and F-key bindings behave as in v1.0.
- [ ] Pi 3A+ and Pi 4 both pass the same checks.

Report the failing check (or the last visible `boot:` line) if anything drifts.

## Provenance

Same procedure as the previous bundle: delete every Circle archive/object,
reconfigure the target, rebuild Circle libs and add-ons, then `make clean` and
`make RASPPI=N` in `src/app`. Sizes grew by 448 bytes on both targets versus
the clean-build bundle, as expected for the seam and its host-only test hook.
