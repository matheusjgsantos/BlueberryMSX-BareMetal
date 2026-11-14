# Space Manbow YMMM command candidate (2026-11-12)

Experimental images adding V9938 SCREEN 5 YMMM (high-speed vertical VRAM
copy) support. YMMM copies bytes at fixed DX from SY to DY, spans to the
horizontal edge according to DIX, and uses NY/DIY for its vertical extent.
This is a likely missing command for the observed Space Manbow gameplay
corruption, not a confirmed root cause: the supplied VDS snapshots retain the
last R#46 value, not a history of command launches.

The host regression verifies YMMM copies full rows despite NX being smaller
and clears the command-executing status on completion. V9938, MSX1 boot, MSX2
C-BIOS boot, and ColecoVision tests pass. Pi 3 and Pi 4 Circle builds pass.
Hardware verification with Space Manbow is required; these are experimental
test images, not releases.

| Target | Image | Bytes | MD5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 546,640 | `8aed8dc56130f458870ff21b9bf6a2fc` |
| Raspberry Pi 4 | `msx-pi4.img` | 592,848 | `33f0f8e92fe7a27c6d1ec721574958c5` |

Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
