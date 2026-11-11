# SCREEN 5 palette channel-order test images

Experimental Pi images fix the V9938 SCREEN 5 palette decoding: the first
palette byte contains red in bits 4-6 and blue in bits 0-2; the second byte
contains green in bits 0-2. This matches BlueberryMSX-2.0plus and openMSX.

The accompanying hardware captures showed the renderer using the captured
palette consistently, but the palette write path had green and blue reversed.
The fix should correct color rendering. Remaining V-Killer/Space Manbow bitmap
corruption is not claimed fixed by this image and needs a fresh capture after
the color correction.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 545,168 |
| Raspberry Pi 4 | `msx-pi4.img` | 591,312 |

These are test images only, not releases.

Verify with `md5sum -c MD5SUMS` and `sha256sum -c SHA256SUMS`.
