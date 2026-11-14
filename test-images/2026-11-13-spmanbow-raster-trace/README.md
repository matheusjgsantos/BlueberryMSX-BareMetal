# Space Manbow raster trace test images (2026-11-13)

Diagnostic Pi 3/Pi 4 images from the current working tree on
`feature/modular-emulation-architecture` (base commit `f80bb74`). These include
the experimental V9938 per-raster-line display-state latching and add a
`raster_trace` section to the ALT+F10 `.CMD` sidecar. That section lists each
latched display-state transition by raster line, to show whether the game split
was captured and where it lands. The Circle trees used for these builds
include the nested-path FAT fix required for `MSX/CAPTURE/` writes.

Please test the matching image, capture Space Manbow during corrupted gameplay
with ALT+F10, and copy the matching `.PPM`, `.VDS`, and `.CMD` files. The trace
is diagnostic only: the graphics fix remains unconfirmed on hardware. These
are test images, not releases; no release files were modified.

| Target | Image | Bytes | MD5 | SHA-256 |
|---|---|---:|---|---|
| Raspberry Pi 3 | `msx-pi3.img` | 550,480 | `cfc42eba6dcea6363d5e05ec2654148e` | `28acf32f1e334777bb337d3aae9df3e946bbd8817b477bb17f93a0ede62c4822` |
| Raspberry Pi 4 | `msx-pi4.img` | 596,816 | `614646dd41b057b4e03a2f30ace63d8e` | `c0512813ccf0451f92a27927571499074924ba7e3530ae588d6ce7f5e0c72a1c` |

Verify integrity from this directory:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
