# Test images: video device seam (2026-11-01)

Branch: `main` (integration line); checkpoint `feature/modular-emulation-architecture`
Status: **hardware verified 2026-11-01** (Pi 3A+ and Pi 4, video regression
checklist passed -- no difference from the mapper-module images)

Fourth extraction step. Behavior should be identical to the mapper-module
images in `../2026-11-01-mapper-module/` (hardware-verified); the machine now
drives the VDP through an ops table instead of calling the chip directly.

## What changed

- `include/msx_video.h` (new): the video device seam. `MSX_VideoOps`
  (`read_io`, `write_io`, `sync_irq`, `irq_pending`, `destroy`) plus an
  `MSX_Video` handle (ops + device instance) and thin forwarders
  (`msx_video_read_io/write_io/sync_irq/irq_pending/destroy`, plus
  `msx_video_attach` for a non-TMS9918 device).
- `src/core/msx_video_tms9918.c` (new): the MSX1 video device, an adapter over
  `src/chips/vdp/tms9918.c`. It is a pure forwarder plus the device lifecycle;
  the MSX port map (0x98-0x9F) stays in `src/core/msx.c`.
- `src/core/msx.c`: no longer includes `tms9918.h`. The I/O callbacks call the
  seam, and `msx_step_frame()` now sequences
  `msx_video_sync_irq()` -> `msx_frame_render(machine->vdp)` ->
  `msx_video_irq_pending()` -> CPU IRQ. `machine->video` is the machine handle;
  `machine->vdp` remains a compatibility alias to the device pointer for
  `vdpblit.cpp` / `msx_task.cpp` and older tests.
- Preserved exactly: VDP port decode and high-byte aliasing, status-read IRQ
  clearing, `tms9918_gen_sync_irq()` timing in the frame loop, the render hook
  order, and the PSG sub-frame write log (untouched).

Host checks before packaging:

```text
PASS: video seam forwards to the TMS9918 and accepts other devices  (new)
PASS: mapper policy (ASCII8/16, Konami, Konami-SCC, guess)
PASS: CPU seam matches direct R800 execution and maps M1
0 timing mismatch(es)
PASS: host callback table routes bus and diagnostics
PASS: Z80 OTIR, VDP/PPI high-byte port aliases, PSG port decode
RESULT: PASS        konami_emu_test, ascii8_emu_test, megarom_bus_test
31 checks, 0 failed: PASS                                    cartdump_test
PASS: 60 Hz deadlines, variable work, wraparound, resume      frame_pacer_test
```

`host-test/video_seam_test.c` checks three things: the seam accepts a fake
device (counter ops, idempotent destroy, inert post-destroy calls), the
TMS9918 adapter produces byte-identical VRAM/register/status state to the raw
chip for the same port sequence, and `MSX_Machine.video.dev == MSX_Machine.vdp`.

## Images

| File | Target | Size | MD5 |
|---|---|---|---|
| `msx-pi3.img` | Pi 3 / 3A+ / 3B+ / Zero 2 W | 535248 | `a883ef188b9d96febcee105a3146e721` |
| `msx-pi4.img` | Pi 4 / 400 / CM4 | 581264 | `70548a0e18a153f827f7a8263018f0fd` |

+512 B (Pi 3) / +576 B (Pi 4) versus the mapper-module bundle. `MD5SUMS` and
`SHA256SUMS` included; images embed `__DATE__`/`__TIME__`, so checksums change
on every rebuild.

## How to test

```sh
cp msx-pi3.img /media/$USER/boot/msx-pi3.img    # Pi 3 family
cp msx-pi4.img /media/$USER/boot/msx-pi4.img    # Pi 4 family
```

Rollback: `release/v1.0/msx-pi3.img` / `msx-pi4.img`.

## Regression checklist (merge gate)

Video is the risk here, so watch these specifically:

- [ ] C-BIOS BASIC screen is correct (no missing/duplicated characters) and
      the BIOS logo/colors look right.
- [ ] Sprite rendering (a game with moving sprites) has no flicker, dropout
      or wrong colors; sprite collision/5S effects still behave.
- [ ] VBlank IRQ still drives games correctly, i.e. no speed change: 32 KiB
      ROMs (Goonies, PacMan) and Konami-SCC MegaROMs (Gradius, Salamander,
      Nemesis 3) run at v1.0 speed.
- [ ] ASCII8/ASCII16 MegaROM boots; mapper menu override still works.
- [ ] `ROM FROM FILE` vs the same ROM from the physical slot behave alike.
- [ ] Physical cart in connector 1 (`msxbus=on`): reads work, cart writes move
      pages (`MFRPROBE.TXT` changes).
- [ ] Reset between two ROMs from the overlay.
- [ ] PSG audio on HDMI and on VCHIQ (the PSG path is untouched, this is a
      control check).
- [ ] Overlay, browser, mapper menu, F-key bindings as before.
- [ ] Pi 3A+ and Pi 4 both pass.

## Next steps after this

- Audio seam (PSG + the sub-frame write log) and input seam (PPI/keyboard).
- Then the machine-profile layer, where the MSX slot map moves behind an
  `MSX_Memory` handle and a profile installs either MSX slots or a flat map
  (ColecoVision is the first non-MSX target).
