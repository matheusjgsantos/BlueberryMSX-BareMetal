# Space Manbow VDP/VRAM access diagnostic (2026-11-12)

These experimental images extend the ALT+F10 `.CMD` sidecar with cumulative
CPU-port VRAM read/write counts by 16 KiB bank and the latest 256 direct VRAM
port accesses. This follows the previous command-history captures, which
showed only R#46 opcodes `90`, `B8`, `C0`, `D0`, and `F0`, with no YMMM or
other unsupported commands. Command launches stopped increasing before the
corrupted gameplay frames, so this build targets direct CPU VRAM traffic.

The images retain command-history logging and the YMMM candidate. Existing
`.VDS` and `.PPM` formats remain unchanged. Hardware verification is pending;
these are experimental test images, not releases.

Please capture during gameplay and during the splash artifact, then copy each
matching `.PPM`, `.VDS`, and `.CMD` trio.

| Target | Image | Bytes | MD5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 548,752 | `0992b5dd527d82cb11a15b9fb545aca4` |
| Raspberry Pi 4 | `msx-pi4.img` | 595,088 | `03d1e539817ae25f51b26c9e2cb0866b` |

Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
