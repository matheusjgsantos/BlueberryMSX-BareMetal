# MSX2 C-BIOS LMMC boot fix test images (2026-11-11)

Experimental Pi images for the MSX2 boot hang seen in captures
`F00000BD`–`F00001F6`. Those captures and the host boot test showed the C-BIOS
logo routine stuck in an 8x8 LMMC transfer with one pixel remaining.

The VDP now preserves an R#44 (COL) write made before R#46 starts LMMC/HMMC as
the first transfer datum. This matches the command engine's latched COL/transfer
behavior. The MSX2 host boot regression now requires the VDP transfer to finish
and display enable to be set; it passes after 600 frames.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 546,064 |
| Raspberry Pi 4 | `msx-pi4.img` | 592,336 |

Flash the image for the matching Pi. Verify that MSX2 selection reaches and
renders the C-BIOS logo, then test Space Manbow gameplay graphics. Capture a
matching `.PPM`/`.VDS` pair with ALT+F10 if the logo or game graphics are still
wrong. **Hardware verification is pending; test images only, not releases.**

Check image integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
