# ColecoVision + MSX1 fallback feature images

These are fresh builds from `feature/modular-emulation-architecture` for the
ColecoVision machine option and MSX1 fallback regression.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 542,160 |
| Raspberry Pi 4 | `msx-pi4.img` | 588,048 |

MSX1 remains the default (`msx.ini`: `machine=msx1`). ColecoVision can be
selected in the overlay; its BIOS is not bundled. Place a legally obtained
8 KiB BIOS at `BIOS/colecovision.rom` (or `BIOS/coleco.rom`) on the SD data
partition. Select **ROM FROM FILE** to load a game; 8/16 KiB ROMs mirror in the
32 KiB cartridge window. ColecoVision currently has a basic keypad/joystick
input mapping and SN76489 audio; advanced controller protocols and MegaCart
banking are not included.

Host validation passed:

- `host-test/run_coleco_machine_test.sh` — Coleco memory/I/O/audio path and
  MSX1 default creation.
- `host-test/run_msx1_boot_test.sh` — C-BIOS MSX1 progressed for 600 frames
  (PC `1A65`).
- `host-test/run_msx2_boot_test.sh` — C-BIOS MSX2 progressed for 600 frames
  (PC `1B19`).
- `host-test/run_v9938_test.sh` and `overlay_test` — passed.

Both Circle images built successfully with matching Circle trees: Pi 3 via
`/data/Projects/MSX/circle-msx2-build`, Pi 4 via
`/data/Projects/MSX/circle-v9938-test-build`. Hardware verification of the new
ColecoVision profile is pending. Images are experimental feature-branch test
artifacts, not release images.

The TMS9918 frame hook passes the framebuffer row pitch in bytes (`width * 4`)
to the renderer. This is required for MSX1 and ColecoVision frames to render;
passing the pixel width was rejected as an undersized pitch.
