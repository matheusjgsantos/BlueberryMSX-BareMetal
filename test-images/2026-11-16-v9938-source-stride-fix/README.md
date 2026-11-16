# V9938 source-stride correction — Pi 3 / Pi 4 hardware test

**Hardware verification pending.** This supersedes
`../2026-11-16-v9938-kernel-memory-fix/`, which boots but shows a large gap
between source lines on SCREEN 5. It also includes the earlier kernel-memory
fix (Circle `_end` must remain below `0x208000`).

## Root cause and evidence

The VDP always writes `s_TempFrame` with a **512-pixel stride**, even when
the mode exposes only 256 dots. HDMI scaling and both RGB888 capture paths
mistakenly read it as tightly packed 256-dot rows. Hardware ALT+F10 capture
`/home/opencode/MSX/capture/F00002A1.PPM` is `256x212`: **every one of its
106 even rows** matches the corresponding row in the `.VDS`/`.CMD` replay,
while odd rows read the unused right half of the source buffer. Replaying the
same `.VDS` and `.CMD` with the correct 512-pixel stride shows an intact
Aleste HUD and playfield. The replay is emulator evidence, not proof that
the new image has the correct HDMI output on hardware.

The blitter now accepts source stride separately from visible source width;
both ALT+F10 and periodic PPM pack each rendered row with that stride, and
video diagnostics skip the unused row space. The offline `.VDS` replay tool
uses the same RGB888 packer. The host blit test covers 256-dot content in
512-dot rows, sentinel padding, the final 212-line row, and 512-dot output.

## Bundle contents and deployment

- `msx-pi3.img` / `msx-pi4.img`: separately clean-built with matching Circle
  and addon libraries; select the matching board using your existing working
  `config.txt` and boot firmware on partition 1.
- `msx.ini`: complete MSX2 physical-bus configuration with `bootlog=on` and
  `capture.dir=capture`; copy to the **second** SD partition.
- `text2-layout-preview.png`: synthetic renderer output, not hardware proof.
- `MD5SUMS`, `SHA256SUMS`: verify exact packaged images.

| Board | Bytes | MD5 | Kernel `_end` | SDHOST symbols |
|---|---:|---|---:|---:|
| Pi 3 | 558,936 | `c65f90be2288d91ebc0c26b9b0b9fece` | `0x001a7b60` | 40 |
| Pi 4 | 605,592 | `7e20615071b5a0c82aa89304cae5ea10` | `0x001b3228` | 0 |

## Please test

1. Boot each board. Check whether the large gaps are gone and SCREEN 5 Aleste
   has the top HUD and complete 212-line playfield; report if anything else
   changed, especially the numbered pickups and bottom of the screen.
2. Press ALT+F10 during actual gameplay; copy the new `.PPM`/`.VDS`/`.CMD`
   and `boot.log` files. The PPM should be `256 212` for Aleste, with **212
   contiguous rendered rows** (not alternating lines). SCREEN 6/7 and TEXT2
   still scan out native 512-dot width.
3. Check an MSX1 game and, if available, SCREEN 6/7 or TEXT2 on each Pi.

## Verification before hardware

- `bash host-test/run_v9938_test.sh`, ASan/UBSan V9938 and blit tests,
  `run_msx1_boot_test.sh`, `run_msx2_boot_test.sh`,
  `run_coleco_machine_test.sh` and `circle_fat/run_fat_path_test.sh`: PASS.
- Pi 3 and Pi 4 Circle/addons/app: clean-built per target; both `make` runs
  passed the `_end <= 0x208000` guard. The packaged MD5 and SHA-256 manifests
  were independently verified against both exact image files.

This is an MSX2 test image, **not a v2 release**. Other V9938 timing and
whole-machine gaps remain in `Docs/MSX2_COMPLETION.md`.
