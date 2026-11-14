# ALT+F10 VDP capture

While emulation is running, press **ALT+F10** to pause the frame loop briefly
and capture a matching RGB PPM screenshot (`.PPM`) plus a binary VDP snapshot
(`.VDS`). On MSX2/V9938, a command-history text sidecar (`.CMD`) is also
written. Files are written only to the mounted SD data filesystem (the second
partition, `emmc1-2`); no boot-partition fallback is used.

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

The optional `.CMD` sidecar begins with `MSXVDPCMD1`, followed by cumulative
counts for each raw R#46 command byte since VDP reset and up to the latest 1024
R#46 writes in chronological order. Each event records the sequence number,
command byte, ARG/COL, and decoded SX/SY/DX/DY/NX/NY values. The bounded event
history lets captures identify command types that are not implemented without
changing the stable VDS format. Counts are cumulative; event sequence numbers
are global since reset, not frame-local. The same sidecar includes cumulative
CPU-port VRAM read/write counts for each 16 KiB bank plus the latest 2048 direct
VRAM-port accesses (`sequence`, `R`/`W`, address, byte). Read entries log bytes
fetched into the VDP read buffer, including the initial address prefetch.
The sidecar also records command launch CPU time (emulated master ticks) and
PC on each `cmd` line, plus the latest 1024 VDP status reads - every register
selected by R#15, so S#0/S#1 acknowledgements are visible next to the S#2 CE
polls - as `status <sequence> time=<ticks> pc=<PC> reg=<n> value=<byte>`. This shows whether
software polls CE/TR and how command launches relate to those polls. The
sidecar also records the latest 16384 R#44 bytes consumed by HMMC (`data`
sequence, command sequence, CPU time in emulated master ticks, TR-ready state
before the write, destination address, byte). This transfer-data history is
separate from direct CPU VRAM-port writes. The timestamp wraps with the 32-bit
CPU clock. These bounded histories can make `.CMD` sidecars several hundred KiB.

The host file writer runs on core 0 while core 1 is paused at a handoff, so
FAT access does not race the emulator. Creating files in a configured
subdirectory depends on the path-aware `CFATDirectory::CreateEntry` support in
the matching Circle tree; the feature-branch build trees were updated for
that behavior. The Circle FAT file handle must retain the complete relative
path through `FileClose` (its original 12-byte title field truncated
subdirectory names), so the updated tree uses a 256-byte path field. Hardware
verification is required to validate the SD write on the target card.
