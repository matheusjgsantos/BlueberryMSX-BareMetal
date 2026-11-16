# V9938 command semantics + native 512-dot/TEXT2 hardware test

> **DO NOT FLASH THESE IMAGES.** The user reported a blank screen on both
> Pi 3 and Pi 4, with no new `boot.log`. The Pi 3 ELF had `_end=0x2469e0`,
> beyond Circle's 2 MiB limit (`0x208000`); `sysinit` halts before `main()`.
> Pi 4 had the same extra static buffers but its old ELF was not retained for
> a separate `_end` check. Use `../2026-11-16-v9938-kernel-memory-fix/` for the corrected
> candidate, pending hardware verification. The image checksums below identify
> these **known-bad** images; they do not establish bootability.

Commits: `a17a1e2`, `782be91`, `30f7324` on
`feature/modular-emulation-architecture` (on top of the
`2026-11-16-v9938-native-height-sprites` bundle, `84bc929`).

This bundle stacks the three V9938 tranches that are still unverified on
hardware: reference `LINE`/`LMCM`/`SRCH` command semantics, native 512-dot
SCREEN 6/7 scanout, and the native TEXT2 80-column renderer with blink. It also
contains everything from the native-height + sprite-mode-2 tranche, so it can
replace the earlier bundle entirely.

## Bundle contents

- `msx-pi3.img` / `msx-pi4.img` — target-specific test images.
- `msx.ini` — complete configuration (`machine=msx2`, `bootlog=on`,
  `capture.dir=capture`, physical cart bus on).
- `text2-layout-preview.png` — synthetic TEXT2 screen rendered by *this build*
  (512x192: 80 six-dot columns between 8-dot background borders, row 0 in the
  blink palette). Emulator output for layout comparison, not reference
  evidence.
- `MD5SUMS`, `SHA256SUMS`.

| Target | Bytes | MD5 | SDHOST symbols |
|---|---:|---|---:|
| Pi 3 | 558,552 | `cffc17e587eb1b9070b8823777036538` | 40 |
| Pi 4 | 605,208 | `e20aa75876410f49dccfe960e5d3ada0` | 0 |

Flash only the image matching the Pi. Copy `msx.ini` to the root of SD
partition 2 and keep/create `capture/` there.

## What changed since the last bundle

1. **LINE / LMCM / SRCH** follow the reference engines: `LINE` uses the
   major-axis length minus one on both axes, the documented minor-axis
   accumulator and the top-border stop; `LMCM` transfers one pixel per CPU read
   of R#44 with the TR/CE handshake (`0xA0`, no longer decoded as a byte fill);
   `SRCH` stops on `(pixel == CL) XOR ARG.EQ`, publishes its result in S#8/S#9
   and clears BD on boundary termination or S#9 read.
2. **SCREEN 6/7 scan out their native 512 dots.** Previously one pixel per
   two-dot group was sampled into a 256-wide buffer, folding the right half of
   every line away. Sprites follow the reference: a SCREEN 6 sprite dot covers
   two screen dots in the same palette colour, SCREEN 7 is 1:1, and collision X
   is measured on the 512-dot grid (so S#3/S#4 report `x+12` there).
3. **TEXT2 is rendered natively.** 80 columns of six-dot glyphs (480 dots)
   between 8-dot background borders, name table `R#2`, pattern generator `R#4`,
   `R#7` per-line foreground/background, the `R#3` blink table with `R#12`
   colours and the `R#13` frame period, and `R#23` scrolling the whole text
   plane. V9938 text modes no longer display sprites.
4. Captures now write the real frame size: the PPM header is `256 192`,
   `256 212`, `512 192` or `512 212` instead of always `256 192`. The HDMI blit
   scales the native source without crop or resample.

## Hardware test

1. **Aleste cartridge** (SCREEN 5, 212-line): press SPACE repeatedly (500 ms
   holds) until the ship and scrolling playfield are running, not the DIA51
   story screen. Check the top HUD (`SC`, `ARM 1`, lives) is still visible, the
   bottom 20 lines are present, and the numbered weapon pickups are layered
   numerals.
2. **An SCREEN 6 or SCREEN 7 title** if you have one: check the whole width is
   drawn (no folded or half-width image, nothing squeezed into the left 256
   dots) and that sprites line up with the background.
3. **An 80-column TEXT2 screen** if available (`SCREEN 0` with `WIDTH 80` on
   MSX2 BASIC, or an 80-column application): 80 full-width characters, borders
   on both sides, blinking characters alternating with the R#12 colours and the
   R#13 period.
4. **MSX1 regression** (Goonies, PacMan from the cart slot): the image must
   stay 256x192 and unchanged.
5. During each run press **ALT+F10** and return `boot.log` with the
   `.PPM`/`.VDS`/`.CMD` set. Objective check: the PPM header must match the
   running mode — `256 212` for SCREEN 5 at 212 lines, `512 212` for SCREEN 6/7
   at 212 lines — never a fixed `256 192`.

## Known gaps (not regressions)

- TEXT1 still renders through the TMS9918 adapter: 240 dots at x=0 instead of
  centring them between 8-dot borders, and no TEXT1 blink table.
- Commands still complete on the start write; CE/TR duration, display
  contention and beam-time sprite/status evaluation are not time-driven yet.
- R#1 blanking/R#8 TP policy, tile masking/R#18, interlace and NTSC/PAL timing
  are unchanged and still open (`Docs/MSX2_COMPLETION.md`).
- The undocumented R#1 bit 2 "fast blink" line-clock mode is not emulated.

## Host and build verification

- `bash host-test/run_v9938_test.sh` — legacy suite, conformance suite
  (including SCREEN 6 native width, LINE/LMCM, TEXT2 columns/borders/blink/
  scroll) and raster split: PASS.
- Conformance suite rebuilt with `-fsanitize=address,undefined`: PASS.
- `framebuffer_blit_test` (256/512-wide sources): PASS.
- MSX1/MSX2 600-frame boot, Coleco and VDP usage probe: PASS.
- Both images are clean-built in sequence with target-specific Circle
  library/addons and clean `src/app` builds; Circle is left configured for
  Pi 3.
