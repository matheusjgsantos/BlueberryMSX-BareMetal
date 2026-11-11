# V9938 mode-2 sprite position adjustment (2026-11-11)

Experimental images incorporating the SAT field-order fix and a small
hardware-feedback position calibration: sprites are shifted 2 pixels right
and 1 pixel down. Sprite palette decoding/composition is unchanged.

The change is in `src/chips/vdp/v9938.c`; the V9938 host regression asserts
that a sprite with a distinct SAT X and pattern appears at the calibrated
coordinate and retains palette color 2. V9938, MSX1 boot, MSX2 C-BIOS boot,
and ColecoVision tests pass. Pi 3 and Pi 4 Circle builds pass.

Hardware verification of this coordinate adjustment is pending. Test
V-Killer and provide fresh PPM/VDS captures if the position still needs
adjustment. These are experimental test images, not releases.

| Target | Image | Bytes | MD5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 546,128 | `8216f89b0a24d193ecf217afc29afc5a` |
| Raspberry Pi 4 | `msx-pi4.img` | 592,336 | `dc179327e19ec88919129cb2e78519ad` |

Verify image integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
