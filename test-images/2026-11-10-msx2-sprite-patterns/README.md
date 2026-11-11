# MSX2 sprite-pattern test images

Experimental feature-branch images rebuilt after adding V9938 mode-2 sprite
pattern and per-sprite-line color fetches.

| Target | Image |
|---|---|
| Raspberry Pi 3 | `msx-pi3.img` |
| Raspberry Pi 4 | `msx-pi4.img` |

The Circle app builds used the matching trees: Pi 3 from
`/data/Projects/MSX/circle-msx2-build`, Pi 4 from
`/data/Projects/MSX/circle-v9938-test-build`. These are test artifacts, not
release images. Hardware verification is pending.

Host regression: `host-test/run_v9938_test.sh` now checks an opaque sprite
pixel from its VRAM pattern row, the matching mode-2 color-table entry, and a
transparent pattern pixel. MSX2 remains incomplete: full 212-line output,
interlace/YJK, precise sprite priority/collision behavior, complete command
timing/status/IRQ, RTC and disk boot remain outside this change.
