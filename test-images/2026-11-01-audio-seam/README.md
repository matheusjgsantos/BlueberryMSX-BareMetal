# Test images: audio device seam (2026-11-01)

Branch: `main` (integration line); checkpoint `feature/modular-emulation-architecture`
Status: **hardware verified 2026-11-01** (Pi 3A+ and Pi 4: PSG audio correct on
HDMI and on the 3.5 mm phone jack; audio regression checklist passed)

Fifth extraction step. Behavior should be identical to the video-seam images in
`../2026-11-01-video-seam/` (hardware-verified); the machine now drives the PSG
through an ops table, and the sub-frame write log lives in the device adapter
instead of in `msx.c`.

## What changed

- `include/msx_audio.h` (new): the audio device seam. `MSX_AudioOps`
  (`read_io`, `write_io`, `write_io_at`, `latched_register`, `log_reset`,
  `render`, `native`, `destroy`) plus an `MSX_Audio` handle and thin
  forwarders (`msx_audio_read_io/write_io/write_io_at/render/destroy/...`,
  `msx_audio_attach` for a non-PSG device).
- `src/core/msx_audio_psg.c` (new): the MSX1 audio device. It owns the AY
  port protocol (0xA0 latch, 0xA1 data, 0xA2 read) and the sub-frame register
  write log with its replay, moved out of `src/core/msx.c` unchanged in
  algorithm. The adapter is now per-machine state (`calloc`'d), so the old
  "saved start state belongs to a destroyed machine" guard is gone.
- `src/core/msx.c`: no longer includes `psg.h`. Port 0xA0/0xA1 writes are
  timestamped with `s_frame_frac16()` (fraction of the frame's instruction
  budget, same value as before) and forwarded to the device; 0xA2 reads go
  through the seam; `msx_psg_render()` is now a forwarder. `machine->audio`
  is the handle, `machine->sound` the compatibility alias to the `PSG*`
  (`msx_audio_native()`), used by diagnostics and older tests.
- Preserved exactly: write ordering (live apply + logged replay), the
  `frac16` timestamp formula, per-segment `psg_render` cycle accounting, the
  0xA0-latch survival across the state restore, the 256-entry log and its
  whole-frame fallback on overflow, `g_psg_writes` / `g_psg_last_reg` /
  `g_psg_last_val`, and the VDP seam from the previous step.

Host checks before packaging:

```text
PASS: audio seam forwards to the PSG, replays timed writes, accepts other devices  (new)
PASS: video seam forwards to the TMS9918 and accepts other devices
PASS: CPU seam matches direct R800 execution and maps M1
0 timing mismatch(es)
PASS: host callback table routes bus and diagnostics
PASS: Z80 OTIR, VDP/PPI high-byte port aliases, PSG port decode
RESULT: PASS        konami_emu_test, ascii8_emu_test, megarom_bus_test
31 checks, 0 failed: PASS                                    cartdump_test
PASS: 60 Hz deadlines, variable work, wraparound, resume      frame_pacer_test
PASS: mapper policy (ASCII8/16, Konami, Konami-SCC, guess)
```

The new test proves the seam accepts a fake device, that the adapter matches a
raw PSG for the same port sequence, that a mid-frame volume write is rendered
only from that point on (byte-equal to a manual two-segment render, and
different from a naive whole-frame render), that a >256-write frame falls back
to whole-frame behaviour, and that the 0xA0 latch survives the replay.

## Images

| File | Target | Size | MD5 |
|---|---|---|---|
| `msx-pi3.img` | Pi 3 / 3A+ / 3B+ / Zero 2 W | 536528 | `60cf95aebef591c4bc9dd39c99b162b5` |
| `msx-pi4.img` | Pi 4 / 400 / CM4 | 582608 | `c4c8b0991d004cc784c882fca04f845c` |

+1280 B (Pi 3) / +1344 B (Pi 4) versus the video-seam bundle. `MD5SUMS` and
`SHA256SUMS` included; images embed `__DATE__`/`__TIME__`, so checksums change
on every rebuild.

## How to test

```sh
cp msx-pi3.img /media/$USER/boot/msx-pi3.img    # Pi 3 family
cp msx-pi4.img /media/$USER/boot/msx-pi4.img    # Pi 4 family
```

Rollback: `release/v1.0/msx-pi3.img` / `msx-pi4.img`.

## Regression checklist (merge gate)

Audio is the risk here, so listen for these specifically:

- [ ] PSG music and sound effects are identical to the video-seam images: same
      pitch, same tempo, same volume balance between channels.
- [ ] Fast passages (arpeggios, drums, sample-ish effects) are no rougher or
      "smeared" than before -- the sub-frame log was moved, not changed.
- [ ] No new clicks/pops at frame boundaries; no channel stuck on after a
      sound effect ends (that would point at the write log or the latch).
- [ ] A game that reads back PSG registers (0xA2) still behaves (rare, but the
      latch survival is the risky part).
- [ ] Audio works on both HDMI and VCHIQ output paths.
- [ ] Silence when the ROM should be silent (no constant hum/DC).
- [ ] Control checks (video path touched only by refactoring): C-BIOS BASIC
      screen clean, sprites fine, 32 KB ROMs (Goonies, PacMan) and
      Konami-SCC/MegaROM games at v1.0 speed, `ROM FROM FILE` vs physical slot,
      cart writes move pages, reset, overlay/browser/F-keys.
- [ ] Pi 3A+ and Pi 4 both pass.

## Next steps after this

- Input seam (PPI/keyboard + joystick ports) so the machine no longer decodes
  input ports itself.
- Then the machine-profile layer, where the MSX slot map moves behind an
  `MSX_Memory` handle and a profile installs either MSX slots or a flat map
  (ColecoVision is the first non-MSX target).
