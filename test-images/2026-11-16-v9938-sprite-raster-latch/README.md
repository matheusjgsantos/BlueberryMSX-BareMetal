# V9938 raster-time sprite register test — Pi 3 / Pi 4

**Hardware verification pending.** Branch `feature/modular-emulation-architecture`,
source commit `2240996`. These are test images, **not** an MSX2 v2 release.

The prior image restored Aleste's full-height picture and HUD, but the user
reports graphic assets leaking into the HUD. Physical `capture/F000104B.PPM`
matches the old `.VDS`/`.CMD` replay byte-for-byte. Turning off sprites in that
offline replay removes 177 pixels from HUD rows 0–9, but old `.CMD` files do
not record sprite registers by raster line, so the cause is **not proven**.

The shared V9938 renderer now records R#1, R#5, R#6, R#8 and R#11 with the
already latched bitmap registers and selects sprite tables/enable per raster
line. New `.CMD` capture lines include all of these; old `.CMD` files remain
replayable but cannot recover past sprite state. A synthetic mid-frame/VBlank
regression passes. The build must be tested on hardware to determine whether
this fixes the observed HUD leak; do not infer success from the host test.

## Deployment

- Copy `msx-pi3.img` or `msx-pi4.img` (matching the board) as `msx.img` to
  your existing **boot** partition. Keep its known-working `config.txt` and
  boot firmware; do not install both images as `msx.img`.
- Copy the bundled **complete** `msx.ini` to the **second, data** partition.
  It keeps `machine=msx2`, `msxbus=on`, `bootlog=on` and
  `capture.dir=capture`. `bootlog=off` remains supported if desired.
- Prefer a `capture/` directory on the data partition; capture falls back to
  its root if that directory cannot be used. Leave `release/` unchanged.
- Verify both exact files with `md5sum -c MD5SUMS` or
  `sha256sum -c SHA256SUMS` inside this bundle.

| Board | Bytes | MD5 | Kernel `_end` | SDHOST symbols |
|---|---:|---|---:|---:|
| Pi 3 | 560,152 | `8088facfb69add0fe06fbd8524d62dff` | `0x001a8020` | 40 |
| Pi 4 | 606,936 | `07c49d2e8d7ccf9c1475fac77f3930c2` | `0x001b3768` | 0 |

## Hardware test

1. Boot the Pi 3 and Pi 4 images separately. Compare the top HUD, bottom of
   the 212-line playfield, and sprite graphics to the last working image;
   also check a second MSX2 game and an MSX1 game if available.
2. During active gameplay press ALT+F10; copy the resulting `.PPM`, `.VDS`,
   `.CMD`, and `boot.log` into `capture/` for analysis. New `.CMD` raster lines
   must include `R1=`, `R5=`, `R6=`, `R8=` and `R11=`. Report the board and
   whether the unexpected HUD pixels are gone or merely changed.

The VDS contains **final** VRAM only: it cannot reconstruct mid-frame VRAM
writes or prove the HUD was correct at beam time. Other MSX2 release blockers
remain in `Docs/MSX2_COMPLETION.md`.

## Pre-hardware checks

- `bash host-test/run_v9938_test.sh`, including raster-split regression: PASS
  on commit `2240996` (also passed with ASan/UBSan before packaging).
- MSX1/MSX2 600-frame boot, Coleco and FAT path tests: PASS before packaging.
- Clean per-target Circle/addons/app builds completed in an isolated copy of
  the locally modified Circle sources. Both app builds passed the Circle
  `_end <= 0x208000` guard; Pi 3 has 40 SDHOST symbols, Pi 4 has none.
  Both `md5sum -c MD5SUMS` and `sha256sum -c SHA256SUMS` passed for the exact
  packaged images. Hardware boot and visual behavior are still unverified.
