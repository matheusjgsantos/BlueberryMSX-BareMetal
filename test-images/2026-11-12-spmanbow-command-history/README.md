# Space Manbow VDP command-history diagnostic (2026-11-12)

These experimental images add an ALT+F10 `.CMD` sidecar on MSX2. The sidecar
contains cumulative raw R#46 command-byte counts and the latest 128 command
launches with ARG/COL and decoded SX/SY/DX/DY/NX/NY. Existing `.VDS` format
and `.PPM` captures are unchanged. This build also includes the uncommitted
YMMM candidate; it is diagnostic and has not fixed the reported graphics
corruption in hardware.

Please capture once during the Konami splash (while the white line is visible)
and once during gameplay, then copy each matching `.PPM`, `.VDS`, and `.CMD`
trio from the configured capture directory. The `.CMD` log contains counts
since reset and a rolling history, so the sequence number helps establish how
recent the retained launches are.

Host V9938, MSX1 boot, MSX2 C-BIOS boot, and ColecoVision tests pass. Pi 3 and
Pi 4 Circle builds pass. Hardware verification of the sidecar write is
pending. These are experimental images, not releases.

| Target | Image | Bytes | MD5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 547,920 | `998e233c4b9486569141682e20f4c5eb` |
| Raspberry Pi 4 | `msx-pi4.img` | 594,128 | `0c558f7896116fa7b68256be0472c7b7` |

Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
