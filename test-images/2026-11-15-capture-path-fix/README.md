# ALT+F10 capture path-fix hardware test images

Pi 3 and Pi 4 test images built from the current working tree to test creation
of ALT+F10 capture files in a nested `capture/` directory. The bundle also
keeps permanent `boot.log` support enabled through `bootlog=on`.

## Bundle contents

- `msx-pi3.img` — Raspberry Pi 3 build.
- `msx-pi4.img` — Raspberry Pi 4 build.
- `msx.ini` — complete configuration, with `bootlog=on`, MSX2, the physical
  cartridge bus enabled, and `capture.dir=capture`.
- `MD5SUMS` and `SHA256SUMS` — generated from the packaged images.

| Target | Bytes | MD5 |
|---|---:|---|
| Pi 3 | 554,960 | `1ce8358fcd4d652c50f50bb8a8273643` |
| Pi 4 | 601,680 | `29de70ba90c31d07e180988129d404dd` |

Flash only the image matching the Pi. Copy `msx.ini` to the root of the SD
card's **data partition 2** (`emmc1-2`), not the boot partition. Create a
`capture` directory there as well for the normal nested-path test.

## Changes under test

- Circle FAT `FileCreate` now resolves nested paths and creates entries in the
  existing destination directory, extending a directory cluster chain when it
  is full.
- FAT file handles retain the complete relative path through `FileClose`.
- If `capture/` is missing or unusable, capture files fall back to partition
  2's root with the same names. The log states which path was used.
- The UI completion line is now truthful: `UI: capture files written` or
  `UI: capture failed (no file written)`.
- `bootlog=on` keeps a rolling 16 KiB RAM log and flushes the 128 KiB padded
  `boot.log` at early boot, frame 60, and capture entry/end.

## Hardware test

1. Put the matching image and this `msx.ini` on the card and create
   `capture/` on partition 2.
2. Boot Aleste (or another MSX2 program), then press **ALT+F10** once.
3. Wait for the capture to complete, power off, and inspect partition 2.
4. Expected nested-path result: matching files such as `F0000083.PPM`,
   `F0000083.VDS`, and on V9938 `F0000083.CMD` appear in `capture/`.
5. Check `boot.log`. A successful capture includes `capture: VDP state saved:
   capture/...VDS`, PPM/CMD saved lines with their actual paths, and `UI:
   capture files written`.
6. Repeat with the `capture` directory renamed or absent. The files should
   instead appear at partition 2's root, with `capture: cannot use dir
   'capture', wrote ... at the partition root` in `boot.log`.

Return the new `boot.log` and, if possible, one `.VDS` and `.CMD` bundle.
Hardware behavior has not yet been verified; do not promote these images to a
release based only on the successful host/build checks.

## Host/build verification already completed

- `host-test/circle_fat/run_fat_path_test.sh`: FAT16 and FAT32 write, remount
  read, structural, and content verification all passed for 102 files,
  including nested paths and directory-chain extension.
- `run_v9938_test.sh`, `run_msx1_boot_test.sh`, `run_msx2_boot_test.sh`, and
  `run_coleco_machine_test.sh`: passed.
- Both app images were clean-built sequentially: Circle configure + `makeall
  clean`/`makeall`, clean/rebuild `SDCard`, `vc4/vchiq`, `vc4/sound`, and
  `linux`, then clean/build `src/app`.
- Pi 3 linked 40 `sdhost` symbols; Pi 4 linked 0 (expected EMMC2 path).
- The Circle tree is left configured for Pi 3.
