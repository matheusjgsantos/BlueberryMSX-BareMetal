# MSX2 completion gate (v2)

MSX2 is **not complete**. A game booting, a passing synthetic test, or a correct
HUD is not a release qualification. Do not release v2 or begin the MSX2+
implementation phase until the MSX2 gate below is satisfied. No game-name,
cartridge-hash, PC, or sprite-specific exceptions belong in the VDP.

## Reference hierarchy

1. Yamaha V9938 data book / MSX2 Technical Handbook, including command,
   sprite, timing, register and port definitions.
2. `../BlueberryMSX/BlueberryMSX-2.0plus/Src/VideoChips/`:
   `VDP.c` (ports/timing/table masks), `SpriteLine.h` (sprite evaluation),
   `Common.h` (scanout) and `V9938.c` (command engine).
3. `../openMSX/src/video/`: `VDP.cc`, `SpriteChecker.cc`,
   `SpriteConverter.hh`, `VDPCmdEngine.cc`, `PixelRenderer.cc` and bitmap
   converters. Cross-check disagreements rather than copying old shortcuts.
4. Runtime openMSX MCP at `http://raspberrypi3b.local:3000/mcp`. Verify actual
   gameplay by screenshot; attract/story mode may also enable line interrupts.

Register encodings and coordinates must be tested against reference semantics,
not inferred from a single title. The reference's internal border-buffer X
bias is not an output-pixel offset. Physical VRAM is the common dump format;
CPU/table addresses are mapped separately for planar modes.

## Audit findings and current implementation tranche

### Active display and presentation

The old renderer and app hardcoded 256x192. A centred 212-line crop removed
the HUD; retaining the top 192 rows restored it but removed 20 bottom rows.
Neither policy implements a 212-line display.

Current implementation: `v9938_render()` reports 192/212 active rows for
SCREEN 4-8 and scans out the native horizontal dot count: 512 for SCREEN 6/7
and TEXT2, 256 for the other modes. Callers allocate
`V9938_MAX_DISPLAY_WIDTH` x `V9938_MAX_DISPLAY_LINES`, the app scales the
complete source to the physical framebuffer, and the frame dump hook, periodic
PPM and ALT+F10 capture all write the real width and height. There is no crop,
downsample or source-side resampling. The `.VDS` binary format is unchanged.
Legacy-mode output remains 256x192.

### Text modes

TEXT2 used to be fed through the TMS9918 adapter as 80 columns of 3-dot cells,
which folded the line into 240 dots. It now has its own scanout:

- 80 columns of 6-dot glyphs (480 dots) between 8-dot background borders in the
  512-dot line, foreground R#7 high nibble and background R#7 low nibble.
- Name table `R#2<<10` masked to a 4 KiB window, 80 bytes per character row;
  pattern generator `R#4<<11` masked to a 2 KiB window; glyph dots are the six
  high pattern bits `0x80..0x04`.
- The blink table is `(R#3<<6)` masked to a 512-byte window: one bit per
  character, ten bytes per character row. While the blink phase is ON, a set bit
  swaps in the R#12 high/low colours.
- Blink is frame-clocked: R#13's high nibble is the ON period and the low nibble
  the OFF period in units of ten frames, and any R#13 write restarts the phase
  in the ON state (openMSX `VDP::frameStart` / `changeRegister`). A zero period
  is a stable colour. The undocumented R#1 bit 2 "fast blink" line-clock mode is
  not emulated.
- R#23 scrolls the whole text plane in dot lines, so the character row and the
  pattern row both follow it (blueMSX `RefreshLineTx80`). openMSX only rotates
  the pattern row; the two disagree once the scroll crosses a character cell and
  blueMSX is the primary reference here.
- Text modes display no sprites (blueMSX `RefreshLineTx80` never evaluates the
  sprite line; openMSX `DisplayMode::getSpriteMode` returns 0). The V9938 legacy
  adapter therefore disables sprite output for TEXT1 as well.

TEXT1 (40 columns) still renders through the TMS9918 adapter, which draws 240
dots at x=0 rather than centring them between 8-dot borders, and has no blink
table. That is the remaining text-mode gap.

### Sprite mode 2

The previous port assumed the colour table was always `SAT - 512`, mixed a
ten-line crop into sprite Y, conflated collision occupancy with display
priority, and approximated CC chains with a per-pixel flag. All are device
semantics errors, not game quirks.

Current working-tree changes:

- Decode the sprite table as the reference masked 1 KiB window, including
  R#5's colour-index mask bits. Test both normal and unusual SAT halves.
- Map SAT/colour/pattern reads to physical VRAM in SCREEN 7/8.
- Use the same active-line origin as bitmap output, preserving the legitimate
  SAT `Y + 1` convention but removing the mode-dependent `+10`.
- Evaluate eight sprites per line (leading CC sprites still count); preserve
  leading-CC suppression and consecutive following-CC OR composition.
- Draw back-to-front; transparent zero does not hide lower-priority sprites.
- Separate collision from drawing; IC or CC excludes either participant;
  record the first collision coordinates with the documented +12/+8 bias.
- Clear S#0's F/overflow/collision flags on acknowledgment.
- Use the fixed SCREEN 8 sprite palette. In SCREEN 6 each sprite dot covers
  two screen dots at the same palette colour (reference GRAPHIC6 sprite
  branch); SCREEN 7 is 1:1 in the 512-dot grid and SCREEN 5 keeps its
  documented one-dot approximation.

Sprite status is still evaluated by the frame renderer, not the emulated beam.
This tranche does not claim cycle/line-accurate sprite-status completion.

### CPU VRAM protocol

Current working-tree changes: apply the SCREEN 7/8 planar mapping to CPU
prefetch/read/write; keep pointer increment in the logical address domain;
increment R#14 at wrap in extended modes rather than legacy modes; cancel a
pending control word on reads/data writes and palette pairing on R#16 writes.
Register masks, some indirect-register behavior and CPU-access timing still
need the full port conformance matrix.

### Commands and status

Implemented from `V9938.c` (`SrchEngine`, `LineEngine`, `LmcmEngine`) and
cross-checked against `VDPCmdEngine.cc` (`executeSrch`, `executeLine`):

- `LINE` (§ opcode `0x70`): major axis from ARG bit 0, X/Y direction from bits
  2/3, minor-axis accumulator starting at `(NX-1)/2`, `NX+1` dots, the
  documented extra minor step, and the top-border stop (`TY<0 && DY<0`); the
  bottom border wraps.
- `LMCM` (opcode `0xA0`): one pixel per read of R#44 through the indirect port,
  with the TR fetch / CPU-read / next-fetch handshake and CE cleared only after
  all pixels are handed over. `0xA0` is no longer decoded as a byte fill.
- `SRCH`: stops on `(pixel == CL) XOR ARG.EQ` (so ARG.EQ set means "find a
  pixel that differs"), sets S#2 BD on a match, clears it when the line boundary
  ends the search, and publishes the result X in S#8/S#9 (`0xFE | bit 8`)
  instead of writing R#32/R#33. Reading S#9 resets BD.

The remaining command-engine gap is incremental execution: commands still run
to completion on the CPU write that starts them, so CE duration, TR
backpressure and display/sprite contention are not yet time-driven.

## Mandatory release blockers

Unchecked items are not implemented/verified, even if some happy paths work.

### VDP scanout

- [ ] GRAPHIC1-7 and MULTICOLOR mode coverage, including 192/212-line
      selection where applicable.
- [x] Full native horizontal resolution for SCREEN 6/7 and TEXT2: 512 dots
      end-to-end (renderer, blit, PPM/capture, replay).
- [x] TEXT2 80-column text renderer: 6-dot glyphs between 8-dot borders,
      R#3 blink table with R#12 colours and the R#13 frame period.
- [ ] TEXT1: centred 240 dots between 8-dot borders and the TEXT1 blink table.
- [ ] R#1 blanking and R#8 TP/color-zero policy in backgrounds and sprites;
      mid-frame mode/blanking/palette/sprite-table changes latched correctly.
- [ ] Tile-table masking/vertical scroll, R#18 set-adjust and border placement.
- [ ] R#9 interlace and even/odd page selection, field status and output.
- [ ] NTSC/PAL frame timing/pacing and beam/status consistency.

### Commands and status

- [x] LINE and LMCM, including directions, extents and CPU read handshake.
      Host-tested in SCREEN 5; extent/clip edges and SCREEN 7/8 still untested.
- [x] SRCH EQ polarity, boundary/BD handling, result in S#8/S#9 (not R#32/33).
      Host-tested; S#8/S#9 backed by `status[8]`/`status[9]`.
- [ ] POINT/PSET/LMMV/LMMM/LMMC/HMMV/HMMM/YMMM/HMMC across SCREEN 5-8,
      all logical operations, zero extents, clipping, overlap and argument bits.
- [ ] Completion-register updates, CL/R#44/S#7 consistency and abort behavior.
- [ ] Incremental time-driven execution with CE/TR/backpressure, display and
      sprite contention; delaying CE after instantaneous writes is insufficient.
- [ ] S#0 F latch independent of IE0; enable changes recompute interrupt line.
- [ ] S#1 line latch/acknowledgment and correct rescheduling/enable semantics.
- [ ] S#2 VR/HR/EO and command flags dynamic at documented boundaries.
- [ ] S#3-6 collision coordinate reads/clear semantics; S#8/9 command results.
- [ ] CPU INT follows remaining VDP sources after any status read, rather than
      unconditionally clearing for port 0x99 reads.
- [ ] Sprite overflow/collision status evaluated at beam time, independent of
      rendering/capture frequency; no capture-induced machine-state mutation.
- [ ] Register masks/reset values, latch cancellation and R#17 restrictions.

### Whole-machine MSX2 requirements

- [ ] Expanded slot and memory mapper tests against BIOS-visible behavior.
- [ ] RP5C01 RTC ports/banks and reset/persistence policy.
- [ ] Disk controller/ROM/media boot and software-visible timing/errors.
- [ ] BIOS/BASIC boot and applicable firmware expectations explicitly tested.
- [ ] Physical slot, mapper, keyboard, joystick and PSG regressions remain intact.
- [ ] Pi 3 performance budget with native-height output and deterministic pacing.

YJK/YAE, V9958-specific horizontal scrolling/masking and later CPU/platform
extensions are **not V9938/MSX2 requirements**. Track them in MSX2+ and later
phases, rather than expanding this gate with unrelated features.

## Conformance and evidence

Run the cheapest device checks before app builds:

```sh
bash host-test/run_v9938_test.sh
gcc -O1 -Wall -Wextra -Isrc/app host-test/framebuffer_blit_test.c \
    -o host-test/framebuffer_blit_test
./host-test/framebuffer_blit_test
sh host-test/run_msx1_boot_test.sh
sh host-test/run_msx2_boot_test.sh
sh host-test/run_coleco_machine_test.sh
bash host-test/circle_fat/run_fat_path_test.sh
make -C src/app RASPPI=3
```

`v9938_conformance_test.c` covers native row 211 and output bounds, 192/212
sprite alignment, planar tables and CPU uploads/readback, table-window masks,
CC grouping/leading CC/transparent priority, IC/CC collisions and ninth-sprite
status, 16x16 quadrants, EC/magnification, and latch cancellation. The raster
suite checks VBlank carry and page/scroll splits. Add boundary and negative
cases for every new device behavior; a test preserving an old incorrect
assumption is not a reference oracle.

For game validation, capture matching state and inspect real gameplay. Compare
physical VRAM/palette/registers first, then reference rendering of those same
bytes. A synthetic test pass is not a claim that the numbered pickup sprites
are fixed on hardware. Require visible full-height output, correct layered
sprites and no regressions across a fixed multi-title/multi-mode matrix on
both Pi 3 and Pi 4 before release. Keep host, emulator-reference and hardware
results separate in reports.

## Current verification record (2026-11-16)

- The 512-dot source buffer is always 512 pixels per row, including 256-dot
  SCREEN 5 and legacy modes. The first kernel-memory-fixed hardware image
  boots, but the user reported large gaps between scanlines; physical
  `capture/F00002A1.PPM` (256x212) had **all 106 even rows** identical to
  rows 0-105 of a replay of its `.VDS`/`.CMD`, while odd rows read the unused
  right half of the 512-dot buffer. This proves a presentation/capture stride
  error, not missing VRAM data. The blit, ALT+F10 and periodic PPM now use the
  512-pixel source stride independently of visible width, with a 256-in-512
  host regression. Corrected output still awaits hardware verification.
- User hardware report: the top-crop workaround restores the Aleste HUD, but
  still crops the bottom and renders the numbered weapon objects incorrectly.
  It is not the native-height/sprite-conformance implementation described here.
- Expanded V9938 suite, raster tests and framebuffer scaling test: PASS.
- Display/sprite conformance executable built and run with
  `-fsanitize=address,undefined -fno-omit-frame-pointer`: PASS.
- MSX1/MSX2 600-frame boot, Coleco and FAT16/FAT32 path suites: PASS.
- `make -C src/app RASPPI=3`: PASS (556376-byte app image); existing
  `ARM_ALLOW_MULTI_CORE` redefinition warnings remain. No new Pi4 build or
  hardware verification claimed for this tranche.
- 2026-11-16 TEXT2 tranche: expanded V9938 suite (TEXT2 columns/borders,
  blink phase, R#23 scroll, no sprites), ASan/UBSan, MSX1/MSX2 boot, Coleco,
  VDP probe and framebuffer scaling: PASS. `make -C src/app RASPPI=3`: PASS
  (558552-byte app image). Not hardware-verified.
- `tools/vdp_capture_report.py` now reads all 128 KiB and accepts the actual
  numbered command-history records. It reports 1024 retained commands for
  `F00007FC`, rather than silently omitting them.
- `tools/mcp_openmsx.py vram` now exports a single atomic snapshot in bounded
  chunks, checks MCP truncation and validates 131072 bytes. Its old single
  large request returned only 49152 bytes. The earlier "44 differences over
  the full HUD page" statement was invalid: only 16384 HUD bytes were compared.
- `host-test/vdp_capture_replay.c` replays `.VDS` plus recorded `.CMD` raster
  states without executing game code. Replaying physical `F00007FC` generated
  a 256x212 PPM with all bottom rows and revised layered pickup sprites. This
  is scanout replay evidence, not proof of temporal alignment with openMSX or
  a hardware pass. The helper is game-independent:

```sh
gcc -O1 -Wall -Wextra -Iinclude -Isrc/chips/vdp -Isrc/app \
    host-test/vdp_capture_replay.c src/chips/vdp/v9938.c \
    src/chips/vdp/tms9918.c host-test/trace_stub.c \
    -o host-test/vdp_capture_replay
./host-test/vdp_capture_replay CAPTURE.VDS CAPTURE.CMD OUTPUT.PPM
```
