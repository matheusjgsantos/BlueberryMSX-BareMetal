# BlueberryMSX-BareMetal — Project Status

Bare-metal MSX1 emulator for the Raspberry Pi 3B+ (Cortex-A53, AArch32), built
on the [Circle](https://github.com/martin-rotter/circle) C++ bare-metal
environment. The C-BIOS ROMs are read at boot from the `BIOS/` folder on the SD
data partition (the machine halts if missing); the kernel boots straight to the
MSX BASIC prompt and renders the TMS9918 VDP screen to the Pi's HDMI
framebuffer. There is no networking at runtime (the former HTTP control API was
removed on Sep 19 2026 — see Known Issues).

## Provenance

This bare-metal port is based on the code in
`/data/Projects/MSX/opencode/Projects/BlueberryMSX-2.0plus` (the BlueberryMSX
2.0+ host emulator):

- `src/core/msx.c`, `src/chips/z80/R800.{h,c}`, `src/chips/vdp/tms9918.{h,c}`
  are ports of that project's C core (MSX machine model, Z80/R800 CPU, TMS9918
  VDP). The ported sources keep their upstream headers (R800.c traces back to
  blueMSX, Daniel Vik).
- The C-BIOS slot map in `src/app/kernel.cpp` (`msx_load_cbios()`) matches the
  host build's mapping.
- MSX machine definitions are shared via symlink:
  `Machines -> /data/Projects/MSX/opencode/Projects/BlueberryMSX-2.0plus/Machines`.

## Architecture (direct boot)

**Primary — direct boot:** **`msx.img`** (`src/app/`) is copied to the boot
partition and named in `config.txt` as the kernel. It is linked for `0x8000`,
the address where the Pi firmware loads a 32-bit kernel image, so it boots
standalone with no second stage.

**Legacy — two-stage chain boot:** **`msxboot.img`** (`circle/msxboot/`) can
still be named as the kernel; it starts an HTTP upload UI on **:8080** plus a
TFTP server, waits for an image to be uploaded, then **chain-boots it at
`0x8000`** (Circle `EnableChainBoot`). This path is shelved — its shutdown
sequence hangs during USB teardown (see Known Issues) and direct boot makes it
unnecessary.

At runtime the SD data partition (FAT2, `emmc1-2`) is mounted read-only: C-BIOS
is loaded from `BIOS/` there, and the overlay's `ROM FROM FILE` browser loads
ROM images from the partition. This superseded the earlier fully-linked build
(C-BIOS, fonts, palette used to be linked into `msx.img`); the embedded
fallback ROMs were removed in v0.11.

## Objective / Roadmap

| Phase | Status | Description |
|-------|--------|-------------|
| 0 | Done | Circle kernel boots on Pi 3B+, UART console + log ring buffer |
| 1 | Done | Framebuffer via Circle `CScreenDevice`/`CBcmFrameBuffer` |
| 2 | Done | TMS9918 real MSX1 VDP protocol + renderer, wired into the frame loop (`msx_step_frame`) |
| 2b | Done (legacy) | Chain-boot flow: msxboot serves/uploads `msx.img`, boots at 0x8000 — superseded by direct boot |
| 2c | Removed | HTTP debug/control API — removed from `msx.img` with all networking (Sep 19 2026); re-addable from git history |
| 2d | Done | Boot from USB thumb drive; kernel log mirrored to `BOOT.LOG` on the UMS log partition (`bootdev=umsd`, msxboot only) |
| 2e | Shelved | Clean shutdown → chain-boot handover; blocked by msxboot USB-teardown hang, no longer needed with direct boot |
| 2f | Testing | Direct boot: `msx.img` on the boot partition, `kernel=msx.img` in `config.txt` |
| 3 | Later | Sprites, keyboard input, PSG sound/audio; verify screens 1/2 via BASIC `SCREEN` |

See `TMS9918_MSX1_VDP.md` for the VDP ground truth and renderer design.

## Build

Prereqs: a Circle checkout at `/data/Projects/MSX/circle` (sibling of this
project) and an `arm-none-eabi` toolchain **with hard-float multilib newlib**
(see `skill.md` → "Toolchain / newlib").

```sh
# MSX emulator image  ->  src/app/msx.img   (+ msx.elf, msx.lst, msx.map)
make -C src/app

# Chain-boot server    ->  circle/msxboot/msxboot.img
make -C circle/msxboot
```

Both Makefiles set `RASPPI=3`, `AARCH=32` and `CIRCLEHOME ?= ../../../circle`.

## Deploy / Run

The boot medium is a **USB thumb drive** (SanDisk U3 Cruzer Micro, ~1.9 GB);
there is no SD card in the Pi's slot. Layout:

| Partition | Size | FS | Host mount | Contents |
|-----------|------|----|------------|----------|
| p1 | 486 M | FAT32 | `/mnt/sdcard` | standard RPi boot partition (`bootcode.bin`, `start.elf`, `kernel7.img`, `config.txt`, `cmdline.txt`, **`msx.img`**, `msxboot.img` legacy) |
| p2 | 1.4 G | FAT32 | `/mnt/logs` | log partition — `BOOT.LOG` written by msxboot at runtime (legacy path only) |

1. Build and stage the emulator image:
   ```sh
   cp src/app/msx.img /mnt/sdcard/
   ```
   `config.txt`:
   ```
   arm_64bit=0
   enable_uart=1
   kernel=msx.img
   hdmi_force_hotplug=1
   disable_splash=1
   hdmi_group=1
   hdmi_mode=4
   hdmi_drive=2
   ```
   `cmdline.txt` (Circle reads this as its command line):
   ```
   width=640 height=480
   logdev=ttyS1 loglevel=4 bootdev=umsd
   ```
   - `logdev`/`loglevel` — serial console device and verbosity.
   - `bootdev` — used by msxboot's `BOOT.LOG` mount only; ignored by `msx.img`.

2. Power-cycle the Pi. Expected serial (ttyS1, 115200):
   `BlueberryMSX: Circle MSX emulator compiled ...`,
   `C-BIOS loaded: [0x0000]=...`; the MSX BASIC prompt appears on HDMI.

**Legacy chain boot:** stage `circle/msxboot/msxboot.img` instead, set
`kernel=msxboot.img`, power-cycle, then upload `msx.img` via the HTTP UI at
`http://<ip>:8080` (or TFTP — filename must start with "kernel" and end in
".img"); msxboot chain-boots it at `0x8000`.

## Boot logging (BOOT.LOG, msxboot legacy path only)

All kernel log output is mirrored to the serial console **and** to
`BOOT.LOG` on the UMS log partition (`umsd1-2`) by `CLogTarget`
(`circle/msxboot/kernel.h`). The file is created in `InitializeBootLog()`
after the USB stack comes up; if no FAT volume is available logging falls
back to serial only.

On shutdown, `~CKernel`'s body (which runs *before* member destructors) calls
`CLogTarget::CloseFile()`: this does the final `CFATFileSystem::FileClose()` —
required because the directory entry (file size / first cluster) is only
updated there — while the USB controller is still alive. Any FAT I/O after
the DWC OTG reset would issue CBW transfers that can never complete and hang
the teardown (observed: "umsd: CBW transfer failed" cascade, no `W` probe).

## Shutdown / chain-boot diagnostics

Single-letter probes are emitted on the raw diagnostic UART (CLO at
`0x3F003004`, 1 MHz) with a 10-µs timestamp; they survive logger teardown:

| Letter | Where | Meaning |
|--------|-------|---------|
| `H`–`M` | `CKernel::Initialize()` steps | boot init progress |
| `T`/`U`/`V` | TFTP handler | upload start / data done / ack |
| `R` | `Run()` exit | reboot requested |
| `S` | `~CKernel` body | shutdown started, boot log closed |
| `e`/`f` | `~CLogger` (logger.cpp) | enter / after queue+buffer teardown |
| `i`/`j` | `~CLogger` (logger.cpp) | before / after event-queue cleanup loop (heap deletes) |
| `g` | `~CLogTarget` (kernel.h) | file+serial tracer torn down |
| `l` | `~CDevice` (device.cpp) | CDevice base destructor (removal-handler list) |
| `h` | `~CFATFileSystem` (fatfs.cpp) | FATFS destructor body |
| `a`/`b` | `~CEMMCDevice` (emmc.cpp) | enter / after `m_Host.Reset()` |
| `c`/`d` | `~CSDHOSTDevice` (sdhost.cpp) | enter / after `remove()` |
| `W` | `~CTimer` | scheduler/timer torn down |
| `X` | `CInterruptSystem::Destructor` | interrupts off |
| `Y` / `Z` | `~CSerialDevice` / `~CScreenDevice` | console/framebuffer released |
| `O` | `sysinit.cpp` | just before `DoChainBoot()` |
| `N`/`P`/`Q` | chain-boot path | handover start / stub / done |
| `A`–`G` | msx.img startup | emulator running |

Expected clean sequence after upload: `R S W X Y Z O N P Q A B C D E F G`.
`SHDN:`-prefixed lines in the log mark logger and USB-teardown milestones.

## Key Files

- `src/app/main.cpp` — entry point; linked for 0x8000 (direct `kernel=` boot or msxboot chain boot).
- `src/app/kernel.{h,cpp}` — `CKernel`: subsystem init chain, C-BIOS loading,
  cooperative `Run()` loop.
- `src/app/msx_task.{h,cpp}` — cooperative task that drives `msx_step_frame()` at
  the VDP cadence; handles pause/step/reset and heartbeat logging.
- `src/app/vdpblit.{h,cpp}` — strong override of `msx_frame_render()`; centers the
  256x192 image in Circle's framebuffer.
- `src/app/apilog.{h,cpp}`, `teelog.h` — log ring buffer + UART/ring tee logger.
- `src/app/syscalls.cpp` — newlib syscall stubs (`_write`, `_sbrk`, …, `_exit`).
- `src/app/biosrom.{h,cpp}` — load the machine's C-BIOS ROM set from `BIOS/` on
  the SD data partition (`msx.ini` `machine=` selects msx1/msx2/msx2+; the
  machine halts if the BIOS files are missing).
- `src/app/cbios_roms.{h,cpp}` — legacy embedded C-BIOS arrays (host-test only;
  no longer compiled into `msx.img`).
- `src/core/msx.c` — MSX machine: 4 slots / subslots, I/O routing, `msx_create`,
  `msx_load_data`, and the per-frame stepper `msx_step_frame`.
- `src/chips/z80/R800.{h,c}` — Z80 CPU.
- `src/chips/vdp/tms9918.{h,c}`, `msx_font.h` — TMS9918 VDP + renderer + font.
- `include/{bus,msx,msx_types}.h` — C API shared between the core and the app.
- `circle/msxboot/kernel.{h,cpp}` — boot-server `CKernel`: init order,
  `CLogTarget` (serial + `BOOT.LOG`), `InitializeBootLog()`/`MountBootLog()`
  (emmc/umsd selection via `bootdev=`), shutdown log close.
- `circle/msxboot/` — chain-boot server (HTTP :8080 + TFTP).
- `Docs/cbios-0.29a/` — C-BIOS reference source used to derive real VDP behavior.
- `/data/Projects/MSX/circle` — Circle environment checkout.
- `/data/Projects/MSX/openmsx-20.0` — openMSX reference for pixel mapping.

## Known Issues / Next Steps

- **Fixed (Sep 19 2026):** direct boot stopped after `netdev: Net device not
  available` + a truncated `kernel: SHDN: logger off` line — `msx.img`
  initialized the net stack without ever bringing up USB, so the LAN9514 was
  never enumerated and `CKernel::Initialize()` failed. Resolved by removing
  networking from `msx.img` entirely (`httpapi.{h,cpp}` deleted, `libnet.a` no
  longer linked; image shrank 333,188 → 255,756 B). Remote control can be
  re-added later if wanted.
- **Shelved:** msxboot shutdown hangs right after `kernel: SHDN: logger off`
  (probe build md5 `142823e0`, Sep 18 2026 — banner confirmed on hardware, no
  further output; disassembly proves the `~CLogger` probes are in the binary).
  Chain boot is no longer the deployment path, so this is parked; direct boot
  (Phase 2f) is being verified instead.
- `sd_update/` staging is stale (holds an old `kernel7l.img` + its config).
- Sprites, keyboard input and PSG audio are not yet implemented (Phase 3).
- Verify screens 1/2 (Graphics I / II) via BASIC `SCREEN` commands once screen 0
  (text) is confirmed stable on hardware.
