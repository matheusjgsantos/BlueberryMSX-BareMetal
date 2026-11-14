# Aleste expanded VDP trace test images (2026-11-13)

Diagnostic Pi 3/Pi 4 images for investigating Aleste gameplay corruption.
These images do **not** contain a confirmed graphics fix. The paired capture
analysis and handbook/openMSX comparison have not identified a concrete
HMMM geometry defect, so the V9938 command behavior is unchanged.

The ALT+F10 `.CMD` sidecar now retains up to 1024 VDP command launches (up from
128) and 2048 CPU VRAM-port accesses (up from 256). This should provide a
longer command/write history around each capture. `.VDS` remains unchanged.
Captures are still on-demand: make sure the card's data partition has
`capture.dir` configured, then capture during the corrupted gameplay and copy
the matching `.PPM`, `.VDS`, and `.CMD` files for analysis. The larger CMD
history makes sidecars larger; allow time for the SD write to finish.

These are test artifacts, not releases. No files under `release/` were
changed. Hardware verification is pending.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 552,016 |
| Raspberry Pi 4 | `msx-pi4.img` | 598,352 |

Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
