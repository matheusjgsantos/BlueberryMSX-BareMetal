# Aleste HMMC payload trace test images (2026-11-13)

Diagnostic Pi 3/Pi 4 images for continuing the Aleste VDP investigation. This
is **not a graphics fix**. Analysis of the expanded capture set replayed the
newly issued HMMM commands against the preceding VRAM snapshot; all checked
gameplay intervals matched the captured destination VRAM exactly. Logged CPU
VRAM writes also matched their final snapshot bytes. The large HMMC payloads
are the remaining useful path to inspect.

The ALT+F10 `.CMD` sidecar now includes the latest 8192 bytes consumed by
HMMC, with each `data` line giving transfer sequence, command sequence,
destination VRAM address, and byte value. Histories are bounded and the
sidecar can be several hundred KiB; wait for the SD write to finish.

Please cold-start Aleste and capture once while it is loading/drawing the
initial presentation, then again when gameplay corruption is visible. Copy
each matching `.PPM`, `.VDS`, and `.CMD` triplet. The first capture is important
because Aleste's HMMC activity occurs during setup and largely stops later.

These are test artifacts, not releases. No files under `release/` were
changed. Hardware verification is pending.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 552,400 |
| Raspberry Pi 4 | `msx-pi4.img` | 598,736 |

Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
