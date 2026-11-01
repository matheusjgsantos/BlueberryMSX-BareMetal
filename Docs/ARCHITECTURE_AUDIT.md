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
6. `include/msx_cpu.h` gives the machine one CPU handle for creation,
   single-instruction execution, the master-tick clock, the interrupt line,
   PC reads and destruction. `src/core/msx_cpu.c` is the current (R800) backend;
   `MSX_Machine.z80` remains only as a compatibility alias for the Circle app
   and older tests.
7. `src/core/msx_mapper.c` (`include/msx_mapper.h`) owns the MegaROM bank
   policy (is-mapped, window read, register write, AUTO guess) for one
   `MSX_SubSlot`. `src/core/msx.c` keeps address routing and the physical
   RPMC bus only, which is the piece a non-MSX memory map will replace.
8. `include/msx_video.h` is the video device seam (`read_io`, `write_io`,
   `sync_irq`, `irq_pending`, `destroy` + attach). `src/core/msx_video_tms9918.c`
   is the MSX1 adapter over `src/chips/vdp/tms9918.c`; `msx.c` no longer
   includes the chip header and `machine->vdp` is only a compatibility alias
   to `machine->video.dev` for the Circle renderer and old tests.
9. `include/msx_audio.h` is the audio device seam (`read_io`, `write_io`,
   `write_io_at`, `latched_register`, `log_reset`, `render`, `native`,
   `destroy` + attach). `src/core/msx_audio_psg.c` is the MSX1 adapter over
   `src/chips/sound/psg.c` and owns both the AY port protocol and the
   sub-frame write log; `msx.c` no longer includes `psg.h` and `machine->sound`
   is only a compatibility alias to `msx_audio_native()`. Frame pacing stays
    in the machine: it passes `frac16` (position in the frame) with each write.
10. `include/msx_input.h` is the input device seam (`read_io`, `write_io`,
    `set_key`, `native`, `destroy` + attach). `src/core/msx_input_ppi.c` owns
    the MSX1 PPI keyboard matrix and EC mapping; port A's primary-slot effect
    remains an explicit callback into the machine memory policy. `msx.c` no
    longer owns the matrix layout.

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
- 2026-11-01: `msx-pi4.img` from the same bundle (580,048 B) also boots and
  runs correctly on the Pi 4. Both targets of the branch are now hardware
  proven at boot; only the MSX1 regression checklist remains before merge.
- 2026-11-01: CPU/clock seam added: `include/msx_cpu.h`, `src/core/msx_cpu.c`.
  The machine now depends on an `MSX_CPU` handle (`msx_cpu_create/execute/
  get_time/set_irq/clear_irq/get_pc/native_handle`) instead of calling the
  R800 core directly: `msx_create()` builds it with
  `MSX_CPU_OPTION_M1`, `msx_step_frame()` paces it by master ticks and raises
  the IRQ, and `msx_set_bus_callbacks`/destruction are unchanged in behavior.
  `MSX_Machine.z80` stays as a compatibility alias to the native R800 handle
  for the Circle app and older tests. New `host-test/cpu_seam_test.c`: 5000
  instructions through the seam match direct R800 execution (PC and clock
  identical at every step checked) and the M1 option maps correctly; all
  existing host tests still pass.
- 2026-11-01: the CPU-seam images in `test-images/2026-11-01-cpu-seam/`
  (Pi 3 534544 B `c55e151d...`, Pi 4 580496 B `56550ac7...`) passed the
  MSX1 regression checklist on hardware (Pi 3A+ and Pi 4): C-BIOS BASIC and
  keyboard, 32 KB ROMs, Konami-SCC and ASCII8/16 MegaROMs, `ROM FROM FILE`
  vs physical slot, cart writes, reset, PSG audio, overlay/browser/F-keys
  all behave as in v1.0. No regression from replacing the direct R800 calls
  with the seam. The branch is mergeable; remaining work is further
  extraction (memory/I/O bus routing), not a fix.
- 2026-11-01: MegaROM mapper policy split out of the memory decoder.
  `include/msx_memory.h` now holds the slot storage and `MSX_MapperType`
  (ownership unchanged), and new `include/msx_mapper.h` +
  `src/core/msx_mapper.c` implement `msx_mapper_is_mapped/read/write/guess`;
  the CPU memory callbacks in `src/core/msx.c` only select the subslot, route
  the physical RPMC bus, and delegate ROM windows and bank registers
  (`msx.c` 853 -> 760 lines). Behavior preserved exactly (Konami fixed
  `0x4000`, Konami-SCC `0x5000-0xBFFF` decode with the SCC window ignored,
  ASCII8 registers, ASCII16 via the ASCII8 decode, bank masking, `0xC000+`
  reading `0xFF`, `LD (nn),A` guess with the openMSX bias). New
  `host-test/mapper_policy_test.c` covers all four mapper types plus the
  heuristic directly; konami/ascii8/megarom_bus/cartdump/io_decode and the CPU
  tests still pass. Images in `test-images/2026-11-01-mapper-module/`:
  Pi 3 534736 B, Pi 4 580688 B (+192 B each), hardware verification pending.
  Deliberately deferred: moving the slot array behind an `MSX_Memory` handle
  (needs app/test accessors and belongs with machine profiles) and splitting
  the I/O decode (belongs with the device interfaces).
- 2026-11-01: mapper-module images hardware-verified. `msx-pi3.img`
  (534736 B `b4d2dfdc...`) and `msx-pi4.img` (580688 B `f2359a86...`) from
  `test-images/2026-11-01-mapper-module/` pass the MSX1 regression checklist
  on the Pi 3A+ and Pi 4: C-BIOS BASIC/keyboard, 32 KB ROMs, Konami-SCC and
  ASCII8/16 MegaROMs, `ROM FROM FILE` vs physical slot, cart writes, reset,
  PSG audio and the overlay/browser/F-keys all behave as before. The bank
  decode and the memory router are independent now with no behavior change.
  Branch layout at this point: `stable` = 10d9a83 (v1.0 rollback line),
  `main` = integration line (this step), `feature/modular-emulation-architecture`
  = d2e887e checkpoint. Next extraction: the video device seam (TMS9918 behind
  an ops table) so the MSX port map stops being hardcoded in `msx.c`.
- 2026-11-01: video device seam added. `include/msx_video.h` defines the ops
  table and handle; `src/core/msx_video_tms9918.c` adapts the TMS9918 chip
  model to it and owns the device lifecycle. `src/core/msx.c` drives video
  only through the seam (port 0x98-0x9F routing stays in the machine) and the
  frame loop sequences sync-IRQ -> render hook -> `msx_video_irq_pending()` ->
  CPU IRQ, unchanged in order. `machine->video` is the handle, `machine->vdp`
  the compatibility alias. `host-test/video_seam_test.c` proves the seam takes
  a foreign device, that the TMS9918 adapter matches the raw chip byte for
  byte, and that the machine alias is wired. All host tests pass. Images in
  `test-images/2026-11-01-video-seam/`: Pi 3 535248 B (`a883ef18...`), Pi 4
  581264 B (`70548a0e...`), hardware verification pending. Next: audio (PSG +
  sub-frame log) and input (PPI/keyboard) seams.
- 2026-11-01: video-seam images hardware-verified on the Pi 3A+ and Pi 4
  (C-BIOS, sprites, VBlank-synced game speed, MegaROMs, `ROM FROM FILE` vs
  physical slot, cart writes, reset, audio, UI): no behaviour change from the
  mapper-module bundle.
- 2026-11-01: audio device seam added. `include/msx_audio.h` defines the ops
  table; `src/core/msx_audio_psg.c` adapts the PSG and now owns the sub-frame
  register write log and its replay (moved out of `msx.c` unchanged in
  algorithm, now per-machine state instead of static state plus an owner
  guard). `msx.c` timestamps 0xA0/0xA1 writes with `s_frame_frac16()` and
  forwards 0xA2 reads through the seam; `msx_psg_render()` is a forwarder.
  `machine->audio` is the handle, `machine->sound` the compatibility alias.
  `host-test/audio_seam_test.c` proves foreign-device support, raw-chip
  equivalence for the port protocol, mid-frame replay (byte-equal to a manual
  two-segment render, different from a whole-frame render), the >256-write
  fallback and latch survival. All host tests pass. Images in
  `test-images/2026-11-01-audio-seam/`: Pi 3 536528 B (`60cf95ae...`), Pi 4
  582608 B (`c4c8b099...`), hardware verification pending. Next: input seam
  (PPI/keyboard + joystick ports), then the machine-profile layer with
  `MSX_Memory` ownership.
 - 2026-11-01: audio-seam images hardware-verified on the Pi 3A+ and Pi 4.
  Sound is delivered correctly on both output paths (HDMI and the phone jack)
  and the audio regression checklist passed, i.e. the sub-frame write log
   behaves exactly as it did inside `msx.c`. Next: input seam (PPI/keyboard +
   joystick ports).
 - 2026-11-01: input device seam added. `include/msx_input.h` defines the
   handle/ops table and standard MSX EC codes; `src/core/msx_input_ppi.c`
   contains the extracted PPI matrix and host-key mapping. `msx.c` retains only
   machine slot policy and routes 0xA8-0xAB through the seam. All 13 host tests
   pass. Images in `test-images/2026-11-01-input-seam/`: Pi 3 537232 B
   (`d2dff0ea...`), Pi 4 583376 B (`54b19822...`), hardware verification
   pending. Next: machine-profile layer and `MSX_Memory` ownership.
- 2026-11-01: input-seam images hardware-verified. Keyboard input passed on
  the Pi 3A+ and Pi 4, including the PPI matrix path; no regression observed.
  The first six device seams are now hardware-verified. Next: machine-profile
  layer and `MSX_Memory` ownership.
