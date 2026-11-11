# SCREEN 5 logical VDP command test images

Adds the SCREEN 5 LMMV (logical fill) and LMMM (logical copy) commands. The
previous V9938 command path handled HMMV/HMMM/HMMC only; these commands update
individual 4-bit pixels using the R#45 logical operation and preserve the
neighboring pixel nibble. This is a targeted candidate for the remaining
V-Killer/Space Manbow bitmap corruption, not yet hardware-verified.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 546,448 |
| Raspberry Pi 4 | `msx-pi4.img` | 592,592 |

These are test images only, not releases.

Verify with `md5sum -c MD5SUMS` and `sha256sum -c SHA256SUMS`.
