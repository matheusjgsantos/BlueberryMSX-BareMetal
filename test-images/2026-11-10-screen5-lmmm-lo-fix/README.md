# SCREEN 5 LMMM logical-operation register test images

The latest hardware captures show R#46=`0x98` (LMMM, transparent logical
operation) while R#45=`0x00` (ARG). The V9938 references take LO from R#46's
low nibble, not R#45. This build fixes that register decode; otherwise LO=8
was executed as LO=0 and transparent zero-source pixels erased the destination.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 546,448 |
| Raspberry Pi 4 | `msx-pi4.img` | 592,592 |

This fix has host regressions but still needs hardware verification. Test images
only; not releases.

Verify with `md5sum -c MD5SUMS` and `sha256sum -c SHA256SUMS`.
