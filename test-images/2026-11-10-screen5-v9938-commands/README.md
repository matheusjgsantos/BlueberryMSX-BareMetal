# SCREEN 5 V9938 command-path test images

Experimental feature-branch builds with synchronous V9938 SCREEN 5 / Graphic 4
support for HMMV, HMMM and HMMC. HMMC is used by the MSX2 C-BIOS splash.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 545,104 |
| Raspberry Pi 4 | `msx-pi4.img` | 591,248 |

Flash the image matching your Raspberry Pi model. Keep the existing second
SD-card data partition and its BIOS/configuration files. This is an
experimental test image, not a release; the C-BIOS splash and V-Killer still
need hardware verification.

Host checks passed: `host-test/run_v9938_test.sh`,
`host-test/run_msx1_boot_test.sh`, `host-test/run_msx2_boot_test.sh`,
`host-test/run_coleco_machine_test.sh`, and `git diff --check`.
