# Raspberry Pi test images — 2026-11-09

Built from branch `feature/modular-emulation-architecture` at source commit
`d2e887e` (with the local Makefile cleanup that removes duplicate rules for a
missing V9938 adapter).

| Image | Target | Size | MD5 |
|---|---:|---:|---|
| `msx-pi3.img` | Raspberry Pi 3, 32-bit | 534,736 bytes | `5594fefc4dbe16ab9f5d77da94b95fe5` |
| `msx-pi4.img` | Raspberry Pi 4, 32-bit | 580,688 bytes | `81a32bc72db01820a7ca2dc3ac3b4245` |

See `MD5SUMS` and `SHA256SUMS` for checksums. Build dates are embedded, so
rebuilding produces different hashes.

## Build and verification

The modified shared Circle checkout was left untouched. Its current source
snapshot was copied to `/data/Projects/MSX/circle-v9938-test-build`; Circle
libraries were purged and rebuilt there for each target, then the app was
clean-built with `RASPPI=3` and `RASPPI=4` respectively. Both app builds
completed successfully. Circle emitted the existing `ARM_ALLOW_MULTI_CORE`
macro redefinition warnings.

These are current-branch **MSX1 fallback** test images, not MSX2/V9938-enabled
images: the V9938 implementation is not yet connected to machine creation or
the video I/O/render path. Hardware boot testing of these exact images is
pending. Do not copy these test artifacts into `release/`.
