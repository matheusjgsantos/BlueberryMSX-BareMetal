# BlueberryMSX-BareMetal — Project Status

Bare-metal MSX1 emulator for Raspberry Pi Zero 2 W, 3A+/B+, 4, and 400, built
with the [Circle](https://github.com/rsta2/circle) C++ bare-metal environment.
Release v1.0 provides separate 32-bit Circle images for the Pi 3 and Pi 4
families. C-BIOS is loaded from `BIOS/` on the SD data partition; the kernel
boots directly to MSX BASIC and renders the TMS9918 VDP to the HDMI framebuffer.
There is no networking at runtime.

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

**Primary — direct boot:** the Pi firmware loads the model-selected
`msx-pi3.img` or `msx-pi4.img` from the boot partition as the kernel. Each is
linked for `0x8000`, so it boots standalone with no second stage. `msx.img` is
kept as a Pi 3 compatibility alias.

**Legacy — two-stage chain boot:** **`msxboot.img`** (`circle/msxboot/`) can
still be named as the kernel; it starts an HTTP upload UI on **:8080** plus a
TFTP server, waits for an image to be uploaded, then **chain-boots it at
`0x8000`** (Circle `EnableChainBoot`). This path is shelved — its shutdown
sequence hangs during USB teardown (see Known Issues) and direct boot makes it
unnecessary.

At runtime the SD data partition (FAT2, Circle device `emmc1-2`) supplies
`msx.ini`, C-BIOS from `BIOS/`, and ROM images for the overlay's `ROM FROM FILE`
browser. Cartridge dumps and optional diagnostics are also written there, not
to the boot partition. C-BIOS is no longer embedded in `msx.img` (v0.11 onward).

## Objective / Roadmap

| Phase | Status | Description |
|-------|--------|-------------|
| 0 | Done | Circle kernel boots on Zero 2, Pi 3 family, Pi 4, and Pi 400 |
| 1 | Done | Framebuffer via Circle `CScreenDevice`/`CBcmFrameBuffer` on supported targets |
| 2 | Done | TMS9918 real MSX1 VDP protocol + renderer, wired into the frame loop (`msx_step_frame`) |
| 2b | Done (legacy) | Chain-boot flow: msxboot serves/uploads `msx.img`, boots at 0x8000 — superseded by direct boot |
| 2c | Removed | HTTP debug/control API — removed from `msx.img` with all networking (Sep 19 2026); re-addable from git history |
| 2d | Done | Boot from USB thumb drive; kernel log mirrored to `BOOT.LOG` on the UMS log partition (`bootdev=umsd`, msxboot only) |
| 2e | Shelved | Clean shutdown → chain-boot handover; blocked by msxboot USB-teardown hang, no longer needed with direct boot |
| 2f | Done | Direct boot via model-selected Pi 3/Pi 4 app images |
| 3 | Partial | USB keyboard and PSG implemented; MSX2/2+ and V9938 support remain future work |

See `TMS9918_MSX1_VDP.md` for the VDP ground truth and renderer design.

## Build

Prerequisites: Circle at `../BlueberryMSX/circle` and an `arm-none-eabi`
toolchain with hard-float multilib newlib. Build Circle and the app with
matching `RASPPI=3` or `RASPPI=4`. Circle's static libraries are shared between
targets, so clean and rebuild them when switching target; see `README.md` for
the complete Pi 3/Pi 4 build sequence.

```sh
# After configuring and rebuilding Circle for the chosen target:
make -C src/app clean RASPPI=4
make -C src/app RASPPI=4
```

The resulting `src/app/msx.img` is the direct-boot application. Release v1.0
ships the Pi 3 build as `msx-pi3.img` and the Pi 4 build as `msx-pi4.img`;
`config.txt` selects the matching image for each board family.

## Deploy / Run

The SD card uses two FAT32 partitions, in order:

| Partition | Circle device | Contents |
|-----------|---------------|----------|
| 1 (boot) | firmware boot volume | matching Raspberry Pi firmware/DTBs, `config.txt`, `msx-pi3.img`, `msx-pi4.img`, and Pi 4 armstub |
| 2 (data) | `emmc1-2` | `msx.ini`, `BIOS/`, optional ROM files and runtime dumps |

Copy the boot payload files to partition 1 and copy `msx.ini` plus the whole
`BIOS/` folder to the root of partition 2. ROM images can be placed anywhere on
partition 2 for the file browser. Keep board-matching Pi firmware files on the
boot partition. See `README.md` for exact release-copy commands.

Do not write runtime dumps or emulator data to partition 1. The C-BIOS set is
required; if the data volume or BIOS files cannot be loaded, the emulator shows
an error instead of starting the MSX machine.

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

## Historical debugging notes (pre-v1.0)

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
  Chain boot is no longer the deployment path; direct boot is the release path.
- `sd_update/` staging is stale (holds an old `kernel7l.img` + its config).
- MSX1/C-BIOS is the supported machine configuration. MSX2/2+ BIOS files are
  bundled, but the required secondary-slot register and V9938 VDP are not yet
  implemented.
