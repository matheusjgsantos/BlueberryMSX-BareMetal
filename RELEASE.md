# BlueberryMSX-BareMetal — Release Notes

Changelog and deployment payloads for the bare-metal emulator. Each version is
kept in its own `release/<ver>/` folder; do not delete older releases. Version
1.0 carries separate 32-bit Circle application images for Pi 3-family boards
(`msx-pi3.img`) and Pi 4/400 (`msx-pi4.img`), selected by `config.txt`.
`msx.img` is retained as a Pi 3 compatibility alias. Circle/Raspberry Pi boot
firmware files are not built by the MSX app; use the matching firmware files
from the Circle `boot/` directory or the Raspberry Pi firmware distribution.

The card has two FAT32 partitions. Copy `config.txt`, both `msx-pi*.img` images,
`msx.img`, the Pi 4 armstub and model DTBs to partition 1 (boot), alongside the
matching Pi firmware files. Copy `msx.ini` and `BIOS/` to partition 2 (data,
Circle device `emmc1-2`); ROM files may also live there. The emulator must never
write its logs, dumps, or content to the boot partition.

Record the default `msx.img` md5 and size in the table. For dual-image releases,
also record the Pi 3 and Pi 4 image hashes and sizes in the release section.

| Version | Date | Tag / base commit | `msx.img` md5 | Size | Focus |
|---------|------|-------------------|---------------|------|-------|
| v1.0 | 2026-10-16 | release commit | `1a071d7ccefca570c95dbfe6824038b9` | 533,072 | Dual Pi 3/Pi 4 release; hardware-verified on Zero 2, Pi 3A+/B+, Pi 4 and Pi 400 |
| v0.1 | 2026-10-08 | tag `v0.1` (`10699e7`) | — (no card bundle) | — | AY-8910 audio, HDMI+JACK, direct boot, host tests |
| v0.2 | 2026-10-11 | tag `v0.2` (`1f4e1d0`) | `aa55cec87e2f0dd45a5fb7dff026aad8` | 602,760 | RPMC bus bring-up + cartridge dump (Milestone A); `release/` layout |
| v0.3 | 2026-10-12 | `4e64ecc` | `620e3feafb5ab0a4a82927c782821571` | 605,584 | Live MegaFlashROM bus + read cache + SLOTS menu (Milestone B) |
| v0.4 | 2026-10-12 | working tree | `7da6bde1fb8f412199c112b28ff54a93` | 606,032 | `msx.ini` size fix + Pi-side MFR diagnostic dump |
| v0.5 | 2026-10-12 | working tree | `8cfb5e23e95f511332400eb27ca22283` | 606,736 | Slot/MFR event log + dense dump across the cartridge INIT |
| v0.6 | 2026-10-12 | working tree | `cb086cd45090f024fbd2525c549ae957` | 606,928 | Robust MFR event log + dense 200-600 window (catch the later failure) |
| v0.7 | 2026-10-13 | working tree | `9fa4a680adb662e0947470302cf1f486` | 607,824 | Bank-switch bus log (cart writes + entry-vector reads) |
| v0.8 | 2026-10-13 | working tree | `1d08564134659ebfb66024fa04ebe18d` | 609,104 | Boot MFR mapper probe; force Konami mode |
| v0.9 | 2026-10-13 | working tree | `9233958b55e18fa08366d0987b544c25` | 609,104 | **LE_C write-protocol fix** (keep control latch transparent during /WR) |
| v0.10 | 2026-10-13 | working tree | `9233958b55e18fa08366d0987b544c25` | 609,104 | Play config: `diag=off`, `msxbus.dump=off` (same image as v0.9) |
| v0.11 | 2026-10-14 | working tree | `88d45b55697e3a1ac8d9cdc665a24d0a` | 525,904 | **C-BIOS loaded from SD `BIOS/`** (0.29a); embedded ROMs removed |
| v0.12 | 2026-10-15 | working tree | `98a512d137ee8a5ae0866b1bb81f2753` | 531,792 | **Emulated ASCII8 MegaROM + SD file browser** (`ROMS/` from the overlay) |
| v0.13 | 2026-10-15 | working tree | `ebc6e417337c4a33818b25c76b291a64` | 532,496 | **Konami / Konami-SCC emulated mappers + AUTO detection** (Gradius, Salamander, Nemesis 3) |
| v0.14 | 2026-10-15 | working tree | `c112657a8ffe9560551295df4a121545` | 533,008 | **Bank-aware cart dump** (`msxbus.dumpmapper`) — correct dumps of >32 KiB MegaROMs |

Historical v0.x bundles retain their original file sets. The v1.0 bundle adds
`msx-pi3.img` and `msx-pi4.img`, and its `config.txt` selects by model.

---

## v1.0 — 2026-10-16 (Pi 3 and Pi 4/400 support)

**Hardware verified:** Raspberry Pi Zero 2 W, Pi 3A+/B+, Pi 4, and Pi 400.
`config.txt` selects the Pi 3 image for `[pi02]` and `[pi3]`, and the Pi 4 image
for `[pi4]`/`[cm4]`. The Pi 4 binary was rebuilt with Circle and the app
consistently using `RASPPI=4`; this selects Circle's EMMC controller rather
than the Pi 1–3 SDHOST backend, so the FAT2 data partition and its BIOS files
are available at runtime.

| Image | MD5 | Size |
|-------|-----|------|
| `msx-pi3.img` (also `msx.img`) | `1a071d7ccefca570c95dbfe6824038b9` | 533,072 B |
| `msx-pi4.img` | `e5e605c61b923df9667a1ee14c91605b` | 578,960 B |

The Pi 4 image's SHA-256 is `f0c318c2bcf142aba5af5cd8ed8180f29b9f20095363daaac8424d05cba1f69a`.
The release config forces HDMI mode 4 and sets the corrected `hdmi_drive=2`.
`msx.ini` is set for play (`diag=off`, `msxbus.dump=off`).

Build both targets by cleaning and rebuilding the shared Circle libraries for
each `RASPPI` value before building the corresponding app image. See the
dual-target build instructions in `README.md`.

---

## v0.14 — 2026-10-15 (bank-aware cartridge dump)

**Image:** `release/v0.14/msx.img` md5 `c112657a8ffe9560551295df4a121545`,
533,008 B. **VERIFIED on hardware (2026-10-15):** the bank-aware dump produced a
correct `CART1.ROM` for the physical F1 Spirit (Konami-SCC) cart. The dump
genuinely was broken: a
512 KiB dump of the physical F1 Spirit cart (`CART1.ROM`, renamed
`F1SPIRIT.ROM`) is 32K/64K-periodic and holds only 4 distinct 8 KiB banks — a
raw linear read, not a ROM image.

- **Root cause.** `DumpCartridges` read `MsxBus_Read(slot, 0x4000 + i)` linearly
  and never wrote a bank register, so it only ever captured the four 8 KiB banks
  the cart maps at power-on; the 16-bit address then wraps and the rest repeats
  (with the Konami-SCC mirror folding `0xC000→0x4000` / `0x0000→0x8000`, which
  is why the dump is 32K-periodic). Present since the dump was first added
  (`b73e10e`, Milestone A), so earlier "valid" cart dumps were valid only in
  their first 32 KiB.
- **Fix — the dump now switches banks.** New shared walk `src/app/cartdump.h`
  (`CartDump_Banked`), used by `CKernel::DumpCartridges`: for each 8 KiB bank it
  writes the mapper's bank register, reads the window, and stops as soon as a
  bank repeats bank 0 (the cart's bank register ignores the bits it does not
  decode, so the first repeat reveals the real ROM size — auto-size). The cart
  is reset afterwards to restore its power-on mapping.
- **New config key** `msxbus.dumpmapper` = `linear` (default, legacy behaviour) |
  `konami` | `konamiscc` | `ascii8`. The banked kinds pair a register with the
  window it selects:
  - `konamiscc`: `0x5000` → `0x4000` window (win0)
  - `konami`: `0x8000` → `0x8000` window (win2; page `0x4000` is fixed)
  - `ascii8`: `0x6000` → `0x4000` window (win0)
- **Host test:** `host-test/cartdump_test.c` (31 checks, PASS) drives the exact
  shipped walk against a fake cart whose bank register masks to its real size,
  for all three banked mappers, with the production read-cache policy on and
  off; it also asserts the old linear read does *not* reconstruct a 128 KiB ROM.
- **Verified on hardware (2026-10-15):** with the F1 Spirit cart (Konami-SCC)
  in connector 1, v0.14 (`msxbus.dump=on`, `msxbus.dumpmapper=konamiscc`) wrote
  a correct `CART1.ROM`.

---

## v0.13 — 2026-10-15 (Konami / Konami-SCC emulated mappers + AUTO detection)

**Image:** `release/v0.13/msx.img` md5 `ebc6e417337c4a33818b25c76b291a64`,
532,496 B. **VERIFIED on hardware (2026-10-15):** Gradius, Salamander and
Nemesis 3 (the Konami-family games that previously failed) all boot and run
correctly via `ROM FROM FILE`.

- **Konami and Konami-SCC bank decoders.** Previously both shared the ASCII8
  decode, so no Konami-family cartridge could switch banks. `src/core/msx.c`
  `slot_write_mem` now dispatches on `mapperType`:
  - **Konami** (no SCC): page `0x4000` fixed at segment 0; any write in
    `0x6000-0xBFFF` selects window `1/2/3` (`address >> 13`).
  - **Konami-SCC**: `0x5000-0x57FF`→win0, `0x7000-0x77FF`→win1,
    `0x9000-0x97FF`→win2, `0xB000-0xB7FF`→win3 (matched as
    `(address & 0x1800) == 0x1000`, `address` in `0x5000-0xBFFF`). The
    `0x9800-0x9FFF` SCC register window is ignored (no SCC chip emulated yet).
- **AUTO now detects the mapper** (`msx_guess_mapper()`): scans the image for
  `LD (nn),A` bank-select idioms, following openMSX's own heuristic
  (`0x5000/0x9000/0xB000`→SCC, `0x4000/0x8000/0xA000`→Konami,
  `0x6800/0x7800`→ASCII8, with the ASCII8 bias). Images <64 KB stay plain;
  large images with no recognizable idiom default to ASCII8. Verified: Gradius,
  Salamander, Nemesis 3 → KONAMI-SCC; Goonies, Pac-Man → ASCII8.
- **Host test:** `host-test/konami_emu_test.c` (28 checks, PASS) exercises the
  Konami and Konami-SCC register maps (including the fixed `0x4000` page, the
  `0x800`-wide register ranges and the SCC window) plus the AUTO guesser.
- **The `cart.mapper`/`mapper` override still wins** over AUTO
  (`ascii8`|`konami`|`konamiscc`|`none`); the boot log now reports the resolved
  mapper (`AUTO:KONAMI-SCC`, etc.).
- **Verified on hardware (2026-10-15):** Gradius, Salamander and Nemesis 3 boot
  and run correctly, loaded via the overlay `ROM FROM FILE` browser.

---

## v0.12 — 2026-10-14 (emulated ASCII8 MegaROM + SD file browser)

**Image:** `release/v0.12/msx.img` md5 `98a512d137ee8a5ae0866b1bb81f2753`,
531,792 B. **Partly hardware-verified (2026-10-15):** the SD file browser lists
files correctly, including VFAT long names with full 8-character base names
(the 7.3 truncation is fixed). ASCII8 MegaROM boot from a browsed file still
needs confirming.

- **Fix (Circle FAT `ListDir`):** the short-name buffer was
  `char ShortName[FAT_DIR_NAME_LENGTH + 1]` (12 B) but `FAT2Name` writes
  `name.ext` + NUL (up to 13 B). The terminator overflowed one byte into the
  adjacent `LongName` buffer, wiping the first character of every VFAT long
  name — an 8-character base name showed as 7 (e.g. `mfrprobe.rom` →
  `frprobe.rom`). Enlarged to `FAT_DIR_NAME_LENGTH + 2`; verified in the
  compiled object that `ShortName` no longer abuts `LongName`.
- **Emulated ASCII8 MegaROM mapper in the core.** `include/msx.h` gains an
  `MSX_MapperType` enum and per-subslot mapper state (`mapperType`,
  `pRomImage`, `romSize`, `romMask`, `bank[4]`); `src/core/msx.c` adds
  `msx_load_rom_image()` and `msx_set_mapper()` and mapper-aware
  `slot_read_mem`/`slot_write_mem`. Bank registers: `0x6000-0x67FF`→`0x4000`
  window, `0x6800-0x6FFF`→`0x6000`, `0x7000-0x77FF`→`0x8000`,
  `0x7800-0x7FFF`→`0xA000`. `AUTO` treats images ≥128 KiB as ASCII8.
  Konami/Konami-SCC select the same decode for now (placeholder). The image is
  heap-owned by the core and freed on reload / `msx_destroy`. (Circle's
  `malloc`/`free` back onto a ~128 MB heap, so multi-MB images are fine.)
- **SD file browser in the overlay.** The third menu entry is now
  **`ROM FROM FILE`**; choosing it lists ROM-like files (`rom`/`bin`/`mx1`/
  `mx2`/`col`) and directories from the data partition, lets you descend into
  folders and select a file, then boots it via the normal reset path.
  Cross-core rule is respected: core 1 (UI) drives navigation while all
  filesystem access runs on core 0 through a `ClaimBrowserList`/
  `FinishBrowserList` handshake (same shape as the reset handshake).
  New Circle API `CFATDirectory::ListDir` (+ `CFATFileSystem::ListDir`) powers
  the listing (`libfatfs.a` rebuilt).
- **New config key** `cart.mapper` / `mapper` = `auto` (default) | `none` |
  `ascii8` | `konami` | `konamiscc` in `msx.ini`.
- **Host test:** `host-test/ascii8_emu_test.c` (13 checks, PASS) drives the
  emulated mapper directly (`msx_load_rom_image` + slot read/write).
- **Verify on hardware:** put one or more `.ROM` images on the data partition,
  open the overlay, pick `ROM FROM FILE`, navigate and load. Confirm an ASCII8
  MegaROM boots and that a plain ROM still boots.

---

## v0.11 — 2026-10-14 (C-BIOS loaded from SD; embedded ROMs removed)

**Image:** `release/v0.11/msx.img` md5 `88d45b55697e3a1ac8d9cdc665a24d0a`,
525,904 B. **Not yet hardware-verified** (see verify step below).

- **C-BIOS now loads from the card.** The MSX1 BIOS used to be compiled into
  `msx.img` (`src/app/cbios_roms.cpp`, C-BIOS 0.23); it is now read at boot
  from `BIOS/cbios_main_msx1.rom` and `BIOS/cbios_logo_msx1.rom` on the data
  partition (C-BIOS **0.29a**). Dropping the embedded arrays shrank the image
  by ~47 KB (568,400 -> 521,488 B).
- **New:** `src/app/biosrom.{cpp,h}` maps a machine type to its ROM set;
  `msx.ini` gains `machine=msx1|msx2|msx2+` (default `msx1`). The `BIOS/`
  folder ships MSX1/2/2+ main+logo, `cbios_sub.rom` and `cbios_music.rom`.
  **MSX2/2+ are scaffolded but do not boot yet** (they also need the MSX2
  secondary-slot register and a V9938 VDP in the core).
- **Fatal if missing:** if the `BIOS/` files are absent (or the data partition
  is not mounted) the kernel logs `FATAL: BIOS load failed: <file>` and halts;
  there is no embedded fallback.
- **Circle FAT gained subdirectory + VFAT long-name support.**
  `CFATFileSystem::FileOpen` is now path-aware and `CFATDirectory` parses VFAT
  long file names (`cbios_main_msx1.rom` is not a legal 8.3 name). Root files
  (`msx.ini`, `CART*.ROM`) are unaffected.
- **Verify on hardware:** boot v0.11 and confirm C-BIOS reaches the MSX logo /
  BASIC; then remove a `BIOS/` file and confirm the kernel logs
  `FATAL: BIOS load failed: ...` and halts.

---

## v0.10 — 2026-10-13 (play config — debug outputs off)

**Image:** `release/v0.10/msx.img` md5 `9233958b55e18fa08366d0987b544c25`,
609,104 B — **identical to v0.9**; this release only changes `msx.ini`.

- `diag=off` (was `on`): stops the per-frame PPM dumps and `MB*.STA` bus-counter
  writes, which stall the emulator on every write — this is the "regular speed"
  setting.
- `msxbus.dump=off` (was `on`): no boot-time `CART1.ROM`/`CART3.ROM` dump.
- Kept `msxbus=on`, `mode=cache`, `rddelay=16`, and **`mfrprobe=on`** (the probe
  forces the mapper mode the MFR multicart menu needs; harmless for read-only
  carts). Re-enable `diag=on` only when capturing a diagnostic.

## v0.9 — 2026-10-13 (cart write protocol fix — LE_C)

**Image:** `release/v0.9/msx.img` md5 `9233958b55e18fa08366d0987b544c25`,
609,104 B. `msx.ini`: same as v0.8 (`diag=on`, `msxbus=on`, `msxbus.dump=on`,
`mode=cache`, `mfrprobe=on`).

- **Root cause of "writes never latch":** on the RPMC board GPIO 8-15 carry the
  high address byte (latched by `LE_A`) **and** the 8 control signals
  (`SLTSL1/SLTSL3/CS1/CS2/RD/WR/IORQ/MREQ`, latched by `LE_C`, a transparent
  74LS373). `LE_C` must stay **high** (transparent) while the select/strobe lines
  are asserted; if it is cleared first the latch freezes on the old deasserted
  value and the `/WR` pulse never reaches the cartridge — **reads still work,
  writes silently do nothing.** That is exactly the v0.7/v0.8 symptom.
- **The bug:** `msxbus_set_data` did `MSXBUS_CLR(LE_C_BIT | nFlag)` — clearing
  `LE_C` in the same write that asserts the controls. The known-good upstream
  `msxslot/MsxBusPi.c` (`msxwrite`) and the RGR `BlueberryMSX-2.0plus` `SetData`
  both keep `LE_C` high (`GPIO_CLR = flag | MSX_WR;`, no `LE_C`) and clear it only
  after the access. The fork commit `a114970` added the early `LE_C` clear (and
  its doc misattributed the resulting failure to a "/WR hardware fault").
- **Fix:** `msxbus_set_data` now keeps `LE_C` transparent for the whole write
  (`MSXBUS_CLR(nFlag | WR)`, then pulse), and latches it (`MSXBUS_CLR(LE_C)`) at
  the end — mirroring upstream/RGR.
- **Test:** re-run with the MFR cart in connector 1. The `MFRPROBE.TXT` rows
  should now *differ per mode/register* (writes move pages) instead of being
  identical; the multicart menu's `0x8000`/`0xA000` bank writes should latch and
  a game should launch.
- **VERIFIED on hardware (2026-10-13).** With the MFR cart in connector 1 the
  multicart menu **launched a game**. `MFRPROBE.TXT` now shows writes latching
  (e.g. under `konami-scc`, `w6000`→`p1=404F`, `w8000`→`p2=404F`, `wA000`→`p3=404F`)
  instead of the identical rows v0.8 produced. Confirms the LE_C write-protocol
  fix and that the fork's "suspected /WR hardware fault" was a misdiagnosis.

## v0.8 — 2026-10-13 (MFR mapper-mode probe)

**Image:** `release/v0.8/msx.img` md5 `1d08564134659ebfb66024fa04ebe18d`,
609,104 B. `msx.ini`: `diag=on`, `msxbus=on`, `msxbus.dump=on`, `mode=cache`,
new `mfrprobe=on`.

- **Root cause (from openMSX `MegaFlashRomSCCPlus.cc`):** the physical cart's
  configuration register (`#7FFE`/`#7FFF`) resets to `0` = **Konami-SCC** mode, in
  which the bank registers only latch writes where `(addr & 0x1800) == 0x1000`
  (`0x5000/0x7000/0x9000/0xB000`). The multicart menu instead writes its banks to
  `0x8000`/`0xA000`, which latch **only in Konami mode** (config bit 5 set). That
  exactly matches the v0.7 hardware log (menu wrote `0x8000=01`/`0xA000=02`, the
  read-back at `0x8000-0x8003` stayed `41 42 80 40`).
- **Corrected the menu decode:** the `0x41EE` table is `(bank, ptr_lo, ptr_hi)` —
  entry0 is `(bank=01, handler=0x427B)`. The earlier "no bank 01" note was an
  off-by-one in the raw dump. So the emulator launches game0 **correctly**; only
  the physical bank switch is not taking effect.
- **Added — `ProbeMfrMapper`** (`kernel.cpp`, gated on `mfrprobe`): after the bus
  is up and before C-BIOS boots, reads the four page signatures, then for each
  mode (`Konami-SCC`, `Konami`, `64K`, `ASCII8`, `ASCII16`) sets `#7FFE` and
  writes `0x05` to each candidate register address (`0x4000`–`0xB000`), logging
  which page moves. Writes a padded `MFRPROBE.TXT` to the data partition.
- **Test:** the probe leaves the cart in **Konami mode** with the default bank
  mapping (`0..3`) restored, so the menu's `0x8000`/`0xA000` stores latch. If the
  game then launches, the mode mismatch is confirmed and the fix is a one-line
  boot-time config-register write.
- **Config:** `mfrprobe=on` (diagnostic only; leave off for play).

## v0.7 — 2026-10-13 (bank-switch bus log)

**Image:** `release/v0.7/msx.img` md5 `9fa4a680adb662e0947470302cf1f486`,
607,824 B. `msx.ini`: `diag=on`, `msxbus=on`, `msxbus.dump=on`, `mode=cache`.
(Fixed: the first v0.7 build dropped the `snprintf` that names the `MB*.STA`
file, so `FileCreate` got an uninitialized name and wrote nothing.)

- **Added — bus access log** (`msxbus.c`): ring buffers record every cartridge
  memory access in `0x4000-0xBFFF` — all **writes** (addr, slot, value) and the
  **first 4 bytes of each 8 KiB bank** on **reads** (the entry vectors a loader
  probes). Dumped into the `MB*.STA` file at offset `0x4000` (`BUS LOG`), via new
  `MsxBus_LogWrite*` / `MsxBus_LogRead*` accessors.
- **Purpose:** show whether the MFR menu's bank-register stores (`0x8000`,
  `0xA000`) actually reach the physical cart, and whether the loader's read of
  `0x8000-0x8003` changes after the store. Host model (`host-test/mfr_bank_test.c`)
  already proved the emulator's slot logic is correct, so this isolates the
  remaining hardware/bank-switch question.
- **Config:** `diag=on` (the `.STA` files are written each dump frame).

## v0.6 — 2026-10-12 (catch the later failure)

**Image:** `release/v0.6/msx.img` md5 `cb086cd45090f024fbd2525c549ae957`,
606,928 B. `msx.ini`: `diag=on`.

- **Fixed — event log crowding:** the page-1 (port `0xA8`) transitions are now a
  small **ring buffer** held separately from the MFR events, so the CALSLT
  trampoline flood can no longer fill the log before the interesting write.
  Every `0xE200`/`0xE210` write is kept in full (`MSX_MFR_EVT_MAX`), so a later
  re-INIT stays visible.
- **Changed — dump window:** frames `100-200` (step 2) plus `200-600` (step 5)
  plus `60`/`90` and the sparse points. v0.5 stopped at frame 200; on hardware
  the failure occurs after the menu appears (between 200 and 600) and then hangs,
  so no later dump was written.
- **Hardware finding (v0.5 run):** the MFR INIT ran **once** with `E200=01` and
  the menu started (`pc=44EE`, active `[0 1 1 3]` at frame 200); the "needs
  64KiB RAM" error appears only later, i.e. a second INIT pass with `E200=03`
  (= page-1 RAM) is the suspected mechanism.
- **Config:** `diag=on`.

Status: diagnostic. This release is meant to capture the dump immediately before
the post-menu hang, where the second `0xE210`/`0xE200` write should appear.

## v0.5 — 2026-10-12 (INIT event-log diagnostic)

**Image:** `release/v0.5/msx.img` md5 `8cfb5e23e95f511332400eb27ca22283`,
606,736 B. `msx.ini`: `diag=on`.

- **Added — slot/MFR event log** (`msx.c`): records page-1 slot transitions on
  port `0xA8` and every write to `0xE200`/`0xE210`, each with the store PC.
  `0xE200` writes are gated on `0xE210 != 0`, because C-BIOS itself mirrors the
  slot register into `0xE200` (`PC=0D43/0D48`) many times during boot; the gate
  keeps the MFR's own `0xE200` write visible. Exposed via
  `msx_slot_event_count/get()` and appended to the `MB<frame>.STA` dump.
- **Changed — denser dump schedule:** `DumpMsxbusDiag` now runs on frames
  100–200 (step 2) plus the previous sparse points (60, 90, 600…1800), to
  capture the page-1 switch and the `0xE210`/`0xE200` writes exactly when the
  cartridge INIT runs.
- **Host result (reference):** the MFR INIT runs exactly once —
  `010 E210=01 pc=4086` then `011 E200=01 pc=40A6` (page 1 = cart slot 1) — and
  the RAM scan succeeds. Hardware frame-600 shows `E210=01 E200=03`, so the
  open question is whether/how the Pi's menu re-runs its INIT with page 1 = RAM.
- **Config:** `diag=on` (each 128 KiB dump stalls the emulator; diagnosis only).

Status: diagnostic release. The physical MegaFlashROM menu still reports
"precisa de pelo menos 64KiB de RAM"; this release captures the Pi-side event
sequence needed to explain the `E200=3` divergence.

## v0.4 — 2026-10-12 (diagnostic build)

**Image:** `release/v0.4/msx.img` md5 `7da6bde1fb8f412199c112b28ff54a93`,
606,032 B. `msx.ini`: `diag=on`.

- **Fixed — `msx.ini` truncation.** `MSX_INI_MAX` was 2048 but the config file
  is 3628 B, so `FileRead` cut it off inside the header comments and the whole
  active block was ignored. Raised to 8192 and the parse buffer made `static`
  (`src/app/msxconfig.cpp`). This change is present only from v0.4 onward.
- **Added:** `CKernel::DumpMsxbusDiag` now also records machine state (PC,
  slot register, active slots, `E210`/`E200`/`F3E9`, `RAMAD0/1/2`, `EXPTBL`,
  `F380-387`); dumps at frames 60/90/120/600/1200/1800 as `MB<frame>.STA`.
- **Config:** `diag=on` (the emulator stalls on each 128 KiB dump; for
  diagnosis only).

Status: the physical MegaFlashROM menu still reports "precisa de pelo menos
64KiB de RAM" but the emulator passes the same check, so v0.4 exists to capture
the Pi-side state. This release is not a gameplay release.

## v0.3 — 2026-10-12 (live bus)

**Image:** `release/v0.3/msx.img` md5 `620e3feafb5ab0a4a82927c782821571`
(605,584 B).

Commits: `fdca3be` (live reads/writes), `0d49def` (SLOTS menu entry),
`fba5a29` (bus diagnostics + configurable settle), `e2ed284` (read page cache),
`49c8151` (gate dumps behind `diag`), `df23352` (ROM read-only), `4e64ecc`
(MegaROM bus forwarding).

- **Added:** live RPMC bus in emulated slots — `MSX_SubSlot.busSlot` and machine
  `bus_ref` + `bus_read/write/read_io/write_io` callbacks; `msx_slot_set_bus()`
  maps connector 1 → slot 1, connector 3 → slot 2 (slot 3 stays system RAM).
  Ports the emulator does not own are forwarded to the bus (music modules, SCC,
  FM). `AttachMsxbus()` wires the callbacks over `MsxBus_*`.
- **Added:** overlay cart selector gains **"SLOTS (MSXBUS)"** and boots it by
  default; `MSXConfig.bMsxbusEnable` defaults to on so SLOTS works with no
  `msx.ini`.
- **Added:** read page cache (`msxbus.mode=cache`, the default) as the speed
  path; `msxbus.rddelay` (default 16) to tune the live-read settle.
- **Added:** new `msx.ini` keys: `msxbus.slot1`, `msxbus.slot3`, `diag`,
  `msxbus.rddelay`; `msxbus.dump`/`msxbus.size` retained.
- **Fixed:** ROM subslots are read-only everywhere (`df23352`) — kills phantom
  RAM where a loaded ROM read back as writable.
- **Known issue (fixed by v0.4):** the shipped `v0.3` image predates the
  `msx.ini` size fix, so with the 3628-byte `msx.ini` the active config block is
  truncated at 2047 bytes. The fix was made in the source tree but was never
  built into `release/v0.3`. Use v0.4.

## v0.2 — 2026-10-11 (Milestone A)

**Image:** `release/v0.2/msx.img` md5 `aa55cec87e2f0dd45a5fb7dff026aad8`
(602,760 B). Tag `v0.2` = `1f4e1d0`; milestone commit `b73e10e` (hardware
verified 2026-10-09).

- **Added:** RPMC V5 cartridge bus driver `src/app/msxbus.{h,c}` — GPCLK0 clock
  (~3,579,545 Hz), pin map, reset pulse; PWR/SLOT LEDs.
- **Added:** `src/app/msxconfig.{h,cpp}` — boot-time `msx.ini` parser
  (keys `log`, `loglevel`, `msxbus`, `msxbus.dump`, `msxbus.mode`,
  `msxbus.size`).
- **Added:** boot cartridge dump → `CART1.ROM` / `CART3.ROM` on the data
  partition (Milestone A verification).
- **Changed:** the `release/<ver>/` bundle convention replaces `sd_update/` and
  the `/data/Projects/MSX/BlueberryMSX/` mirror; every version owns its folder.
- **Notes:** `msx.ini` set to `msxbus=on`, `msxbus.dump=on`, `mode=live`.
  Hard rule reaffirmed: never write the SD boot partition.

## v0.1 — 2026-10-08 (first tag)

Tag `v0.1` = commit `10699e7` ("clean AY-8910 audio, HDMI+JACK output, host
tests"). No card bundle in the repo.

- Direct boot: `msx.img` linked at `0x8000`, named as the kernel in
  `config.txt`.
- TMS9918 renderer, sprites, overlay cart selector, USB keyboard → MSX PPI.
- AY-3-8910 (PSG) audio with blueMSX R3 low-pass and openMSX-form DC-removal
  filters; HDMI and JACK output.
- SMP: emulator frame loop moved to core 1 (core 0 keeps IRQs/VCHIQ/USB).

---

### Maintenance

When cutting a dual-target release:

1. For each target, configure Circle (`./configure -r 3 --multicore -f` or
   `./configure -r 4 --multicore -f`), clean/rebuild Circle and the SDCard,
   Linux-emulation, and VCHIQ libraries, then build the app with the same
   `RASPPI` value. Clean/rebuild between targets; shared Circle archives do not
   track changes in target compiler flags. See `README.md` for commands.
2. Copy the exact builds to `msx-pi3.img` and `msx-pi4.img`; keep `msx.img` as
   the Pi 3 alias. Copy the previous release bundle to `release/<ver>/` and
   update `config.txt`/`msx.ini` as needed.
3. Record both image checksums and sizes, the default alias checksum, version,
   date, and a short release summary here.

Note: `msx.img` embeds `__DATE__`/`__TIME__` (the boot log line in
`kernel.cpp`), so the md5 is **not reproducible** — a rebuild of identical
source yields a different hash. Always build once, then copy *that* `msx.img`
into `release/<ver>/` and record *its* md5 (do not rebuild after recording).
