# Test images: memory-profile address ops (2026-11-02)

Branch: `main`  
Status: **hardware verified 2026-11-02** (full checklist passed on Pi 3A+ and Pi 4)

This step puts memory access behind an address-decode ops table
(`MSX_MemoryOps`) attached to `MSX_Memory`. The MSX1 slot decoder moved out of
`msx.c` into `src/core/msx_memory_msx.c`, with behavior unchanged: slot
routing, MegaROM mapper dispatch, ROM read-only masking, live RPMC bus
forwarding and the 0xE200/0xE210 MegaFlashROM event log all stay in the same
order.

## Images

| File | Target | Size | MD5 |
|---|---|---:|---|
| `msx-pi3.img` | Pi 3 / 3A+ / 3B+ / Zero 2 W | 537424 | `20b95a66c79667b421e48b62c2bbc91a` |
| `msx-pi4.img` | Pi 4 / 400 / CM4 | 583632 | `2740fa1da71d34704668d54998f364c9` |

## Changes

- `include/msx_memory.h`: `MSX_MemoryOps { name, read, write }` and
  `MSX_Memory.ops`/`ctx`; `MSX_Memory` is now a tagged struct.
- `src/core/msx_memory.c`: `msx_memory_set_ops`, plus null-safe
  `msx_memory_read` (0xFF when unconfigured) and `msx_memory_write`.
- `src/core/msx_memory_msx.c`: MSX1 slot-memory backend implementing the ops
  (active page selection, bus subslots, mapper policy, ROM mask).
- `src/core/msx.c`: CPU bus entry points forward to the profile; only the
  MegaFlashROM event log remains machine-local.
- `include/msx.h`: `msx_memory_ops_msx()` for the default backend.

## Host verification

All 15 host tests pass, including the new `memory_ops_test.c`: default MSX
backend attachment, RAM/ROM/empty-slot reads, ROM write masking, live RPMC bus
forwarding, foreign flat-profile replacement and inert forwarders. Existing
seam, CPU/timing, mapper, cart dump (31/31), frame pacer and I/O tests remain
green.

## Hardware checklist

- [ ] C-BIOS BASIC and keyboard input.
- [ ] 32 KB ROMs and Konami/ASCII8/ASCII16/SCC MegaROM games.
- [ ] `ROM FROM FILE` and physical slot behavior.
- [ ] Cartridge writes and bank switching (MegaFlashROM cart).
- [ ] Reset, PSG audio, video, overlay/browser and F-keys.
- [ ] Pi 3A+ and Pi 4 both pass.

Rollback: `release/v1.0/`.
