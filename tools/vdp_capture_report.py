#!/usr/bin/env python3
"""Summarise BlueberryMSX .VDS/.CMD VDP captures.

A capture written by the kernel is a pair of files:

    F%07X.VDS   magic (8 B), aInfo[4] (16 B, frame at +16), R#0-R#63 (64 B at
                +24), S#0-S#3 (4 B at +88), palette (48 B at +92), 128 KiB VRAM
                at +140
    F%07X.CMD   text log: "cmd", "status", "raster_trace" and "raster" lines

Usage:
    python3 tools/vdp_capture_report.py CAPTURE_DIR [CAPTURE_DIR ...]
    python3 tools/vdp_capture_report.py F0000236.VDS

For every capture it prints the display registers, per-page VRAM usage, the
raster-split transitions (a raster split needs "transitions" > 1) and a
histogram of VDP command opcodes, their destination page and issuing PC.
Joint with the neighbouring .PPM this separates "the game draws the wrong
thing" from "the game never switches the displayed page".
"""

import struct
import sys
import os
import glob
import collections

VDS_HEADER = 140
VDS_VRAM = 0x10000
CMD_RE = collections.namedtuple
CMD_FIELDS = ("pc", "op", "sx", "sy", "dx", "dy", "nx", "ny", "col", "time")


def parse_kv(tokens):
    out = {}
    for t in tokens:
        if "=" in t:
            k, _, v = t.partition("=")
            out[k] = v
    return out


def read_cmd(path):
    ops = collections.Counter()
    pcs = collections.Counter()
    dst_page = collections.Counter()
    status_regs = collections.Counter()
    transitions = None
    splits = []
    if not os.path.exists(path):
        return None
    with open(path, "r", errors="replace") as f:
        for line in f:
            parts = line.split()
            if not parts:
                continue
            head = parts[0]
            if head == "cmd" and len(parts) > 1:
                kv = parse_kv(parts[1:])
                ops[kv.get("cmd", "??")] += 1
                pcs[kv.get("pc", "????")] += 1
                try:
                    dy = int(kv["dy"], 16)
                except (KeyError, ValueError):
                    continue
                dst_page[">=256 (page1)" if dy >= 256 else "<256 (page0)"] += 1
            elif head == "status" and len(parts) > 1:
                kv = parse_kv(parts[1:])
                status_regs["S#" + kv.get("reg", "?")] += 1
            elif head == "raster_trace":
                kv = parse_kv(parts[1:])
                transitions = (kv.get("valid"), kv.get("transitions"))
            elif head == "raster" and len(parts) > 1:
                kv = parse_kv(parts[1:])
                splits.append((parts[1], kv))
    return {
        "ops": ops,
        "pcs": pcs,
        "dst": dst_page,
        "status": status_regs,
        "transitions": transitions,
        "splits": splits,
    }


def line_runs(vram, base, lines, width=128):
    """Compress the nonzero/zero pattern of visible lines into runs."""
    runs = []
    prev = None
    start = 0
    for y in range(lines):
        nz = any(vram[base + ((y & 1023) << 7) + x] for x in range(width))
        tag = "data" if nz else "blank"
        if tag != prev:
            if prev is not None:
                runs.append((start, y - 1, prev))
            prev, start = tag, y
    runs.append((start, lines - 1, prev))
    return runs


def report(vds_path):
    name = os.path.basename(vds_path)
    with open(vds_path, "rb") as f:
        blob = f.read()
    if len(blob) < VDS_HEADER + VDS_VRAM:
        print(f"{name}: short .VDS ({len(blob)} bytes)")
        return
    frame = struct.unpack_from("<I", blob, 16)[0]
    reg = blob[24:88]
    status = blob[88:92]
    pal = blob[92:VDS_HEADER]
    vram = blob[VDS_HEADER:VDS_HEADER + VDS_VRAM]
    bright = sum(pal)

    print(f"== {name}  frame={frame}")
    print(
        "   R0=%02X R1=%02X R2=%02X R5=%02X R6=%02X R7=%02X R8=%02X R9=%02X "
        "R18=%02X R19=%02X R23=%02X R25=%02X  S0=%02X S1=%02X S2=%02X S3=%02X "
        " palette=%d" % (
            reg[0], reg[1], reg[2], reg[5], reg[6], reg[7], reg[8], reg[9],
            reg[18], reg[19], reg[23], reg[25], status[0], status[1],
            status[2], status[3], bright))
    lines = 212 if reg[9] & 0x80 else 192
    for label, base in (("page0", 0x0000), ("page1", 0x8000)):
        window = vram[base:base + 0x8000]
        nz = sum(1 for b in window if b)
        runs = line_runs(vram, base, lines)
        text = ", ".join(
            f"{a}-{b} {t}" if a != b else f"{a} {t}" for a, b, t in runs[:8])
        more = "" if len(runs) <= 8 else f" ... ({len(runs)} runs)"
        print(f"   {label}: {nz}/32768 bytes nonzero; visible lines: {text}{more}")

    cmd = read_cmd(os.path.splitext(vds_path)[0] + ".CMD")
    if cmd is None:
        print("   (no .CMD alongside)")
        return
    if cmd["transitions"]:
        valid, count = cmd["transitions"]
        print(f"   raster split: valid={valid} transitions={count}")
        if count not in (None, "1"):
            for line, kv in cmd["splits"][:10]:
                print("      at %s R2=%s R23=%s" % (
                    line, kv.get("R2", "??"), kv.get("R23", "??")))
    if cmd["status"]:
        print("   status reads: " + ", ".join(
            f"{k}={v}" for k, v in sorted(cmd["status"].items())))
    if cmd["ops"]:
        total = sum(cmd["ops"].values())
        print(f"   commands={total} ops=" + ", ".join(
            f"{k}:{v}" for k, v in cmd["ops"].most_common(8)))
        print("   destinations: " + ", ".join(
            f"{k}:{v}" for k, v in cmd["dst"].most_common()))
        print("   issuing PCs: " + ", ".join(
            f"{k}:{v}" for k, v in cmd["pcs"].most_common(5)))


def main(argv):
    if len(argv) < 2:
        print(__doc__)
        return 2
    paths = []
    for arg in argv[1:]:
        if os.path.isdir(arg):
            paths.extend(sorted(glob.glob(os.path.join(arg, "*.VDS"))))
        else:
            paths.append(arg)
    if not paths:
        print("no .VDS captures found")
        return 1
    for p in paths:
        report(p)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
