# V9938 display blanking / colour-zero hardware test — Pi 3 / Pi 4

**Hardware verification pending.** Source commit `1ac9f30` on
`feature/modular-emulation-architecture`. These are **test images**, not an
MSX2 v2 release. The full MSX2 checklist remains open.

R#1 display-off now produces the R#7 backdrop instead of continuing to show
VRAM; R#8 bit 5 (TP) selects transparent/solid palette index zero on V9938
screens and sprite mode 2. SCREEN 8 direct-colour zero remains opaque black.
SCREEN 6 uses R#7's separate even/odd two-bit background colours. Mid-frame
blanking and TP changes are selected by captured raster state.

## Deploy and test

1. Copy `msx-pi3.img` **or** `msx-pi4.img` (matching your board) as `msx.img`
   to the existing **boot partition**; keep its working firmware/config.txt.
   Copy the complete bundled `msx.ini` to the **second, data partition** root.
   It retains `machine=msx2`, physical bus settings, `capture.dir=capture`,
   and `bootlog=on` (set to `off` if desired). Never place these in `release/`.
2. Check MSX2 TEXT1 (`SCREEN 0: WIDTH 40`) for legible text and equal margins;
   check a familiar SCREEN 5 game for its stable HUD and playfield (including
   Aleste's HUD if available). Check a SCREEN 6/7/8 program if you have one,
   and confirm an MSX1 title still works. Report visual differences versus
   the prior TEXT1 bundle, including any unexpected black/blank lines, colour
   zero, or sprite changes. No title-specific exception was added.
3. Capture relevant frames with ALT+F10 and send the matching `.PPM`, `.VDS`,
   `.CMD` and `boot.log`; report Pi model, display appearance and the mode or
   game shown. A capture checks the emulated RGB, not the HDMI presentation.

| Board | Bytes | MD5 | Kernel `_end` | SDHOST symbols |
|---|---:|---|---:|---:|
| Pi 3 | 562,072 | `a8d5340275b93e1bd833704be2c8cbc6` | `0x001a87a0` | 40 |
| Pi 4 | 608,856 | `a51daeff3414918e36e440a5749cac68` | `0x001b3ee8` | 0 |

Verify with `md5sum -c MD5SUMS` and `sha256sum -c SHA256SUMS` in this directory.

## Pre-hardware verification

`bash host-test/run_v9938_test.sh` passes normally and with ASan/UBSan.
MSX1/MSX2 600-frame boot and Coleco profile tests pass. A Pi 3 app build
passed (`msx.img` 562,072 bytes, `_end=0x001a87a0 <= 0x208000`). This bundle's
Pi 3 and Pi 4 images are clean target-isolated Circle/add-on/app builds;
per-board results and checksums are recorded above. 26 build logs were
audited with zero errors; both `_end` values satisfy Circle's `0x208000`
limit, and both checksum manifests passed `-c`. Hardware visual verification
has **not** been performed on either image.
