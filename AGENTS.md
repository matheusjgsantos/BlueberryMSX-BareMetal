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
  seam, MegaROM mapper module) and is fast-forwarded from the feature branch
  after host tests and, for hardware-facing steps, hardware verification.
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
