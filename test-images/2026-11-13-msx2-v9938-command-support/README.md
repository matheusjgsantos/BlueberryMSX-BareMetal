# MSX2 / V9938 command-support test images (2026-11-13)

Development images for host-tested MSX2/V9938 changes on
`feature/modular-emulation-architecture`. These are test artifacts only; no
release directory was changed, and neither image has been verified on a Pi.

The build includes SCREEN 8 direct RGB rendering, SCREEN 6/7 wide-mode
sampling, SCREEN 6-8 logical/high-speed command addressing, and basic POINT,
PSET, and SRCH results/status support. Remaining gaps include LINE, LMCM,
command timing, and broader V9938 status fidelity. MSX2+ remains deferred.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 552,080 |
| Raspberry Pi 4 | `msx-pi4.img` | 598,416 |

The two images were rebuilt from the same working tree, using isolated Circle
trees configured for Pi 3 and Pi 4 respectively, with a clean app build between
targets. Host regressions passed: `host-test/run_v9938_test.sh`, MSX1/MSX2
C-BIOS boot tests, Coleco profile test, and VDP raster-split test.

Use the image matching your Pi. Please report boot behavior and test MSX2 BASIC
plus representative SCREEN 5/6/7/8 output and command operations. Hardware
verification is pending.

Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
