# V9938 mode-2 sprite X alignment candidate (2026-11-12)

Experimental images applying the latest V-Killer hardware feedback. The
mode-2 sprite X coordinate is now SAT X + 2 pixels; the previous 32-pixel
subtraction was removed. The validated +1-pixel Y correction is unchanged,
and sprite color decoding is untouched.

The V9938 regression checks the sprite at `(SAT X + 2, Y + 1)` and verifies
palette color 2. V9938, MSX1 boot, MSX2 C-BIOS boot, and ColecoVision tests
pass. Pi 3 and Pi 4 Circle builds pass.

Hardware verification is pending. Please test V-Killer sprite X/Y placement
and colors, and send fresh paired ALT+F10 PPM/VDS captures if anything is
still off. These are experimental test images, not releases.

| Target | Image | Bytes | MD5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 546,128 | `e4dffe06657af27e84e20c3141eab9c1` |
| Raspberry Pi 4 | `msx-pi4.img` | 592,336 | `b2cb971e5e0653ee60783d6bb2485eef` |

Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
