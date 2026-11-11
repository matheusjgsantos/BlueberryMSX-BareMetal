# V9938 R#14 page-preserve candidate test images (2026-11-11)

Experimental Pi images for a confirmed V9938 address-pointer bug that may
contribute to missing/corrupted MSX2 SCREEN 5 graphics in Space Manbow and
V-Killer. Headless probes improved after the fix, but this does not establish
that gameplay graphics are fixed. The user reports both games are still
corrupted; **hardware verification is pending, and these are test images only,
not releases.**

## Root cause

Setting a VRAM address through port `0x99` used to do `reg[14] &= 0xF8`, which
clears the low three bits of R#14. Those bits are **A16-A14** of the VRAM
address, so every addressed CPU read/write after an address setup was forced
back into the first 16 KiB (`0x0000-0x3FFF`) regardless of what the game had
programmed.

The BlueberryMSX reference (`VDP.c` `writeLatch` / `vdpRegs[14]`) and openMSX
(`VDP.cc` `executeCpuVramAccess` with `controlRegs[14]`) both preserve R#14
when the 14-bit address pointer is set. R#14 only changes on an explicit
register write or when the pointer wraps past `0x3FFF`.

This is consistent with the earlier captures: game buffers at `0x10000+` were
empty and R2=0x3F frames were black. Those captures are timestamped 06:26,
before these images were built at 06:37, so they are not post-fix validation.

## Fix

`src/chips/vdp/v9938.c`: the port-`0x99` address-set path no longer modifies
R#14. Auto-increment still bumps A14-A16 when the 14-bit pointer wraps.

Host regression `host-test/v9938_test.c` (`test_v9938_address_set_preserves_r14`)
covers an address setup with R#14=4 (page `0x10000`) and the `0x3FFF` wrap.

## Evidence

Headless `host-test/run_vdp_usage_probe.sh` (same core as the Pi build; useful
for core diagnostics, not a substitute for hardware gameplay validation):

| Run | Before fix | After fix |
|---|---|---|
| V-Killer, 600 frames | `VRAMnz=896`, all data in `0x0000-0x3FFF` | - |
| V-Killer, 1300 frames | - | `VRAMnz=33,285`, pages 0-7 populated, rendered frame 182/192 non-black lines |
| Space Manbow, 1300 frames | - | `VRAMnz=54,014` across `0x4000-0x7FFF` and `0x10000-0x1FFFF` |

Other host checks passing: `run_v9938_test.sh`, `run_msx1_boot_test.sh`,
`run_msx2_boot_test.sh` (C-BIOS logo + finished transfer), and
`run_coleco_machine_test.sh`; CPU timing/seam and mapper-policy tests report no
mismatches.

## Images

| Target | Image | Bytes | MD5 |
|---|---|---:|---|
| Raspberry Pi 3 | `msx-pi3.img` | 546,128 | `5c07e824031400a9db5ec6e070a341bd` |
| Raspberry Pi 4 | `msx-pi4.img` | 592,336 | `603d1ecdbde4771af650833dd49b7c4f` |

Flash the image for the matching Pi. Test both games:

1. Space Manbow — gameplay graphics should now fill the screen instead of a
   thin top band.
2. V-Killer — same, and page flips to R2=0x3F should show picture rather than
   black.

The currently available capture set (`F0000099`–`F000051D`, 17 PPM/VDS pairs)
is timestamped 06:26, before these images were built. Please verify the flashed
image MD5, play both games, and create fresh ALT+F10 `.PPM`/`.VDS` pairs after
the fix if graphics remain wrong.

Check image integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```
