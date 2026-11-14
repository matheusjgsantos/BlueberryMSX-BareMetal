# Space Manbow SCREEN4 rendering test (2026-11-12)

These experimental images include the V9938 SCREEN4 / Graphic 3 rendering fix
and ALT+F10 `.CMD` diagnostics (R#46 command history and direct CPU-port VRAM
access history). The existing `.VDS` and `.PPM` formats are unchanged. No
release files were modified; hardware verification is pending.

Please test the image for your Pi. Capture the affected gameplay and the splash
artifact if present, then copy each matching `.PPM`, `.VDS`, and `.CMD` trio.
The `.VDS` register snapshot will help confirm the active display mode; the
`.CMD` file includes recent CPU VRAM accesses and command history.

| Target | Image | Bytes | MD5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 549,200 | `b10411be36b4118bebb3610a466234d8` |
| Raspberry Pi 4 | `msx-pi4.img` | 595,664 | `1527d08ad55b15af31d0d944eb3a155e` |

Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
