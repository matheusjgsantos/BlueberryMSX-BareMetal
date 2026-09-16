# BlueberryMSX-BareMetal — Project Status

Bare-metal MSX1 emulator for the Raspberry Pi 3B+ (Cortex-A53, AArch32), built
on the [Circle](https://github.com/martin-rotter/circle) C++ bare-metal
environment. C-BIOS ROMs are embedded in the image; the kernel boots straight to
the MSX BASIC prompt and renders the TMS9918 VDP screen to the Pi's HDMI
framebuffer. A small HTTP API exposes live status, a log buffer, and pause /
step / reset control.

## Architecture (two-stage chain boot)

1. **`msxboot.img`** (`circle/msxboot/`) is flashed to the SD boot partition and
   named in `config.txt` as the kernel. It starts an HTTP upload UI on **:8080**
   plus a TFTP server, waits for an image to be uploaded, then **chain-boots it
   at `0x8000`** (Circle `EnableChainBoot`).
2. **`msx.img`** (`src/app/`) is the actual MSX emulator. It is *uploaded* to a
   running msxboot (HTTP or TFTP) and chain-booted — it is **not** flashed to
   the SD card. This keeps the emulator updatable over the network without
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

1. Stage the boot server on the SD **boot** partition and point `config.txt` at
   it:
   ```
   arm_64bit=0
   enable_uart=1
   kernel=msxboot.img
   ```
   (Copy `circle/msxboot/msxboot.img` to the partition.)
2. Power-cycle the Pi. It comes up on static IP **192.168.178.42/24**
   (gateway 192.168.178.1) and prints its address over UART (115200).
3. Upload the emulator image to the running boot server:
   ```sh
   # HTTP UI: open http://192.168.178.42:8080 and upload msx.img, then press Boot
   # ...or TFTP:
   tftp -m binary 192.168.178.42 -c put src/app/msx.img
   ```
4. msxboot chain-boots `msx.img` at `0x8000`; the MSX BASIC prompt appears on
   HDMI and the HTTP API is live on :8080.

> **Note:** `sd_update/` is a staging copy for the SD partition and is currently
> **stale** (it holds an old `kernel7l.img` and a `config.txt` that references it).
> Refresh it with the current `msxboot.img` and set `kernel=msxboot.img` before
> flashing.

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
- `circle/msxboot/` — chain-boot server (HTTP :8080 + TFTP).
- `Docs/cbios-0.29a/` — C-BIOS reference source used to derive real VDP behavior.
- `/data/Projects/MSX/circle` — Circle environment checkout.
- `/data/Projects/MSX/openmsx-20.0` — openMSX reference for pixel mapping.

## Known Issues / Next Steps

- `sd_update/` staging is stale (see Deploy note above).
- Sprites, keyboard input and PSG audio are not yet implemented (Phase 3).
- Verify screens 1/2 (Graphics I / II) via BASIC `SCREEN` commands once screen 0
  (text) is confirmed stable on hardware.
