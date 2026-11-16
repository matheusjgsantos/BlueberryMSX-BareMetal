# V9938 native-width test — kernel memory fix

**Hardware verification pending.** This candidate supersedes
`../2026-11-16-v9938-command-512-text2/`, whose Pi 3 and Pi 4 images both
showed a blank screen and produced no `boot.log`. The last known booting pair
on the user's boards is `../2026-11-16-aleste-top-crop-hud-fix/`.

## Root cause and fix

The earlier 512-dot tranche grew three static frame/capture buffers. The Pi 3
ELF linked with `_end=0x2469e0`, beyond Circle's fixed 32-bit kernel region
`MEM_KERNEL_START + KERNEL_MAX_SIZE = 0x8000 + 0x200000 = 0x208000`. Circle
`sysinit` explicitly halts at this check before `main()`, screen setup or
`boot.log`. Checking only the raw `.img` byte count missed the BSS overflow.

The ALT+F10 and optional periodic-dump RGB buffers now allocate from the heap
only while capturing and are freed afterwards; the 512x212 source framebuffer
remains static. `src/app/Makefile` checks `_end <= 0x208000` on every default
`make`, and fails the build if it exceeds Circle's reserved kernel range.

The corrected Pi 3 ELF linked with `_end=0x001a7a20` (394,720 bytes below
the limit); Pi 4 linked with `_end=0x001b30e8` (347,928 bytes below). This is
a **static fix and build check**, not a claim of a successful hardware boot;
please verify both boards.

## Bundle contents

- `msx-pi3.img` and `msx-pi4.img`: separately cleaned Circle, addon and app
  builds for their respective boards.
- `msx.ini`: complete data-partition configuration (`machine=msx2`, physical
  bus on, `bootlog=on`, `capture.dir=capture`).
- `text2-layout-preview.png`: synthetic host renderer output (not hardware
  evidence).
- `MD5SUMS`, `SHA256SUMS`: checksums of the exact bundled images.

Copy only the matching image to boot partition 1; keep the existing working
firmware and `config.txt`. Copy `msx.ini` to the root of data partition 2.

## Hardware verification requested

1. Boot both Pi 3 and Pi 4. Record the last visible `boot:` line and whether
   a **new** `boot.log` appears on partition 2. If either is still blank,
   report that before testing games.
2. On a successful boot, check Aleste gameplay (HUD, complete bottom, numbered
   pickups), an MSX1 cartridge regression, and SCREEN 6/7 or TEXT2 if available.
3. Press ALT+F10 and provide `boot.log`, `.PPM`, `.VDS` and `.CMD` captures.
   SCREEN 6/7 and TEXT2 use native 512-dot PPM width.

## Included VDP changes

This image includes `84bc929` (native 192/212-line display and reference
sprite mode 2), `a17a1e2` (LINE/LMCM/SRCH semantics), `782be91` (native
512-dot SCREEN 6/7) and `30f7324` (native TEXT2 80-column scanout and blink).
It is not a v2 release candidate: TEXT1 parity, beam-time sprite/IRQ/status,
command duration/CE, interlace, RTC and disk remain open; see
`Docs/MSX2_COMPLETION.md`.

## Host/build evidence

- V9938 conformance/raster tests, framebuffer blit, MSX1/MSX2 600-frame boot
  and Coleco regression: PASS after the memory fix.
- Pi 3 and Pi 4 Circle/addons/app: clean builds. Both MD5/SHA-256 manifests
  verified against the packaged files. Hardware boot is **not verified**.

| Target | Bytes | MD5 | `_end` | SDHOST symbols |
|---|---:|---|---:|---:|
| Pi 3 | 558,616 | `ca24d13bdc07e47fa0e5da52efd9dcde` | `0x001a7a20` | 40 |
| Pi 4 | 605,272 | `09e69a839f3db3fce663d7f710603aae` | `0x001b30e8` | 0 |
