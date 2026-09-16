# skill.md — BlueberryMSX-BareMetal Agent Guide

Read this before touching code in this repository. It captures the app's goals,
hard requirements, build/deploy flow, and the non-obvious pitfalls already paid
for during development.

## What this project is

A **bare-metal MSX1 emulator** that runs directly on a Raspberry Pi 3B+
(Cortex-A53, **AArch32 / 32-bit ARM**) using the
[Circle](https://github.com/martin-rotter/circle) C++ bare-metal environment.
No Linux, no OS: Circle is the kernel.

Two images, two stages:

- **`msxboot.img`** (`circle/msxboot/`) — flashed to the SD boot partition.
  HTTP upload UI (:8080) + TFTP; chain-boots whatever image it receives at
  `0x8000`.
- **`msx.img`** (`src/app/`) — the emulator itself. Uploaded over the network to
  a running msxboot, then chain-booted. Boots C-BIOS straight to the MSX BASIC
  prompt and renders the TMS9918 VDP (256x192) to the HDMI framebuffer.

## Hard requirements (do not violate)

- Target: **Pi 3B+, `RASPPI=3`, `AARCH=32`** in both Makefiles.
- Emulator image is **uploaded, never flashed**; it must chain-boot at load
  address **0x8000**.
- **No filesystem at runtime.** C-BIOS ROMs, fonts and palette are compiled into
  `msx.img` (`src/app/cbios_roms.cpp`). Do not add file I/O to the app.
- Networking is **static IP** `192.168.178.42/24`, gw `192.168.178.1`
  (`m_acStaticIP` in `kernel.cpp`). HTTP API port is **8080**.
- The MSX core (`src/core`, `src/chips`, `include`) is **plain C** shared with
  the C++ app. Keep it C (C99), no C++ features, no OS calls.

## Repository layout

```
BlueberryMSX-BareMetal/
├── circle/msxboot/        # chain-boot server (Circle app) -> msxboot.img [flashed]
├── src/
│   ├── app/               # MSX emulator (Circle app)      -> msx.img    [uploaded]
│   │   ├── main.cpp       # entry, chain-booted at 0x8000
│   │   ├── kernel.{h,cpp} # CKernel: init chain, network, HTTP bring-up, Run loop
│   │   ├── msx_task.{h,cpp}# cooperative task driving msx_step_frame()
│   │   ├── vdpblit.{h,cpp}# strong msx_frame_render() -> Circle framebuffer
│   │   ├── httpapi.{h,cpp}# HTTP API :8080
│   │   ├── apilog.{h,cpp} # 8 KiB log ring buffer
│   │   ├── teelog.h       # UART + ring tee logger (CTeeLogDevice)
│   │   ├── syscalls.cpp   # newlib syscall stubs
│   │   └── cbios_roms.{h,cpp}# embedded C-BIOS ROM arrays
│   ├── core/msx.c         # MSX machine: slots, I/O routing, msx_step_frame
│   └── chips/             # z80/R800 (CPU), vdp/tms9918 + msx_font.h
├── include/               # bus.h, msx.h, msx_types.h (C API)
├── Docs/                  # PROJECT_STATUS.md, TMS9918_MSX1_VDP.md, cbios-0.29a/
├── Machines -> ...        # symlink to machine definitions (external project)
└── sd_update/             # SD staging (config.txt + kernel image) — keep fresh
```

## Build & deploy

Prereqs: Circle checkout at `/data/Projects/MSX/circle`; `arm-none-eabi`
toolchain with **hard-float multilib newlib** (see pitfall #1).

```sh
make -C src/app          # -> src/app/msx.img  (+ msx.elf/.lst/.map)
make -C circle/msxboot   # -> circle/msxboot/msxboot.img

# Deploy: copy msxboot.img to SD boot partition, config.txt:
#   arm_64bit=0
#   enable_uart=1
#   kernel=msxboot.img
# Power-cycle, then upload the emulator image:
tftp -m binary 192.168.178.42 -c put src/app/msx.img
# (or use the HTTP UI at http://192.168.178.42:8080)
```

`msx.img` is a **raw binary** (`objcopy -O binary`), not an ELF — msxboot passes
the received bytes straight to `EnableChainBoot()`. Verify with `file msx.elf`
(ELF32 ARM, entry 0x8000); the `.img` will report as `data`.

## HTTP API (port 8080)

`/` index · `/status` JSON · `/log` ring buffer · `/command?cmd=pause|resume|step|reset`
· `/regs` CPU/VDP register dump · `/mem?addr=0x...&size=N` hex dump.

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

2. **C++ `const` arrays have internal linkage → DCE'd.** Namespace-scope `const`
   ROM arrays in `cbios_roms.cpp` vanish at link time unless marked `extern`.
   The 4 definitions carry an explicit `extern`. If you regenerate that file,
   preserve it. (The file is auto-generated from `Docs/cbios-0.29a/`; no
   generator script exists in the repo — edit by hand or re-derive carefully.)

3. **MSX core C headers have no `__cplusplus` guards.** Every include of
   `msx.h`, `R800.h`, `tms9918.h`, etc. from a C++ translation unit must be
   wrapped in `extern "C" { ... }`.

4. **No C++ standard library headers** in the Circle toolchain. Use `<stdlib.h>`,
   `<string.h>`, `<stdio.h>` — not `<cstdlib>`/`<cstring>`/`<cstdio>`.

5. **`THTTPStatus` enum names have no "Status" prefix:** `HTTPOK` (200),
   `HTTPBadRequest` (400), `HTTPNotFound` (404). There is no `StatusOK`.

6. **CLogger API:** `m_Logger.Write (pSource, TLogSeverity, fmt, ...)` with
   severities `LogError` / `LogWarning` / `LogNotice`. There is **no**
   `.Error()`/`.WriteLine()` convenience method.

7. **`HTTP_PORT` macro clash:** Circle's `<circle/net/http.h>` defines
   `HTTP_PORT 80`. The app uses its own `MSX_HTTP_PORT 8080`. Never redefine or
   rely on `HTTP_PORT`.

8. **Prebuilt `.o` files in source trees are x86-64 host artifacts.** The app
   Makefile has explicit ARM compile rules for the C sources
   (`msx_core.o: ../core/msx.c`, `r800.o`, `tms9918.o`). Don't link stray `.o`
   files; delete them if they reappear.

## Emulator pacing & boot facts

- Frame cadence: `VDP_FRAME_INSTR 12000` Z80 instructions per VDP frame (~60 Hz),
  `FRAME_SLEEP_MS 16`, `HEARTBEAT_FRAMES 120` (`msx_task.cpp`). The VDP sync IRQ
  is fired on this fixed instruction cadence (not wall-clock) so it keeps ticking
  while the Z80 HALTs.
- `msx_step_frame(machine, vdp_frame_instr)` runs exactly that many instructions,
  then fires the sync IRQ and the `msx_frame_render()` hook once. It is the only
  execution entry point used by the app (there is no blocking run loop).
- Boot sequence (`kernel.cpp`): slot 3 / subslot 0 RAM init → load C-BIOS **main
  ROM at 0x0000** and **logo ROM at 0x8000** via `msx_load_data` → write slot map
  port `0xA8 = 0xC0`.
- Slot map port 0xA8: region0 = `val & 3`, region1 = `(val >> 2) & 3`,
  region2 = `(val >> 4) & 3`, region3 = `(val >> 6) & 3`.

## Conventions

- Circle code style in the app: tabs, `ClassName (args)` with a space before
  parens, `m_` member prefix, `bOK` chained init pattern in `CKernel::Initialize`.
- Core C code: 4-space indent, `snake_case`, no comments unless asked.
- After any change: rebuild with `make -C src/app` (and `make -C circle/msxboot`
  if boot-server code changed) and confirm `msx.img` is produced.
