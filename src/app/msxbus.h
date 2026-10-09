//
// msxbus.h
//
// BlueberryMSX - Bare-metal MSX emulator for Raspberry Pi (Circle)
//
// Low-level RPMC expansion-board bus (V5). Port of the hardware-verified
// driver in BlueberryMSX-2.0plus/Src/IoDevice/MsxBusPi.c to bare metal.
//
// The board maps two real MSX cartridge slots onto the Pi GPIO header:
//   connector 1 -> SLTSL1  -> MsxBusSlot1
//   connector 3 -> SLTSL3  -> MsxBusSlot3
// Address/control share GPIO 8-15 (latched via LE_A/LE_C), data is GPIO
// 0-7, and the MSX master clock (3,579,545 Hz) comes from GPCLK0 (GPIO 20).
//
// While the bus is active, GPIO 14/15 are IORQ/MREQ - the same pins the
// UART uses. The caller MUST NOT log over the UART while the bus is in use
// (see msx.ini log mode).
//

#ifndef _msx_msxbus_h
#define _msx_msxbus_h

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

// Emulator-side slot identifiers (match the board connectors).
enum
{
	MsxBusSlot1 = 0,	// board connector 1 (SLTSL1)
	MsxBusSlot3 = 1,	// board connector 3 (SLTSL3)
	MsxBusSlotCount
};

// Telemetry counters (cheap, always updated, never reset except on init).
typedef struct
{
	unsigned long nMemReads [MsxBusSlotCount];
	unsigned long nMemWrites [MsxBusSlotCount];
	unsigned long nIoReads;
	unsigned long nIoWrites;
	unsigned long nWaitIters;	// total WAIT polling iterations
	unsigned long nWaitTimeouts;	// WAIT never released within the bound
	unsigned long nSlowOps;		// ops whose WAIT took > 500 iterations
} MsxBusStats;

/// Initialize the bus: pin directions, pull-ups (WAIT/INT/SW1), GPCLK0 on
/// GPIO 20 and a reset pulse. nCkDivi/nCkDivF must produce ~3,579,545 Hz
/// from the runtime clock source (see kernel.cpp / CMachineInfo).
void MsxBus_Init (unsigned nCkDivi, unsigned nCkDivF);

/// Re-pulse the cartridge RESET line.
void MsxBus_Reset (void);

/// SW1 (active low) says a cartridge is present in which slot the hardware
/// exposes; returns non-zero when the line reads low. Not slot-specific:
/// SW1 is a single pack-presence line on the board.
int MsxBus_PackPresent (void);

/// One memory access on the physical bus. slot: MsxBusSlot1 or MsxBusSlot3.
uint8_t MsxBus_Read (int nSlot, uint16_t nAddr);
void MsxBus_Write (int nSlot, uint16_t nAddr, uint8_t nVal);

/// One I/O-port access (MSX IOPORT). Only used by the live-bus mode.
uint8_t MsxBus_ReadIo (uint16_t nAddr);
void MsxBus_WriteIo (uint16_t nAddr, uint8_t nVal);

/// Front-panel LEDs (74HC595 on GPIO 22/23/26). Verified bit map:
/// 0x80 PWR, 0x40 SLT2, 0x20 SLT1, 0x10 I/O, 0x08 HAN, 0x04 CAPS.
/// Only re-shifts when the byte changes.
void MsxBus_Leds (unsigned char nByte);

/// Copy the telemetry counters.
void MsxBus_GetStats (MsxBusStats *pStats);

#ifdef __cplusplus
}
#endif

#endif