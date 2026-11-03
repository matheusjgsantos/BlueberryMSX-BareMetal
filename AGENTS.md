# BlueberryMSX-BareMetal Modularization Rules

This project is being extended from a working MSX1 bare-metal emulator into a
reusable multi-machine emulation platform. The parent rules in
`/home/opencode/MSX/AGENTS.md` and `/home/opencode/AGENTS.md` remain mandatory.

## Branches (updated 2026-11-01)

- `stable` is the known-good backup line: the pre-modularization MSX1 state
  (commit `10d9a83`, the v1.0 release line). Treat it as read-only rollback
  material; do not commit modularization work to it.
- `main` is the integration line. It currently carries every verified
  modularization step (host-callback seam, bus/diagnostic split, CPU/clock
  seam, MegaROM mapper module, video/audio/input device seams, memory profile
  and memory ops, and the first machine profiles MSX1 + ColecoVision) and is
  fast-forwarded from the feature branch after host tests and, for
  hardware-facing steps, hardware verification.
- `feature/modular-emulation-architecture` is kept as a checkpoint of the
  first four verified extractions (tip `d2e887e`, fully contained in `main`).
  Do not delete or rewrite it. New work branches from `main`.
- Preserve the current v1.0 behavior and release artifacts. Every refactoring
  step must leave a buildable MSX1 fallback.
- Before fast-forwarding `main`, run the existing host tests and the
  appropriate Circle build; hardware-facing changes require hardware
  verification or an explicit note that hardware verification is still pending.

## Long-term goals

1. Keep the current Circle/Raspberry Pi application as the platform adapter.
2. Extract a platform-neutral emulation core without discarding working code.
3. Support machine profiles and composable devices for MSX, ColecoVision,
   ZX Spectrum, Amstrad CPC, MSX2, MSX2+, Turbo-R, and future systems.
4. Permit CPU-family substitution. Z80-family machines may share the Z80/R800
   interface; Game Boy requires a separate LR35902-compatible CPU core.
5. Make video, audio, input, storage, networking, clock, and display services
   explicit host interfaces.
6. Keep deterministic host tests and enable optional native and WASM builds.

## Required implementation strategy

Use an incremental strangler refactor. Do not rewrite the emulator or move all
code into WASM in one step.

### Phase 1: Baseline and dependency map

- Record the current build commands, host tests, release checksums, and known
  hardware results.
- Classify existing code as CPU, memory/I/O bus, device emulation, machine
  logic, Circle/platform service, or diagnostic/test code.
- Identify dependencies before moving files or changing ownership.

### Phase 2: Stable seams

Introduce the smallest useful interfaces around existing implementations:

- CPU execution and state
- Memory bus and I/O bus
- Clock/event scheduler
- Video output
- Audio output
- Input
- Storage/cartridge/media
- Optional network service

The existing MSX1 implementation is the first implementation of each seam.
Avoid speculative abstractions and preserve C/C++ compatibility with the
current core where practical.

### Phase 3: Portable core and machine profiles

- Move code behind the seams only after MSX1 behavior remains unchanged.
- Represent each machine using a profile/device graph: CPU, memory map, I/O
  map, video, audio, timers, interrupts, firmware, and expansion devices.
- Add host builds and deterministic tests for the portable code.
- Add new machines one at a time, starting with systems closest to the current
  Z80-oriented architecture.

### Phase 4: Optional WASM target

First make the core portable and expose a small stable C ABI. Then compile the
same core natively for Circle and host tests and optionally to WASM for browser
tools, replay, inspection, and cross-platform validation. Do not add a WASM
runtime to the Pi image until memory use, performance, startup, persistence,
and debugging costs have been measured and accepted.

## Non-regression requirements

- Keep CPU pacing time-driven; never replace it with a fixed instruction count.
- Preserve `CPU_ENABLE_M1`, `MSX_FRAME_TICKS`, mapper behavior, cartridge header
  handling, bank-aware dumps, and the working cart-write latch sequence.
- Keep Circle `RASPPI` builds isolated and rebuild shared Circle libraries when
  switching between Pi 3 and Pi 4 targets.
- Do not move runtime data onto the boot partition.
- Do not alter release directories or publish images from build intermediates.
- Keep the authoritative reference implementation at
  `../BlueberryMSX/BlueberryMSX-2.0plus/Src` in mind when comparing behavior.

## Machine profiles (2026-11-02)

- `include/msx_profile.h` / `src/core/msx_profile.c` hold machine descriptors
  (interrupt mode, memory backend, input backend, audio device, VDP ports).
  `msx_create_profile(id)` composes a machine; `msx_create()` is exactly
  `msx_create_profile(MSX_PROFILE_MSX1)`. MSX1 remains the default and the
  verified fallback.
- Memory routing is per-profile. MSX1 uses `msx_memory_ops_msx()`
  (`src/core/msx_memory_msx.c`, slots/mapper/RPMC). ColecoVision uses
  `msx_memory_ops_flat()` (`src/core/msx_memory_flat.c`) over
  `MSX_Machine.flat` with this map, which must not drift:
  `0x0000-0x1FFF` 8 KB BIOS ROM (read-only), `0x2000-0x5FFF` open bus
  (reads `0xFF`), `0x6000-0x7FFF` 1 KB RAM mirrored, `0x8000-0xFFFF` 32 KB
  cartridge window (read-only, image mirrored when power-of-two and < 32 KB).
  Storage offsets: BIOS `0x0000`, RAM `0x2000`, cart `0x10000`.
- ColecoVision I/O decode lives in `src/core/msx.c` as machine policy:
  `0x80-0x9F` write = keypad mode, `0xC0-0xDF` write = joystick mode,
  `0xA0-0xBF` VDP (A0=0 data / A0=1 control, so `0xBE/0xBF`), `0xE0-0xFF`
  write = SN76489 serial data input (every address aliases the same chip),
  `0xE0-0xFF` read = pad 1 (A1=0) / pad 2 (A1=1). The controller adapter is
  `src/core/msx_input_coleco.c`.
- ColecoVision audio is a real SN76489AN behind `MSX_AudioOps`:
  `src/chips/sound/sn76489.{h,c}` (chip core, openMSX `SN76489.cc` model) and
  `src/core/msx_audio_sn76489.c` (adapter + sub-frame write replay). The
  profile picks it via `MSX_PROFILE_AUDIO_SN76489`; MSX1 keeps the AY adapter.
  Do not restore the pre-frame chip struct after the replay: the tone/noise
  phase and sampler remainder must carry across frames (otherwise every frame
  restarts the waveform -> 60 Hz phase step, audible roughness).
  Hardware verified 2026-11-03: Coleco audio is clean and the machine radio
  group works (user: "sounding perfectly now, and the menu is working").
- ColecoVision uses NMI frame interrupts. `machine_flat_read_io()` re-arms the
  edge-triggered R800 NMI (`msx_cpu_clear_nmi`) when the CPU reads the VDP
  status port; do not remove that or only the first frame interrupts.
- App selection: `msx.ini` `machine=colecovision` (or `coleco`) / `msx1`, and
  the overlay machine radio group (`OVERLAY_MACHINE_OPTIONS` rows:
  "(*) MACHINE: MSX1" / "( ) MACHINE: COLECOVISION"): Enter on an option
  selects that machine and requests a reset, it does not cycle. Adding a
  profile means adding it to `s_anMachineOptions` in `src/app/kernel.cpp`
  (the count must stay equal to `OVERLAY_MACHINE_OPTIONS`).
  Coleco BIOS is read from `BIOS/colecovision.rom` (fallback
  `BIOS/coleco.rom`); it is not in the repository. Coleco runs only a cartridge
  file (`ROM FROM FILE`, flat window); MSX DIAG/SLOTS and the RPMC bus are
  skipped for that profile.
- Deferred, do not pretend they work: full keypad/Super Action Controller
  protocol, MegaCart banking, and a Coleco-specific palette (MSX TMS9918
  palette is reused for bring-up). ColecoVision is otherwise closed out as of
  2026-11-03, with the image set above hardware verified.
- Next target (user decision 2026-11-03): MSX2, then ZX Spectrum, then
  Amstrad CPC. MSX2 is the first profile that needs a new video device
  (V9938: 128 KB VRAM, mode 7+ bitmap modes, hardware scroll, sprites, palette,
  VDP command engine) plus the MSX2 BIOS/BASIC ROM pair, the memory mapper and
  the RTC; all of it must land behind the existing seams so MSX1 and
  ColecoVision keep building and running.
- Host tests: `host-test/flat_memory_test.c`, `host-test/coleco_machine_test.c`,
  `host-test/sn76489_test.c` (run with the standard core source list in the
  README/progress log, which now includes `src/core/msx_audio_sn76489.c` and
  `src/chips/sound/sn76489.c`), and `host-test/overlay_test.cpp` (draws the
  menu into a stub framebuffer; 41 checks including the machine radio group).
  MSX1 regressions are the existing seam tests.

## Verification requirements

Each change must use the cheapest relevant checks first and then the real build:

1. Host unit/regression tests for portable logic.
2. Formatting, compile, or static checks if defined by the affected component.
3. The relevant Circle app build (`src/app`) with the correct `RASPPI`.
4. Hardware verification for boot, timing, video, audio, SD, GPIO, or physical
   cartridge changes; otherwise document why it is unavailable.

Never claim that a build or test works without running it. Rebuild stale host
test objects instead of trusting prebuilt objects.

## Empirical knowledge and Mem0

Valuable empirical information must be captured after every investigation,
hardware session, failed experiment, fix, or architectural decision. Do not
leave important findings only in chat or raw logs.

For each durable finding, store a concise Mem0 entry with:

- project: `BlueberryMSX-BareMetal`
- tags such as `architecture`, `hardware`, `fix`, `build`, `test`, `gotcha`, or
  `workflow`
- date and hardware/software version when relevant
- setup and exact command or configuration
- observation and expected behavior
- conclusion/root cause and fix
- verification result and related commit, test, log, or artifact path
- confidence level when the result is tentative

Store one to three focused facts rather than entire transcripts. Search Mem0
before starting related work. Update or delete stale memories instead of
creating contradictory duplicates. Keep raw logs, binaries, and full test
output in the repository or release artifacts; Mem0 should contain durable
summaries and pointers, not large files or secrets. Redact credentials and
personal data before storing anything.

Before completing a multi-step task, confirm that:

- the changed files were indexed;
- durable findings were stored in Mem0;
- the actual verification commands and results were recorded; and
- the branch and working-tree state are clear in the final report.
