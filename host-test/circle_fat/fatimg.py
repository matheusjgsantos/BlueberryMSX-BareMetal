#!/usr/bin/env python3
"""Create directories in and verify a FAT16/FAT32 disk image (host FAT test).

Only what the Circle FAT regression test needs: FAT16 and FAT32, 8.3 short
names, one or more directory levels, and a structural + content verifier.

Usage:
    fatimg.py mkdir <image> <dir-path> ...     create directory paths
    fatimg.py verify <image>                   verify structure and contents
"""

import os
import sys

ATTR_DIRECTORY = 0x10
ATTR_VOLUME_ID = 0x08
ATTR_LONG_NAME = 0x0F


def pattern(seed, index):
    return (seed * 37 + index * 11 + (index >> 8)) & 0xFF


def expected_files():
    """Mirror of GetTestFiles() in fat_path_test.cpp."""
    files = {}
    for i in range(100):
        files["capture/T%03u.BIN" % i] = (i + 1, 700)
    files["capture/NESTED/DEEP.TXT"] = (7, 1200)
    files["ROOT.BIN"] = (9, 1000)
    return files


def name83(name):
    base, _, ext = name.partition(".")
    base = base.upper()[:8].ljust(8)
    ext = ext.upper()[:3].ljust(3)
    return (base + ext).encode("ascii")


class FatImage:
    def __init__(self, path):
        with open(path, "rb") as fp:
            self.data = bytearray(fp.read())
        self.path = path
        bpb = self.data
        self.bytes_per_sector = int.from_bytes(bpb[11:13], "little")
        self.sectors_per_cluster = bpb[13]
        self.reserved = int.from_bytes(bpb[14:16], "little")
        self.num_fats = bpb[16]
        self.root_entries = int.from_bytes(bpb[17:19], "little")
        total16 = int.from_bytes(bpb[19:21], "little")
        total32 = int.from_bytes(bpb[32:36], "little")
        self.total_sectors = total16 if total16 else total32
        fat16_size = int.from_bytes(bpb[22:24], "little")
        fat32_size = int.from_bytes(bpb[36:40], "little")
        self.fat_size = fat16_size if fat16_size else fat32_size
        self.bits = 16 if fat16_size else 32
        if self.bits == 32:
            self.root_cluster = int.from_bytes(bpb[44:48], "little")

        self.fat_start = self.reserved
        if self.bits == 16:
            self.root_dir_sectors = (self.root_entries * 32
                                     + self.bytes_per_sector - 1) // self.bytes_per_sector
        else:
            self.root_dir_sectors = 0
        self.root_start = self.fat_start + self.num_fats * self.fat_size
        self.data_start = self.root_start + self.root_dir_sectors
        self.cluster_size = self.bytes_per_sector * self.sectors_per_cluster
        self.cluster_count = (self.total_sectors - self.data_start) // self.sectors_per_cluster

    # --- FAT access

    def fat_get(self, cluster):
        offset = self.fat_start * self.bytes_per_sector
        if self.bits == 16:
            entry = int.from_bytes(self.data[offset + cluster * 2:offset + cluster * 2 + 2], "little")
        else:
            entry = int.from_bytes(self.data[offset + cluster * 4:offset + cluster * 4 + 4], "little")
            entry &= 0x0FFFFFFF
        return entry

    def fat_set(self, cluster, value):
        for copy in range(self.num_fats):
            offset = self.fat_start * self.bytes_per_sector
            offset += copy * self.fat_size * self.bytes_per_sector
            if self.bits == 16:
                self.data[offset + cluster * 2:offset + cluster * 2 + 2] = value.to_bytes(2, "little")
            else:
                old = int.from_bytes(self.data[offset + cluster * 4:offset + cluster * 4 + 4], "little")
                new = (old & 0xF0000000) | (value & 0x0FFFFFFF)
                self.data[offset + cluster * 4:offset + cluster * 4 + 4] = new.to_bytes(4, "little")

    def is_eoc(self, entry):
        return entry >= (0xFFF8 if self.bits == 16 else 0x0FFFFFF8)

    def cluster_offset(self, cluster):
        return (self.data_start + (cluster - 2) * self.sectors_per_cluster) * self.bytes_per_sector

    def allocate_cluster(self):
        for cluster in range(2, self.cluster_count + 2):
            if self.fat_get(cluster) == 0:
                self.fat_set(cluster, 0xFFFF if self.bits == 16 else 0x0FFFFFFF)
                start = self.cluster_offset(cluster)
                self.data[start:start + self.cluster_size] = b"\0" * self.cluster_size
                return cluster
        raise RuntimeError("no free cluster")

    # --- directories

    def root_dir_slice(self):
        if self.bits == 16:
            start = self.root_start * self.bytes_per_sector
            return start, start + self.root_entries * 32
        return None

    def dir_slots(self, cluster):
        """Return byte offsets of the 32-byte entries of a directory."""
        if cluster == 0:
            slot = self.root_dir_slice()
            if slot is not None:
                return list(range(slot[0], slot[1], 32))
            cluster = self.root_cluster
        slots = []
        while cluster >= 2:
            start = self.cluster_offset(cluster)
            slots.extend(range(start, start + self.cluster_size, 32))
            next_cluster = self.fat_get(cluster)
            if self.is_eoc(next_cluster):
                break
            cluster = next_cluster
        return slots

    def entries(self, cluster):
        result = []
        for offset in self.dir_slots(cluster):
            raw = self.data[offset:offset + 32]
            if len(raw) < 32 or raw[0] == 0x00:
                break
            if raw[0] == 0xE5:
                continue
            attr = raw[11]
            if attr == ATTR_LONG_NAME or attr & ATTR_VOLUME_ID:
                continue
            name = raw[0:8].decode("ascii", "replace").rstrip()
            ext = raw[8:11].decode("ascii", "replace").rstrip()
            full = name + ("." + ext if ext else "")
            first = int.from_bytes(raw[26:28], "little")
            if self.bits == 32:
                first |= int.from_bytes(raw[20:22], "little") << 16
            result.append({
                "name": full,
                "attr": attr,
                "cluster": first,
                "size": int.from_bytes(raw[28:32], "little"),
                "offset": offset,
            })
        return result

    def lookup(self, path):
        cluster = 0
        entry = None
        for part in path.strip("/").split("/"):
            wanted = part.upper()
            entry = None
            for candidate in self.entries(cluster):
                if candidate["name"].upper() == wanted:
                    entry = candidate
                    break
            if entry is None:
                return None
            cluster = entry["cluster"]
        return entry

    def make_entry(self, name, attr, cluster, size):
        """Build a 32-byte short-name directory entry."""
        entry = bytearray(32)
        entry[0:11] = name83(name) if name not in (".", "..") else name.encode("ascii").ljust(11)
        entry[11] = attr
        if self.bits == 32:
            entry[20:22] = (cluster >> 16).to_bytes(2, "little")
        entry[26:28] = (cluster & 0xFFFF).to_bytes(2, "little")
        entry[28:32] = size.to_bytes(4, "little")
        return entry

    def add_dir(self, path):
        parts = path.strip("/").split("/")
        if self.lookup(path) is not None:
            return  # already present
        parent = "/".join(parts[:-1])
        parent_entry = self.lookup(parent) if parent else None
        if parent and parent_entry is None:
            raise RuntimeError("parent %s does not exist" % parent)
        parent_cluster = parent_entry["cluster"] if parent_entry else 0

        new_cluster = self.allocate_cluster()

        # "." and ".." entries inside the new directory
        start = self.cluster_offset(new_cluster)
        self.data[start:start + 32] = self.make_entry(".", ATTR_DIRECTORY, new_cluster, 0)
        self.data[start + 32:start + 64] = self.make_entry("..", ATTR_DIRECTORY,
                                                           parent_cluster, 0)

        # directory entry in the parent
        slot = None
        for offset in self.dir_slots(parent_cluster):
            if self.data[offset] in (0x00, 0xE5):
                slot = offset
                break
        if slot is None:
            # extend the parent chain (root on FAT16 cannot grow)
            if parent_cluster == 0 and self.bits == 16:
                raise RuntimeError("FAT16 root is full")
            cluster = parent_cluster if parent_cluster else self.root_cluster
            while not self.is_eoc(self.fat_get(cluster)):
                cluster = self.fat_get(cluster)
            new_parent = self.allocate_cluster()
            self.fat_set(cluster, new_parent)
            slot = self.cluster_offset(new_parent)

        entry = bytearray(32)
        entry[0:11] = name83(parts[-1])
        entry[11] = ATTR_DIRECTORY
        if self.bits == 32:
            entry[20:22] = (new_cluster >> 16).to_bytes(2, "little")
        entry[26:28] = (new_cluster & 0xFFFF).to_bytes(2, "little")
        self.data[slot:slot + 32] = entry
    def read_file(self, entry, used, expect_eoc=True):
        """Collect a file's content by following its cluster chain.

        The current cluster is read first, then the chain link is examined, so
        the last cluster of the chain is included (a chain whose FAT entry is
        an EOC marker is not empty, it is the tail).
        """
        size = entry["size"]
        content = bytearray()
        cluster = entry["cluster"]
        while cluster >= 2:
            if cluster in used:
                raise RuntimeError("cross-linked cluster %u" % cluster)
            used.add(cluster)

            start = self.cluster_offset(cluster)
            content.extend(self.data[start:start + self.cluster_size])
            if len(content) >= size and not expect_eoc:
                break

            next_cluster = self.fat_get(cluster)
            if self.is_eoc(next_cluster):
                break
            if len(content) >= size:
                raise RuntimeError("chain of %s is longer than its size" % entry["name"])
            cluster = next_cluster

        return bytes(content[:size])

    def verify(self):
        expected = {name.upper(): value for name, value in expected_files().items()}
        used = set()
        seen = set()
        problems = []

        def walk(cluster, prefix):
            for entry in self.entries(cluster):
                name = prefix + entry["name"]
                if entry["attr"] & ATTR_DIRECTORY:
                    if entry["name"] in (".", ".."):
                        continue
                    if entry["cluster"] in used:
                        problems.append("directory %s reuses cluster %u" % (name, entry["cluster"]))
                    used.add(entry["cluster"])
                    walk(entry["cluster"], name + "/")
                    continue
                seen.add(name)
                if name not in expected:
                    problems.append("unexpected file %s (%u bytes)" % (name, entry["size"]))
                    continue
                seed, size = expected[name]
                if entry["size"] != size:
                    problems.append("%s: size %u, expected %u" % (name, entry["size"], size))
                    continue
                data = self.read_file(entry, used)
                if len(data) != size:
                    problems.append("%s: chain holds %u of %u bytes" % (name, len(data), size))
                    continue
                want = bytes(pattern(seed, i) for i in range(size))
                if data != want:
                    problems.append("%s: content mismatch" % name)

        walk(0, "")

        for name in expected:
            if name not in seen:
                problems.append("missing file %s" % name)

        return problems


def format_fat16(path, megabytes, label="MSXTEST"):
    """Write a minimal but valid FAT16 filesystem to a zeroed image file.

    BusyBox mkfs.vfat in this environment only ever creates FAT32, so the FAT16
    case is formatted here. Parameters match what mkfs.vfat would pick for a
    small card: 512-byte sectors, 4-sector (2 KiB) clusters, one reserved
    sector, two FATs, 512 root entries.
    """
    bytes_per_sector = 512
    sectors_per_cluster = 4
    reserved = 1
    num_fats = 2
    root_entries = 512
    root_dir_sectors = (root_entries * 32 + bytes_per_sector - 1) // bytes_per_sector
    total_sectors = megabytes * 1024 * 1024 // bytes_per_sector

    fat_size = 1
    while True:
        data_sectors = total_sectors - reserved - num_fats * fat_size - root_dir_sectors
        clusters = data_sectors // sectors_per_cluster
        needed = ((clusters + 2) * 2 + bytes_per_sector - 1) // bytes_per_sector
        if needed <= fat_size:
            break
        fat_size = needed
    if not 4085 <= clusters <= 65524:
        raise RuntimeError("cluster count %u is not FAT16" % clusters)

    data = bytearray(total_sectors * bytes_per_sector)

    boot = bytearray(512)
    boot[0:3] = b"\xEB\x3C\x90"
    boot[3:11] = b"MSXHOST "
    boot[11:13] = bytes_per_sector.to_bytes(2, "little")
    boot[13] = sectors_per_cluster
    boot[14:16] = reserved.to_bytes(2, "little")
    boot[16] = num_fats
    boot[17:19] = root_entries.to_bytes(2, "little")
    if total_sectors < 0x10000:
        boot[19:21] = total_sectors.to_bytes(2, "little")
    boot[21] = 0xF8                          # media descriptor
    boot[22:24] = fat_size.to_bytes(2, "little")
    boot[24:26] = (32).to_bytes(2, "little")   # sectors per track
    boot[26:28] = (64).to_bytes(2, "little")   # heads
    boot[28:32] = (0).to_bytes(4, "little")    # hidden sectors
    if total_sectors >= 0x10000:
        boot[32:36] = total_sectors.to_bytes(4, "little")
    boot[36] = 0x80                          # drive number
    boot[38] = 0x29                          # extended boot signature
    boot[39:43] = (0x4D535831).to_bytes(4, "little")  # volume id
    boot[43:54] = label.upper()[:11].ljust(11).encode("ascii")
    boot[54:62] = b"FAT16   "
    boot[510:512] = b"\x55\xAA"
    data[0:512] = boot

    for copy in range(num_fats):
        offset = (reserved + copy * fat_size) * bytes_per_sector
        data[offset:offset + 2] = (0xFFF8).to_bytes(2, "little")
        data[offset + 2:offset + 4] = (0xFFFF).to_bytes(2, "little")

    with open(path, "wb") as fp:
        fp.write(data)


def main(argv):
    if len(argv) < 3:
        print(__doc__)
        return 2
    command = argv[1]

    if command == "mkfs16":
        if len(argv) < 4:
            print(__doc__)
            return 2
        format_fat16(argv[2], int(argv[3]))
        return 0

    image = FatImage(argv[2])

    if command == "mkdir":
        for path in argv[3:]:
            image.add_dir(path)
        with open(image.path, "wb") as fp:
            fp.write(image.data)
        return 0

    if command == "verify":
        problems = image.verify()
        for problem in problems:
            print("FAIL: " + problem)
        if problems:
            print("%u problem(s)" % len(problems))
            return 1
        print("verify PASS: %u files, no cross-links" % len(expected_files()))
        return 0

    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv))
