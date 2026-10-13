# Session Handoff — MSX Diag ROM + USB host boots on hardware (2026-10-05)

## Update (2026-10-13): Knightmare cart removed

The Knightmare cartridge and its host-test artifacts have been removed. The
built-in cart selector now offers only `MSX DIAG` and `SLOTS (MSXBUS)`
(`TCartId { CartMsxDiag, CartSlots }`, `OVERLAY_CART_COUNT == 2`). Historical
notes below that mention a Knightmare cart describe earlier sessions. Build
verified: `msx.img` md5 `48fa0026d25fb8207818b7091be9cd90`, 576,400 bytes.
Build outputs (`*.o`, `*.d`, `*.elf`, `*.img`, `*.lst`, `*.map`) are no longer
tracked (see `.gitignore`).

## Current status

Hardware run confirmed (`MSX/serial-out/msx-boot.log`):

- `make` in `src/app` builds cleanly; `msx.img` was 479,952 bytes
  (md5 `7b2a27472ba3dda91900258c25b48fe6`) for the USB/C-BIOS baseline and is
  now 521,784 bytes (md5 `94cc0d24d3b31327f84796729a739918`) with sprites, the
  overlay ROM menu and the HID keyboard fix added (see "Feature work" below).
  That image has been copied to `/data/Projects/MSX/BlueberryMSX/msx.img`.

Hardware status: sprites verified working on the Pi. The overlay opens with
`ALT+F11`, but two problems were reported from that run and are **not yet
re-verified**: unreliable key presses (fixed by the usage-based diff above) and
a flickering menu. The overlay now logs `UI: overlay held, frames=N` about once
a second; **if that counter advances while the menu is open, the emulator is not
really frozen and that is what overwrites the menu** - the next step would be
to find what else steps the machine.

Latest image (fixes the Knightmare keyboard regression, see "Knightmare
keyboard regression" below): `msx.img` 538,680 bytes, md5
`fe7c933808fcc02caa208f76e306e121`, deployed to
`/data/Projects/MSX/BlueberryMSX/msx.img` — needs a hardware re-test of both
Knightmare and MSX Diag keyboard input.
- The firmware chain-boots, initializes USB, loads C-BIOS plus the MSX
  Diagnostics cartridge, and sustains 59.25 fps
  (`PACE: target=60 fps=59.25 work_avg_us=15013`).
- MSX Diag replaced the Knightmare ROM: `src/app/msxdiag.rom` (32,768 bytes,
  md5 `ff73168bc0dcb9c7af596711d091bc89`, header `"AB"`, init `0x401C`)
  embedded via `src/app/msxdiag_roms.{h,cpp}`.

Startup stage logging (`Stage 1` … `Stage 14`) was added to
`src/app/kernel.cpp` to localize boot stalls; it is the reason two hangs were
found. Stage numbering in the current source: 1 hardware, 2 interrupts, 3 timer,
4 USB (4a create, 4b created, 4c initialize), 5 network (absent), 6 Run,
7 VDP blit, 8/9 `msx_create`, 10 C-BIOS, 11 MSX Diag, 12 USB scan, 13 MSX
task creation, 14 MSX task created, 15 scheduler loop.

## Boot-delay instrumentation (2026-10-06)

Latest image: `msx.img` 538,744 bytes, md5 `9e9ecfc9cdc2ad01bc0e467cefc709be`,
deployed (same file as `/data/Projects/MSX/BlueberryMSX/msx.img`). It forces
GPIO14/15 to ALT0 in `diag_uart_init` (circle/lib/startup.S) so early probes
reach the wire, and timestamps every stage with `<ch> <10-digit µs from BCM
CLO>`:

- startup.S: `A` (entry), `B` (after stacks), blink(1/2) around them.
- sysinit.cpp: `C` → blink(3) → `c` → IRQs/cache/vfp → `k` → BSS/TBSS memset
  → `m` → `CMemorySystem` → `D` → blink(4) → `E` → … → `G`.
- kernel.cpp/main.cpp: `0` (main entry), `1`/`2` around `m_Screen.Initialize()`.

Hardware result (corrected 2026-10-07): the earlier "22.4 s banner, delay is
intermittent" claim was **wrong** — the Oct 6 and Oct 7 captures of image
`9e9ecfc9` are microsecond-identical, so the delay was deterministic:
bootcode → first VRAM = **219.6 s**, of which **207 s are the three
`diag_blink` loops with caches/MMU off** (`A→B = 59.0 s`, `B→C = 69.4 s`,
`C→c = 79.2 s`; the `0x10000000` pause dominates each loop at ~185 ns per
uncached iteration). Everything after probe `c` was already fast (`c→D` =
18 ms, `D→0` = 3.6 s, `1→first VRAM` ≈ 5.7 s).

**Fix, verified on hardware 2026-10-07** — image md5
`1faf7018491344c7c048e67f1a652b4c` (538,744 bytes): blink constants in
`circle/lib/startup.S` reduced from `0x01000000/0x02000000/0x10000000` to
`0x00010000/0x00020000/0x00100000`, plain `diag_uart` kept. Measured:
`B→C = 186 ms`, `C→c = 212 ms`, bootcode → banner = **3.1 s**, bootcode →
first VRAM = **8.47 s** (26× faster).

**Landmine — do not re-add UART TX polls.** Two `startup.S` variants that
polled `PL011_FR.TXFF` before every DR store (push/`bl` helper md5
`5f5c9beb…`, stackless md5 `fc6cb86c…`, backup
`MSX/host-test/startup.S.poll-variant`) produced **zero kernel bytes on every
boot**, although objdump showed instruction-correct code and the mechanism
was never explained; both plain-`diag_uart` images boot every time. Related
UART facts: probe `A` is written while the firmware's last line still drains
the 16-byte PL011 FIFO, so `A` is normally dropped, and any dropped bytes
shred probe lines (`k 02m 0219312461`) — `MSX/host-test/parse_msx_boot.py`
tolerates both. The one-time "boot #15 jumped from firmware with zero kernel
output" event is the same artifact class; three more were seen with the poll
builds.

## Feature work (2026-10-06)

Three features were requested on top of the verified USB/C-BIOS baseline:

1. TMS9918 sprite mode 1 — **implemented and host-verified**.
2. Overlay ROM selector (`ALT+F11`, reboot `ALT+F12`) — **implemented,
   host-verified and hardware-verified** (user: "Overlay menu is perfect
   now").
3. AY-3-8910 PSG audio — **implemented and host-verified; HDMI only, not yet
   run on hardware** (see below).

### 1. TMS9918 sprites — implemented

`src/chips/vdp/tms9918.c` gained `sprite_mode1()` and `render_sprites()`,
called at the end of `tms9918_render()` (background first, sprites on top,
matching openMSX's overdraw order). Supporting changes:

- `TMS9918` gained `UInt8 status` (S#0 bits) and `int fifth_sprite` scratch,
  initialised in `tms9918_create()`.
- Reading status register `0x99` returns `0x80 | status` and clears the IRQ
  plus bits 6/5 (keeping bits 4-0, the 5S index); writing register `0`
  (`R0`) clears status/irq the same way.
- `tms9918_render()` lost its `const` qualifier (it now writes `status`).
  Call sites: `src/app/vdpblit.cpp` casts `m->vdp` to `TMS9918 *`, and
  `host-test/harness.c`'s `dump_vdp()` takes `TMS9918 *`.
- `UInt64` was added to **both** copies of `msx_types.h`
  (`include/msx_types.h` — the one the Makefile uses — and the stale
  duplicate `src/include/msx_types.h`). Both files are now identical; do not
  edit only one of them again.

Semantics implemented (all from openMSX `SpriteChecker.cc` /
`SpriteConverter.hh` and BlueberryMSX `SpriteLine.h`):

- Mode gate: `base = ((R0 & 0x0E) << 1) | ((R1 & 0x08) >> 2) |
  ((R1 & 0x10) >> 4)`, sprites drawn only when `getSpriteMode(base)` != 0,
  i.e. bases `0x00`, `0x02`, `0x04`, `0x06`. **Per explicit user decision we
  follow openMSX exactly, so there are no sprites in TEXT1/TEXT2 or in base
  `0x03` (SCREEN 3), even though real TMS9918 hardware does show sprites in
  text modes.** On a TMS9918 only bases 0-3 are reachable, so in practice
  SCREEN 1 and SCREEN 2 get sprites.
- Sprites need `R1.6` (display on) and `!(R8 & 0x02)`.
- Sprite line: `row = (line - 1 - attr[0]) & 0xFF`, so a sprite attribute Y of
  0 starts at display line 1 (attribute Y is one less than the top line).
- Sprite X: `x = attr[1] - 32 + ((attr[3] >> 2) & 0x20)` for early clock;
  screen X wrap is handled by clipping to the 256-pixel line.
- Size `R1.1` 8x16, magnification `R1.0` (pixel doubled); pattern number is
  masked with `0xFC` when 16x16.
- Pattern fetch: `pat_ba = (R6 & 0x07) << 11` — **note this is `<< 11`, so
  R6=1 is `0x0800`, not `0x2000`**; attributes come from
  `attr_ba = ((R5 & 0x7F) << 7) + index * 4` with a 14-bit mask.
- A 16x16 sprite is assembled from **four** patterns: `n` = top left,
  `n+1` = bottom left, `n+2` = top right, `n+3` = bottom right. Left byte goes
  into the high 8 bits (`patternPtr[index] << 24` in openMSX, whose bit 31 is
  the leftmost pixel), right byte 16 bytes further into the generator.
- Max 4 sprites per line on MSX1; list terminates at Y = 208; the **lowest**
  index wins (sprites are drawn back-to-front, like openMSX's
  `std::views::reverse(visibleSprites)`).
- Colour 0 is transparent but **still participates in collision detection**
  (MSX1 behaviour).
- S#0: bit 7 = 1, bit 6 = 5S flag (sticky), bit 5 = collision, bits 4-0 =
  index of the 5th sprite in the line's list. `no 5th sprite -> S#0 bits 0-4
  = number of sprites in the list`, exactly as openMSX does.

Host test `host-test/render_sprite_test.c` (40 checks, all passing):

```sh
cd /home/opencode/MSX/BlueberryMSX-BareMetal/host-test
gcc -O1 -Wall -Wextra -Wno-unused-parameter -Wno-unused-const-variable \
    -I../include -I../src/chips/vdp \
    -o render_sprite_test render_sprite_test.c ../src/chips/vdp/tms9918.c
./render_sprite_test     # RESULT: PASS (0 failures)
```

Regression suite — all ten exit 0 after the PSG work (2026-10-06):
`harness` (4000 frames), `psg_test`, `io_decode_test`, `render_sprite_test`,
`render_g2_test`, `overlay_test`, `ui_queue_test`, `hid_keydiff_test`,
`framebuffer_blit_test`, `frame_pacer_test`. Build commands are in section 9;
the harness and `io_decode_test` need `-I../include` **and** `-I../src/include`,
and both now link `../src/chips/sound/psg.c`.

Known sprite gaps: only sprite mode 1 is decoded (GRAPHIC2's extra sprite
planes and SCREEN 5/7/8 are not implemented), there is no per-line early-clock
clash emulation beyond the ±32 px attribute offset, and `render_screen1()`
in `tms9918.c` is still dead code (pre-existing `-Wunused-function`
warning).

### 2. PSG audio — implemented, host-verified, HDMI path only

The user asked for PSG output to **both HDMI and the analogue jack via I2S**.
On a Raspberry Pi 3 that combination is not reachable with one Circle device:
`CHDMISoundBaseDevice` is the HDMI/S-PDIF DMA device, while `CI2SSoundBaseDevice`
drives GPIO21/GPIO22 (PCM clock/data) for an *external* DAC and has no
connection to the HDMI block; `CPWMSoundBaseDevice` is the PWM path. The
implemented path is therefore `CHDMISoundBaseDevice` — **HDMI only**. Analogue
output needs either a verified PWM wiring for the 3.5 mm jack or an external
I2S DAC; that is still open.

#### Core: `src/chips/sound/psg.{h,c}`

A complete AY-3-8910/YM2149 model, semantics copied from
`BlueberryMSX/msx2pp/openMSX/src/sound/AY8910.cc`:

- one emulation tick = 16 master clocks, `MSX_PSG_MASTER_CLOCK = 3579545`
  (so 223721.5625 ticks/s);
- three square-wave channels, half period `max(1, fine | (coarse & 0x0F) << 8)`
  ticks, i.e. `f = clock / (32 * period)`;
- one shared noise generator, period `2 * max(1, R6 & 0x1F)` ticks, 17-bit
  Galois LFSR `r = (r >> 1) ^ ((r & 1) << 13) ^ ((r & 1) << 16)`, seeded to 1;
- one shared 32-step logarithmic envelope, step period
  `EFINE + 256 * ECOARSE` ticks, all 32 shapes (continue/attack/alternate/
  hold), selected when R8-R10 bit 4 is set;
- mixer rule `out = (toneOut | !toneEnable) & (noiseOut | !noiseEnable)` per
  channel, summed and clamped to `Int16`, centred (`±volume` per voice, so a
  50 %-duty tone averages 0 — but an R7-held voice sits at `+volume`, see the
  DC blocker below);
- volume table `2^((v-15)/2)` (3 dB per step — the law openMSX, blueMSX and
  FluBBa all implement), scaled to 1/3 so three channels fit `Int16`:
  peak = 10922, `v = 0` silent;
- register read masks R1 `0x0F`, R6 `0x1F`, R13 `0x0F`, out-of-range registers
  read `0xFF` and ignore writes, `0xA0`/`0xA1` read as `0xFF`.

`psg_render(psg, out, nSamples, nMasterClocks)` carries the leftover master
clocks in `clock_rem`, so a non-integer number of ticks per sample does not
drift, and clamps `nMasterClocks` to `0xFFFF` per call (the app never passes
more than one video frame).

#### Wiring

- `src/core/msx.c`: `0xA0` latches the register, `0xA1` writes it, `0xA2` reads
  it; `0xFF` on the A0/A1 *read* path (both are write-only). The PSG is created
  in `msx_create()`, destroyed in `msx_destroy()`, and exposed through
  `msx_psg_render()`. Counters `g_psg_writes`, `g_psg_last_reg`,
  `g_psg_last_val` are for the log only.
- `include/msx.h`: `MSX_PSG_MASTER_CLOCK`, `MSX_PSG_CLOCKS_PER_FRAME` (59659),
  `msx_psg_render()` and the counters.
- `src/app/sound.{h,cpp}`: `CMsxSound` wraps `CHDMISoundBaseDevice` in DMA
  mode, 48000 Hz, `CHUNK_SIZE = 384 * 10`, `SoundFormatSigned16`/2 channels,
  `MSX_SOUND_QUEUE_MSECS = 100`. One emulated video frame is exactly
  `48000 / 60 = 800` stereo frames. `Start()` fills the **whole** queue with
  silence in video-frame sized chunks before starting the DMA engine, so the
  emulator warm-up cannot underrun it. `PushFrame()` renders mono, then runs
  the output conditioning chain — the openMSX DC-removal filter
  (`y = x - x[-1] + R*y[-1]`, R = 511/512 ≈ 14 Hz; needed because R7-held
  voices output pure DC, verified by `host-test/dc_test.c`) followed by
  blueMSX R3's 1-pole LPF (fc ≈ 8.4 kHz) — then duplicates
  it to both channels and writes it without ever blocking: a short write is
  counted as dropped frames.
- PSG time follows the real frame duration: `CTimer::GetClockTicks()` (1 MHz)
  delta between pushes is converted to master clocks, falling back to
  `MSX_PSG_CLOCKS_PER_FRAME` when the gap is `< 4 ms` or `> 100 ms` (boot,
  reset, returning from the menu). `R800` has no cycle counter, so wall-clock
  time is the only timing source available.
- `src/app/kernel.cpp`: `m_pSound` is created and started in stage 7b, and
  `PushSound()` is called from the task loop after `msx_step_frame()`.
- `src/app/Makefile`: `sound.o` and `psg.o`; the link now needs
  `$(CIRCLEHOME)/lib/sound/libsound.a` for `CHDMISoundBaseDevice` and
  `CSoundBaseDevice::AllocateQueue()/SetWriteFormat()`.
- Serial log: `Stage 7b: sound device started (sndhdmi, 48000 Hz)` and, once
  per 100 frames, `PSG: writes=... ui_events=... peak=... dropped=...`.

#### Host verification

- `host-test/psg_test.c` — **53 checks, all passing**: tone frequency
  (3496 measured rising edges vs 3496 expected for period 16), period-0
  clamping, the full volume table (15 = 10922, 13 = 5461 = half,
  11 = 2731 = quarter, 8 = 965 — 3 dB/step), the
  mixer rule, noise amplitude and the exact LFSR recurrence, envelope decay /
  attack / R8-bit-4 gating, register read masks, I/O port direction (R14/R15
  read the pulled-up pins `0xFF` while R7 says input, echo the latch when
  output — the Knightmare joystick fix, see below), clock-remainder carry,
  int16 saturation and reset.
- `host-test/io_decode_test.c` — extended with the PSG port protocol through
  the real Z80 bus callbacks, including the A8-A15 alias forms (`0x12A0`,
  `0x12A1`) and a mixer round trip that must render full-scale samples.
- `host-test/harness.c` — `argv[6]=1` renders 800 PSG samples per frame and
  reports `[PSG]`/`[PSG-summary]` lines. Run over 4000 frames of the real
  C-BIOS + Knightmare boot (exit 0):

      [PSG-summary] frames_with_audio(peak>64)=378/4000  writes=77540
      [PSG-summary] max volume A/B/C = 11/0/12 (15 = full)
      [PSG-summary] final mixer R7=B8  volumes R8/R9/R10=00/00/00
      R7 histogram: B8 = 3858 frames, 98 = 128 frames, 00 = 14 frames

  This proves the port decode, the core and the renderer work end to end
  against a real ROM: the ROM writes the PSG ~20 times per frame. It also
  explains why a hardware test may be quiet: for 3858 of 4000 frames the ROM
  holds R7 = `0xB8`, i.e. **all three tone channels disabled** with the PSG I/O
  port A switched to input, and R8/R9/R10 = 0. With a tone channel disabled the
  AY forces that channel's output to 1, so the mix bit stays 1 and the channel
  emits a constant DC level instead of a tone - exactly what real hardware
  would do, and it is why the 378 "loud" frames are mostly DC bursts rather
  than audible music. Whether the ROM reaches its music routine at all is
  entangled with the still-open "solid blue screen" boot issue.

#### Open items

- Analogue (3.5 mm) output: not implemented; needs a PWM or external-I2S-DAC
  decision.
- `PushFrame()` is only called for emulated frames, so the queue drains to
  silence while the overlay menu is open or a single step is executed.
- No hardware run yet: expect to hear nothing until the boot issue is fixed or
  a ROM/game that actually plays sound is booted.

### 3. Overlay ROM selector — implemented

Controls: `ALT+F11` opens/closes the menu, `UP`/`DOWN` move the cursor,
`ENTER` boots the highlighted cartridge, `ESC` closes, `ALT+F12` reboots. The
emulator is frozen while the menu is open, so the guest never sees the
navigation keys and the menu can never race a frame.

Files:

- `src/app/overlay.{h,cpp}` — pure drawing, no state: `Overlay_Init()` caches
  the framebuffer geometry, `Overlay_Draw(nSelected)` paints the box, and
  `Overlay_CartName()` supplies the labels. It scales the MSX 8x8 font by
  `height / 300` (min 1x), works for 16-bit RGB565 and 32-bit XRGB8888
  targets, and clips everything to the target. The box is centred and its
  height is `9 + OVERLAY_CART_COUNT` glyph cells.
- `src/app/ui_queue.h` — single-producer/single-consumer byte ring (USB IRQ
  produces, MSX task consumes), header-only so it is host testable, like
  `frame_pacer.h`. A full queue drops the event.
- `src/app/vdpblit.{h,cpp}` — new `VDPBlit_GetTarget()` (hands the overlay the
  cached framebuffer geometry) and `VDPBlit_Redraw()` (re-blits the last
  rendered MSX frame after the menu has drawn over it).
- `src/app/kernel.{h,cpp}` — `enum TCartId`, `enum TUiKey`, `PushUiKey()` /
  `PopUiKey()`, overlay open/selection state, and the cart loader.
- `src/app/msx_task.cpp` — `ServiceUiQueue()` drains the queue in task context
  and is what actually reboots or draws; the task loop skips emulation while
  the menu is open.

`CKernel::KeyStatusHandlerRaw()` (USB IRQ) recognises `ALT+F11` / `ALT+F12`
(HID usages `0x44` / `0x45`, `ALT` = `1 << 2`) before the MSX mapping and
pushes them to the queue; while the menu is open it also captures
`UP`/`DOWN`/`ENTER`/`ESC` and swallows them so they never reach the PPI
matrix. Nothing in that path touches the screen, the scheduler or ROM state.

### HID keyboard state: usage-based diff (hardware bug, fixed)

The first hardware test of the overlay exposed a real input bug: **key presses
were often ignored** in a game (hold left, press right, the character stalled).
Cause: the handler diffed the HID report **per slot** (`RawKeys[i] !=
PrevKeys[i]`), but a USB keyboard repacks its six-slot key array in scan order,
so slot indices are not stable. Hold left, press right, and the array goes
`{LEFT}` -> `{RIGHT, LEFT}`: slot 0 changed, so the handler released LEFT (which
was still held) and pressed RIGHT; when right was released the array went back
to `{LEFT}` and LEFT was released again. The guest saw left/right chatter and
lost the real press.

Fix: `src/app/hid_keydiff.h` diffs two reports **by usage code**, so array order
is irrelevant, and reports only changes (at most 12 per report, so the IRQ
handler stays short). `m_aKeyGuest[256]` records what is currently asserted in
the PPI matrix; releases are emitted before presses so a chord swap cannot leave
a key stuck.

Two related fixes in the same handler:

- **Auto-repeat filter** for the six UI keys (`UI_REPEAT_HOLD_US` /
  `UI_REPEAT_GAP_US` in `kernel.cpp`): a press that arrives within 60 ms of
  releasing a key that had been held for more than 400 ms is the keyboard
  repeating itself. Without it, a self-repeating keyboard toggles the menu once
  per repeat (flicker). A fast human re-press still gets through.
- **Menu key steal**: while the menu is open, a navigation key the guest already
  held is released, so it cannot stay stuck for as long as it is held.

Host test: `host-test/hid_keydiff_test.c` (27 checks) reproduces the exact
re-pack sequences, including the reported left/right case, slot swaps of held
keys, rotating permutations of three held keys, a full six-key array, sparse
reports and a duplicated usage.

Cartridge switching (the chosen design — reload, no hot swap):
`msx_load_cart(machine, nCart)` loads `msxdiag_rom`,
clears slot 1 subslot 0 and copies the 32K image into `0x4000` and `0x8000`.
`CKernel::m_nCurrentCart` remembers the selection; `DoReset()` recreates the
machine and calls `msx_load_cbios()` + `msx_load_cart()`. `ENTER` sets the
cart and calls `RequestReset()`, so booting a new ROM and rebooting the
current one share one path. `DoReset()` now also re-arms the `diag_log`
bridge, which the old reset path silently dropped.

`src/app/Makefile` links `overlay.o`.

Host tests (all passing):

```sh
cd /home/opencode/MSX/BlueberryMSX-BareMetal/host-test
# overlay menu drawing (28 checks), links overlay.cpp against stub framebuffer
# accessors so no hardware is needed:
g++ -O1 -Wall -Wextra -I../../BlueberryMSX/circle/include -I../src/app \
    -I../src/chips/vdp -o overlay_test overlay_test.cpp ../src/app/overlay.cpp
./overlay_test
# IRQ-safe key queue (20 checks):
gcc -O1 -Wall -Wextra -I../src/app -o ui_queue_test ui_queue_test.c
./ui_queue_test
# HID key diff (27 checks):
gcc -O1 -Wall -Wextra -I../src/app -o hid_keydiff_test hid_keydiff_test.c
./hid_keydiff_test
```

Not yet verified: real hardware behaviour of the hotkeys, the menu's
appearance at the Pi's actual resolution, and booting Knightmare. The serial
log has not been re-read since the overlay landed.

### USB host: the two hangs, and why NO_BUSY_WAIT is the wrong fix

1. `CUSBHCIDevice::Initialize(TRUE)` (the default `bScanDevices = TRUE`)
   deadlocked with no output after `Stage 4c`. Fix: `Initialize(FALSE)` and
   discover devices later from task level.

2. Scanning from the task loop with the stock `libusb.a` enumerated the whole
   device tree in ~1.9 s but starved the MSX task (blank display, no `CKR`
   traces, no `frame=` heartbeat), because `SubmitBlockingRequest` →
   `TransferStage` spins on `while (m_bWaiting[nWaitBlock])` in
   `BlueberryMSX/circle/lib/usb/dwhcidevice.cpp:735` with **no timeout** and no
   yield; only the USB IRQ completion routine clears the flag.

The obvious fix — rebuilding the library with `NO_BUSY_WAIT` — is **wrong for
this project** and must not be used:

- With `NO_BUSY_WAIT` the wait loop calls `CScheduler::Get()->Yield()`, but the
  first control transfer of the scan then never completes, so
  `UpdatePlugAndPlay()` never returns at all: the log shows `USB poll 1 start`
  and no `done`, with no `usbdev` line after it.
- The MSX task is the only other task, so every yield runs another full frame
  and the root-port transaction never gets a clean window.

Working configuration (current source):

- `libusb.a` is built **plain**, i.e. *without* `NO_BUSY_WAIT`
  (`cd BlueberryMSX/circle/lib/usb && make clean && make`). Verify with
  `arm-none-eabi-ar x libusb.a dwhcidevice.o && arm-none-eabi-nm -C dwhcidevice.o | grep CScheduler`
  (must print nothing) and `arm-none-eabi-nm -C libusb.a | grep CMutex`
  (must print nothing — the DWHCI locks are IRQ-context `CSpinLock`s, and
  `CGenericLock` in `circle/include/circle/genericlock.h` would turn them into
  scheduler `CMutex`es when `NO_BUSY_WAIT` is defined globally).
- `CKernel::Run()` scans **before** `new CMsxTask(this)` (stages 12/13/14),
  because nothing can be starved while the emulator task does not exist yet.
  This also matches the timing of the one call site that always worked
  (~1.5 s after boot, i.e. after the VDP/machine/ROM stages).
- The idle loop keeps polling `UpdatePlugAndPlay()` every 30 yields for
  hot-plug, and calls `UpdateUSB()` to (re)acquire `ukbd1`.

`src/app/kernel.h` holds `CUSBHCIDevice *m_pUSBController` (a pointer, created
lazily in `Initialize` after the timer is up). `src/app/Makefile` links
`libusb.a` then `libinput.a` before `libcircle.a`; `libinput.a` is required or
`libusb.a` fails to link (`CKeyboardBehaviour`, `CMouseDevice`).

### USB keyboard → MSX PPI

- `CKernel::UpdateUSB()` acquires `ukbd1` from the device name service and calls
  `RegisterKeyStatusHandlerRaw(KeyStatusHandlerRaw, FALSE, this)` (the `Ex`
  variant passes `CKernel *` as the argument).
- `CKernel::KeyStatusHandlerRaw()` runs in USB IRQ context. It only writes the
  PPI matrix through `msx_ppi_set_ec()` (single-byte stores, no allocation).
- `HidKeyToEC()` maps USB HID usage codes to `MSX_EC_*`. Unmapped keys are
  ignored; a Japanese-layout key maps to `MSX_EC_JIKKOU`/`MSX_EC_TORIKE`.
- The HID report is diffed per slot, so up to six simultaneous keys and
  modifier transitions are handled. `MSX_EC_LSHIFT`/`MSX_EC_RSHIFT` share one
  matrix bit, which is why the modifier is reduced to a single EC code before
  being applied.
- `msx_ppi_set_ec()` is implemented in `src/core/msx.c`; `keyState` is
  active-low (`0` = pressed).

### Knightmare keyboard regression: PSG R14 joystick read (fixed)

Report: keyboard works in MSX Diag but not in Knightmare "anymore" — the
regression arrived with the PSG session. Root cause, from Knightmare's own
input routine (`host-test/km.asm`, `sub_44DF`):

```text
44DF: LD E,8Fh / LD A,0Fh / CALL 00093h   ; WRTPSG(15, 8Fh)
44E6: LD A,0Eh / DI / CALL 00096h / EI     ; RDPSG(14) = joystick port 1
44ED: CPL / AND 3Fh / PUSH AF              ; 6 input bits, active low
      ... rows 7/8 keyboard via SNSMAT ...
4515: POP BC / OR B / RET                  ; joystick OR keyboard
```

Before the PSG existed, `IN A2` was undecoded and returned `0xFF` → `CPL` →
`00` = no joystick input. After the PSG landed, `psg_read()` returned the
register latch: nobody ever writes R14, so it stayed at its power-on `0x00`
→ `CPL` → `3F` = **up+down+left+right+trigger A+trigger B permanently
pressed**, OR'd into the input word every frame. The keyboard could not
change a word that was already all-ones, so keys did nothing.

Fix (`src/chips/sound/psg.c`, `psg_read`): R14/R15 are I/O ports. While the
R7 direction bit says input (bit6 port A, bit7 port B — C-BIOS and the game
both program R7=`B8`, port A = input), the read returns the external pins,
pulled up to `0xFF` with nothing attached (same as openMSX's
`periphery.readA()`). With the direction bit set the latch reads back, like
the real chip.

Verification (host-side, all exit 0):

- `psg_test` 45 → **53 checks PASS**, including the exact Knightmare
  sequence (R7=`B8`, write R15=`8F`, read R14 → must be `FF`).
- New **argv[7] input-injection mode** in `host-test/harness.c`
  (`in_phases[]` + `in_report()`): presses RETURN, SPACE, UP, DOWN, LEFT,
  RIGHT, A, ESC, F1 one at a time and reports at each phase end:
  - guest-visible matrix probed through the real bus: `row7=7F` (RETURN),
    `row8=FE/DF/BF/EF/7F` (SPACE/UP/DOWN/LEFT/RIGHT), `row7=FB` (ESC);
  - `PSG R14=FF R15=8F R7=B8` in every phase;
  - trace now prints read values: `[IO-R] port=A2 val=FF` (was `00`);
  - the game reacts — `E052` (its decoded input word) becomes
    `01/02/04/08/10` for UP/DOWN/LEFT/RIGHT/SPACE, the name-table hash
    changes on RETURN/SPACE (title → game), cooldown returns to idle.
- Full ten-test regression + 4000-frame harness (plain and audio mode) all
  exit 0. Current `msx.img` = 538,680 bytes, md5
  `fe7c933808fcc02caa208f76e306e121`, deployed to
  `/data/Projects/MSX/BlueberryMSX/msx.img`.

### Overlay flicker and sluggish menu keys: UART flooding + blind repaints

Hardware report (image 521,800, md5 `79d7d84a...`): gameplay keys fine, but the
menu "flickers" and arrows/ENTER need several presses. Evidence gathered from
`/home/opencode/MSX/serial-out/msx-boot.log`:

- The log is **character-shredded** (`00:00:01.37 Apsx: UI: overlay App: Stage 8:
  msx_create startage 9: msx_creat...`). Two tasks were writing the same UART
  concurrently.
- 97,645 `USB poll` lines across the concatenated log (~160/s): the primary task
  logged two lines every 30 scheduler yields.
- The menu session shows exactly **one** `overlay opened` and 50 `overlay held`
  lines spanning ~67 s, so there was no open/close toggle storm.
- `frames=1034` never moved while the menu was open, proving the emulator freeze
  works and the emulator is **not** overdrawing the menu.
- Only one `booting selected cart` line, i.e. ENTER did eventually get through.

Root causes and the fixes now in the tree:

1. **Non-task-safe logging starved the MSX task.** `CLogger`/`CSerialDevice` are
   not reentrant and `CSerialDevice::Write` busy-waits on the shared TX FIFO, so
   two writers make each wait for the other's bytes. `CKernel::LogLine` and the
   new `CKernel::WriteLog (prefix, fmt, ...)` (`kernel.cpp`) take a task-level
   spin lock that yields while held; all 26 `m_Logger.Write ("App", ...)` calls
   now go through `WriteLog`.
2. **USB plug-and-play logged far too much.** The idle-loop pass is now rate
   limited to every 250 ms via `CTimer::GetClockTicks ()` (documented 1 MHz) and
   logs nothing (`USB_POLL_INTERVAL_US` in `kernel.h`). `strings msx.img | grep
   "USB poll"` returns nothing.
3. **The menu was repainted ~47 times per second.** While the menu is open the
   emulator is frozen, so the pixels underneath are static. `msx_task.cpp` keeps
   `nDrawnSel` and calls `Overlay_Draw` only when the selection changes, when the
   menu (re)opens (`nDrawnSel = OVERLAY_NOT_DRAWN`), and after a reset, because
   `DoReset` repaints the whole screen.
4. **`FillRect` in `overlay.cpp` now fills rows with runs of stores** instead of
   one bounds-checked `PutPixel` call per pixel (~65k calls per repaint before).
5. Diagnostics: `UI: overlay held, frames=N, ui_events=M, sel=S` once per second,
   with `CKernel::GetUiEvents ()` counting events drained by the task. If keys
   still need multiple presses, compare `ui_events` growth against presses made.

Image built and copied to `/data/Projects/MSX/BlueberryMSX/msx.img`: 521,848
bytes, md5 `3c92e935db298bca8ffebec4027caee0`. Host regressions all pass:
`render_sprite_test` (40), `overlay_test` (28), `ui_queue_test` (20),
`hid_keydiff_test` (27), `render_g2_test`, `io_decode_test`,
`framebuffer_blit_test`, `frame_pacer_test`, and the 4000-frame harness.

### Known open issues

- ~~Hardware verification of the pre-task image pending.~~ Resolved: the log
  session compiled `Oct  6 2026 04:07:06` reaches `Stage 15: Entering scheduler
  loop`, registers the keyboard (`USB keyboard ready`) and boots gameplay. USB
  keyboard input into the MSX PPI is hardware-confirmed working.
- A scan that runs later from the idle loop still busy-waits and can stall the
  emulator for up to ~2 s when a device actually changes (hot-plug). Tolerable
  for now.
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
    -I../src/chips/z80 -I../src/chips/vdp -I../src/chips/sound -I../src/app \
    -x c -o harness harness.c \
    ../src/core/msx.c ../src/chips/vdp/tms9918.c ../src/chips/z80/R800.c \
    ../src/chips/sound/psg.c \
    ../src/app/cbios_roms.cpp ../src/app/knightmare_roms.cpp -lm
./harness 4000 0            # no audio
./harness 4000 0 -1 100 0 1 # argv[6]=1: also render/report PSG audio
```

The PSG and bus-decode host tests:

```sh
cd /home/opencode/MSX/BlueberryMSX-BareMetal/host-test
gcc -O1 -std=c11 -I../include -I../src/chips -I../src/chips/sound \
    -o psg_test psg_test.c ../src/chips/sound/psg.c
./psg_test                                            # 53 checks, RESULT: PASS
gcc -O1 -std=c11 -I../include -I../src/chips -I../src/chips/sound \
    -o dc_test dc_test.c ../src/chips/sound/psg.c -lm
./dc_test                                             # DC means + blocker effect
gcc -O1 -I../include -I../src/include -I../src/chips \
    -I../src/chips/z80 -I../src/chips/vdp -I../src/chips/sound \
    -o io_decode_test io_decode_test.c ../src/core/msx.c \
    ../src/chips/z80/R800.c ../src/chips/vdp/tms9918.c ../src/chips/sound/psg.c
./io_decode_test    # OTIR + VDP/PPI aliases + PSG port decode

gcc -O0 -g -std=gnu11 -I../include -I../src -I../src/core -I../src/chips \
    -I../src/chips/z80 -I../src/chips/vdp -I../src/chips/sound -I../src/app \
    -o megarom_bus_test megarom_bus_test.c ../src/core/msx.c \
    ../src/chips/vdp/tms9918.c ../src/chips/z80/R800.c ../src/chips/sound/psg.c -lm
./megarom_bus_test  # ASCII8 + Konami bank switch via bus callbacks (RESULT: PASS)
```

Note: `framebuffer_blit.h` and `frame_pacer.h` are header-only, so their tests
compile the `.c` alone with `-I../src/app` (no extra source file).

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
| `host-test/harness.c` | Diagnostic harness: VRAM scan, Z80 dump, IO trace (reads print `val=`), register dump, argv[6] PSG audio, argv[7] key-injection test |
| `host-test/render_sprite_test.c` | Sprite mode 1 regression test (40 checks) |
| `src/app/overlay.cpp` | ROM selection menu drawing (framebuffer + MSX font) |
| `src/app/ui_queue.h` | IRQ-safe single-producer key queue for UI hotkeys |
| `host-test/overlay_test.cpp` | Overlay drawing test (28 checks), stub framebuffer |
| `host-test/ui_queue_test.c` | Key queue test (20 checks) |
| `src/app/hid_keydiff.h` | Usage-based USB HID report diff (slot order independent) |
| `host-test/hid_keydiff_test.c` | HID key diff test (27 checks), includes the hardware bug |
| `src/chips/sound/psg.{h,c}` | AY-3-8910 PSG core (3 tone, noise LFSR, 32-step envelope, mixer) |
| `src/app/sound.{h,cpp}` | `CMsxSound`: `CHDMISoundBaseDevice` DMA queue, 48 kHz, 800 frames/video frame |
| `host-test/psg_test.c` | PSG core test (53 checks): pitch, volume table, mixer, noise, envelope, I/O port direction |
| `host-test/dc_test.c` | DC-offset probe: per-scenario output means (held voice = 100 % DC) and the openMSX-form DC blocker from `sound.cpp` applied to them |
| `msx2pp/openMSX/src/sound/AY8910.cc` | PSG reference: tick rate, tone/noise periods, envelope, mixer rule |
| `/home/opencode/MSX/openMSX/src/video/SpriteChecker.cc` | Sprite list, 4-per-line limit, 5S/collision status (`calculatePatternNP`, `checkSprites1`) |
| `/home/opencode/MSX/openMSX/src/video/SpriteConverter.hh` | `drawMode1` overdraw order, pattern bit order (bit 31 = leftmost) |
| `/home/opencode/MSX/openMSX/src/video/DisplayMode.hh` | `getSpriteMode()`, mode constants |
| `/home/opencode/MSX/BlueberryMSX/BlueberryMSX-2.0plus/Src/VideoChips/SpriteLine.h` | BlueberryMSX reference: early clock, Y=208 terminator, 4-sprite MSX1 limit |
| `Docs/cbios-0.29a/roms/` | C-BIOS ROMs used by the harness |
| `msx2pp/openMSX/src/video/DisplayMode.hh` | Mode decode (line 65), mode constants (line 27) |
| `msx2pp/openMSX/src/video/VDP.cc` | `updateNameBase` 1460, `updateColorBase` 1488, `updatePatternBase` 1515, display-enable 524 |
| `msx2pp/openMSX/src/video/VDPVRAM.hh` | `setMask` 168, read address 234 |
| `msx2pp/openMSX/src/video/CharacterConverter.cc` | `renderGraphic2` 275 |

## 11. Environment notes

* No pre-built openMSX binary exists in the tree (`openMSX/build` contains only
  3rdparty makefile helpers), so openMSX cannot be run headless for ground truth.
  All comparison must be source-level or against known-good VRAM dumps.
* Z80 disassembler available at `/usr/local/bin/z80dasm`.
* Toolchain: `arm-none-eabi-gcc` 16.1.0, `make` 4.4.1, `python3` 3.14. Do not
  reinstall.
