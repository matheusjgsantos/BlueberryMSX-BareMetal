# BlueberryMSX-BareMetal — Project Status

Bare-metal MSX1 emulator for the Raspberry Pi 3B+ (Cortex-A53, AArch32), built
on the [Circle](https://github.com/martin-rotter/circle) C++ bare-metal
environment. C-BIOS ROMs are embedded in the image; the kernel boots straight to
the MSX BASIC prompt and renders the TMS9918 VDP screen to the Pi's HDMI
framebuffer. A small HTTP API exposes live status, a log buffer, and pause /
step / reset control.

## Architecture (two-stage chain boot)

1. **`msxboot.img`** (`circle/msxboot/`) lives on the boot partition (USB thumb
   drive, see Deploy) and is named in `config.txt` as the kernel. It starts an
   HTTP upload UI on **:8080** plus a TFTP server, waits for an image to be
   uploaded, then **chain-boots it at `0x8000`** (Circle `EnableChainBoot`).
2. **`msx.img`** (`src/app/`) is the actual MSX emulator. It is *uploaded* to a
   running msxboot (HTTP or TFTP) and chain-booted — it is **not** written to
   the boot medium. This keeps the emulator updatable over the network without
   re-flashing.

There is no filesystem at runtime; everything (C-BIOS, fonts, palette) is linked
into `msx.img`.

## Objective / Roadmap

| Phase | Status | Description |
|-------|--------|-------------|
| 0 | Done | Circle kernel boots on Pi 3B+, UART console + log ring buffer |
| 1 | Done | Framebuffer via Circle `CScreenDevice`/`CBcmFrameBuffer` |
| 2 | Done | TMS9918 real MSX1 VDP protocol + renderer, wired into the frame loop (`msx_step_frame`) |
| 2b | Done | Chain-boot flow: msxboot serves/uploads `msx.img`, boots at 0x8000 |
| 2c | Done | HTTP debug/control API (status, log, pause/step/reset, regs, mem) |
| 2d | Done | Boot from USB thumb drive; kernel log mirrored to `BOOT.LOG` on the UMS log partition (`bootdev=umsd`) |
| 2e | Testing | Clean shutdown → chain-boot handover verified on hardware (probe sequence S W X Y Z O N P Q A–G) |
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
| p1 | 486 M | FAT32 | `/mnt/sdcard` | standard RPi boot partition (`bootcode.bin`, `start.elf`, `kernel7.img`, `config.txt`, `cmdline.txt`, **`msxboot.img`**) |
| p2 | 1.4 G | FAT32 | `/mnt/logs` | log partition — `BOOT.LOG` written by msxboot at runtime |

1. Build and stage the boot server:
   ```sh
   cp circle/msxboot/msxboot.img /mnt/sdcard/
   ```
   `config.txt`:
   ```
   arm_64bit=0
   enable_uart=1
   kernel=msxboot.img
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
   - `bootdev` — `umsd` (USB mass storage) or `emmc` (SD slot); absent = try
     emmc, then umsd. With `umsd`, EMMC init is skipped entirely.

2. Power-cycle the Pi. It gets an address via **DHCP** (observed
   192.168.1.206) and prints it over UART (ttyS1, 115200). USB enumeration
   takes ~3 s; the stick appears as `umsd1` with partitions `umsd1-1`/`umsd1-2`.

3. Upload the emulator image to the running boot server:
   ```sh
   # HTTP UI: open http://<ip>:8080 and upload msx.img, then press Boot
   # ...or TFTP (filename must start with "kernel" and end in ".img"):
   tftp -m binary <ip> -c put kernel.img
   ```

4. msxboot chain-boots `msx.img` at `0x8000`; the MSX BASIC prompt appears on
   HDMI and the HTTP API is live on :8080.

## Boot logging (BOOT.LOG)

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
| `W` | `~CTimer` | scheduler/timer torn down |
| `X` | `CInterruptSystem::Destructor` | interrupts off |
| `Y` / `Z` | `~CSerialDevice` / `~CScreenDevice` | console/framebuffer released |
| `O` | `sysinit.cpp` | just before `DoChainBoot()` |
| `N`/`P`/`Q` | chain-boot path | handover start / stub / done |
| `A`–`G` | msx.img startup | emulator running |

Expected clean sequence after upload: `R S W X Y Z O N P Q A B C D E F G`.
`SHDN:`-prefixed lines in the log mark logger and USB-teardown milestones.

## HTTP API (port 8080)

| Path | Description |
|------|-------------|
| `/` | index page |
| `/status` | live status JSON |
| `/log` | log ring buffer contents (`text/plain`) |
| `/command?cmd=pause\|resume\|step\|reset` | control the emulator |
| `/regs` | coherent CPU/VDP register dump (JSON) |
| `/mem?addr=0x...&size=N` | hex dump of MSX memory |

## Key Files

- `src/app/main.cpp` — entry point; chain-booted at 0x8000.
- `src/app/kernel.{h,cpp}` — `CKernel`: subsystem init chain, network (static IP),
  HTTP server bring-up, cooperative `Run()` loop.
- `src/app/msx_task.{h,cpp}` — cooperative task that drives `msx_step_frame()` at
  the VDP cadence; handles pause/step/reset and heartbeat logging.
- `src/app/vdpblit.{h,cpp}` — strong override of `msx_frame_render()`; centers the
  256x192 image in Circle's framebuffer.
- `src/app/httpapi.{h,cpp}` — `CMsxHttpServer` (the API above).
- `src/app/apilog.{h,cpp}`, `teelog.h` — log ring buffer + UART/ring tee logger.
- `src/app/syscalls.cpp` — newlib syscall stubs (`_write`, `_sbrk`, …, `_exit`).
- `src/app/cbios_roms.{h,cpp}` — embedded C-BIOS ROM images (main + logo).
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

- **In testing:** clean shutdown → chain-boot handover. Shutdown now closes
  `BOOT.LOG` before USB teardown (`CLogTarget::CloseFile()` in `~CKernel`);
  verify the full probe sequence `R S W X Y Z O N P Q A–G` and that
  `BOOT.LOG` on p2 is non-empty after a run.
- `sd_update/` staging is stale (holds an old `kernel7l.img` + its config).
- Sprites, keyboard input and PSG audio are not yet implemented (Phase 3).
- Verify screens 1/2 (Graphics I / II) via BASIC `SCREEN` commands once screen 0
  (text) is confirmed stable on hardware.
