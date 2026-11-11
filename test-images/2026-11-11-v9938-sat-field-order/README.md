# V9938 mode-2 SAT field-order candidate (2026-11-11)

Experimental images for the V-Killer sprite corruption reported after the
R#14 page-preservation fix. The latest captures show the MSX2 mode-2 sprite
attribute entries use `(Y, X, pattern, reserved)`, while the renderer had
treated them as `(Y, pattern, X, reserved)`. This reverses both sprite
placement and pattern selection.

The fix in `src/chips/vdp/v9938.c` now reads X from SAT byte 1 and pattern
number from byte 2, matching BlueberryMSX `SpriteLine.c` and openMSX
`SpriteChecker.cc`. The host regression uses distinct X/pattern values to
catch another field swap. `host-test/run_v9938_test.sh`, MSX1 boot, MSX2
C-BIOS boot, and ColecoVision tests passed. Pi 3 and Pi 4 Circle builds
completed successfully.

**Hardware verification is pending.** Test images only; do not publish as a
release. The Space Manbow background corruption is not addressed here: its
captured gameplay frames have R8=0x2A (sprites disabled), and still need a
separate command/bitmap diagnosis.

| Target | Image | Bytes | MD5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 546,128 | `59d928a7e586ea249cdd71c26d805725` |
| Raspberry Pi 4 | `msx-pi4.img` | 592,336 | `5c6f11252543187567d0dce0d7a02722` |

Flash the matching image, test V-Killer sprite visibility/position, and send
fresh paired ALT+F10 `.PPM`/`.VDS` captures if sprites are still wrong.

Verify image integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
