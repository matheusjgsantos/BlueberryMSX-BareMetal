# boot.log flag hardware test images

Pi 3 and Pi 4 test images built from the current working tree to exercise the
new `bootlog` setting in the complete `msx.ini` shipped alongside them.

## Bundle contents

- `msx-pi3.img` — Raspberry Pi 3 build.
- `msx-pi4.img` — Raspberry Pi 4 build.
- `msx.ini` — complete supported configuration, with `bootlog=on`, MSX2, and
  the physical cartridge bus enabled.
- `MD5SUMS` and `SHA256SUMS` — generated from the packaged images.

| Target | Bytes | MD5 |
|---|---:|---|
| Pi 3 | 554,192 | `358ff1e066ce706b9c6de7fd4185300e` |
| Pi 4 | 600,720 | `b18ba3cd85a10eeda3e2bd47f3852587` |

Copy the `msx.ini` file to the root of the SD card's **data partition 2**
(`emmc1-2`), not the boot partition. Flash only the image matching the Pi.

## Test boot.log on/off

1. With `bootlog=on`, boot and confirm `boot.log` appears at the root of
   partition 2. It is a 128 KiB padded file; the text is at the start.
2. Change the setting to `bootlog=off` and reboot. New boot log lines should
   no longer be written to `boot.log`. The option does not delete a file from
   the previous boot, so remove or rename that file before testing if you want
   a clear absence/update check.
3. `bootlog=off` does not disable UART logging or other output files.

## Capture diagnostic status

The config sets `capture.dir=capture`; create that directory on the data
partition if testing ALT+F10. The current Circle FAT `FileCreate` path handling
does not yet create files in nested directories, so ALT+F10 VDP-state creation
is still expected to fail for this setting. The boot log should nevertheless
record `UI: F10 capture requested` and the `capture: ...` failure. This bundle
does not claim that capture-file creation is fixed.

## Build/verification

Both images are clean-built sequentially for their own `RASPPI` setting:
Circle configure + `makeall clean`/`makeall`, clean and rebuild `SDCard`,
`vc4/vchiq`, `vc4/sound`, and `linux` addons, then clean/build `src/app`.
Build results: both app builds succeeded; Pi 3 linked 40 `sdhost` symbols,
Pi 4 linked 0 (expected EMMC2 path). The Circle tree is left configured for
Pi 3. Hardware behavior has not been verified yet; report whether `boot.log`
is created/updated for each setting.
