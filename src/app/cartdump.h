//
// cartdump.h
//
// BlueberryMSX - Bare-metal MSX emulator for Raspberry Pi (Circle)
//
// Shared banked-cartridge dump walk. A raw linear read (0x4000..) only ever
// sees the four 8 KiB banks a MegaROM maps at power-on, so any cart larger
// than 32 KiB comes out wrapped/garbled. This walk instead selects each 8 KiB
// bank into the mapper's window and reads it back. It stops early when a bank
// repeats bank 0 -- a cart's bank register ignores the high bits it does not
// decode, so the first repeat reveals the real ROM size (auto-size).
//
// The read/write callbacks carry the connector slot, so the same walk drives
// the RPMC bus in the firmware and a fake cart in the host test.
//

#ifndef _msx_cartdump_h
#define _msx_cartdump_h

#include <stdint.h>

typedef uint8_t (*TCartDumpRead)  (int nSlot, uint16_t nAddr);
typedef void    (*TCartDumpWrite) (int nSlot, uint16_t nAddr, uint8_t nVal);

// nReg:  the mapper's bank-select register to write (e.g. 0x5000 Konami-SCC)
// nBase: read base of the window that register selects (e.g. 0x4000)
// nCap:  upper bound on bytes to read (multiple of 8 KiB)
// Returns bytes written to pBuf (a multiple of 8 KiB; 0 if nCap < 8 KiB).
static inline unsigned CartDump_Banked (TCartDumpRead pRead, TCartDumpWrite pWrite,
					int nSlot, uint16_t nReg, uint16_t nBase,
					unsigned char *pBuf, unsigned nCap)
{
	unsigned nBanks = nCap / 0x2000u;
	unsigned b;

	for (b = 0; b < nBanks; b++)
	{
		pWrite (nSlot, nReg, (uint8_t) b);

		unsigned char *pDst = pBuf + b * 0x2000u;
		for (unsigned j = 0; j < 0x2000u; j++)
		{
			pDst[j] = pRead (nSlot, (uint16_t) (nBase + j));
		}

		if (b > 0)
		{
			unsigned k;
			for (k = 0; k < 0x2000u; k++)
			{
				if (pBuf[k] != pDst[k])
				{
					break;
				}
			}
			if (k == 0x2000u)
			{
				break;		// wrapped back to bank 0: real size is b
			}
		}
	}

	return b * 0x2000u;
}

#endif
