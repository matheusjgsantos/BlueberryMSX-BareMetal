# Test images: MSX memory profile (2026-11-02)

Branch: `main`  
Status: **hardware verified 2026-11-02** (Pi 3 and Pi 4 boot correctly; games run
from physical slots)

This step moves MSX1 slot storage and active-page selection into an embedded
`MSX_Memory` profile. Existing `machine->slots[]` and
`machine->activeSlot[]` expressions remain valid through compatibility
pointers; no machine behavior or mapper policy changes.

## Images

| File | Target | Size | MD5 |
|---|---|---:|---|
| `msx-pi3.img` | Pi 3 / 3A+ / 3B+ / Zero 2 W | 537168 | `59ace709cf106bd7c098bad8fcd9b232` |
| `msx-pi4.img` | Pi 4 / 400 / CM4 | 583312 | `15faa25341a5b11ca669e254073ab6e5` |

## Changes

- `include/msx_memory.h`: `MSX_Memory` owns slots, `slotReg`, and
  `activeSlot[]`; `msx_memory_init()` initializes all subslots as emulated
  (`busSlot = -1`).
- `include/msx.h`: `MSX_Machine.memory` is the owned profile;
  `machine->slots` and `machine->activeSlot` remain source-compatible pointers.
  `machine->slotReg` remains a scalar compatibility mirror.
- `src/core/msx_memory.c`: profile initialization.
- `src/core/msx.c`: attaches the owned profile at creation and keeps port-A
  slot writes synchronized with the compatibility scalar.

## Host verification

All 14 host tests pass, including `memory_profile_test.c`: owned storage,
pointer aliases, profile initialization, slot selection and port readback.
The video/audio/input seams, CPU/timing tests, mapper tests, cart dump (31/31),
frame pacer and I/O regression also pass.

## Hardware checklist

- [ ] C-BIOS BASIC and keyboard input.
- [ ] 32 KB ROMs and MegaROM mapper games.
- [ ] `ROM FROM FILE` and physical slot behavior.
- [ ] Cartridge reads/writes and bank switching.
- [ ] Reset, PSG audio, video, overlay/browser and F-keys.
- [ ] Pi 3A+ and Pi 4 both pass.

Rollback: `release/v1.0/`.
