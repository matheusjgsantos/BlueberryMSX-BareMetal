# SCREEN 5 backdrop rendering test images (2026-11-12)

Experimental builds for the SCREEN 5 zero-pixel backdrop fix. Bitmap pixels
with color index 0 now display the backdrop color selected by VDP R#7 instead
of palette entry 0. This is intended to restore the blue C-BIOS background and
white Space Manbow Konami splash seen in openMSX. The fix passed the V9938 host
regression suite; hardware verification is pending. These are test artifacts,
not releases; no files in `release/` were changed.

Built from branch `feature/modular-emulation-architecture` at source commit
`f80bb74`, including the working-tree changes present at build time. The first
Pi 3/Pi 4 pair in this folder used Circle trees that could create files in
subdirectories but still truncated the saved path on close; those images did
not persist captures and should not be used. The images here were rebuilt with
the target-specific Circle trees that retain the full relative path through
file close (256-byte path field), as well as path-aware FAT directory support.

| Target | Image | Bytes | MD5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 549,200 | `e4ec497e8e2c6ac0eb7705702fd2309b` |
| Raspberry Pi 4 | `msx-pi4.img` | 595,664 | `0deb28eec487cd982f2e9acf9d9789d0` |

Please test the image for your Pi and check that the C-BIOS splash background
is blue and the Space Manbow Konami splash background is white. If either
still differs from openMSX, capture the screen and a matching ALT+F10 `.VDS`
snapshot for comparison.

Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
