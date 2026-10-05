# Session Handoff — MSX Diag ROM + USB host boots on hardware (2026-10-05)

## Current status

Hardware run confirmed (`MSX/serial-out/msx-boot.log`):

- `make` in `src/app` builds cleanly; `msx.img` is 478,832 bytes.
- The firmware chain-boots, initializes USB, loads C-BIOS plus the MSX
  Diagnostics cartridge, and sustains 59.25 fps
  (`PACE: target=60 fps=59.25 work_avg_us=15013`).
- MSX Diag replaced the Knightmare ROM: `src/app/msxdiag.rom` (32,768 bytes,
  md5 `ff73168bc0dcb9c7af596711d091bc89`, header `"AB"`, init `0x401C`)
  embedded via `src/app/msxdiag_roms.{h,cpp}`.

Startup stage logging (`Stage 1` … `Stage 14`) was added to
`src/app/kernel.cpp` to localize boot stalls; it is the reason two hangs were
found. Stage numbering: 1 hardware, 2 interrupts, 3 timer, 4 USB (4a create,
4b created, 4c initialize), 5 network (absent), 6 Run, 7 VDP blit, 8/9
`msx_create`, 10 C-BIOS, 11 MSX Diag, 12/13 MSX task, 14 scheduler loop.

### USB host: two hangs and their fixes

1. `CUSBHCIDevice::Initialize(TRUE)` (the default `bScanDevices = TRUE`)
   deadlocked. `Initialize` → `ReScanDevices` → `EnableRootPort` →
   `SubmitBlockingRequest` → `TransferStage`, which spins on
   `while (m_bWaiting[nWaitBlock])` in
   `BlueberryMSX/circle/lib/usb/dwhcidevice.cpp` with **no timeout**; only the
   USB IRQ completion routine clears the flag. Fix: `Initialize(FALSE)` and
   discover devices later from task level.

2. The prebuilt `libusb.a` was compiled **without** `NO_BUSY_WAIT`, so those
   blocking spins never yielded and starved every other task: USB enumeration
   ran ~1.9 s and the MSX task never ran (blank display, no `CKR` traces, no
   `frame=` heartbeat). Fix — rebuild the library, the define is compiled in:

   ```
   cd BlueberryMSX/circle/lib/usb && make clean && make DEFINE+=-DNO_BUSY_WAIT
   ```

   Verify with
   `arm-none-eabi-ar x libusb.a dwhcidevice.o && arm-none-eabi-nm -C dwhcidevice.o | grep CScheduler`
   (undefined `CScheduler::Get`/`Yield` prove the yielding path is active).
   `*.a` is gitignored, so rebuilding does not dirty the Circle repo.

`src/app/kernel.h` holds `CUSBHCIDevice *m_pUSBController` (a pointer, created
lazily in `Initialize` after the timer is up). `src/app/Makefile` links
`libusb.a` then `libinput.a` before `libcircle.a`; `libinput.a` is required or
`libusb.a` fails to link (`CKeyboardBehaviour`, `CMouseDevice`).

### Known open issues

- **No keyboard input yet.** No `CUSBKeyboardDevice` is acquired and no HID
  handler is registered, so no key can reach `msx_ppi_set_ec()`.
- **`UpdatePlugAndPlay()` never returns.** The log has `USB poll 1 start` and
  no matching `done`, so PnP is permanently stuck after the first enumeration
  (last USB line: `usbhub: Port 5: Device configured`). Because the library now
  yields, the emulator survives, but hot-plug events are never processed.
- **No keyboard was enumerated.** The devices found are hub `ven424-9514`,
  `ven424-ec00`, `ven45e-800` (Microsoft wireless receiver), `ven781-5406`
  (SanDisk U3 Cruzer Micro), `ven1a86-7523` (CH340 console adapter).
- Enumeration also mounts the SanDisk and brings up the SMC951x network driver,
  costing ~1.9 s at boot for hardware we do not use.

Earlier verified state (boot11, still valid for the display path) follows.

Boot11 hardware run confirmed:

- The C-BIOS logo, Knightmare splash, and attract-mode animation are visible.
- `MSX/serial-out/msx-boot11.log` reports
  `VIDEO: ... fb=800x480 pitch=1600 depth=16` with nonzero `different` values,
  including `12221`, `1069`, `2032`, and sustained 40k–46k values.
- Remaining user-visible gaps: pacing slower than expected, no sprites, no sound,
  and no keyboard input.

Frame pacing is now deadline-based at 60 Hz:

- `src/app/frame_pacer.h` advances a 1,666,666 µs deadline per frame, returns
  the remaining sleep, counts late frames, and resyncs after long stalls to avoid
  accumulating unbounded timing debt.
- `src/app/msx_task.cpp` replaces the old fixed 16 ms post-frame sleep with
  `CScheduler::usSleep(remaining)` and logs a `PACE:` line every 120 frames with
  measured fps, average/max frame work, late frames, and resyncs.
- `host-test/frame_pacer_test.c` covers exact 60 Hz deadlines, variable frame
  work, timer wraparound, small overruns, long-stall resync, and overload.
  It passes under both GCC C and G++ front-ends.
- `make` in `src/app` builds cleanly; `msx.img` is 337,776 bytes.

Display fixes verified in boot11:

- `src/core/msx.c` masks I/O ports to eight bits on reads and writes, like the
  reference `Src/Memory/IoPort.c`. The Z80 supplies full 16-bit port addresses;
  previously transfers such as OTIR to `0x0398` were silently dropped. This
  left the displayed G2 pattern bytes zero. A CPU-executed OTIR regression
  reproduced the missing bytes before the fix and passes after it.
- `src/app/vdpblit.cpp` uses the actual framebuffer depth and byte pitch via
  `framebuffer_blit.h`. boot10 reported 800x480 with pitch 1600 (16-bit RGB565),
  but the previous code wrote 800 32-bit pixels per row. Both RGB565 and
  XRGB8888 now have bounds/padding/scaling tests. VIDEO diagnostics include depth.
- `src/chips/vdp/tms9918.c` now uses the MSX palette ordering (1 black, 4 dark
  blue, 15 white). The host PPM export also had incorrect RGB shifts; corrected.

Verification: `framebuffer_blit_test`, `render_g2_test`, `io_decode_test`, and
`frame_pacer_test` pass. The 4000-frame `hk` run completes without forced IRQs.
Before port masking, all 6144 sampled G2 pattern rows were zero. After masking,
457 are nonzero, and `screen.ppm` has 2032 pixels differing from its black
background (1088 red, 944 white). Boot11 now confirms real graphics on the Pi.

Build firmware with `make` in `src/app`. Host GCC/G++ require the existing sysroot:
`-isystem /home/opencode/.cache/musl-dev/usr/include`
`-L/home/opencode/.cache/musl-dev/usr/lib -B/home/opencode/.cache/musl-dev/usr/lib/`.
Regression test sources live in `host-test/`; blit test includes `src/app`, G2
test links `tms9918.c`, and I/O test links `msx.c`, `R800.c`, and `tms9918.c`.

The Pi was powered off by the user after boot10; cessation of that log was not
a crash. No forced-sync IRQ override was reintroduced.

## Historical investigation (superseded by current status above)

The following records earlier hypotheses and intermediate renderer fixes.
Claims that I/O was fully correct or that fixes were not yet applied are historical.

Status: **root cause identified and confirmed against openMSX source. Fix not yet applied.**

Last updated: end of session. All formulas below were read directly out of the
local openMSX tree and are verified, not guessed.

---

## 1. Objective

BlueberryMSX bare-metal MSX1 emulator must render the Knightmare title screen.
Screen is currently all black. Three separate problems were isolated:

| # | Problem | Status |
|---|---------|--------|
| A | `tms9918_render` decodes the **name table base** with an MSX2 formula → reads the wrong VRAM | **confirmed bug, not yet fixed** |
| B | `render_graphics2` hardcodes the **color table base to 0x2000**; with R3=0x7F it must be 0x0000 | **confirmed bug, not yet fixed** |
| C | `render_graphics2` reads **one color byte per character**; openMSX reads **8 bytes per character (one per scanline)** | **confirmed bug, not yet fixed** |

Bugs A–C together fully explain the black screen. The emulator's VDP I/O,
IRQ delivery and CPU are all working correctly (section 4).

---

## 2. What is already correct (do not re-investigate)

* **0x98 / 0x99 VDP port decode** — `src/chips/vdp/tms9918.c`. Write-mode gate and
  the key-flag byte-pair desync bug were found and fixed earlier.
* **IRQ delivery path** works end to end:
  `r800SetInt` → RST 38 → `0x190B` → `CALL 0xFD9A` → game's H.TIMI hook.
* **H.TIMI hook is installed correctly.** Bus read at 0xFD9A yields `C3 2E 40`
  = `JP 0x402E`. Confirmed at frame 200 and later.
* **C-BIOS ISR fires every frame** (confirmed by status reads landing on
  0x1797 / 0x191E in the trace).
* **98_writes = 28469, 99_writes = 1142**, and `tms9918_w98_dropped == 0`.
  The game performed all its init writes between frame 1 and frame 200.

---

## 3. The emulator's problem: game state at frame 4000

```
PC=0x40C9  (idle loop, JR -2)
R0=0x02  R1=0xE2  R2=0x0E  R3=0x7F  R4=0x07  R5=0x76  R6=0x03  R7=0xE4
GRAPHICS 2,  slotReg=0x14,  activeSlot=[0 1 1 0]
H.TIMI= C3 2E 40      H.KEYI= C9 C9 C9
```

Decoding the mode with openMSX's `DisplayMode` constructor
(`msx2pp/openMSX/src/video/DisplayMode.hh:65`):

```c
mode = ((reg25 & 0x18) << 2) | ((reg0 & 0x0E) << 1)
     | ((reg1 & 0x08) >> 2) | ((reg1 & 0x10) >> 4);
// (reg1 & 0x40) is BLANK, (reg1 & 0x20) is the interrupt enable
```

With R0=0x02, R1=0xE2:

```
(0x02 & 0x0E) << 1 = 0x04
(0xE2 & 0x08) >> 2 = 0x02
(0xE2 & 0x10) >> 4 = 0x01
mode = 0x07  ->  base = mode & 0x1F = 0x07
```

**The mode is `MULTIQ` (0x06)/`TEXT1Q` (0x05)/bogus 0x07 — it is NOT GRAPHICS 2.**
The `0x07` value is a V9958 quarter-resolution variant that does not exist on a
TMS9918A. The game is running in an **undefined/illegal MSX1 mode**.

For comparison, `GRAPHIC2 = 0x04` requires `(reg0 & 0x0E) << 1 == 0x04` **and**
`(reg1 & 0x08) == 0` **and** `(reg1 & 0x10) == 0`, i.e. R1 bits 3 and 4 both clear.
R1=0xE2 has both set (0xE2 = `1110 0010`: bits 7,6,5,1).

R1 bit 6 (`0x40`) is **display enable, NOT blank** — see
`openMSX/src/video/VDP.cc:524`:

```c
bool newDisplayEnabled = (controlRegs[1] & 0x40) != 0;
```

An earlier note in this session claiming bit 6 was "blank / display off" was
**wrong**. The display is enabled. `render_*` therefore reads real VRAM data
and faithfully draws black because it reads the wrong VRAM addresses.

The temporary `KNIGHTMARE_FORCE_SYNC_IRQ` debug hook was removed for the final
wrap-up; the normal VDP INTEN/IRQ generation path is the active path.

---

## 4. Base address decode — verified openMSX formulas

openMSX composes each table base through `VDPVRAM::setMask`
(`openMSX/src/video/VDPVRAM.hh:168`), whose read address is
(`VDPVRAM.hh:234`):

```
addr = effectiveBaseMask & (indexMask | index)
effectiveBaseMask = base & (vram_size - 1)      // vram_size = 0x4000 on MSX1
baseAddr          = effectiveBaseMask & indexMask
combiMask         = ~effectiveBaseMask | indexMask
```

`base` is built as `(reg << shift) | 0x3FF` (or `| 0x7FF`), so the low bits of
the register contribute only through `& index` — i.e. they act as a *mask* on
the character number, and the register's high bits supply the base.

### Name table (`VDP.cc:1460`)

```
base      = (R2 << 10) | ~(~0u << 10)
indexMask = ~0u << 12   (text modes)   |   ~0u << 10   (graphics modes)

graphics  -> baseAddr = (R2 & 0x0F) << 10
text      -> baseAddr = (R2 & 0x0C) << 10
```

`R2 = 0x0E` → **name base = 0x3800** (24 rows x 32 cols = 768 bytes, ends 0x3AFF,
sprite attribute table follows at 0x3B00 — matches the observed game layout).

### Color table (`VDP.cc:1488`)

```
base = (R10 << 14) | (R3 << 6) | ~(~0u << 6)     // R10 = 0 on MSX1
switch (mode) {
  case 0x00 GRAPHIC1:  setMask(base,                   ~0u <<  6)
  case 0x04 GRAPHIC2:  setMask(base | (lacksMirror ? 0x1800 : 0), ~0u << 13)
  case 0x09 TEXT2:     setMask(base,                   ~0u <<  9)
}
```

Resolving for MSX1 (16 KiB, `vdpLacksMirroring()` is false):

```
GRAPHIC1 -> color base = (R3 & 0x7F) << 6     R3=0x7F -> 0x1FC0
GRAPHIC2 -> color base = (R3 & 0x80) << 8     R3=0x7F -> 0x0000
```

`R10` does not exist on MSX1 — it must be hard-wired to 0 in the port.

### Pattern table (`VDP.cc:1515`)

```
base = (R4 << 11) | ~(~0u << 11)
case 0x01,0x05,0x09,0x00,0x02,0x06:  setMask(base, ~0u << 11)
case 0x04 GRAPHIC2:  if (vdpHasPatColMirroring())      // TRUE on TMS99XX
                         base = (R4 << 11) | ((R3 & 0x1F) << 6) | ~(~0u << 6);
                     setMask(base | (lacksMirror ? 0x1800 : 0), ~0u << 13)
```

Resolving for MSX1 GRAPHICS 2 with R4=0x07, R3=0x7F:
`base = 0x3800 | 0x07C0 | 0x3F = 0x3FFF`, `& 0xFFFFE000` → **pattern base = 0x2000**.

openMSX documents the leakage explicitly (comment cites
`http://www.youtube.com/watch?v=XJljSJqzDR0`): **on TMS99XX some bits of the
color-base register R3 leak into the pattern-base.**

### Sprite pattern (`R6`)

```
base = (R6 << 11) | ~(~0u << 11),  indexMask = ~0u << 11
=> sprite pattern base = (R6 & 0x07) << 11
```

---

## 5. The G2 render loop — the color/pattern indexing bug

`openMSX/src/video/CharacterConverter.cc:275`:

```c
void CharacterConverter::renderGraphic2(std::span<Pixel, 256> buf, int line) const
{
    int quarter8 = (((line / 8) * 32) & ~0xFF) * 8;
    int line7 = line & 7;
    ...
    auto patternArea = vram.patternTable.getReadArea<256 * 8>(quarter8);
    auto colorArea   = vram.colorTable  .getReadArea<256 * 8>(quarter8);
    for (auto n : xrange(32)) {
        auto charCode8 = namePtr[n] * 8;
        auto pattern = patternArea[line7 + charCode8];
        auto color   = colorArea  [line7 + charCode8];   // <-- SAME index!
        Pixel fg = palFg[color >> 4];
        Pixel bg = palFg[color & 0x0F];
        draw8(pixelPtr, fg, bg, pattern);
    }
}
```

**The color table is indexed identically to the pattern table: `charNum*8 + line7`.**
One color byte *per character per scanline*, not one byte per character.

`quarter8` only ever takes three values, `{0x000, 0x800, 0x1000}`, encoding the
character number's bits 9-8 (which third of the 24 rows we are on).

So for `row = line/8`, name byte `n`:

```
pattern addr = pattern_base + ((row >> 3) << 11) + n*8 + (line & 7)
color   addr = color_base   + ((row >> 3) << 11) + n*8 + (line & 7)
name    addr = name_base + row*32 + col
```

The current emulator's `render_graphics2` reads the color table as
`col_ba2 + ch_col*8 + py` (one 8-byte block per character, correct byte layout)
but with `col_ba2` hardcoded to `0x2000` — which for R3=0x7F is the *pattern*
base, so it reads pattern bytes as colors. That is bug **B**.

And the emulator never applies `((row >> 3) << 11)` to the high character-number
bits, so characters in the 3rd row-third alias onto row 1. That is bug **C**.

---

## 6. Bugs to fix, precisely

`src/chips/vdp/tms9918.c` — `tms9918_render()` (dispatch) currently:

```c
UInt16 name_ba = (UInt16)((vdp->reg[2] & 0xF0) << 6);   // WRONG -> (R2 & 0x0F) << 10
UInt16 col_ba  = (UInt16)((vdp->reg[3] & 0xF0) << 6);   // WRONG -> (R3 & 0x7F) << 6
UInt16 pat_ba  = (UInt16)((vdp->reg[4] & 0x07) << 11);  // correct
```

Note `(R2 & 0xF0) << 6` yields **0** for R2=0x0E — the name table is being read
from 0x0000 instead of 0x3800. This is bug **A** and is the single biggest
cause.

`render_graphics2()` currently:

```c
const UInt16 pat_ba2 = (reg4 & 0x04) ? 0x2000 : 0x0000;  // matches openMSX for R4=0x07
const UInt16 col_ba2 = 0x2000;                            // WRONG, must derive from R3
UInt16 ch = vdp->vram[(name_ba + (row*32 + col)) & mask];
ch |= (UInt16)(row / 8) << 8;                             // adds bits 8-9 unconditionally
UInt16 ch_pat = (ch & 0xFF) | ((ch & 0x300) & ((reg4 & 0x03) << 8));
UInt16 ch_col = (ch & 0x07) | ((ch & 0x3F8) & ((reg3 & 0x7F) << 3));
```

Required changes:

1. `name_ba = (reg[2] & 0x0F) << 10` for graphics/multicolor,
   `(reg[2] & 0x0C) << 10` for text modes.
2. `col_ba = (reg[3] & 0x7F) << 6` for GRAPHICS 1.
3. `render_graphics2`: color table base must be `((reg3 & 0x80) ? 0x2000 : 0x0000)`
   for GRAPHICS 2, and the color index must use the same
   `((row>>3) << 11) + charNum*8 + line7` as the pattern index.
4. Derive the mode from the openMSX `DisplayMode` bit layout before dispatching,
   instead of the current hand-rolled `if (r1 & 0x08) / if (r1 & 0x10) /
   else if (r0 & 0x02)` chain, which misclassifies R1=0xE2.
5. Never treat `(reg[1] & 0x40)` as blank — it is display *enable*.

---

## 7. Empirical data to re-check after the fix

Observed VRAM at frame 4000 (from the harness scan):

```
0x0000-0x07FF  DENSE     color table   (0x0000-0x17FF all dense)
0x1800-0x1BFF  zero
0x1D00/0x1E00  sprite patterns (nz = 116 / 108)
0x2000+        EMPTY     <- pattern table should be dense here; verify after fix
0x3800         name table, char IDs 0-7 repeating
0x3B00         sprite attribute table, 128 entries
```

The "pattern table empty" observation is the thing to re-examine first — if
0x2000 really is empty then the game has not drawn its title art and there is a
**second, deeper problem** (see section 8). If it turns out 0x2000-0x37FF *is*
dense, then bugs A-C were the whole story.

---

## 8. Open question / possible deeper problem

`renderGraphic2` in openMSX indexes the color table with `charNum*8 + line7`,
i.e. **8 color bytes per character**. But `setMask` for GRAPHIC2 uses
`indexMask = ~0u << 13`, giving a 0x1800-byte color window, and the char number
is only 11 bits — 8 bytes/char would need 16384 bytes. The two are only
reconcilable because `quarter8` (max 0x1000) + `charCode8` (max 0x7F8) +
`line7` (max 7) = 0x17FF fits inside the 0x1800 window, meaning openMSX's G2
color window addresses are effectively `(row>>3)<<11 + charNum*8 + line7`
where bits 9-11 of the *byte* index are row-group bits, not character bits.

This means for real MSX1 GRAPHICS 2 hardware the color table entry for a
character is selected by `charNum`, but openMSX reads `charNum*8 + line7`.
Either openMSX is intentionally modelling a quirk, or the "8 colors per
character" reading is a consequence of the 0x1800 window aliasing. **This needs
to be settled empirically** — render one known-good frame and compare against a
reference dump before assuming openMSX's indexing is literally right.

Practical way to settle it: run the harness with the corrected base addresses
(bugs A and B only, keeping the existing 1-byte-per-char color indexing), dump
VRAM, and see whether the resulting image is coherent. If the color table
actually holds 8 bytes per character (nz count of 2048 over 0x0000-0x17FF with a
repeating 8-byte period), openMSX's indexing is confirmed.

---

## 9. Build and run

```sh
cd /home/opencode/MSX/BlueberryMSX-BareMetal/host-test
gcc -O0 -g -std=gnu11 \
    -I../include -I../src -I../src/core -I../src/chips \
    -I../src/chips/z80 -I../src/chips/vdp -I../src/app \
    -x c -o harness harness.c \
    ../src/core/msx.c ../src/chips/vdp/tms9918.c ../src/chips/z80/R800.c \
    ../src/app/cbios_roms.cpp ../src/app/knightmare_roms.cpp -lm
./harness 4000 0
```

Firmware build (only after the fix is verified in the harness):

```sh
cd /home/opencode/MSX/BlueberryMSX-BareMetal/src/app && make
```

The temporary `KNIGHTMARE_FORCE_SYNC_IRQ` debug hook has been removed, so no
forced-sync cleanup is required before the final firmware build.

---

## 10. Useful file map

| Path | Role |
|---|---|
| `src/chips/vdp/tms9918.c` | VDP. `render_graphics2`, `tms9918_render` dispatch, 0x98/0x99 I/O |
| `src/core/msx.c` | Machine core, `msx_step_frame` IRQ delivery |
| `src/chips/z80/R800.c` | Z80, INT vectoring |
| `src/app/kernel.cpp` | Bare-metal main loop |
| `host-test/harness.c` | Diagnostic harness: VRAM scan, Z80 dump, IO trace, register dump |
| `Docs/cbios-0.29a/roms/` | C-BIOS ROMs used by the harness |
| `msx2pp/openMSX/src/video/DisplayMode.hh` | Mode decode (line 65), mode constants (line 27) |
| `msx2pp/openMSX/src/video/VDP.cc` | `updateNameBase` 1460, `updateColorBase` 1488, `updatePatternBase` 1515, display-enable 524 |
| `msx2pp/openMSX/src/video/VDPVRAM.hh` | `setMask` 168, read address 234 |
| `msx2pp/openMSX/src/video/CharacterConverter.cc` | `renderGraphic2` 275 |

## 11. Environment notes

* No pre-built openMSX binary exists in the tree (`openMSX/build` contains only
  3rdparty makefile helpers), so openMSX cannot be run headless for ground truth.
  All comparison must be source-level or against known-good VRAM dumps.
* `host-test/km/` holds scratch ROM extracts for `z80dasm`:
  `h402e.bin`, `d49c0.bin`, `s49b7.bin`.
* Z80 disassembler available at `/usr/local/bin/z80dasm`.
* Toolchain: `arm-none-eabi-gcc` 16.1.0, `make` 4.4.1, `python3` 3.14. Do not
  reinstall.
