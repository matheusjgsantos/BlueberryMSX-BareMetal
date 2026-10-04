#!/usr/bin/env python3
"""Minimal Z80 disassembler with real addresses (z80dasm 1.2.0 cannot do this).

Usage: z80d.py <rom.bin> <base_addr_hex> [start_offset] [length]
"""
import sys

# (mnemonic, operand_len) for 1-byte opcodes; 'imp' = implied, 'A8' etc handled below
R = ['B', 'C', 'D', 'E', 'H', 'L', '(HL)', 'A']
RP = ['BC', 'DE', 'HL', 'SP']
RP2 = ['BC', 'DE', 'HL', 'AF']
CC = ['NZ', 'Z', 'NC', 'C', 'PO', 'PE', 'P', 'M']
ALU = ['ADD A,', 'ADC A,', 'SUB ', 'SBC A,', 'AND ', 'XOR ', 'OR ', 'CP ']
ROT = ['RLC', 'RRC', 'RL', 'RR', 'SLA', 'SRA', 'SLL', 'SRL']


def fmt_imm(v, n):
    if n == 1:
        return f"0x{v:02X}"
    if n == 2:
        return f"0x{v:04X}"
    return str(v)


def disasm1(op):
    """Return (text, size) for a 1-byte opcode."""
    lo, hi = op & 0x07, (op >> 3) & 0x07
    if op == 0x00: return ('NOP', 1)
    if op == 0x08: return ('EX AF,AF\'', 1)
    if op == 0x10: return ('DJNZ +%d', 2)
    if op == 0x18: return ('JR +%d', 2)
    if (op & 0xE7) == 0x20: return ('JR %s,%%d' % CC[(op >> 3) & 3], 2)
    if op == 0x01: return ('LD BC,%d16', 3)
    if op == 0x11: return ('LD DE,%d16', 3)
    if op == 0x21: return ('LD HL,%d16', 3)
    if op == 0x31: return ('LD SP,%d16', 3)
    if 0x40 <= op <= 0x7F:
        if lo == 6 and hi == 6: return ('HALT', 1)
        return ('LD %s,%s' % (R[lo], R[hi]), 1)
    if 0x80 <= op <= 0xBF:
        return (ALU[hi] + R[lo], 1)
    if op == 0xC9: return ('RET', 1)
    if op == 0xC3: return ('JP %d16', 3)
    if op == 0xCD: return ('CALL %d16', 3)
    if op == 0x32: return ('LD (%d16),A', 3)
    if op == 0x22: return ('LD (%d16),HL', 3)
    if op == 0x2A: return ('LD HL,(%d16)', 3)
    if op == 0x3A: return ('LD A,(%d16)', 3)
    if op in (0xC6, 0xCE, 0xD6, 0xDE, 0xE6, 0xEE, 0xF6, 0xFE):
        return (ALU[(op >> 3) & 7].rstrip(',A') + ' %d8', 2)
    if op == 0xF3: return ('DI', 1)
    if op == 0xFB: return ('EI', 1)
    if op == 0xD9: return ('EXX', 1)
    if (op & 0xCF) == 0xC5: return ('PUSH %s' % RP2[(op >> 4) & 3], 1)
    if (op & 0xCF) == 0xC1: return ('POP %s' % RP2[(op >> 4) & 3], 1)
    if (op & 0xC7) == 0xC7: return ('RST %02XH' % (op & 0x38), 1)
    if (op & 0xC7) == 0xC2: return ('JP %s,%%d16' % CC[hi], 3)
    if (op & 0xC7) == 0xC4: return ('CALL %s,%%d16' % CC[hi], 3)
    if (op & 0xC7) == 0xC0: return ('RET %s' % CC[hi], 1)
    if (op & 0xCF) == 0x01: return ('LD %s,%s' % (RP[(op >> 4) & 3], RP[lo]), 1)
    if (op & 0xCF) == 0x09: return ('ADD HL,%s' % RP[(op >> 4) & 3], 1)
    if (op & 0xCF) == 0x02:
        return ('LD (%s),%s' % (RP[lo], R[(op >> 4) & 3]), 1)
    if (op & 0xCF) == 0x0A:
        return ('LD %s,(%s)' % (R[(op >> 4) & 3], RP[lo]), 1)
    if (op & 0xC7) == 0x04: return ('INC %s' % R[lo], 1)
    if (op & 0xC7) == 0x05: return ('DEC %s' % R[lo], 1)
    if (op & 0xC7) == 0x06: return ('LD %s,%%d8' % R[lo], 2)
    if hi == 6 and (op & 0xC7) == 0x04: return ('INC (HL)', 1)
    if hi == 6 and (op & 0xC7) == 0x05: return ('DEC (HL)', 1)
    if (op & 0xC7) == 0xC6: return ('RST %02XH' % (op & 0x38), 1)
    if (op & 0xCF) == 0x03:
        return ('INC %s' % RP2[(op >> 4) & 3], 1)
    if (op & 0xCF) == 0x0B:
        return ('DEC %s' % RP2[(op >> 4) & 3], 1)
    if (op & 0xCF) == 0x43: return ('LD (nn),SP %02X' % op, 1)
    if op == 0xCB: return (None, -1)
    if op == 0xED: return (None, -2)
    return ('DB %02XH' % op, 1)


def disasm2(op):
    """CB-prefixed."""
    x, y = op & 7, (op >> 3) & 7
    reg = ['B', 'C', 'D', 'E', 'H', 'L', '(HL)', 'A'][x]
    if x == 6:
        if 0 <= y <= 3: return ('BIT %d,(HL)' % y, 2)
        if 4 <= y <= 7: return ('RES %d,(HL)' % (y - 4), 2)
        return ('SET %d,(HL)' % (y - 8), 2)
    ops = [ROT[y] if y < 8 else None]
    if y < 8: return ('%s %s' % (ROT[y], reg), 2)
    if y < 12: return ('BIT %d,%s' % (y - 8, reg), 2)
    if y < 16: return ('RES %d,%s' % (y - 12, reg), 2)
    return ('SET %d,%s' % (y - 16, reg), 2)


def disasm3(op2, op3):
    """ED-prefixed."""
    if op2 == 0x46: return ('IM 0', 2)
    if op2 == 0x56: return ('IM 1', 2)
    if op2 == 0x5E: return ('IM 2', 2)
    if op2 == 0x47: return ('LD I,A', 2)
    if op2 == 0x4F: return ('LD R,A', 2)
    if op2 == 0x57: return ('LD A,I', 2)
    if op2 == 0x5F: return ('LD A,R', 2)
    if 0x40 <= op2 <= 0x47: return ('LD %s,(%d16)' % (R[op2 & 7], op3), 4)
    if 0x42 <= op2 <= 0x43 and op2 < 0x44: return ('LD (%d16),%s' % (op3, R[op2 & 7]), 4)
    if 0x42 <= op2 <= 0x47: return ('LD (%d16),%s' % (op3, R[op2 & 7]), 4)
    if 0x50 <= op2 <= 0x57: return ('LD (%d16),%s' % (op3, RP2[(op2 >> 4) & 3]), 4)
    if 0x4A <= op2 <= 0x4F: return ('LD %s,(%d16)' % (RP2[(op2 >> 4) & 3], op3), 4)
    if op2 == 0x4D: return ('RETN', 2)
    if op2 == 0x45: return ('RETN', 2)
    if op2 == 0xB0: return ('LDDR', 2)
    if op2 == 0xB8: return ('LDDRR', 2)
    if op2 == 0xA0: return ('LDI', 2)
    if op2 == 0xA8: return ('LDIR', 2)
    if op2 == 0xB8: return ('LDDR', 2)
    if op2 == 0x44: return ('NEG', 2)
    if op2 == 0x4C: return ('RETN', 2)
    if op2 in (0x67, 0x6F): return ('RST %02XH' % op2, 2)
    if op2 in (0x73, 0xF3): return ('LD (nn),SP-ish %02X' % op2, 2)
    return ('DB ED %02XH' % op2, 2)


def disasm_ix(data, off, base, reg):
    """DD/FD prefixed instruction. Returns (text, size). reg is 'IX' or 'IY'."""
    op = data[off + 1]
    lo, hi = op & 7, (op >> 3) & 7
    if op == 0x21: return ('LD %s,0x%04X' % (reg, data[off + 2] | (data[off + 3] << 8)), 4)
    if op == 0x22: return ('LD (0x%04X),%s' % (data[off + 2] | (data[off + 3] << 8), reg), 4)
    if op == 0x2A: return ('LD %s,(0x%04X)' % (reg, data[off + 2] | (data[off + 3] << 8)), 4)
    if op == 0x23: return ('INC %s' % reg, 2)
    if op == 0x2B: return ('DEC %s' % reg, 2)
    if op == 0x09: return ('ADD %s,%s' % (reg, RP[(op >> 4) & 3]), 2)
    if op == 0x19: return ('ADD %s,%s' % (reg, RP2[(op >> 4) & 3]), 2)
    if op == 0xE5: return ('PUSH %s' % reg, 2)
    if op == 0xE1: return ('POP %s' % reg, 2)
    if op == 0xD9: return ('EXX', 2)
    d = data[off + 2] - 256 if data[off + 2] > 127 else data[off + 2]
    tgt = '(%s%+d)' % (reg, d)
    if op == 0x34: return ('INC %s' % tgt, 3)
    if op == 0x35: return ('DEC %s' % tgt, 3)
    if op == 0x36: return ('LD %s,0x%02X' % (tgt, data[off + 3]), 4)
    if op == 0x46: return ('LD B,%s' % tgt, 3)
    if op == 0x4E: return ('LD C,%s' % tgt, 3)
    if op == 0x56: return ('LD D,%s' % tgt, 3)
    if op == 0x5E: return ('LD E,%s' % tgt, 3)
    if op == 0x66: return ('LD H,%s' % tgt, 3)
    if op == 0x6E: return ('LD L,%s' % tgt, 3)
    if op == 0x7E: return ('LD A,%s' % tgt, 3)
    if op == 0x77: return ('LD %s,A' % tgt, 3)
    if 0x70 <= op <= 0x77: return ('LD %s,%s' % (tgt, R[op & 7]), 3)
    if 0x40 <= op <= 0x7F: return ('LD %s,%s' % (R[op & 7], tgt), 3)
    if 0x80 <= op <= 0xBF: return (ALU[hi] + tgt, 3)
    if op == 0xCB:
        sub = data[off + 3]
        x, y = sub & 7, (sub >> 3) & 7
        if y < 8: return ('%s %s' % (ROT[y], tgt), 4)
        if y < 12: return ('BIT %d,%s' % (y - 8, tgt), 4)
        if y < 16: return ('RES %d,%s' % (y - 12, tgt), 4)
        return ('SET %d,%s' % (y - 16, tgt), 4)
    return ('DB %s %02XH' % (reg, op), 2)


def disasm_at(data, off, base):
    op = data[off]
    if op in (0xDD, 0xFD):
        t, sz = disasm_ix(data, off, base, 'IX' if op == 0xDD else 'IY')
        return base + off, sz, t, bytes(data[off:off + sz])
    t, sz = disasm1(op)
    if sz == -1:  # CB
        t, sz = disasm2(data[off + 1])
        raw = bytes(data[off:off + sz])
    elif sz == -2:  # ED
        t, sz = disasm3(data[off + 1], data[off + 2])
        raw = bytes(data[off:off + sz])
    else:
        raw = bytes(data[off:off + sz])
    addr = base + off
    out = t
    if sz == 2 and '%d8' in t:
        out = t.replace('%d8', '0x%02X' % raw[1])
    elif sz == 3 and '%d16' in t:
        out = t.replace('%d16', '0x%04X' % (raw[1] | (raw[2] << 8)))
    elif sz == 4 and '%d16' in t:
        out = t.replace('%d16', '0x%04X' % (raw[2] | (raw[3] << 8)))
    for pre in ('JR ', 'DJNZ '):
        if out.startswith(pre) and out.endswith('+%d'):
            rel = raw[1] - 256 if raw[1] > 127 else raw[1]
            out = pre + '0x%04X' % (addr + 2 + rel)
    if out.startswith('JR ') and out.endswith(',%d'):
        rel = raw[1] - 256 if raw[1] > 127 else raw[1]
        out = out[:-2] + ',0x%04X' % (addr + 2 + rel)
    return addr, sz, out, raw


def main():
    path = sys.argv[1]
    base = int(sys.argv[2], 16)
    start = int(sys.argv[3], 0) if len(sys.argv) > 3 else 0
    length = int(sys.argv[4], 0) if len(sys.argv) > 4 else 256
    data = open(path, 'rb').read()
    off = start
    end = min(start + length, len(data))
    while off < end:
        try:
            addr, sz, txt, raw = disasm_at(data, off, base)
        except Exception as e:
            print(f"{base+off:04X}  ?? ({e})")
            off += 1
            continue
        hexs = ' '.join('%02X' % b for b in raw)
        print(f"{addr:04X}  {hexs:<10} {txt}")
        off += sz


if __name__ == '__main__':
    main()
