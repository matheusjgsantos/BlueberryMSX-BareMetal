# Aleste HUD: openMSX reference comparison

**Audit erratum:** the original MCP export used below was truncated to 49152
bytes. The reported 44 mismatches compare only the first 16384 bytes of the
HUD page, not its full 32768 bytes. The physical VDS replay is independent
evidence. The MCP export helper now validates a full 131072-byte snapshot.

Reference machine: `C-BIOS_MSX2` in the MCP service at
`raspberrypi3b.local:3000`, cartridge
`/home/matheusjgsantos/MSX2/ROM/ALESTE.ROM`. The cartridge was inserted after
boot, followed by reset. SPACE was pressed repeatedly (500 ms holds) until a
screenshot visibly confirmed the ship, scrolling playfield, and SC/ARM/lives
HUD; an earlier DIA51 story screen was not treated as gameplay evidence.

A `write_io 0x99` watchpoint recorded changes to R#2/R#23. This representative
sequence establishes the page/scroll phases (hexadecimal register values):

```text
185.658468 y=11  pc=590C R2=1F R19=08 R23=F2
185.671398 y=214 pc=57AD R2=3F R19=08 R23=F2
185.671410 y=214 pc=57B5 R2=3F R19=08 R23=00
185.675149 y=11  pc=5903 R2=1F R19=08 R23=00
185.675163 y=11  pc=590C R2=1F R19=08 R23=1D
185.688085 y=214 pc=57AD R2=3F R19=08 R23=1D
185.688097 y=214 pc=57B5 R2=3F R19=08 R23=00
185.691828 y=10  pc=5903 R2=1F R19=08 R23=00
185.691842 y=11  pc=590C R2=1F R19=08 R23=1C
```

Interpretation:

1. VBlank at display line 214 selects page 1 (`R#2=$3F`) and zero scroll for
   the fixed HUD.
2. The next line interrupt at display line 10/11 selects page 0
   (`R#2=$1F`), then installs the new playfield scroll.
3. Therefore the top of the active display must retain the VBlank state until
   the line split. It is not correct to start the active display using the
   previous end-of-line-interrupt state.

The pre-fix hardware capture `F0000313.CMD` instead showed:

```text
raster 000 R2=1F R7=00 R23=F2 R25=00 R26=00 R27=00
raster 042 R2=1F R7=00 R23=EB R25=00 R26=00 R27=00
```

That confirms both missing HUD ingredients in BlueberryMSX: page 1 was never
restored at the top of the active display and the old playfield scroll was not
reset above the split.

The fix carries display-register writes made after the active display ends
across the raster wrap into the next active display. The host regression
`host-test/vdp_raster_split_test.c::test_aleste_vblank_hud_state` reproduces
the reference R#2/R#23 sequence and checks the rendered HUD pixels. The patched
code passes; the same test compiled against the pre-fix VDP fails at the
raster-0 `R#2=$3F` assertion.

## Follow-up after the wrap fix still left the HUD invisible

New post-wrap hardware captures had the intended state (`F0000542.CMD`):

```text
raster 000 R2=3F R7=00 R23=00 R25=00 R26=00 R27=00
raster 042 R2=1F R7=00 R23=15 R25=00 R26=00 R27=00
```

Despite that, `F0000542.PPM` still showed only the playfield. This meant the
wrap change was necessary but not sufficient.

A full 32 KiB comparison of the HUD page (`0x8000-0xFFFF`) between that VDS and
paused openMSX gameplay found only **44 differing bytes out of 32768**. The HUD
graphics were already present and essentially identical in BlueberryMSX VRAM.

The remaining defect was the 212-line framebuffer mapping: both
`frame_line_for_row()` and `display_line_at()` added ten active-display lines.
Aleste splits at R#19=8, so the fixed HUD lives above that discarded crop.
Moreover framebuffer row 0 sampled the post-split register state instead of the
VBlank HUD state. The corrected 192-row framebuffer starts at active display
line 0 and shows lines 0-191; only the extra 20 bottom lines of 212-line mode
are omitted. No change was made to the R#19 scheduler.

As a direct end-to-end check, the original `F0000542.VDS` was replayed through
the corrected renderer using its captured VBlank/split states. The resulting
`expected-hud.png` visibly contains `SC`, `ARM 1`, and the lives icons from the
physical cartridge's VRAM. This is emulator-side replay evidence; the physical
HUD still needs one final hardware check.
