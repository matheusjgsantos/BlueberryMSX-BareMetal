#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"
BIN=host-test/.msx1_boot_test
trap 'rm -f "$BIN"' EXIT HUP INT TERM
${CC:-gcc} -std=c99 -O2 -Wall -Wextra -Wno-unused-parameter \
    -Iinclude -Isrc/include -Isrc/core -Isrc/chips/z80 \
    -Isrc/chips/vdp -Isrc/chips/sound \
    host-test/msx1_boot_test.c src/core/msx.c src/core/msx_cpu.c \
    src/core/msx_mapper.c src/chips/z80/R800.c src/chips/vdp/tms9918.c \
    src/chips/vdp/v9938.c src/chips/sound/psg.c \
    src/chips/sound/sn76489.c -o "$BIN"
"$BIN"
