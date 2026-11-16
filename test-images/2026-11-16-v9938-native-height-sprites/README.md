# V9938 native height + sprite conformance hardware test

Commit: `84bc929` on `feature/modular-emulation-architecture`.

This bundle replaces the `2026-11-16-aleste-top-crop-hud-fix` workaround. That
build restored the top HUD by keeping active rows 0-191, which cropped the
bottom 20 rows of 212-line mode and still drew the numbered weapon pickups with
the old approximate sprite compositor.

## Bundle contents

- `msx-pi3.img` / `msx-pi4.img` — target-specific test images.
- `msx.ini` — complete configuration (`machine=msx2`, `bootlog=on`,
  `capture.dir=capture`, physical cart bus on).
- `expected-native-height.png` — offline replay of the physical `F00007FC.VDS`
  capture through the new renderer (256x212, bottom rows present).
- `MD5SUMS`, `SHA256SUMS`.

| Target | Bytes | MD5 | SDHOST symbols |
|---|---:|---|---:|
| Pi 3 | 556,376 | `73ac70f1bb4b13a5ba55c44f9161cc26` | 40 |
| Pi 4 | 603,096 | `1419519f38a3c9921a1510cfdd49c36a` | 0 |

Flash only the image matching the Pi. Copy `msx.ini` to the root of SD
partition 2 and keep/create `capture/` there.

## What changed

1. **Native active height.** `v9938_render()` now reports 192 or 212 rows for
   SCREEN 4-8. The HDMI blit scales the real source height and the PPM writers
   use it, so nothing is cropped and nothing is resampled 212-to-192.
2. **Sprite mode 2.** Reference masked 1 KiB sprite-table window (including
   R#5 colour-index mask bits) instead of assuming the colour table is
   `SAT-512`; no more ten-line sprite Y crop (sprites share the bitmap origin);
   planar SCREEN 7/8 table reads; 8 sprites per line counting leading CC;
   leading-CC suppression; consecutive CC colour groups; back-to-front drawing;
   transparent zero not hiding lower-priority sprites; collision independent of
   drawing with IC/CC exclusion and first-collision coordinates; fixed SCREEN 8
   sprite palette; S#0 F/overflow/collision cleared on acknowledge.
3. **CPU VRAM protocol.** SCREEN 7/8 planar mapping for CPU read/write,
   pointer kept in the logical domain, R#14 bumped at wrap only in extended
   modes, pending control word/palette pairing cancelled correctly.

## Hardware test

1. Boot the physical Aleste cartridge. Press SPACE repeatedly (500 ms holds)
   until the ship and scrolling playfield are running — not the DIA51 story
   screen.
2. Check the three things that were wrong before:
   - top HUD (`SC`, `ARM 1`, lives) still visible;
   - **bottom of the screen complete**, no missing 20-line band (compare with
     `expected-native-height.png`);
   - **numbered pickups drawn as layered blue/red numerals**, not flat blocks
     or misaligned fragments.
3. During gameplay press **ALT+F10** and return `boot.log` plus the
   `.PPM`/`.VDS`/`.CMD` set.
   Objective check: the PPM header should read `P6` / `256 212` / `255`
   (previously always `256 192`).
4. Please also do a short MSX1 regression (e.g. Goonies or PacMan from the
   cart slot) — that path must stay 256x192 and unchanged.

## Not in this bundle

This is **not** a v2 release candidate and MSX2 is still incomplete
(`Docs/MSX2_COMPLETION.md`). Still missing: native 512-dot SCREEN 6/7 and TEXT2
output, text80/blink/interlace, LINE/LMCM, `SRCH` results in S#8/S#9,
incremental CE/TR command timing, beam-time status/IRQ, RTC and disk support.
Sprite status is evaluated per rendered frame, not by the emulated beam.

## Host and build verification

- `bash host-test/run_v9938_test.sh` — legacy V9938 suite, new
  `v9938_conformance_test` and `vdp_raster_split_test`: PASS.
- `v9938_conformance_test` rebuilt with `-fsanitize=address,undefined`:
  PASS.
- `framebuffer_blit_test` (including 212-row source scaling): PASS.
- MSX1/MSX2 600-frame boot, Coleco and Circle FAT16/FAT32 path suites: PASS.
- Both images are clean-built in sequence with target-specific Circle
  library/addons and clean `src/app` builds; Circle is left configured for
  Pi 3.
