# Space Manbow SCREEN 5 scroll-wrap test images (2026-11-11)

Experimental Raspberry Pi images built from the current feature branch to test
the V9938 bitmap vertical-scroll wrap correction. **Not a release.**

The scanout now wraps the bitmap display-Y counter to 8 bits, matching the
reference behavior in openMSX (`PixelRenderer.cc`: `displayY &= 255`). Host
regression `test_v9938_screen5_vertical_scroll_wrap` passes. The Space Manbow
black-gameplay/page mismatch seen in captures `F0000A18` through `F0000E40`
is not yet confirmed fixed; hardware captures from this build are needed.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 546,000 |
| Raspberry Pi 4 | `msx-pi4.img` | 592,208 |

Flash the image for the matching Pi target. Boot Space Manbow, start gameplay,
and capture the same stages with ALT+F10. Please send the paired `.PPM` and
`.VDS` captures, including one after the screen switches to gameplay. Compare
with the previous capture set in `/home/opencode/MSX/capture`.

Hardware verification is pending. Verify image integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
