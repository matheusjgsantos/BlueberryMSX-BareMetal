# Architecture Audit: Modular Emulation

Status: initial audit, 2026-10-29

This document records the starting point for modularization. It is intentionally
descriptive first; the existing MSX1 implementation remains the behavioral
reference while seams are introduced.

## Current build boundary

`src/app/Makefile` is the Circle/Raspberry Pi application boundary. It links
the application objects with Circle and its add-ons:

- Circle core, scheduler, filesystem/FAT, USB/input, and sound
- SDCard, Linux emulation, VCHIQ, and VCHIQ sound add-ons
- Application objects for kernel, task loop, UI, framebuffer, sound, BIOS and
  configuration
- Portable C objects for `src/core/msx.c`, `src/chips/z80/R800.c`,
  `src/chips/vdp/tms9918.c`, and `src/chips/sound/psg.c`

The Makefile already separates the portable C objects from Circle C++ objects,
which is a useful foundation for host and future WASM builds.

## Current dependency map

```text
Circle kernel / devices / FAT / USB / VCHIQ
                 |
       src/app/kernel.cpp
       - lifecycle and reset ownership
       - BIOS and ROM loading
       - configuration and physical cartridge bus
       - USB keyboard translation
       - logging and SD diagnostics
                 |
       src/app/msx_task.cpp
       - frame loop and time pacing
       - UI queue and overlay coordination
       - reset handoff between cores
       - frame/audio service calls
                 |
       include/msx.h + src/core/msx.c
       - MSX_Machine aggregate
       - slot/subslot memory and mapper dispatch
       - PPI keyboard matrix
       - Z80/R800 memory and I/O callbacks
       - frame stepping and synchronization hook
          |             |              |
      R800         TMS9918            PSG
  src/chips/z80  src/chips/vdp   src/chips/sound
```

Additional application adapters:

- `vdpblit.cpp`: converts TMS9918 output into the Circle framebuffer and owns
  frame-dump hooks.
- `sound.cpp`: converts PSG samples into Circle HDMI/VCHIQ audio, including
  queue management, wall-clock sample production, filtering, and telemetry.
- `msxbus.c`: physical RPMC GPIO bus implementation; `kernel.cpp` installs its
  callbacks into the machine.
- `biosrom.cpp`, `msxconfig.cpp`, `cartdump.h`: SD/configuration and cartridge
  policy currently called by the Circle kernel.
- `overlay.cpp`, `ui_queue.h`, `hid_keydiff.h`: Circle UI and input policy.

## Important existing seams

The following seams already exist and should be preserved rather than replaced:

1. `MSX_Machine` callback fields (`bus_read`, `bus_write`, `bus_read_io`,
   `bus_write_io`, and `diag_log`) keep the core testable without a GPIO link.
2. `msx_frame_render(void *)` is a weak core hook with a strong Circle
   framebuffer implementation in `vdpblit.cpp`.
3. `msx_psg_render()` produces samples independently of the Circle sound device.
4. `msx_step_frame(machine, frame_ticks)` accepts an explicit emulated-time
   budget and does not own wall-clock sleeping.
5. The app Makefile compiles the core/chip C sources separately from the C++
   Circle adapter.

These are the first modular interfaces. They need naming, ownership, and state
documentation before they need replacement.

## Coupling and risks

### `MSX_Machine` is both machine state and device wiring

`include/msx.h` combines CPU, VDP, PSG, PPI, slots, mapper state, physical-bus
callbacks, and diagnostics. It is a good compatibility structure but not yet a
general machine model. Do not split it in one change. First introduce opaque
accessors or a context wrapper while retaining the structure for the MSX1 path.

### `msx.c` contains MSX-specific policy

The core includes the MSX slot/subslot layout, PPI keyboard matrix, MSX port
decoding, mapper rules, and MegaFlashROM diagnostics. The CPU and chip code are
more reusable than the machine bus. Future profiles should own address maps and
device routing instead of copying `msx.c`.

### Circle ownership and core affinity are real constraints

`kernel.cpp` owns newlib allocation, filesystem operations, VCHIQ control, and
reset handoff. The emulation task runs on the other core and must not directly
perform blocking Circle operations. Any host-service interface must document
thread/IRQ/core affinity and whether it may block.

### Video and audio are already policy-heavy adapters

`vdpblit.cpp` and `sound.cpp` contain hardware-specific buffering and timing
work, not just output calls. Extract only narrow frame/audio sink interfaces;
do not move their queue algorithms into the portable core.

### Physical cartridge access is a device, not generic memory

The RPMC bus has GPIO timing, latch ordering, cache modes, diagnostics, and
hardware-specific failure modes. Keep it behind a cartridge/expansion device
interface. Do not expose Circle GPIO types to the emulation core.

## Recommended first implementation slice

The first code change should be a low-risk `EmulationHost`/service callback
boundary around the existing `MSX_Machine` callbacks and frame hooks:

- define a small C-compatible host callback table for memory/I/O expansion,
  diagnostics, frame notification, and optional audio/video notification;
- provide an MSX1 adapter that populates it from the current callbacks;
- keep all existing fields and entry points during the transition;
- add a host test that runs the core with a fake host and verifies callback
  routing;
- build the unchanged Circle MSX1 path afterward.

Do not begin by adding a WASM runtime, changing mapper code, or introducing a
large C++ class hierarchy. The first seam must be useful to both host tests and
Circle while preserving the current C ABI.

## Planned extraction order

1. Host callback/context boundary and ownership documentation.
2. CPU execution context and clock/event interface, retaining R800 behavior.
3. Memory and I/O bus routing separate from MSX slot policy.
4. Device interfaces for video, audio, input, storage, and expansion buses.
5. Machine profile description and MSX1 profile implementation.
6. Additional machine profiles, with regression tests per profile.
7. Native portable build and only then an optional WASM build.

## Baseline verification

Before and after each extraction, use the project-required checks:

- rebuild stale host tests from source;
- run timing, mapper, cart-dump, PSG, VDP, UI, and framebuffer tests that are
  relevant to the changed seam;
- build `src/app` with the matching Circle/RASPPI configuration;
- document hardware verification separately for changes affecting Pi devices.

The current hardware-proven invariants are recorded in the parent MSX
`AGENTS.md` and must not be weakened by this refactor.

## Progress log

- 2026-10-29: audit committed (`c264015`).
- 2026-10-29: host callback table added (`0cf3608`): `include/msx_host.h`,
  `msx_set_host_callbacks()`, `host-test/host_callbacks_test.c`.
- 2026-10-29: the Circle app now installs that table in `CKernel::Run()` and
  `CKernel::DoReset()` through `InstallHostCallbacks()`; `AttachMsxbus()` only
  performs slot routing. Host tests pass; Pi 3 and Pi 4 images built and
  packaged under `test-images/2026-10-29-hostcallbacks/` for hardware
  verification.
- 2026-11-01: those images failed on hardware (blank screen, white cursor,
  Pi 3A+). Root cause: they were linked against a mixed Pi 3/Pi 4 Circle
  archive set left over from an incomplete `RASPPI` switch, not the seam.
  Evidence: a clean `main` (v1.0 source) build with clean Pi 3 libraries is
  533,072 bytes, exactly the v1.0 size, while the shipped image was 540,752.
- 2026-11-01: seam lifetime split. The core forwards unclaimed I/O ports to
  `bus_read_io`/`bus_write_io` whenever those pointers are installed,
  independent of slot routing, so the bus transport must be installed only
  after `MsxbusBringUp()`. Added `msx_set_bus_callbacks()` (bus only,
  diagnostics untouched); `InstallHostCallbacks()` is diagnostic-only and
  `AttachMsxbus()` calls the new `InstallBusCallbacks()`. Host test extended:
  detaching the bus stops port forwarding and keeps the diagnostic budget.
- 2026-11-01: `CKernel::BootStatus()` draws `boot: ...` lines on the
  framebuffer until the first emulated frame, so a boot stall is visible
  without a UART. Clean Pi 3/Pi 4 branch images and a v1.0-source control are
  packaged under `test-images/2026-11-01-clean-build/` (hardware verification
  pending).
- 2026-11-01: `msx-pi3.img` from `2026-11-01-clean-build/` booted correctly on
  the Pi 3A+, confirming the blank screen was the mixed-target archive
  contamination and not the seam. The bus/diagnostic split and the `boot:`
  status lines are now hardware-proven on the boot path. Still open before a
  merge: the MSX1 regression checklist (cart/MegaROM, physical RPMC bus,
  reset, audio) and Pi 4 hardware verification.
