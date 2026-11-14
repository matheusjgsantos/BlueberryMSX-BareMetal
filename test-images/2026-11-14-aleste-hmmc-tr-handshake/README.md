# Aleste HMMC/TR handshake diagnostic images (2026-11-14)

Pi 3/Pi 4 test images for the Aleste MSX2 VDP investigation. These are
diagnostic builds, **not a graphics fix**. They leave VDP transfer behavior
unchanged and extend the HMMC trace so it can capture Aleste's full initial
10,880-byte transfer (128 bytes x 85 rows).

The `.CMD` sidecar records up to 16,384 HMMC bytes. Each `data` line contains:

```text
data <sequence> <command-sequence> <cpu-time> TR=<ready-before-write> <address> <byte>
```

`cpu-time` is the emulated CPU clock in master ticks (32-bit, wraps); `TR` is
the VDP transfer-ready flag immediately before the byte is consumed. This
helps compare CPU write spacing/readiness against the timed HMMC implementation
in `msxbarepi`. The sidecar buffer is heap-allocated; allow the SD write to
finish because `.CMD` files can be large.

For a useful capture, cold-start Aleste and save matching `.PPM`, `.VDS`, and
`.CMD` triplets once during initial loading/setup, then again when the
corruption is visible. Do not change VDP timing or graphics settings between
captures. The first capture should include the complete initial HMMC stream.

| Target | Image | Bytes |
|---|---|---:|
| Raspberry Pi 3 | `msx-pi3.img` | 552,656 |
| Raspberry Pi 4 | `msx-pi4.img` | 599,056 |

Verify image integrity with:

```sh
md5sum -c MD5SUMS
sha256sum -c SHA256SUMS
```

Both ELF load footprints were checked against Circle's 2 MiB kernel limit.
Host V9938 and MSX1/MSX2 boot tests passed. Hardware boot and SD capture
verification remain pending. No release image was changed.
