# Aleste HUD top-crop fix hardware test

These Pi 3/Pi 4 images include both V9938 fixes identified during the openMSX
comparison:

1. VBlank display-register writes carry across the raster wrap into the next
   active display.
2. The 192-row framebuffer starts at active display line 0 in 212-line mode,
   retaining the top HUD instead of discarding active lines 0-9.

The second change is the new fix relative to the still-failing
`2026-11-16-aleste-vblank-hud-fix` bundle.

## Bundle contents

- `msx-pi3.img` / `msx-pi4.img` — target-specific test images.
- `msx.ini` — complete configuration, including `bootlog=on` and
  `capture.dir=capture`.
- `openmsx-gameplay.png` — actual openMSX gameplay with its HUD visible.
- `expected-hud.png` — replay of the post-wrap physical `F0000542.VDS` through
  the corrected BlueberryMSX renderer, with `SC`, `ARM 1`, and lives visible.
- `REFERENCE.md` — register traces, VRAM comparison, and diagnosis.
- `MD5SUMS` and `SHA256SUMS`.

| Target | Bytes | MD5 |
|---|---:|---|
| Pi 3 | 554,960 | `1ea3a4bc894c1a1734cecd5a1f7104d8` |
| Pi 4 | 601,680 | `4ebb618ee038f3b127f53f92b918b8de` |

Flash only the image matching the Pi. Copy `msx.ini` to the root of SD partition
2 and keep/create `capture/` there.

## Evidence for this fix

- The previous bundle did correct the register history: new captures have
  raster 0 `R2=3F R23=00`, changing to `R2=1F` and playfield scroll at the
  split. Nevertheless the hardware PPM still lacked the HUD.
- The captured HUD page (`0x8000-0xFFFF`) differs from actual openMSX gameplay
  by only **44 of 32768 bytes**. The graphics are already in BlueberryMSX VRAM.
- OpenMSX schedules `R#19-R#23` from active display line 0. The R#19 scheduler
  was therefore left unchanged. The defect was the extra ten-line crop in both
  register-state selection and pixel address calculation. It discarded
  Aleste's HUD rows and sampled its post-split state at framebuffer row 0.
- Replaying the physical VDS through the corrected renderer produces
  `expected-hud.png`, directly demonstrating restored HUD pixels.

## Hardware test

1. Boot Aleste and press SPACE repeatedly (500 ms holds work well) until the
   ship and scrolling playfield are running. Do not stop at the DIA51 story
   screen or assume `R#19=8` alone proves gameplay.
2. Verify that the top HUD (`SC`, `ARM 1`, lives) is visible, resembling
   `expected-hud.png` / `openmsx-gameplay.png` rather than the old playfield-only
   image.
3. During gameplay, press **ALT+F10** and return the new `boot.log` plus a
   matching `.PPM`/`.VDS`/`.CMD` set.
4. `.CMD` should retain the corrected VBlank/split state (`R2=3F/R23=00` at
   raster 0; `R2=1F` and playfield scroll after the split).

Hardware verification is still pending; these are not release images.

## Host/build verification already completed

- Updated `test_aleste_vblank_hud_state` uses VBlank R#2/R#23 and the actual
  R#19=8 split; rows 0-7 must render as HUD pixels.
- `vdp_raster_split_test`: all checks pass.
- `run_v9938_test.sh`, `run_msx1_boot_test.sh`, `run_msx2_boot_test.sh`,
  `run_coleco_machine_test.sh`, and `circle_fat/run_fat_path_test.sh`: pass.
- `git diff --check`: pass.
- Both images are clean-built sequentially with target-specific Circle
  libraries/addons and clean `src/app` builds.
- Pi 3 links 40 `sdhost` symbols; Pi 4 links 0. Circle is configured for Pi 3.
