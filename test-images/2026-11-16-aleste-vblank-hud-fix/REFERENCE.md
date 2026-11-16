# Aleste HUD: openMSX reference comparison

Reference machine: `C-BIOS_MSX2` in the MCP service at
`raspberrypi3b.local:3000`, cartridge
`/home/matheusjgsantos/MSX2/ROM/ALESTE.ROM`. The cartridge was inserted after
boot, followed by reset. SPACE was pressed three times to leave attract mode.

A `write_io 0x99` watchpoint recorded changes to R#2/R#23. This representative
sequence is from real gameplay (hexadecimal register values):

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
