# TMS9918 (MSX1 VDP) — Protocol Ground Truth and Renderer Design

This document records the *real* MSX1 VDP behavior, derived from C-BIOS
(`Docs/cbios-0.29a/src/video.asm`, `sub.asm`, `main.asm`) and openMSX
(`src/video/CharacterConverter.cc`), so the emulator can render a correct
screen instead of the previous fictional register mapping.

## MSX1 I/O Port Map

| Port | Direction | Use |
|------|-----------|-----|
| `0x98` | R/W | VRAM data (auto-increment address) |
| `0x99` | W | VDP control: register writes and VRAM address set (2-byte commands) |
| `0x99` | R | Status register (bit 7 = sync flag; reading clears the IRQ latch) |

`0x9A`-`0x9F` are palette/second-data ports used by V9938-class VDPs; a real
MSX1 TMS9918 ignores them. (C-BIOS only uses `0x9A`/`0x9B` under its non-MSX1
code paths.)

## Register Write Protocol (`wrtvdp`)

Two bytes to port `0x99`, **value first**, then `0x80 | register`:

```asm
        ld      a,b          ; b = value
        out     (VDP_ADDR),a ; out 0x99, value
        ld      a,c          ; c = register number
        or      $80
        out     (VDP_ADDR),a ; out 0x99, 0x80|reg
```

Example (`vdp_bios` in C-BIOS): `$00,$80 $70,$81 $00,$82 $01,$84 $F5,$87`
means R0=$00, R1=$70, R2=$00, R4=$01, R7=$F5.

## VRAM Address Set (`SETWRT` / `SETRD`)

Two bytes to port `0x99`:

```
write mode (SETWRT):  out 0x99, ADDR_LOW            ; full low byte
                      out 0x99, (ADDR_HIGH & 0x3F) | 0x40
read  mode (SETRD):   out 0x99, ADDR_LOW
                      out 0x99, (ADDR_HIGH & 0x3F)          ; no 0x40
```

The `0x40` bit in the second byte selects write mode; clear = read mode.
After setting address+mode, every `0x98` access reads/writes that byte and
**auto-increments** the address.

## Command Decode Model (two-byte latch)

The VDP alternates through 2-byte command pairs. The *second* byte decides:

- `second & 0x80` -> **register write**: `reg[second & 0x0F] = first` (value).
- otherwise      -> **address set**: `addr = first | ((second & 0x3F) << 8)`,
  `write_mode = (second & 0x40) != 0`.

This makes C-BIOS's `[value][0x80|reg]` register writes and
`[low][0x40|high]` address writes both work; the first byte is never examined
for command type.

## Registers Used (MSX1)

| Reg | Bits | Meaning |
|-----|------|---------|
| R0  | 1    | M1 (text mode) |
| R1  | 0 / 3 / 5 / 6 | M3 (multicolor) / M2 (Graphics II) / display enable / sync IRQ enable (0x40) |
| R2  | 0-3  | Name table base `>> 10` |
| R3  | 0-7  | Color table base `>> 6` (Graphics II and multicolor) |
| R4  | 0-2  | Pattern table base `>> 11` (text mode: `R4 & 0x03`) |
| R5  | 0-6  | Sprite attribute table base `>> 7` |
| R6  | 0-2  | Sprite pattern table base `>> 11` |
| R7  | 0-3 / 4-7 | Foreground (text/tiles) / background color |

Mode selection: `M1 = R0 & 0x02`, `M2 = R1 & 0x08`, `M3 = R1 & 0x01`.

## C-BIOS MSX1 Screen Memory Maps

| Screen | Name table | Pattern table | Color table |
|--------|-----------|---------------|-------------|
| 0 (text 40x24) | `0x0000` (R2=0) | `0x0800` (R4=1) | none (R7) |
| 1 (gr. I 32x24) | `0x1800` (R2=6) | `0x0000` (R4=0) | (R7) |
| 2 (gr. II) | `0x1800` | `0x0000` | `0x2000` (R3=0x80) |

## Pixel Format Rules (from openMSX)

- Text mode: 40 x 24 chars, each 6 px wide x 8 tall; pattern byte bits
  `0x80..0x04` map to pixel columns 0..5 (6 MSBs). Colors = R7 (fg/bg).
- Graphics I: 32 x 24 tiles, 8 x 8 px; pattern bit `0x80>>px` (bit 7 =
  leftmost); fg/bg from R7 for the whole tile.
- Graphics II: 32 x 24 tiles, 8 x 8 px; pattern base `R4<<11`, color table
  base `R3<<6`; color byte per tile-row = `base + name*8 + pattern_row`.
  **`color >> 4` (high nibble) = fg, `color & 0x0F` = bg**.
- Multicolor: 64 x 48 blocks of 4 x 4 px. For pixel line `line`, column block:
  `name = nameTable[(line/8)*32 + (col/8)]`,
  `byte = patternTable[name*8 + ((line/4)&7)]`; left nibble = left 4 px block,
  right nibble = right 4 px block.

## Renderer Integration

- `tms9918_render(vdp, out, pitch_bytes)` renders 256x192 into a caller
  buffer as 32bpp XRGB8888 using the MSX1 16-color palette.
- `msx_step_frame()` (in `src/core/msx.c`) calls the weak hook
  `msx_frame_render(vdp)` once per VDP frame, after every
  `vdp_frame_instr` Z80 instructions (~12000, ~60 Hz). The weak default in
  `msx.c` is a no-op.
- The Circle app provides the strong override in `src/app/vdpblit.cpp`:
  `VDPBlit_Init()` captures Circle's `CBcmFrameBuffer`, and
  `msx_frame_render()` centers the 256x192 image in the (larger) native
  framebuffer and calls `tms9918_render()`. Circle handles VPU coherency.
- Palette (classic MSX1): 0/1 black, 2 green, 3 light green, 4 dark blue,
  5 light blue, 6/8/9 reds, 7 cyan, A/B yellows, C dark green, D magenta,
  E grey, F white.