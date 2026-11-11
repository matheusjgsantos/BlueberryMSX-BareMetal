# ALT+F10 frame and VDP capture test images

Feature-branch images containing the restored **ALT+F10** capture path.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 543,888 |
| Raspberry Pi 4 | `msx-pi4.img` | 589,968 |

Set `capture.dir = MSX/CAPTURE` in `msx.ini` on the data partition (partition
2, `emmc1-2`), and create that directory on the card first. ALT+F10 writes a
256x192 RGB PPM and a `.VDS` file containing registers, status, palette and
full VRAM. Format details and configuration are in `Docs/ALT_F10_CAPTURE.md`.

Host regression checks passed: `run_v9938_test.sh`, `run_msx1_boot_test.sh`,
`run_msx2_boot_test.sh`, and `run_coleco_machine_test.sh`. Both Pi builds
completed against their matching Circle trees. Subdirectory creation and full
path retention through file close were enabled in the Pi 4 Circle FAT tree;
actual SD-card capture and the reported garbled graphics still need hardware
capture/inspection.
