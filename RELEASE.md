# BlueberryMSX-BareMetal — Release Notes

Changelog of deployable SD-card images. Each version lives in its own
`release/<ver>/` folder and owns a **complete card bundle**
(`config.txt`, `msx.ini`, `msx.img`, `kernel7l.img`,
`bcm2710-rpi-zero-2-w.dtb`, `bootloader_canary.img`, `config_linux.bak`).
`sd_update/` and stray `/data` copies are retired: `release/<ver>/` is the only
place an image is published or flashed from.

Deploy: copy the whole folder to the card - `config.txt`, `msx.img`,
`kernel7l.img`, the `.dtb` and the bootloader go on the **boot** partition
(FAT1); `msx.ini` goes on the **data** partition (FAT2, `emmc1-2`). The
emulator must never write the boot partition.

Record every release here with its `msx.img` md5 and size.

| Version | Date | Tag / base commit | `msx.img` md5 | Size | Focus |
|---------|------|-------------------|---------------|------|-------|
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

Bundle file list is identical across releases (`config.txt`, `kernel7l.img`,
`bcm2710-rpi-zero-2-w.dtb` are unchanged; `config.txt` md5
`981608755b496b2cc76b8a530c1e7e6b`).

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

When cutting a release:

1. Build: `make -C src/app` (produces `msx.img`).
2. `mkdir release/<ver>` (or copy the previous bundle) and copy in the new
   `msx.img`; adjust `msx.ini` for the release.
3. Record the version, date, commit, `msx.img` md5 and size in the table above,
   with a short changelog entry.
