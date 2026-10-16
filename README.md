BlueberryMSX Bare-Metal (Circle)
================================

Bare-metal MSX emulator built with [Circle](https://github.com/rsta2/circle).
Release **v1.0** is hardware-verified on Raspberry Pi Zero 2 W, 3A+/B+, 4, and
400. It boots directly from the Pi firmware and loads C-BIOS from the SD data
partition.

Features include ASCII8, Konami, and Konami-SCC MegaROM emulation; physical
cartridges through the RPMC/MSX bus; bank-aware cartridge dumps; a USB-keyboard
controlled SD ROM browser; PSG audio; and time-driven 60 Hz CPU pacing.

## SD card setup

Use an SD card with two FAT32 partitions, in this order:

| Partition | Purpose | Files |
|---|---|---|
| 1 (boot) | Pi firmware and directly booted Circle application | Raspberry Pi boot firmware/DTBs, `config.txt`, `msx-pi3.img`, `msx-pi4.img`, `armstub7-rpi4.bin` |
| 2 (data; Circle device `emmc1-2`) | Emulator configuration and content | `msx.ini`, `BIOS/`, optional `ROMS/`; runtime dumps are written here |

Do not put `msx.ini` or `BIOS/` on the boot partition. The emulator reads them
from partition 2, and keeps its cartridge/frame dumps off the boot files.
`BIOS/` must contain the C-BIOS files shipped in the release bundle. `ROMS/` is
optional; ROM images can also be placed in subdirectories on the data partition.

### Install the v1.0 release

Start with a card whose first partition has the Raspberry Pi boot firmware for
these boards and whose second FAT32 partition is the emulator data partition.
The firmware files (for example `start.elf`, `fixup.dat`, `start4.elf`,
`fixup4.dat`, `bootcode.bin`, and model DTBs) come from the matching Raspberry
Pi firmware distribution or the Circle `boot/` assets; they are not generated
by building the MSX application. Keep the matching DTB for each board on the
boot partition; the release includes the Zero 2 W DTB, and the firmware bundle
provides the Pi 3/Pi 4/Pi 400 DTBs.

Mount partition 1 at `/mnt/msx-boot` and partition 2 at `/mnt/msx-data`, then
copy the payload into the corresponding partition roots:

```sh
cp release/v1.0/config.txt release/v1.0/msx-pi3.img \
   release/v1.0/msx-pi4.img release/v1.0/msx.img \
   release/v1.0/armstub7-rpi4.bin \
   release/v1.0/bcm2710-rpi-zero-2-w.dtb /mnt/msx-boot/
cp release/v1.0/msx.ini /mnt/msx-data/
cp -a release/v1.0/BIOS /mnt/msx-data/
sync
```

`config.txt` selects `msx-pi3.img` on Pi Zero 2 W and Pi 3 (including 3A+/B+),
and `msx-pi4.img` on Pi 4 and Pi 400. `msx.img` is a Pi 3 compatibility alias.
After copying, safely unmount both partitions and boot the Pi.

## Build both Pi targets

The app sources are under `src/`; the entry point and Circle application are in
`src/app/`. Use an `arm-none-eabi` toolchain with hard-float newlib and a Circle
checkout at `../BlueberryMSX/circle` (relative to this project). Circle's static
libraries are shared between targets and Make does not track changes to the
`RASPPI` compiler define. **Clean and rebuild Circle's libraries whenever
switching between Pi 3 and Pi 4.** Otherwise a Pi 4 image can accidentally link
the Pi 3 SDHOST backend.

For each target (`3`, then `4`), configure Circle and rebuild its libraries,
SDCard/Linux/VCHIQ add-ons, and the app for the same target. Example for Pi 4:

```sh
cd ../BlueberryMSX/circle
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

The app build produces `src/app/msx.img` (plus `msx.elf`, `msx.lst`, and
`msx.map`). Copy that image to `release/v1.0/msx-pi4.img`. Repeat after
configuring Circle with `-r 3` and building the app with `RASPPI=3`; copy that
image to `msx-pi3.img` and to the `msx.img` compatibility alias. The release's
`config.txt` maps models to their matching image. Circle's `boot/` directory
contains the Pi boot support assets; the app build itself creates the
`msx.img` kernel, not the Pi firmware.

## Configuration and controls

`msx.ini` controls machine type, logging, cartridge selection, and physical bus
behavior. Common settings include `machine=msx1`, `cart.mapper=auto|ascii8|
konami|konamiscc|none`, `msxbus=on|off`, `msxbus.dump=on|off`, and
`msxbus.dumpmapper=linear|konami|konamiscc|ascii8`. Only MSX1 is currently
implemented; MSX2/2+ BIOS sets are included for future core support.

Use the overlay menu to open **ROM FROM FILE** and load `.rom`, `.bin`, `.mx1`,
`.mx2`, or `.col` files from the data partition. USB keyboard F11 opens the
overlay; use arrows and Enter to navigate.

## Release notes

`release/v1.0/` is the current release bundle. Previous versions are preserved
under `release/`. See [RELEASE.md](RELEASE.md) for the changelog and image
checksums. Images embed build date/time, so a rebuild of identical source has a
different checksum; record checksums from the exact binaries copied into a
release bundle.
