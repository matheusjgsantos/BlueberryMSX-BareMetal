# Aleste V9938 line-interrupt (IE1) test images (2026-11-14)

Emulator fix for the Aleste MSX2 graphics corruption: the emulated V9938 had no
**line interrupt** at all, and the corrupt phase of the trace turns out to
depend on it.

Builds against `2026-11-14-aleste-timed-d0-ce/` (B, timed D0 CE) and
`2026-11-14-aleste-vdp-command-timing/` (A, trace only). Neither A nor B is a
fix; this build is the first one that adds a hardware feature the game asks for.

## What changed

1. **V9938 line interrupt (IE1)** — `src/chips/vdp/v9938.c`
   - `R#0` bit 4 (`IE1`) enable, `R#19` line number, `S#1` bit 0 (`FH`)
     report/acknowledge, exactly as the reference
     `BlueberryMSX-2.0plus/Src/VideoChips/VDP.c` (`scheduleHint`, `onHint`,
     `peekStatus`).
   - Pulse line = `displayLineZero + ((R#19 - R#23) & 0xFF)`, so the `R#23`
     vertical scroll shifts it like the reference. With IE1 disabled, `S#1`
     bit 0 is the live H-bank flag of that line and no interrupt is latched.
2. **Mid-frame interrupt delivery** — `src/core/msx.c` `msx_step_frame()`
   - The CPU `INT` line is now held asserted at instruction cadence while a VDP
     interrupt latch is pending (level-triggered, like hardware), instead of
     only at the frame boundary. Without this the handler would still run only
     once per frame, so a raster split could not be timed.
3. **Capture format** — the `.CMD` status trace now records every status read,
   not just `S#2`:
   - old: `status2 <seq> time=<t> pc=<pc> value=<xx>`
   - new: `status <seq> time=<t> pc=<pc> reg=<r> value=<xx>`

The `V9938_DIAGNOSTIC_TIMED_D0_CE=1` experiment is untouched and **off** in
these images (default build).

## Why (evidence, from the B-build captures in `MSX/capture/`)

| frame | R#0 | R#2 | R#8 | R#19 | page0 nonzero | page1 nonzero |
|------:|----:|----:|----:|-----:|--------------:|--------------:|
| 272 | `0E` | `1F` | `0A` | `00` | 939 | 0 |
| 391 | `06` | `1F` | `0A` | `00` | 18,529 | 23,919 |
| 525 | `16` | `1F` | `08` | `00` | 0 | 5,376 |
| 548 | `16` | `1F` | `08` | `00` | 0 | 5,376 |
| 566 | `16` | `3F` | `0A` | **`08`** | 32,768 | 11,886 |
| 894 | `16` | `3F` | `0A` | **`08`** | 32,768 | 11,885 |

- `R#0` goes `0x06 -> 0x16` at frame 525. Bit 4 is **IE1**, not a mode bit
  (the mode key is `((R0 & 0x0E) >> 1) | (R1 & 0x18)`, unchanged).
- `R#19` becomes `0x08` at frame 566 — exactly where the corruption starts and
  where it stays until the end of the run.
- Every capture reports `raster_trace ... transitions=1`: the display state
  never changes inside a frame, so there is no raster split.
- All 1,024 recorded commands are `D0` issued from PC `0x4B76`, and they all
  draw into the page that is **not** displayed (`R2=0x3F` selects page 1, whose
  visible half is only a 32-line HUD band), so the repainted playfield in page 0
  is never shown and the page is never swapped.

So the game programs a line interrupt and then behaves as if a per-frame flip /
split handler never ran — which is what happens when `IE1` is unimplemented.
Missing `D0` CE busy timing is **not** the cause: A and B are structurally
identical and B's CE hook demonstrably works.

## What to look for on hardware

1. Gameplay should show the composite screen instead of a HUD-only page:
   score/HUD band at the top and the scrolling playfield below it, and the
   playfield should animate instead of freezing on a stale page.
2. In a capture taken during gameplay, `.CMD` should now contain
   `raster_trace valid=1 transitions=<n>` with `n > 1`, plus `raster` lines whose
   `R2=` differs between the top band and the body (the split the game wants).
3. The status trace should contain `reg=1` reads (the game acknowledging `S#1`).
   If the game instead hangs or stalls, capture anyway: the `reg=` histogram
   shows whether it acks IE1 at all, which is the next thing to fix.

Analyse a capture set with:

```sh
python3 tools/vdp_capture_report.py /path/to/capture-dir
```

## Images

| Target | Image | Bytes | ELF size (text+data+bss) |
|---|---|---:|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 553,104 | `0x1ac468` |
| Raspberry Pi 4 | `msx-pi4.img` | 599,632 | `0x1b7ab0` |

Both footprint below Circle's 2 MiB limit. Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```

Both images were built with the full Circle sequence for their own target
(`./configure -r N --multicore -f`, `./makeall clean && ./makeall`, the
SDCard/linux/vc4 add-ons, then `make -C src/app clean RASPPI=N && make
RASPPI=N`). The Pi 3 image contains the SDHOST backend (40 `sdhost` symbols),
the Pi 4 image the EMMC backend — the earlier build-tree state in this checkout
was Pi 4, which silently produced a Pi 4 binary for a "Pi 3" build, so check
`arm-none-eabi-nm src/app/msx.elf | grep -ci sdhost` before shipping one.

## Verification

- `host-test/run_v9938_test.sh` — PASS, including the new
  `test_v9938_line_interrupt` (S#1 acknowledge, IE1 on/off, `R#19`/`R#23` line
  math, sharing the INT line with VBlank). Also PASS with
  `V9938_TEST_CFLAGS=-DV9938_DIAGNOSTIC_TIMED_D0_CE`.
- `host-test/run_msx1_boot_test.sh`, `run_msx2_boot_test.sh`,
  `run_coleco_machine_test.sh` — PASS.
- `host-test/run_cbios_msx2_boot_test.sh` — pre-existing breakage: it lists
  source files that no longer exist (`src/core/msx_audio_psg.c`,
  `msx_memory_msx.c`, ...). Unrelated to this change; not used here.
- Pi 3 and Pi 4 Circle builds PASS.

**Hardware verification is pending.** Nothing was flashed and no release image
was changed.
