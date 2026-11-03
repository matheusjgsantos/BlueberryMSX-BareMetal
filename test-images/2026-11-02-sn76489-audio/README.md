# ColecoVision SN76489 audio (2026-11-02)

Branch: `main`
Status: **hardware verified 2026-11-03** on Pi 3 and Pi 4 — audio is clean and
the machine radio group works; MSX1 boot/AY unchanged.

## Change

- `src/chips/sound/sn76489.c` implements the ColecoVision SN76489AN model
  using the local openMSX `SN76489.cc` reference (serial latch/data protocol,
  tone/noise counters, attenuation, LFSR and period-zero behavior).
- `src/core/msx_audio_sn76489.c` adapts it through `MSX_AudioOps`, including
  the existing sub-frame write replay. Coleco writes to every address in
  `0xE0-0xFF` reach the same serial data input; controller reads remain routed
  separately. MSX1 continues using the AY adapter.
- Initial hardware listening on Pi 3 and Pi 4 found rough audio. The SN renderer
  was point-sampling the final chip state for each output sample, unlike the AY
  renderer's boxcar average over every native tick in that sample. It now uses
  the same tick averaging. A host regression verifies a three-tick interval
  averages `(+8191,-8191,+8191)` to `2730`, rather than returning the final
  full-scale state.
- Second fix (this build): the adapter restored the pre-frame chip struct after
  the replay, which threw away the tone/noise phase and the master-clock
  remainder it had just computed. Every frame with a register write therefore
  restarted the waveform at the same phase, i.e. a phase step at 60 Hz. The
  replay now keeps its end state, exactly like the AY adapter. Measured with a
  440.4 Hz tone (period `0x0FE`) over 60 frames of 800 samples: before the fix
  the zero-crossing spacing was 54..92 samples, mean pitch 420.3 Hz, and
  adapter frames 1..59 all differed from a continuous render; after the fix the
  spacing is 54/55 samples, mean pitch 440.4 Hz, and every frame matches the
  continuous render byte for byte.
- Overlay: the machine row is no longer a "press Enter to cycle" item. The
  first menu rows are a radio group, `(*) MACHINE: MSX1` /
  `( ) MACHINE: COLECOVISION`; Enter on an option selects that machine and
  requests the reset (Enter on the running machine does nothing). Row macros
  in `src/app/overlay.h` are now `OVERLAY_MACHINE_OPTIONS`,
  `OVERLAY_CART_ROW(n)` and `OVERLAY_AUDIO_ROW`.
- Audio samples use the existing 48 kHz Circle output path. Real-hardware
  audio output and MSX1 regression remain to be checked by the user.

## Images

| File | Target | Bytes | MD5 | SHA-256 |
|---|---|---:|---|---|
| `msx-pi3.img` | Pi 3 / 3A+ / 3B+ / Zero 2 W | 544080 | `0fd5ec2301c07d5b2de9824ca124d855` | `a730f9e294a88bd7c17782ed6ac5eeb4c2571b81a91ca319f9050a930be9b5ad` |
| `msx-pi4.img` | Pi 4 / 400 / CM4 | 590672 | `1b69228ab323fa123bba0fef16846f51` | `a4aa8aa27063761a5b3bad9a99b9a12abada6309c9251492fb7a002c1f758029` |

Images embed `__DATE__`/`__TIME__`; these checksums identify the exact tested
build artifacts and are not reproducible across rebuilds.

## Verification

- `sn76489_test`: register protocol, oscillator output/reset silence, sample
  boxcar average, two-frame adapter replay vs. continuous render, adapter and
  aliased Coleco write ports — PASS. The two-frame case fails against the
  pre-fix adapter and passes after it.
- `coleco_machine_test` — PASS.
- `audio_seam_test` — PASS (MSX AY forwarding and timed-write replay).
- `io_decode_test` — PASS.
- `overlay_test` (rebuilt for the 5-argument `Overlay_Draw`, 41 checks) — PASS:
  the `(*)` marker is drawn on the running machine, flipping the machine only
  repaints the two radio rows, and the drawing still clips to a tiny target.
- Pi 3: `make clean RASPPI=3 && make RASPPI=3` in `src/app` — PASS.
- Pi 4: Circle libraries purged/reconfigured/rebuilt with
  `./configure -r 4 --multicore -f`, then `make clean RASPPI=4 && make RASPPI=4`
  in `src/app` — PASS.

## Hardware checklist

- [x] Coleco BIOS and a game still boot.
- [x] Game music/effects are audible through the configured audio output.
- [x] Audio is no longer rough (the 60 Hz phase step above is gone).
- [x] MSX1 boot and AY sound remain unchanged on both target images.
- [x] Overlay shows the machine radio group, `(*)` on the running machine, and
      Enter on the other option switches machine + reboots.

User report 2026-11-03: "It's sounding perfectly now, and the menu is working."

ColecoVision is closed out at this point: machine profile, flat memory map,
controller ports, NMI frame delivery, SN76489 audio and the machine radio
group are all hardware verified. Still deferred and not started: full
keypad/Super Action Controller protocol, MegaCart banking, and a
Coleco-specific palette.
