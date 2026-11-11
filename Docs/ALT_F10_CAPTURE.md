# ALT+F10 VDP capture

While emulation is running, press **ALT+F10** to pause the frame loop briefly
and capture a matching RGB PPM screenshot (`.PPM`) plus a binary VDP snapshot
(`.VDS`). Files are written only to the mounted SD data filesystem (the
second partition, `emmc1-2`); no boot-partition fallback is used.

Configure the relative destination in `msx.ini` on that data partition:

```ini
capture.dir = MSX/CAPTURE
```

Create that directory on the card first. Paths are relative to the data
partition root. Use slash-separated components and FAT-compatible names; the
default `MSX/CAPTURE` is an 8.3-compatible example. Captures use matching
`Fxxxxxxx.PPM` and `Fxxxxxxx.VDS` names based on the emulated frame number.
The capture path is independent of the optional `diag=on` periodic dump.

The PPM is 256x192 RGB888. The `.VDS` file is little-endian and contains:

1. Eight-byte signature `MSXVDPS1`.
2. Four 32-bit values: format version (1), machine profile, frame number,
   VRAM byte count.
3. 64 VDP register bytes, four status bytes, 48 palette bytes (zero for
   TMS9918), then the complete VRAM image (16 KiB TMS9918, 128 KiB V9938).

The host file writer runs on core 0 while core 1 is paused at a handoff, so
FAT access does not race the emulator. Creating files in a configured
subdirectory depends on the path-aware `CFATDirectory::CreateEntry` support in
the matching Circle tree; the feature-branch build trees were updated for
that behavior. The Circle FAT file handle must retain the complete relative
path through `FileClose` (its original 12-byte title field truncated
subdirectory names), so the updated tree uses a 256-byte path field. Hardware
verification is required to validate the SD write on the target card.
