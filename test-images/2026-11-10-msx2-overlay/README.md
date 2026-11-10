# MSX2/V9938 test images — 2026-11-10

Experimental Pi 3 and Pi 4 images with MSX2/V9938 selectable from the overlay.
Built on `feature/modular-emulation-architecture` from source commit
`d2e887e`, including the uncommitted MSX2 integration and legacy-screen
rendering changes present at build time. These are test artifacts, not a
release; `release/` was not modified.

| Image | Target | Size | MD5 | SHA-256 |
|---|---|---:|---|---|
| `msx-pi3.img` | Pi 3 family, 32-bit | 538,768 bytes | `d38ce2fb2725bff0b502876b3bf18ea5` | `861a9b8d2d8c64bc20f272ee0994f6dd6d33c677d259a9077a07163f7016f6c5` |
| `msx-pi4.img` | Pi 4 family, 32-bit | 584,912 bytes | `9f672799c4005ac78608a91fd38ab2ed` | `c1b0b6c2073bee1664a3faa52b5830cc9193b9b77b34f184df9fb4297a2e2e64` |

The checksum manifests are included. Build date/time are embedded in the
firmware, so a rebuild will produce different checksums.

## Install and test

Use the existing v1.0 boot/data card bundle and replace the matching boot
partition kernel image:

```sh
cp msx-pi3.img /media/$USER/boot/msx-pi3.img  # Pi 3 family
cp msx-pi4.img /media/$USER/boot/msx-pi4.img  # Pi 4 / 400
```

Keep the existing `config.txt`, firmware, and data partition unchanged. Ensure
the data partition has `BIOS/cbios_main_msx2.rom`, `BIOS/cbios_logo_msx2.rom`,
and `BIOS/cbios_sub.rom` (the v1.0 bundle already contains these). Open the
overlay and select **MSX2 / V9938**; the default remains **MSX1 / TMS9918**.
Selecting a different machine resets the emulated machine. Roll back by
restoring `release/v1.0/msx-pi3.img` or `release/v1.0/msx-pi4.img`.

## Verification and limits

- Host V9938 port/render tests, MSX2 profile/expanded-slot checks, overlay test,
  and a 600-frame C-BIOS MSX2 boot test pass.
- Circle Pi 3 and Pi 4 app builds pass using the isolated Circle tree at
  `/data/Projects/MSX/circle-v9938-test-build`; existing Circle
  `ARM_ALLOW_MULTI_CORE` redefinition warnings remain.
- Hardware testing of these exact image checksums is pending. V9938 command
  engine behavior and full MSX2 compatibility are not complete.

Verify the manifests from this directory with `md5sum -c MD5SUMS` and
`sha256sum -c SHA256SUMS`.
