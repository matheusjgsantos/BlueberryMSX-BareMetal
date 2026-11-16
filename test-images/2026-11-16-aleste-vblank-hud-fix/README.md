# Aleste VBlank-state / HUD fix hardware test

Pi 3 and Pi 4 images containing a targeted V9938 raster-state fix for Aleste's
missing HUD band. The earlier ALT+F10 capture path fix remains intact and was
hardware-verified before these images were built.

## Bundle contents

- `msx-pi3.img` — Raspberry Pi 3 build.
- `msx-pi4.img` — Raspberry Pi 4 build.
- `msx.ini` — complete configuration (`bootlog=on`, MSX2, physical cartridge
  bus, and `capture.dir=capture`).
- `REFERENCE.md` — the observed openMSX R#2/R#23 sequence and comparison with
  the failing BlueberryMSX capture.
- `MD5SUMS` and `SHA256SUMS`.

| Target | Bytes | MD5 |
|---|---:|---|
| Pi 3 | 555,024 | `c059a1bebd353a0812d3d4241d3261f8` |
| Pi 4 | 601,680 | `a85fea70308bb338b3712b95d462d1fd` |

Flash only the image matching the Pi. Copy `msx.ini` to the root of SD partition
2 (`emmc1-2`) and keep/create `capture/` there.

## Fix being tested

Aleste selects the HUD in its VBlank handler:

- VBlank: `R#2=$3F` (page 1), `R#23=0`.
- Line interrupt: `R#2=$1F` (playfield page 0), then new playfield scroll.

BlueberryMSX frame time zero is the end of active display. Previously a display
register write in VBlank was only applied from that raster line forward, so it
never reached the wrapped top lines of the next active display. The renderer
therefore showed the playfield page/scroll even above the split. The patch
carries blanking-period display-register writes across the raster wrap. Writes
made during active display still affect only the current and subsequent lines.

## Hardware test

1. Boot Aleste and press SPACE three times to leave attract mode and start
   gameplay.
2. The fixed HUD band should be visible at the top of the screen during
   gameplay.
3. Press **ALT+F10** during gameplay and inspect the new `.CMD` sidecar.
4. Expected register trace: raster 0 has `R2=3F R23=00`; the line split changes
   to `R2=1F` and a nonzero/playfield `R23`. The pre-fix capture incorrectly
   had `R2=1F` at raster 0 and retained the previous playfield scroll there.
5. Return the new `boot.log` and one matching `.PPM`/`.VDS`/`.CMD` capture set.

Hardware verification of the HUD fix is still pending. These are test images,
not release replacements.

## Verification already completed

- New `test_aleste_vblank_hud_state` in `host-test/vdp_raster_split_test.c`
  reproduces the openMSX R#2/R#23 sequence and checks HUD pixels.
- The new test fails against the pre-fix VDP at the raster-0 `R#2=$3F`
  assertion and passes with the patch.
- `host-test/vdp_raster_split_test`: all checks passed.
- `run_v9938_test.sh`, `run_msx1_boot_test.sh`, `run_msx2_boot_test.sh`, and
  `run_coleco_machine_test.sh`: passed.
- `git diff --check`: passed.
- Both app images were clean-built sequentially with target-specific Circle
  libraries/addons and clean `src/app` builds.
- Pi 3 links 40 `sdhost` symbols; Pi 4 links 0. Circle is configured for Pi 3.
