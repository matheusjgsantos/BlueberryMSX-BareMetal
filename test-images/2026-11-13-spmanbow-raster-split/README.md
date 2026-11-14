# Space Manbow raster-split test images (2026-11-13)

Experimental Pi 3 and Pi 4 images built from the current working tree on
`feature/modular-emulation-architecture` (base commit `f80bb74`). They include
the V9938 per-raster-line display-register latching change intended to address
Space Manbow's HUD/playfield split. Host raster-split, V9938, and MSX2 C-BIOS
tests passed before packaging. The change has **not** been confirmed on
hardware; use these as test images only, not as a release.

These images are built against the isolated Circle trees containing the
nested-path FAT fix, including the 256-byte file path retained until close.
That is required for ALT+F10 files under `MSX/CAPTURE/`.

Please test the matching image on each Pi and capture Space Manbow gameplay
with ALT+F10 if the corruption remains or changes. No release files were
modified.

| Target | Image | Bytes | MD5 | SHA-256 |
|---|---|---:|---|---|
| Raspberry Pi 3 | `msx-pi3.img` | 549,968 | `287487205bcc2ee176d8eda4fad8a044` | `044c408f172ff30412cacd3e216acfc4cc43581610f688bc6a09bfc3deec394f` |
| Raspberry Pi 4 | `msx-pi4.img` | 596,432 | `8e9db1ce7bb18b6de11bf7ea5a79bbe6` | `e446e6af9813a8b932c3f8b6bb044ed12210e4280c86d45e9bebb7f345a2ed86` |

Verify image integrity from this directory:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
