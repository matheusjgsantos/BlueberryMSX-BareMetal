# Aleste diagnostic D0 CE timing images (2026-11-14)

Diagnostic B-builds for the Aleste MSX2 graphics investigation. Use these
against the trace-only A-builds in `2026-11-14-aleste-vdp-command-timing/`.

The opt-in `V9938_DIAGNOSTIC_TIMED_D0_CE=1` build option holds S#2 CE busy
after D0/HMMM for the reference BlueberryMSX HMMM timing-table duration. The
VRAM copy still happens immediately and produces the same bytes as the A-build;
only the visible CE timing changes. Other command types are unchanged. This is
an isolation experiment, not a complete timed VDP command engine or a confirmed
graphics fix. It is not enabled in normal/release builds.

Please cold-start Aleste on the same hardware and compare the brief correct
graphics interval and subsequent corruption against the A-build. Capture
matching `.PPM`, `.VDS`, and `.CMD` files in both runs, including a capture
after corruption returns. The expected diagnostic effect is longer CE waits
between D0 launches; report whether the correct image lasts longer, corruption
changes, or behavior is unchanged.

| Target | Image | Bytes | ELF LOAD MemSiz |
|---|---|---:|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 553,360 | `0x1ac58c` |
| Raspberry Pi 4 | `msx-pi4.img` | 599,760 | `0x1b7b54` |

Both load footprints are below Circle's 2 MiB limit. Verify integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```

Host V9938 tests pass with and without the diagnostic define; MSX1 and MSX2
600-frame boot tests pass. Pi 3/Pi 4 Circle builds pass. Hardware boot and
graphics behavior remain unverified. No release images were changed.
