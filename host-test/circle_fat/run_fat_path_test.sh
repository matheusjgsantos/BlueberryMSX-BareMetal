#!/bin/sh
#
# Host regression test for creating files inside an existing FAT subdirectory.
#
# Builds the real Circle FAT sources (lib/fs/fat/*.cpp) against the stub
# Circle headers in stub/ and a RAM-backed device, then exercises
# FileCreate/FileWrite/FileClose/FileOpen with subdirectory paths on both a
# FAT16 and a FAT32 image. fatimg.py verifies the resulting on-disk structure
# (directory chains, cluster allocation, no cross-links) and the file contents.
#
set -e

HERE=$(cd "$(dirname "$0")" && pwd)
CIRCLE=${CIRCLEHOME:-$HERE/../../../BlueberryMSX/circle}
TMP=${TMPDIR:-/tmp}/circle_fat_test.$$
BIN=$HERE/fat_path_test

cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

mkdir -p "$TMP"

echo "building fat_path_test"
g++ -std=c++17 -O1 -g -Wall -Wextra -Wno-unused-parameter \
	-DAARCH=64 -DRASPPI=3 \
	-I "$HERE/stub" -I "$CIRCLE/include" -I "$CIRCLE/lib" \
	"$HERE/fat_path_test.cpp" \
	"$CIRCLE/lib/fs/fat/fatdir.cpp" \
	"$CIRCLE/lib/fs/fat/fatfs.cpp" \
	"$CIRCLE/lib/fs/fat/fatcache.cpp" \
	"$CIRCLE/lib/fs/fat/fatinfo.cpp" \
	"$CIRCLE/lib/fs/fat/fat.cpp" \
	-o "$BIN"

run_case() {
	BITS=$1
	MB=$2
	IMG=$TMP/fat$BITS.img

	if [ "$BITS" = "16" ]; then
		echo "creating FAT16 image (${MB} MiB)"
		python3 "$HERE/fatimg.py" mkfs16 "$IMG" "$MB"
	else
		echo "creating FAT$BITS image (${MB} MiB)"
		dd if=/dev/zero of="$IMG" bs=1M count="$MB" status=none
		mkfs.vfat -n MSXTEST "$IMG" >/dev/null
	fi

	python3 "$HERE/fatimg.py" mkdir "$IMG" capture capture/NESTED

	echo "FAT$BITS: write pass"
	"$BIN" "$IMG" write

	echo "FAT$BITS: read pass (remounted image)"
	"$BIN" "$IMG" read

	echo "FAT$BITS: structure verification"
	python3 "$HERE/fatimg.py" verify "$IMG"
}

run_case 16 16
run_case 32 64

echo "All Circle FAT path tests passed!"
