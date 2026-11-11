# SCREEN 5 V9938 command-status and byte-operation test images

Experimental Pi builds correcting two differences found against openMSX and
BlueberryMSX V9938 implementations:

- Status register 2 uses bit 0 for command-executing (CE) and bit 7 for
  transfer-ready (TR), as C-BIOS polls CE while uploading its HMMC splash.
- SCREEN 5 HMMV/HMMM/HMMC operate on packed VRAM bytes (two pixels per byte),
  rather than treating these high-speed commands as pixel-by-pixel operations.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 545,168 |
| Raspberry Pi 4 | `msx-pi4.img` | 591,312 |

Flash the image matching your Pi and preserve the second SD-card data
partition. Host tests pass, but C-BIOS splash and V-Killer visuals still need
hardware verification. These are test images only, not releases.
