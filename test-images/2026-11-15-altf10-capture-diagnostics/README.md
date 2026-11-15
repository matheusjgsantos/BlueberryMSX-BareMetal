# ALT+F10 capture diagnostics test images (2026-11-15)

Diagnostic build to localize why ALT+F10 no longer produces capture files on
hardware, while ALT+F11/ALT+F12 still work.

## What changed

1. `CKernel::CaptureFrameAndVdp()` logs `capture: enter (fs=… machine=… dir=…)`
   at entry and the failing path when `FileCreate` fails.
2. `CMsxTask` logs `UI: F10 capture requested` when the F10 shortcut is
   dispatched.
3. **`boot.log` on the SD data partition (partition 2, `emmc1-2`).** The kernel
   keeps a rolling 16 KiB RAM log and flushes it to `boot.log` as a padded
   128 KiB file (small FAT writes hang this Circle build; 128 KiB is the size
   class that writes reliably) at these checkpoints:
   - right after `boot: video boot status ready` (early boot, before the
     VCHIQ sound init),
   - a one-shot boot checkpoint at emulated frame 60, and
   - the start and end of every ALT+F10 capture attempt (including the
     failure early-returns).

   The flush runs on core 0 only. Because the early and frame-60 checkpoints
   fire even if ALT+F10 is never pressed, `boot.log` is the primary record for
   both a boot that stops early and a capture that produces no files.
   Control this with `bootlog = on` or `bootlog = off` in `msx.ini`; it
   defaults to `on`.

No emulation behavior change.

## How to use

1. Flash the image that matches the board (Pi 3 vs Pi 4 — do not mix).
2. Ensure `capture.dir = MSX/CAPTURE` in `msx.ini` and that `MSX/CAPTURE`
   exists on the SD data partition (partition 2, `emmc1-2`).
3. Boot; `boot.log` should appear at the root of the data partition almost
   immediately (early checkpoint). If it never appears, note where the splash
   stopped.
4. Run Aleste, then press ALT+F10.
5. Read `boot.log` (a 128 KiB padded text file; the text is at the top).
   Report the `UI:` and `capture:` lines.

## Images

| Target | Image | Bytes | md5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 554,128 | `9fadac0bd0614a5c31acb5d7e7d19fb2` |
| Raspberry Pi 4 | `msx-pi4.img` | 600,720 | `defc7973eda50729e0af5be199c265e0` |

## Build note (important)

Both images were built **fully clean for their own target**: `configure -r N`,
`makeall clean && makeall`, then `make clean && make` for each Circle addon
(`SDCard`, `vc4/vchiq`, `vc4/sound`, `linux`), then `make clean RASPPI=N && make
RASPPI=N` in `src/app`. `makeall` does **not** clean the addons, so switching
Pi 3/Pi 4 without cleaning them links wrong-architecture addon archives; that
was the cause of the previous image stopping right after
`boot: video boot status ready` (the next step, `m_pSound->Start()` via VCHIQ,
hangs on a wrong-arch addon).

Sizes relative to the hardware-verified `2026-11-14-aleste-line-interrupt`
images: Pi 3 553,104 -> 554,128 (+1,024 B); Pi 4 599,632 -> 600,720 (+1,088 B).
Pi 3 links the SDHOST SD driver (40 `sdhost` symbols); Pi 4 uses the EMMC2 path
(no `sdhost` symbols).

Host regression checks passed: `run_v9938_test.sh`, `run_msx1_boot_test.sh`,
`run_msx2_boot_test.sh`, `run_coleco_machine_test.sh`.
(`run_cbios_msx2_boot_test.sh` is stale and references a removed
`src/core/msx_profile.c`; pre-existing, unrelated to this build.)

Tree is left configured/built for Pi 3. Hardware verification is still pending:
flash the Pi-matched image, confirm `boot.log` appears, then press ALT+F10 and
report the `boot.log` contents.
