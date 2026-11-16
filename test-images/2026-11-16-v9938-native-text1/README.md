# V9938 native TEXT1 — Pi 3 / Pi 4 hardware test

**Hardware verification pending.** Source commit `69ac3ed` on
`feature/modular-emulation-architecture`; the last hardware-tested
sprite-raster-latch fix is included. These are test images, **not** an MSX2 v2
release. The rest of the MSX2 completion gate remains open.

TEXT1 now scans out 40 six-dot characters (240 pixels) between 8-dot
background borders in a 256-dot frame. It reads the V9938 R#2 name table and
R#4 pattern table, follows R#23 scrolling, and outputs 192 or 212 active lines
according to R#9. The renderer does not mix sprites into text. **TEXT1 does
not blink:** blueMSX `RefreshLine0` and openMSX `renderText1` both ignore the
R#3/R#12/R#13 blink table used by TEXT2; our host test checks that too.

## Deploy and check

1. Select the image matching your board (`msx-pi3.img` or `msx-pi4.img`),
   copy it as `msx.img` to your existing **boot partition**, and keep your
   working boot firmware and `config.txt`. The bundled **complete** `msx.ini`
   goes at the root of the **second, data partition**. It keeps the MSX2
   physical-bus configuration, `bootlog=on` (change to `off` if desired), and
   `capture.dir=capture`. Do not copy test images into `release/`.
2. In MSX2 BASIC, select `SCREEN 0: WIDTH 40` if available. Check the left
   and right margins are equal, all 40 columns fit, text is legible, and no
   sprites overlap the characters. Also compare an existing working MSX2 game
   (e.g. its stable HUD) and an MSX1 game with the previous test image.
3. During 40-column text output, use ALT+F10; copy `.PPM`, `.VDS`, `.CMD` and
   `boot.log` to `capture/` for analysis. Report the Pi model and whether the
   text PPM is 256 pixels wide (height depends on R#9). Check 80-column TEXT2
   still displays at 512 dots if available.

| Board | Bytes | MD5 | Kernel `_end` | SDHOST symbols |
|---|---:|---|---:|---:|
| Pi 3 | 560,856 | `24b19fb26a0a8088757dda12845b75d2` | `0x001a82e0` | 40 |
| Pi 4 | 607,576 | `a28b193f8347692be536d648c56fc080` | `0x001b39e8` | 0 |

Verify the exact packaged images inside this directory with
`md5sum -c MD5SUMS` or `sha256sum -c SHA256SUMS`.

## Pre-hardware checks

- `bash host-test/run_v9938_test.sh` and the ASan/UBSan variant: PASS. TEXT1
  host regressions cover all 40 columns, table-page masks, R#23 scroll,
  192/212 rows and guard, no sprites and no TEXT2 blink bleed-through.
- MSX1/MSX2 600-frame boot, Coleco, FAT16/FAT32 and framebuffer blit tests:
  PASS. Pi 3 and Pi 4 Circle/addons/app were cleaned, reconfigured and built
  separately using an isolated Circle source copy. Both kernel `_end` values
  passed Circle's `0x208000` guard. Pi 3 links 40 SDHOST symbols, Pi 4 links
  none. Both MD5 and SHA-256 manifests passed `-c` verification; exact SHA-256
  values are in `SHA256SUMS`. No hardware TEXT1 result is claimed.
