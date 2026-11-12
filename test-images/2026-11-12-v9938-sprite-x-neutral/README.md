# V9938 mode-2 sprite X alignment candidate (2026-11-12)

Experimental images removing the 2-pixel rightward trim from the prior
candidate. Mode-2 sprite X is now the SAT X value. The validated +1-pixel Y
correction and all sprite color handling are unchanged.

The V9938 regression checks the sprite at `(SAT X, Y + 1)` and preserves the
expected palette color. V9938, MSX1 boot, MSX2 C-BIOS boot, and ColecoVision
tests pass. Pi 3 and Pi 4 Circle builds pass.

Hardware verification is pending. These are experimental test images, not
releases.

| Target | Image | Bytes | MD5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 546,128 | `44c282216373173505316f40d0a6a171` |
| Raspberry Pi 4 | `msx-pi4.img` | 592,336 | `4439c260c75a9cc5c9900709bfe720d4` |

Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
