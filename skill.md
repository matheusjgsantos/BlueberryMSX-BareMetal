# skill.md — BlueberryMSX-BareMetal Agent Guide

Read this before touching code in this repository. It captures the app's goals,
hard requirements, build/deploy flow, and the non-obvious pitfalls already paid
for during development.

## What this project is

A **bare-metal MSX1 emulator** built with the [Circle](https://github.com/rsta2/circle)
C++ environment. Release v1.0 runs directly on Raspberry Pi Zero 2 W, Pi 3A+/B+,
Pi 4, and Pi 400. It boots from a model-selected 32-bit app image, loads C-BIOS
from SD, and renders the TMS9918 VDP to the HDMI framebuffer.

## Hard requirements (do not violate)

- Targets: **Pi 3 family, `RASPPI=3`, `AARCH=32`** and **Pi 4 family,
  `RASPPI=4`, `AARCH=32`**. Build separate images and select them in
  `config.txt` (`msx-pi3.img` / `msx-pi4.img`).
- Circle static libraries are shared across targets and do not track compiler
  flag changes. Clean and rebuild Circle libraries and add-ons when switching
  `RASPPI`, or a Pi 4 image can link the Pi 3 SDHOST backend.
- The emulator boots directly from the Pi firmware at load address **0x8000**;
  network upload and chain boot are legacy only.
- **C-BIOS comes from the SD card.** The ROMs are read at boot from the `BIOS/`
  folder on the data partition (FAT2, `emmc1-2`); the machine halts if they are
  missing. `msx.ini` also lives there. Fonts and palette are still compiled in.
- The MSX core (`src/core`, `src/chips`, `include`) is **plain C** shared with
  the C++ app. Keep it C (C99), no C++ features, no OS calls.

## Repository layout

```
BlueberryMSX-BareMetal/
├── circle/msxboot/        # legacy chain-boot server
├── src/
│   ├── app/               # direct-boot MSX emulator -> msx.img
│   │   ├── main.cpp       # entry point at 0x8000
│   │   ├── kernel.{h,cpp} # CKernel: init chain, C-BIOS and Run loop
│   │   ├── msx_task.{h,cpp}# cooperative task driving msx_step_frame()
│   │   ├── vdpblit.{h,cpp}# strong msx_frame_render() -> Circle framebuffer
│   │   ├── apilog.{h,cpp} # 8 KiB log ring buffer
│   │   ├── teelog.h       # UART + ring tee logger (CTeeLogDevice)
│   │   ├── syscalls.cpp   # newlib syscall stubs
│   │   ├── biosrom.{h,cpp}  # load C-BIOS from SD BIOS/ (machine -> ROM set)
│   │   └── cbios_roms.{h,cpp}# legacy embedded ROM arrays (host-test only)
│   ├── core/msx.c         # MSX machine: slots, I/O routing, msx_step_frame
│   └── chips/             # z80/R800 (CPU), vdp/tms9918 + msx_font.h
├── include/               # bus.h, msx.h, msx_types.h (C API)
├── Docs/                  # PROJECT_STATUS.md, TMS9918_MSX1_VDP.md, cbios-0.29a/
├── Machines -> ...        # symlink to machine definitions (external project)
└── release/               # versioned release bundles; preserve old versions
```

## Build and deploy

Prerequisites: Circle at `../BlueberryMSX/circle` and `arm-none-eabi` with
hard-float multilib newlib (see pitfall #1). For each model family, configure
and rebuild Circle for its matching target, then build the app with that same
`RASPPI`. Clean/rebuild when switching targets because Circle archives are
shared and Make does not track architecture-define changes.

For example, from the Circle checkout for Pi 4:

```sh
./configure -r 4 --multicore -f
./makeall clean
./makeall
for lib in addon/SDCard addon/linux addon/vc4/vchiq addon/vc4/sound; do
    make -C "$lib" clean
    make -C "$lib"
done
make -C ../../BlueberryMSX-BareMetal/src/app clean RASPPI=4
make -C ../../BlueberryMSX-BareMetal/src/app RASPPI=4
```

Repeat for Pi 3 using `./configure -r 3 --multicore -f` and `RASPPI=3`; copy
the output to `msx-pi3.img` (`msx.img` compatibility alias). The Pi 4 output is
`msx-pi4.img`. `release/<ver>/config.txt` selects the correct image by model.

An SD card has two FAT32 partitions: partition 1 is boot (Pi firmware, DTBs,
`config.txt` and app images); partition 2 is data (`msx.ini`, `BIOS/`, ROMs,
and runtime dumps). Circle's `boot/` folder contains Pi boot support files;
building `src/app` produces the raw `msx.img` application, not Pi firmware.
See `README.md` for exact copy locations and v1.0 release deployment commands.

## Pitfalls (already hit — do not rediscover)

1. **newlib libc must be linked manually, hard-float.** Circle's
   `STDLIB_SUPPORT=1` (default) links only libgcc+libm; level ≥2 needs an external
   `circle-stdlib` project that is not available here. Fix (in `src/app/Makefile`):
   ```make
   EXTRALIBS += "$(shell $(CC) -mcpu=cortex-a53 -mfloat-abi=hard -mfpu=neon-fp-armv8 -print-file-name=libc.a)"
   ```
   This resolves the toolchain's **hard-float** newlib
   (`.../thumb/v8-a+simd/hard/libc.a`). The default `libc.a` is soft-float and
   fails with VFP ABI mismatches. Put it in `EXTRALIBS` (recipe-only), **not**
   `LIBS` — a quoted path in `LIBS` becomes a make prerequisite and breaks.
   Also keep the `_exit` stub in `syscalls.cpp` (newlib's `abort` needs it).

2. **(Legacy) C++ `const` arrays have internal linkage → DCE'd.** The embedded
   ROM arrays in `cbios_roms.cpp` carry an explicit `extern` for that reason.
   That file is **no longer compiled into `msx.img`** (C-BIOS now loads from SD
   `BIOS/` via `biosrom.cpp`), but the host tests (`host-test/`) still link it.

3. **MSX core C headers have no `__cplusplus` guards.** Every include of
   `msx.h`, `R800.h`, `tms9918.h`, etc. from a C++ translation unit must be
   wrapped in `extern "C" { ... }`.

4. **No C++ standard library headers** in the Circle toolchain. Use `<stdlib.h>`,
   `<string.h>`, `<stdio.h>` — not `<cstdlib>`/`<cstring>`/`<cstdio>`.

5. **Prebuilt `.o` files in source trees are x86-64 host artifacts.** The app
   Makefile has explicit ARM compile rules for the C sources
   (`msx_core.o: ../core/msx.c`, `r800.o`, `tms9918.o`). Don't link stray `.o`
   files; delete them if they reappear.

## Emulator pacing & boot facts

- Frame cadence is time-driven: `MSX_FRAME_TICKS=357954` R800 master ticks
  (21477270/60) per 60 Hz frame. The R800 is created with `CPU_ENABLE_M1`; do not
  replace this with a fixed instruction budget.
- `msx_step_frame(machine, frame_ticks)` executes until the emulated master-time
  budget expires, then fires the sync IRQ and render hook. HALT advances the
  emulated time safely.
- Boot sequence (`kernel.cpp`): SD data partition mounted → `LoadMsxConfig()`
  → `msx_create()` → `LoadBios()` reads the machine's ROM set from `BIOS/` on
  the data partition and maps it onto the slots (RAM in slot 3, BIOS in slot 0)
  → slot map port `0xA8 = 0xC0`. A missing BIOS is fatal.
- Slot map port 0xA8: region0 = `val & 3`, region1 = `(val >> 2) & 3`,
  region2 = `(val >> 4) & 3`, region3 = `(val >> 6) & 3`.

## Conventions

- Circle code style in the app: tabs, `ClassName (args)` with a space before
  parens, `m_` member prefix, `bOK` chained init pattern in `CKernel::Initialize`.
- Core C code: 4-space indent, `snake_case`, no comments unless asked.
- After app changes, rebuild and verify the intended target. Rebuild Circle
  libraries for each `RASPPI` value when switching between Pi 3 and Pi 4; see
  the dual-target commands in `README.md`. The old HTTP/TFTP boot-server build
  is legacy and is not part of the release workflow.
