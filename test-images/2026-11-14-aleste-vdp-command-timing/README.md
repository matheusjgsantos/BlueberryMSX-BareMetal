# Aleste VDP command/status timing trace images (2026-11-14)

Diagnostic Pi 3/Pi 4 images for the Aleste MSX2 investigation. This build
changes trace data only; VDP rendering and command execution semantics are
unchanged.

The `.CMD` sidecar now includes:

- `cmd` records with emulated master-clock time and Z80 PC at command launch.
- Up to 1,024 `status2` records with time, PC, and returned S#2 value. This
  captures CE/TR polling and shows whether Aleste waits for commands to finish.
- Existing HMMC payload records (`data`) and direct CPU VRAM access records.

Compare each D0 launch with subsequent S#2 polling and the next launch. The
current emulator executes D0 commands synchronously, so this trace is intended
to establish whether Aleste polls CE and how its command cadence relates to the
missing command-engine timing model. It does not itself establish hardware
timing or diagnose/fix the graphics corruption.

Cold-start Aleste and capture matching `.PPM`, `.VDS`, and `.CMD` files during
the affected scene. Keep the capture after the game has reached the corrupted
state; the S#2 history is a rolling window of the latest 1,024 reads.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 553,040 |
| Raspberry Pi 4 | `msx-pi4.img` | 599,440 |

Verify image integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```

Both ELF load footprints are below Circle's 2 MiB limit. V9938, MSX1, and
MSX2 host tests passed. Hardware boot/capture verification is pending; no
release image was changed.
