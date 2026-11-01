//
// msx_mapper.c
//
// BlueberryMSX - MSX MegaROM bank-mapper policy.
//
// Extracted verbatim from the decode in src/core/msx.c so the memory router
// (which subslot serves an address, physical cart bus) and the mapper policy
// (which 8 KB bank a ROM window shows, which writes select banks) can evolve
// independently. Behavior must stay identical to the inline version; the
// hardware-proven cases are Konami, Konami-SCC, ASCII8 and ASCII16, all of
// which expose four windows at 0x4000/0x6000/0x8000/0xA000 selected by
// ss->bank[0..3]; only the register write decode differs.
//

#include <msx_mapper.h>

int msx_mapper_is_mapped(MSX_MapperType type)
{
    switch (type) {
    case MSX_MAPPER_ASCII8:
    case MSX_MAPPER_ASCII16:
    case MSX_MAPPER_KONAMI:
    case MSX_MAPPER_KONAMI_SCC:
        return 1;
    default:
        return 0;
    }
}

UInt8 msx_mapper_read(const MSX_SubSlot *ss, UInt16 addr)
{
    int window = (addr - 0x4000) >> 13;
    if (window < 0 || window > 3) return 0xFF;

    unsigned bank = ss->bank[window];
    unsigned page = bank & ss->romMask;
    unsigned offset = (page << 13) | (addr & 0x1FFF);
    if (offset < ss->romSize) {
        if (ss->pRomImage) return ss->pRomImage[offset];
        return ss->data[offset];
    }
    return 0xFF;
}

void msx_mapper_write(MSX_SubSlot *ss, UInt16 addr, UInt8 val)
{
    if (ss->mapperType == MSX_MAPPER_KONAMI_SCC) {
        /* bank 1: 0x5000-0x57FF, bank 2: 0x7000-0x77FF,
         * bank 3: 0x9000-0x97FF, bank 4: 0xB000-0xB7FF.
         * (0x9800-0x9FFF is the SCC register window; with no SCC chip present
         * those writes are ignored.) Note that 0x4000 IS switchable here,
         * unlike the plain Konami mapper. */
        if (addr >= 0x5000 && addr < 0xC000 && (addr & 0x1800) == 0x1000) {
            int window = (addr >> 13) - 2; /* 0x5000->0 .. 0xB000->3 */
            if (window >= 0 && window <= 3) {
                ss->bank[window] = val & ss->romMask;
            }
        }
        return;
    }

    if (ss->mapperType == MSX_MAPPER_KONAMI) {
        /* Page 0x4000 is fixed at segment 0; 0x6000/0x8000/0xA000 select
         * windows 1/2/3 (any address in the page works). */
        if (addr >= 0x6000 && addr < 0xC000) {
            int window = (addr >> 13) - 2; /* 0x6000->1 .. 0xA000->3 */
            if (window >= 0 && window <= 3) {
                ss->bank[window] = val & ss->romMask;
            }
        }
        return;
    }

    /* ASCII8: 0x6000/w0, 0x6800/w1, 0x7000/w2, 0x7800/w3.
     * ASCII16 is approximated with this decode (see msx_guess_mapper). */
    if (addr >= 0x6000 && addr <= 0x67FF) {
        ss->bank[0] = val & ss->romMask;
    } else if (addr >= 0x6800 && addr <= 0x6FFF) {
        ss->bank[1] = val & ss->romMask;
    } else if (addr >= 0x7000 && addr <= 0x77FF) {
        ss->bank[2] = val & ss->romMask;
    } else if (addr >= 0x7800 && addr <= 0x7FFF) {
        ss->bank[3] = val & ss->romMask;
    }
}

MSX_MapperType msx_mapper_guess(const uint8_t *pImage, unsigned nSize)
{
    if (!pImage) return MSX_MAPPER_NONE;
    /* Anything that fits in a single 32KB page pair with no bank selects has
     * no mapper. Small ROMs (<64KB) are treated as plain even if a stray
     * 0x32 exists. */
    if (nSize < 0x10000) return MSX_MAPPER_NONE;

    int nScc = 0, nKonami = 0, nAscii8 = 0, nAscii16 = 0;
    unsigned i;
    for (i = 0; i + 3 <= nSize; i++) {
        if (pImage[i] != 0x32) continue; /* LD (nn),A */
        unsigned v = (unsigned)pImage[i + 1] | ((unsigned)pImage[i + 2] << 8);
        switch (v) {
        case 0x5000: case 0x9000: case 0xB000:
            nScc++; break;                              /* Konami-SCC only */
        case 0x4000: case 0x8000: case 0xA000:
            nKonami++; break;                           /* Konami only */
        case 0x6800: case 0x7800:
            nAscii8++; break;                           /* ASCII8 only */
        case 0x6000:
            nKonami++; nAscii8++; nAscii16++; break;    /* ambiguous */
        case 0x7000:
            nScc++; nAscii8++; nAscii16++; break;       /* ambiguous */
        case 0x77FF:
            nAscii16++; break;                          /* ASCII16 marker */
        default:
            break;
        }
    }
    /* openMSX biases away from ASCII8 (its marker is weakest). */
    if (nAscii8 > 0) nAscii8--;

    if (nScc == 0 && nKonami == 0 && nAscii8 == 0 && nAscii16 == 0) {
        /* No recognizable idiom: fall back to ASCII8 (the common MegaROM). */
        return MSX_MAPPER_ASCII8;
    }
    if (nScc > 0 && nScc >= nKonami && nScc >= nAscii8 && nScc >= nAscii16)
        return MSX_MAPPER_KONAMI_SCC;
    if (nKonami > 0 && nKonami >= nAscii8 && nKonami >= nAscii16)
        return MSX_MAPPER_KONAMI;
    if (nAscii8 >= nAscii16) return MSX_MAPPER_ASCII8;
    /* ASCII16 wins, but we approximate it with the shared ASCII8 decode. */
    return MSX_MAPPER_ASCII8;
}
