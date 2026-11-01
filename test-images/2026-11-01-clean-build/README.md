# Test images: host-callback seam, clean build (2026-11-01)

Branch: `feature/modular-emulation-architecture`
Status: **Pi 3A+ boot verified 2026-11-01** (`msx-pi3.img`,
`fdb30362aa38e2bfc1e6898f90acf16b`); full MSX1 regression checklist and the
Pi 4 image are still pending.

> Supersedes `../2026-10-29-hostcallbacks/`. Those images were linked against a
> contaminated Circle library set left over from a Pi 4 build, which is the
> likely cause of the blank screen on the Pi 3A+. Do not use them.

## What changed since the last test round

1. **Build fix.** The 2026-10-29 Pi 3 image was 540,752 bytes. A clean Pi 3
   rebuild of the *unmodified v1.0 source* produces exactly 533,072 bytes
   (same size as `release/v1.0/msx-pi3.img`), and this branch produces
   534,096 bytes. That proves the old image was polluted by objects from the
   Pi 4 build of the shared Circle libraries. This bundle was built after
   deleting every Circle archive and object and reconfiguring the target.
2. **Bus-callback lifetime fix.** The core forwards every non-internal I/O
   port to `bus_read_io`/`bus_write_io` whenever those pointers are installed,
   regardless of slot routing. The app now installs only the diagnostic sink
   at `msx_create()` time and hooks the RPMC bus transport in
   `AttachMsxbus()`, i.e. only after the bus is actually initialized. This is
   the same lifetime v1.0 had.
3. **On-screen boot progress.** `Run()` now draws short `boot: ...` lines on
   the framebuffer before the first emulated frame overwrites them. If a boot
   still stalls, the last visible line says where.

## Images

| File | Source | Size | MD5 |
|---|---|---|---|
| `msx-pi3.img` | this branch | 534096 | `fdb30362aa38e2bfc1e6898f90acf16b` |
| `msx-pi4.img` | this branch | 580048 | `fc8af775cceb82b171ad5860ab947065` |
| `control-pi3-v1.0-source.img` | `main` (v1.0 source, built today) | 533072 | `704cf8eabbf156ba53a526209f55f52c` |

`MD5SUMS` and `SHA256SUMS` are included. Images embed `__DATE__`/`__TIME__`,
so checksums change on every rebuild.

## How to test

Use the v1.0 card and replace only the kernel on the boot partition.

```sh
# 1) branch image
cp msx-pi3.img /media/$USER/boot/msx-pi3.img    # Pi 3 / Zero 2 W
cp msx-pi4.img /media/$USER/boot/msx-pi4.img    # Pi 4 / 400 / CM4
sync
```

If the screen stays blank:

```sh
# 2) control: today's build of the untouched v1.0 source
cp control-pi3-v1.0-source.img /media/$USER/boot/msx-pi3.img
sync
```

- Branch boots, control boots: seam and boot-status changes are good.
- Control boots, branch blank: the modular changes are at fault; report the
  last visible `boot:` line.
- Both blank: the problem is the card/build environment, not the emulator
  change; restore `release/v1.0/msx-pi3.img` and confirm v1.0 still boots.

Rollback: copy `release/v1.0/msx-pi3.img` (and `msx-pi4.img` on Pi 4) back.

## What you should see on the branch image

The screen shows, in order, before MSX video replaces them:

```text
BlueberryMSX boot: RASPPI=3 build <date> <time>
boot: video boot status ready
boot: machine created
boot: C-BIOS loaded
boot: cartridge ready
boot: releasing emulation core
```

If it stops, the last line is the phase that hung. A photo of the screen is
enough; a serial capture is better.

## Then the v1.0 regression checklist

- [ ] C-BIOS BASIC screen, 32 KiB ROM from the browser (F11).
- [ ] Konami-SCC MegaROM and ASCII8/16 MegaROM boot and run at v1.0 speed.
- [ ] Physical cart in connector 1 (`msxbus=on`): reads, cartridge writes,
      and board port I/O.
- [ ] Reset between two ROMs from the overlay (exercises `DoReset()`).
- [ ] PSG audio, HDMI and VCHIQ destinations, overlay/browser/mapper menu.

## Build provenance

```sh
cd ../BlueberryMSX/circle
for d in lib lib/usb lib/input lib/fs lib/fs/fat lib/sched lib/sound \
         addon/SDCard addon/linux addon/vc4/vchiq addon/vc4/sound; do
    rm -f "$d"/*.a "$d"/*.o "$d"/*.d
done
./configure -r 3 --multicore -f
for d in <same list>; do make -C "$d" -j4 RASPPI=3; done
cd ../../BlueberryMSX-BareMetal/src/app && make clean RASPPI=3 && make RASPPI=3
```

Repeat with `-r 4` / `RASPPI=4` for the Pi 4 image. Control image was built
from a `main` worktree with the same Pi 3 libraries.

Host checks for this change:

```text
PASS: host callback table routes bus and diagnostics
PASS: Z80 OTIR, VDP/PPI high-byte port aliases, PSG port decode
```
