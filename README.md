BlueberryMSX Bare-Metal (Circle)
================================

This is a bare-metal MSX emulator targeting Raspberry Pi (Zero 2, 3A+/B+, 4, 400)
built with the [Circle](https://github.com/rsta2/circle) bare-metal framework.
It boots directly from an SD card, loads C-BIOS, and supports:

- Emulated MegaROM mappers: ASCII8, Konami, Konami-SCC (AUTO detection via
  openMSX-style idiom scan + `cart.mapper` override)
- Physical cartridges via RPMC/MSX bus (connector 1 and/or connector 3)
- Bank-aware cartridge dump with configurable mapper (`msxbus.dumpmapper`)
- On-screen file browser to load `.rom/.bin/.mx1/.mx2` from SD card
- SD-based C-BIOS (`BIOS/*` required at boot)
- Time-driven CPU pacing (blueMSX-compatible, 60 Hz frame budget)

Hardware target (32-bit ARM, Cortex-A53/A72)
- Raspberry Pi 3 (B/B+), 3A+, Zero 2 W
- Raspberry Pi 4, Raspberry Pi 400

Build
-----
Built with `arm-none-eabi-gcc` (16.1.0). Sources under `src/`, app in `src/app`.

```bash
cd /home/opencode/MSX/BlueberryMSX-BareMetal/src/app
make
```

Outputs: `msx.elf`, `msx.lst`, `msx.img` in `src/app/`.

Create SD Card
--------------
This bare-metal build loads from FAT32 on the SD card's first partition. You need:

1. An SD card (≥ 1 GB) formatted FAT32
2. The Circle boot files for your Pi model (Circle typically ships
   `bootcode.bin`, `start*.elf`, `fixup*.dat`, `bcm*.dtb`)
3. `msx.img` (kernel), `config.txt`, and `msx.ini`
4. C-BIOS files in `BIOS/` directory on SD

Quick start (using release bundles)
------------------------------------
Each `release/<ver>/` contains a complete SD card bundle (boot files, DTB,
`msx.img`, `config.txt`, `msx.ini`, and `BIOS/`). To prepare an SD card:

1. Write the contents of `release/v0.14/` (latest tested) to the root of a
   FAT32-formatted SD card. Example (Linux):

```bash
sudo mount /dev/mmcblk0p1 /mnt/sd
cp -a release/v0.14/* /mnt/sd/
sync
sudo umount /mnt/sd
```

2. Insert the SD card into the Pi and power on.

Release v0.14 image md5: `a6a6054ee5c0af9cdc811f8c16d54fc5` (time-driven CPU pacing + ROM header fix; hardware-verified).

Configuration
-------------
`msx.ini` controls machine type, slots, cartridge selection, and MSX bus/cart dump.

Key settings:
- `machine = msx1 | msx2 | msx2+` (default `msx1`)
- `slot1`, `slot2`, `slot3` — slot/subslot mapping
- `cart.mode = msxdiag | slots | romfile` (UI equivalent)
- `cart.rompath = <path>` — default ROM path for file browser
- `cart.mapper = ascii8|konami|konamiscc|none|auto` (AUTO by default)
- `msxbus = on|off`, `msxbus.dump = on|off`, `msxbus.dumpmapper = linear|konami|konamiscc|ascii8`

File browser
-------------
Overlay file browser (F11/menu): navigate directories with Up/Down, Enter to
open directory or load ROM file (`.rom`, `.bin`, `.mx1`, `.mx2`, `.col`).
Loading a ROM selects `ROM FROM FILE` and triggers a soft reset.

BIOS
----
Place C-BIOS files in `BIOS/` on the SD card (C-BIOS is required). The emulator
will halt with an error overlay if `BIOS/*` is missing.

Notes
-----
- `msx.img` embeds `__DATE__`/`__TIME__`, so its md5 is **not reproducible**.
  Build once and record the md5 for that binary.
- Release bundles preserve all versions. Keep each in `release/<ver>/`.

See `AGENTS.md` for toolchain, build/verify rules, and "do not regress"
sections (boot-delay, cart-write/dump, MegaROM mappers, CPU speed/frame pacing).
