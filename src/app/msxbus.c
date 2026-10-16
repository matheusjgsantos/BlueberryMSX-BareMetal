//
// msxbus.c
//
// BlueberryMSX - Bare-metal MSX emulator for Raspberry Pi (Circle)
//
// Low-level RPMC expansion-board bus (V5). Port of the hardware-verified
// driver in BlueberryMSX-2.0plus/Src/IoDevice/MsxBusPi.c to bare metal.
//
// Protocol notes (from Doc/RPMC.md in the reference tree):
//  - The Pi drives address and control straight onto GPIO 8-15 and latches
//    the address with LE_A; the control flags (SLTSL1/SLTSL3/MREQ/IORQ/RD/WR/
//    CS1/CS2, all active-low) are live-driven on the same lines while LE_C
//    holds them for the rest of the access.
//  - DATA is GPIO 0-7, tri-stated by DAT_DIR (0=Pi writes, 1=board drives).
//  - WAIT (GPIO 25) can stretch a cycle; it is polled with a hard bound.
//  - The master clock is GPCLK0 (GPIO 20, ALT0), ~3,579,545 Hz.
//
// GPIO 14/15 are IORQ/MREQ here. That is the UART TX/RX pair in Circle, so
// the caller MUST keep UART output off while the bus is active (msx.ini).
//
// This file deliberately does raw volatile MMIO instead of Circle's
// write32()/read32(): the bus is touched on every emulated cartridge byte,
// and __dsb() after each access would dominate the cost. Volatile accesses
// are ordered among themselves and the IO region is mapped device memory,
// so the strobe ordering is safe.

#include "msxbus.h"
#include <assert.h>
#include <stdlib.h>
#include <string.h>

#ifndef RASPPI
#define RASPPI 3
#endif

// Peripheral base (compile-time per Circle RASPPI, same as
// circle/include/circle/bcm2835.h). 32-bit build, so these are also the
// virtual addresses Circle maps the IO region to.
#if RASPPI == 4
#define MSXBUS_IO_BASE	0xFE000000UL
#elif RASPPI == 1
#define MSXBUS_IO_BASE	0x20000000UL
#else
#define MSXBUS_IO_BASE	0x3F000000UL
#endif

#define MSXBUS_GPIO_BASE	(MSXBUS_IO_BASE + 0x200000UL)
#define MSXBUS_CM_BASE		(MSXBUS_IO_BASE + 0x101000UL)

// GPIO register offsets (BCM283x family).
#define MSXBUS_GPFSEL0		0x00
#define MSXBUS_GPSET0		0x1C
#define MSXBUS_GPCLR0		0x28
#define MSXBUS_GPLEV0		0x34
#define MSXBUS_GPPUD		0x94
#define MSXBUS_GPPUDCLK0	0x98
#define MSXBUS_GPPUPPDN0	0xE4

// Clock manager: GP0 control/divisor and the register-write passkey.
#define MSXBUS_CM_GP0CTL	(MSXBUS_CM_BASE + 0x70)
#define MSXBUS_CM_GP0DIV	(MSXBUS_CM_BASE + 0x74)
#define MSXBUS_CM_PASSWD	(0x5AUL << 24)
#define MSXBUS_CM_CTL_KILL	(1 << 5)
#define MSXBUS_CM_CTL_ENAB	(1 << 4)
#define MSXBUS_CM_CTL_BUSY	(1 << 7)
#define MSXBUS_CM_CTL_MASH(x)	((x) << 9)
#define MSXBUS_CM_CTL_SRC(x)	((x) << 0)
#define MSXBUS_CM_CTL_SRC_OSC	1
#define MSXBUS_CM_DIV_DIVI(x)	((x) << 12)
#define MSXBUS_CM_DIV_DIVF(x)	((x) << 0)

// RPMC V5 pin map (GPIO numbers).
#define MSXBUS_D0		0
#define MSXBUS_SLTSL1		8	// also A8
#define MSXBUS_SLTSL3		9	// also A9 / CS12
#define MSXBUS_CS1		10	// also A10
#define MSXBUS_CS2		11	// also A11
#define MSXBUS_RD		12	// also A12
#define MSXBUS_WR		13	// also A13
#define MSXBUS_IORQ		14	// also A14
#define MSXBUS_MREQ		15	// also A15
#define MSXBUS_LE_A		16
#define MSXBUS_LE_C		17
#define MSXBUS_LE_D		18
#define MSXBUS_RESET		19
#define MSXBUS_CLK		20
#define MSXBUS_DAT_DIR		21
#define MSXBUS_SRCLK		22
#define MSXBUS_RCLK		23
#define MSXBUS_INT		24
#define MSXBUS_WAIT		25
#define MSXBUS_SER		26
#define MSXBUS_SW1		27

// Line-level bit masks.
#define MSXBUS_SLTSL1_BIT	(1u << MSXBUS_SLTSL1)
#define MSXBUS_SLTSL3_BIT	(1u << MSXBUS_SLTSL3)
#define MSXBUS_CS1_BIT		(1u << MSXBUS_CS1)
#define MSXBUS_CS2_BIT		(1u << MSXBUS_CS2)
#define MSXBUS_RD_BIT		(1u << MSXBUS_RD)
#define MSXBUS_WR_BIT		(1u << MSXBUS_WR)
#define MSXBUS_IORQ_BIT		(1u << MSXBUS_IORQ)
#define MSXBUS_MREQ_BIT		(1u << MSXBUS_MREQ)

// Idle value of the control group (all active-low signals de-asserted).
#define MSXBUS_CONTROLS		(MSXBUS_SLTSL1_BIT | MSXBUS_SLTSL3_BIT | \
				 MSXBUS_MREQ_BIT | MSXBUS_IORQ_BIT | \
				 MSXBUS_RD_BIT | MSXBUS_WR_BIT | \
				 MSXBUS_CS1_BIT | MSXBUS_CS2_BIT)

#define MSXBUS_LE_A_BIT		(1u << MSXBUS_LE_A)
#define MSXBUS_LE_C_BIT		(1u << MSXBUS_LE_C)
#define MSXBUS_LE_D_BIT		(1u << MSXBUS_LE_D)
#define MSXBUS_RESET_BIT	(1u << MSXBUS_RESET)
#define MSXBUS_CLK_BIT		(1u << MSXBUS_CLK)
#define MSXBUS_DAT_DIR_BIT	(1u << MSXBUS_DAT_DIR)
#define MSXBUS_SRCLK_BIT	(1u << MSXBUS_SRCLK)
#define MSXBUS_RCLK_BIT		(1u << MSXBUS_RCLK)
#define MSXBUS_SER_BIT		(1u << MSXBUS_SER)
#define MSXBUS_INT_BIT		(1u << MSXBUS_INT)
#define MSXBUS_WAIT_BIT		(1u << MSXBUS_WAIT)
#define MSXBUS_SW1_BIT		(1u << MSXBUS_SW1)

// WAIT poll bound (matches the reference driver).
#define MSXBUS_WAIT_MAX		500000

// Register access.
#define MSXBUS_SET(mask)	(*msxbus_gpset = (mask))
#define MSXBUS_CLR(mask)	(*msxbus_gpclr = (mask))
#define MSXBUS_LEV()		(*msxbus_gplev)

static volatile uint32_t *msxbus_gpset;
static volatile uint32_t *msxbus_gpclr;
static volatile uint32_t *msxbus_gplev;

// Post-WAIT settle delay for memory reads (see MsxBus_SetReadDelay). The
// reference uses 100; WAIT already signals data-ready, so 16 is the default.
static int msxbus_read_delay = 16;

// Read page cache (see MsxBus_SetCacheMode). One 64 KiB data array and one
// 64 KiB "valid" array per connector, lazily allocated so live mode costs
// nothing. A byte is cached the first time the emulator reads it (reads stay
// in program order, so a read-triggered mapper still advances as on the real
// bus until the byte is cached); any write to the connector flushes it.
static int msxbus_cache_mode = 0;
static uint8_t *msxbus_cache[MsxBusSlotCount];
static uint8_t *msxbus_cache_valid[MsxBusSlotCount];

static unsigned long msxbus_counter_nreads[MsxBusSlotCount];
static unsigned long msxbus_counter_nwrites[MsxBusSlotCount];
static unsigned long msxbus_counter_nioreads;
static unsigned long msxbus_counter_niowrites;
static unsigned long msxbus_counter_wait_iters;
static unsigned long msxbus_counter_wait_timeouts;
static unsigned long msxbus_counter_slow_ops;
static unsigned long msxbus_counter_cache_hits;
static unsigned long msxbus_counter_cache_misses;

// Bank-switch diagnostics (see MsxBus_LogWrite* / MsxBus_LogRead*). Ring
// buffers, so only the most recent accesses survive; the writer records every
// cart write in 0x4000-0xBFFF (bank-register stores are rare) and the reader
// records only the first 4 bytes of each 8 KiB bank (the entry vectors the
// loader probes). Both are always recorded; dumping is on demand.
#define MSXBUS_LOG_MAX 512
static uint16_t msxbus_wlog_addr[MSXBUS_LOG_MAX];
static uint8_t  msxbus_wlog_val [MSXBUS_LOG_MAX];
static uint8_t  msxbus_wlog_slot[MSXBUS_LOG_MAX];
static unsigned msxbus_wlog_head;
static unsigned msxbus_wlog_count;
static uint16_t msxbus_rlog_addr[MSXBUS_LOG_MAX];
static uint8_t  msxbus_rlog_val [MSXBUS_LOG_MAX];
static unsigned msxbus_rlog_head;
static unsigned msxbus_rlog_count;

static void msxbus_log_write (int nSlot, uint16_t nAddr, uint8_t nVal)
{
	if (nAddr < 0x4000 || nAddr >= 0xC000)
	{
		return;
	}
	unsigned i = msxbus_wlog_head;
	msxbus_wlog_addr[i] = nAddr;
	msxbus_wlog_val [i] = nVal;
	msxbus_wlog_slot[i] = (uint8_t) nSlot;
	msxbus_wlog_head = (i + 1) % MSXBUS_LOG_MAX;
	if (msxbus_wlog_count < MSXBUS_LOG_MAX)
	{
		msxbus_wlog_count++;
	}
}

static void msxbus_log_read (uint16_t nAddr, uint8_t nVal)
{
	if (nAddr < 0x4000 || nAddr >= 0xC000 || (nAddr & 0x1FFF) >= 4)
	{
		return;
	}
	unsigned i = msxbus_rlog_head;
	msxbus_rlog_addr[i] = nAddr;
	msxbus_rlog_val [i] = nVal;
	msxbus_rlog_head = (i + 1) % MSXBUS_LOG_MAX;
	if (msxbus_rlog_count < MSXBUS_LOG_MAX)
	{
		msxbus_rlog_count++;
	}
}

static inline void msxbus_dsb (void)
{
	__asm__ __volatile__ ("dsb sy" ::: "memory");
}

// Burn a few cycles (matches the reference SetDelay/loop style).
static inline void msxbus_delay (int n)
{
	for (int i = 0; i < n; i++)
	{
		MSXBUS_SET (0);
	}
}

// GPFSEL of pin: return address + field shift.
static inline unsigned msxbus_fsel_addr (int nPin, uint32_t **pReg)
{
	*pReg = (uint32_t *) (MSXBUS_GPIO_BASE + MSXBUS_GPFSEL0 + (nPin / 10) * 4);
	return (unsigned) (nPin % 10) * 3;
}

static void msxbus_set_function (int nPin, unsigned nFunction)
{
	uint32_t *pReg;
	unsigned nShift = msxbus_fsel_addr (nPin, &pReg);
	uint32_t nVal = *pReg;
	nVal &= ~(7u << nShift);
	nVal |= (nFunction & 7u) << nShift;
	*pReg = nVal;
}

static void msxbus_set_input (int nPin)
{
	msxbus_set_function (nPin, 0);
}

static void msxbus_set_output (int nPin)
{
	msxbus_set_function (nPin, 1);
}

// Enable the pull-up on one pin. BCM283x (RASPPI <= 3) uses the legacy
// GPPUD/GPPUDCLK handshake; BCM2711 uses the GPPUPPDN register fields.
static void msxbus_pull_up (int nPin)
{
#if RASPPI <= 3
	volatile uint32_t *pPud   = (volatile uint32_t *) (MSXBUS_GPIO_BASE + MSXBUS_GPPUD);
	volatile uint32_t *pPudclk = (volatile uint32_t *) (MSXBUS_GPIO_BASE + MSXBUS_GPPUDCLK0);

	*pPud = 2;					// pull-up
	for (volatile int d = 0; d < 1000; d++) { }	// > 150 ns settle
	*pPudclk = 1u << nPin;
	*pPud = 0;
	*pPudclk = 0;
#else
	volatile uint32_t *pPd =
		(volatile uint32_t *) (MSXBUS_GPIO_BASE + MSXBUS_GPPUPPDN0 + (nPin / 16) * 4);
	unsigned nShift = (nPin % 16) * 2;
	uint32_t nVal = *pPd;
	nVal &= ~(3u << nShift);
	nVal |= 1u << nShift;				// 1 = pull-up on BCM2711
	*pPd = nVal;
#endif
}

// Set the clock source/divisor, then fsel GPIO 20 to ALT0 (GPCLK0).
// nDivi/nDivF are passed in so the caller can compute them from the runtime
// clock-source rate (19.2 MHz on Pi 3/Zero 2, 54 MHz on Pi 4/400); MASH=1
// dithering produces the fractional frequency.
static void msxbus_enable_clock (unsigned nDivi, unsigned nDivF)
{
	volatile uint32_t *pCtl = (volatile uint32_t *) MSXBUS_CM_GP0CTL;
	volatile uint32_t *pDiv = (volatile uint32_t *) MSXBUS_CM_GP0DIV;

	assert (2 <= nDivi && nDivi <= 4095);
	assert (nDivF <= 4095);

	// Stop, wait BUSY clear.
	*pCtl = MSXBUS_CM_PASSWD | MSXBUS_CM_CTL_KILL;
	while (*pCtl & MSXBUS_CM_CTL_BUSY)
	{
	}

	*pDiv = MSXBUS_CM_PASSWD | MSXBUS_CM_DIV_DIVI (nDivi) | MSXBUS_CM_DIV_DIVF (nDivF);
	msxbus_delay (2000);

	// Source = oscillator, MASH = 1 - divider off (then enable).
	*pCtl = MSXBUS_CM_PASSWD | MSXBUS_CM_CTL_MASH (1) | MSXBUS_CM_CTL_SRC (MSXBUS_CM_CTL_SRC_OSC);
	msxbus_delay (2000);
	*pCtl = (*pCtl | MSXBUS_CM_PASSWD | MSXBUS_CM_CTL_ENAB);

	msxbus_set_function (MSXBUS_CLK, 4);	// ALT0 = GPCLK0 on GPIO 20
}

// Time base used by SetAddress/SetData/GetData.
static void msxbus_set_address (uint16_t nAddr)
{
	MSXBUS_CLR (MSXBUS_LE_C_BIT | 0xffff | MSXBUS_DAT_DIR_BIT);
	MSXBUS_SET (MSXBUS_LE_A_BIT | MSXBUS_LE_D_BIT | nAddr);
	MSXBUS_SET (MSXBUS_LE_A_BIT);
	MSXBUS_CLR (MSXBUS_LE_A_BIT);
	MSXBUS_SET (MSXBUS_LE_C_BIT | MSXBUS_CONTROLS);
	MSXBUS_CLR (MSXBUS_LE_D_BIT | 0xff);
}

static void msxbus_set_data (uint32_t nIoFlag, uint32_t nFlag, int nDelay,
			     unsigned char nByte)
{
	// The control latch (74LS373, enabled by LE_C) must stay transparent
	// while the select/strobe lines are asserted. Clearing LE_C here freezes
	// the latch and blocks the /WR pulse from ever reaching the cartridge
	// (reads still work, which is why writes silently did nothing).
	// msxbus_set_address leaves LE_C high; keep it high for the whole access
	// and latch it (LE_C low) only at the end. Mirrors the known-good
	// upstream msxslot / RGR SetData.
	MSXBUS_SET (nByte);
	MSXBUS_CLR (nFlag | MSXBUS_WR_BIT);
	MSXBUS_SET (nIoFlag | MSXBUS_WR_BIT);
	MSXBUS_SET (nIoFlag | MSXBUS_WR_BIT);
	MSXBUS_CLR (nFlag);
	msxbus_delay (5);
	MSXBUS_CLR (MSXBUS_WR_BIT);

	int wait_cnt = 0;
	while (!(MSXBUS_LEV () & MSXBUS_WAIT_BIT) && wait_cnt++ < MSXBUS_WAIT_MAX)
	{
	}
	msxbus_counter_wait_iters += (unsigned long) (wait_cnt < MSXBUS_WAIT_MAX
							? wait_cnt : MSXBUS_WAIT_MAX);
	if (wait_cnt > 500)
	{
		msxbus_counter_slow_ops++;
	}
	if (wait_cnt >= MSXBUS_WAIT_MAX)
	{
		msxbus_counter_wait_timeouts++;
	}

	msxbus_delay (nDelay);
	MSXBUS_SET (MSXBUS_WR_BIT);
	msxbus_delay (2);
	MSXBUS_SET (MSXBUS_CONTROLS);
	MSXBUS_CLR (MSXBUS_LE_C_BIT);
}

static unsigned char msxbus_get_data (uint32_t nFlag, uint32_t nRFlag, int nDelay)
{
	int wait_cnt = 0;

	MSXBUS_SET (MSXBUS_DAT_DIR_BIT | 0xff);
	MSXBUS_CLR (nFlag);
	msxbus_delay (1);
	MSXBUS_CLR (nRFlag);

	while (!(MSXBUS_LEV () & MSXBUS_WAIT_BIT) && wait_cnt++ < MSXBUS_WAIT_MAX)
	{
	}
	msxbus_counter_wait_iters += (unsigned long) (wait_cnt < MSXBUS_WAIT_MAX
							? wait_cnt : MSXBUS_WAIT_MAX);
	if (wait_cnt > 500)
	{
		msxbus_counter_slow_ops++;
	}

	msxbus_delay (nDelay);
	unsigned char nByte = (unsigned char) (MSXBUS_LEV () & 0xff);

	if (wait_cnt >= MSXBUS_WAIT_MAX)
	{
		msxbus_counter_wait_timeouts++;
		MSXBUS_SET (MSXBUS_LE_D_BIT | MSXBUS_CONTROLS);
		MSXBUS_CLR (MSXBUS_LE_C_BIT);
		return 0xFF;
	}

	MSXBUS_SET (MSXBUS_LE_D_BIT | MSXBUS_CONTROLS);
	MSXBUS_CLR (MSXBUS_LE_C_BIT);
	return nByte;
}

// Static mask for the slot-select + memory-request group of one connector.
static uint32_t msxbus_slot_sel (int nSlot)
{
	return nSlot == MsxBusSlot1 ? MSXBUS_SLTSL1_BIT : MSXBUS_SLTSL3_BIT;
}

void MsxBus_Init (unsigned nCkDivi, unsigned nCkDivF)
{
	msxbus_gpset = (volatile uint32_t *) (MSXBUS_GPIO_BASE + MSXBUS_GPSET0);
	msxbus_gpclr = (volatile uint32_t *) (MSXBUS_GPIO_BASE + MSXBUS_GPCLR0);
	msxbus_gplev = (volatile uint32_t *) (MSXBUS_GPIO_BASE + MSXBUS_GPLEV0);

	// All bus pins start as outputs; WAIT/INT/SW1 become inputs afterwards.
	// CLK is configured to ALT0 by the clock setup. This also re-claims
	// GPIO 14/15 (the UART TX/RX pair) as IORQ/MREQ.
	for (int p = 0; p < 28; p++)
	{
		switch (p)
		{
		case MSXBUS_CLK:	// configured by msxbus_enable_clock()
		case MSXBUS_WAIT:	// cart -> Pi
		case MSXBUS_INT:	// cart -> Pi
		case MSXBUS_SW1:	// switch on the board
			break;

		default:
			msxbus_set_output (p);
			break;
		}
	}

	msxbus_set_input (MSXBUS_WAIT);
	msxbus_pull_up (MSXBUS_WAIT);
	msxbus_set_input (MSXBUS_INT);
	msxbus_pull_up (MSXBUS_INT);
	msxbus_set_input (MSXBUS_SW1);
	msxbus_pull_up (MSXBUS_SW1);

	// Drive the idle state: re-assert all control lines and both address
	// latches so the board latches the idle controls, then pulse RESET.
	MSXBUS_SET (MSXBUS_LE_C_BIT | MSXBUS_CONTROLS | MSXBUS_WAIT_BIT | MSXBUS_INT_BIT);
	MSXBUS_SET (MSXBUS_LE_A_BIT | MSXBUS_LE_D_BIT);
	MSXBUS_CLR (MSXBUS_LE_C_BIT | 0xffff);
	MSXBUS_CLR (MSXBUS_LE_C_BIT);
	msxbus_dsb ();

	msxbus_enable_clock (nCkDivi, nCkDivF);

	MSXBUS_CLR (MSXBUS_RESET_BIT);
	msxbus_delay (2000000);
	MSXBUS_SET (MSXBUS_RESET_BIT);
	msxbus_delay (1000000);
	msxbus_dsb ();

	for (int i = 0; i < MsxBusSlotCount; i++)
	{
		msxbus_counter_nreads[i] = 0;
		msxbus_counter_nwrites[i] = 0;
	}
	msxbus_counter_nioreads = 0;
	msxbus_counter_niowrites = 0;
	msxbus_counter_wait_iters = 0;
	msxbus_counter_wait_timeouts = 0;
	msxbus_counter_slow_ops = 0;
}

void MsxBus_Reset (void)
{
	MSXBUS_CLR (MSXBUS_RESET_BIT);
	msxbus_delay (2000000);
	MSXBUS_SET (MSXBUS_RESET_BIT);
	msxbus_delay (1000000);
	msxbus_dsb ();
}

int MsxBus_PackPresent (void)
{
	return (MSXBUS_LEV () & MSXBUS_SW1_BIT) ? 0 : 1;
}

// Raw one-byte memory read on the bus (no cache). Kept separate so the cache
// wrapper below can fall back to it on a miss.
static uint8_t msxbus_bus_read (int nSlot, uint16_t nAddr)
{
	uint32_t nCs1 = (nAddr & 0xc000) == 0x4000 ? MSXBUS_CS1_BIT : 0;
	uint32_t nCs2 = (nAddr & 0xc000) == 0x8000 ? MSXBUS_CS2_BIT : 0;

	msxbus_set_address (nAddr);
	uint8_t nByte = msxbus_get_data (msxbus_slot_sel (nSlot) | MSXBUS_MREQ_BIT,
					 MSXBUS_RD_BIT | nCs1 | nCs2, msxbus_read_delay);
	msxbus_counter_nreads[nSlot]++;
	msxbus_log_read (nAddr, nByte);
	MsxBus_Leds (0x80 | (nSlot == MsxBusSlot1 ? 0x20 : 0x40));
	return nByte;
}

// Raw one-byte memory write on the bus (no cache). The cache is flushed by the
// public MsxBus_Write wrapper, because a write may be a bank-register store.
static void msxbus_bus_write (int nSlot, uint16_t nAddr, uint8_t nByte)
{
	uint32_t nCs;
	if ((nAddr & 0xc000) == 0x4000)
	{
		nCs = MSXBUS_CS1_BIT;
	}
	else if ((nAddr & 0xc000) == 0x8000)
	{
		nCs = MSXBUS_CS2_BIT;
	}
	else
	{
		nCs = 0;
	}

	msxbus_set_address (nAddr);
	msxbus_set_data (MSXBUS_MREQ_BIT, msxbus_slot_sel (nSlot) | MSXBUS_MREQ_BIT | nCs,
			 45, nByte);

	// The reference driver settles the board's flash after a bank-register
	// write of some cartridges; harmless otherwise.
	if ((nAddr & 0x1800) == 0x1000)
	{
		msxbus_delay (500);
	}
	msxbus_counter_nwrites[nSlot]++;
	msxbus_log_write (nSlot, nAddr, nByte);
	MsxBus_Leds (0x80 | (nSlot == MsxBusSlot1 ? 0x20 : 0x40));
}

uint8_t MsxBus_Read (int nSlot, uint16_t nAddr)
{
	if (msxbus_cache_mode && msxbus_cache_valid[nSlot] != 0)
	{
		if (msxbus_cache_valid[nSlot][nAddr])
		{
			msxbus_counter_cache_hits++;
			return msxbus_cache[nSlot][nAddr];
		}

		msxbus_counter_cache_misses++;
		uint8_t nByte = msxbus_bus_read (nSlot, nAddr);
		msxbus_cache[nSlot][nAddr] = nByte;
		msxbus_cache_valid[nSlot][nAddr] = 1;
		return nByte;
	}

	return msxbus_bus_read (nSlot, nAddr);
}

void MsxBus_Write (int nSlot, uint16_t nAddr, uint8_t nByte)
{
	msxbus_bus_write (nSlot, nAddr, nByte);

	// Any write to a connector can move a bank register, so drop the whole
	// connector's cache. Over-invalidating is safe, only slower to warm up.
	if (msxbus_cache_mode && msxbus_cache_valid[nSlot] != 0)
	{
		memset (msxbus_cache_valid[nSlot], 0, 0x10000);
	}
}

uint8_t MsxBus_ReadIo (uint16_t nAddr)
{
	msxbus_set_address (nAddr);
	uint8_t nByte = msxbus_get_data (MSXBUS_IORQ_BIT, MSXBUS_RD_BIT, 45);
	msxbus_counter_nioreads++;
	MsxBus_Leds (0x80 | 0x10);
	msxbus_delay (2000);
	MsxBus_Leds (0x80);
	return nByte;
}

void MsxBus_WriteIo (uint16_t nAddr, uint8_t nByte)
{
	msxbus_set_address (nAddr);
	msxbus_set_data (MSXBUS_IORQ_BIT, MSXBUS_IORQ_BIT, 55, nByte);
	msxbus_counter_niowrites++;
	MsxBus_Leds (0x80 | 0x10);
	msxbus_delay (2000);
	MsxBus_Leds (0x80);

	// A few cartridges expose their bank latch through an I/O port; the port
	// does not say which connector, so flush both. Port stores are rare (the
	// VDP/PSG/slot registers are handled inside the emulator), so this is
	// cheap insurance for those edge-case packs.
	if (msxbus_cache_mode)
	{
		for (int i = 0; i < MsxBusSlotCount; i++)
		{
			if (msxbus_cache_valid[i] != 0)
			{
				memset (msxbus_cache_valid[i], 0, 0x10000);
			}
		}
	}
}

void MsxBus_Leds (unsigned char nByte)
{
	static unsigned char s_oldByte = 0;
	// Don't debounce if I/O activity bit changes quickly; but easier to just
	// update every time (shifting 8 bits is cheap). Also slot bits can stay.
	if (nByte == s_oldByte)
	{
		// allow forced refresh? not needed
	}
	s_oldByte = nByte;

	MSXBUS_CLR (MSXBUS_SRCLK_BIT | MSXBUS_RCLK_BIT | MSXBUS_SER_BIT);
	for (int i = 0; i < 8; i++)
	{
		if (nByte & (1 << i))
		{
			MSXBUS_SET (MSXBUS_SER_BIT);
		}
		else
		{
			MSXBUS_CLR (MSXBUS_SER_BIT);
		}
		MSXBUS_SET (MSXBUS_SRCLK_BIT);
		MSXBUS_CLR (MSXBUS_SRCLK_BIT);
	}
	MSXBUS_SET (MSXBUS_RCLK_BIT);
}

void MsxBus_SetReadDelay (int nDelay)
{
	if (nDelay < 0)
	{
		nDelay = 0;
	}
	else if (nDelay > 100000)
	{
		nDelay = 100000;
	}
	msxbus_read_delay = nDelay;
}

void MsxBus_SetCacheMode (int bEnable)
{
	msxbus_cache_mode = bEnable ? 1 : 0;

	if (!msxbus_cache_mode)
	{
		return;
	}

	for (int i = 0; i < MsxBusSlotCount; i++)
	{
		if (msxbus_cache[i] == 0)
		{
			msxbus_cache[i] = malloc (0x10000);
			msxbus_cache_valid[i] = malloc (0x10000);
		}
		if (msxbus_cache_valid[i] != 0)
		{
			memset (msxbus_cache_valid[i], 0, 0x10000);
		}
	}
}

void MsxBus_GetStats (MsxBusStats *pStats)
{
	for (int i = 0; i < MsxBusSlotCount; i++)
	{
		pStats->nMemReads[i] = msxbus_counter_nreads[i];
		pStats->nMemWrites[i] = msxbus_counter_nwrites[i];
	}
	pStats->nIoReads = msxbus_counter_nioreads;
	pStats->nIoWrites = msxbus_counter_niowrites;
	pStats->nWaitIters = msxbus_counter_wait_iters;
	pStats->nWaitTimeouts = msxbus_counter_wait_timeouts;
	pStats->nSlowOps = msxbus_counter_slow_ops;
	pStats->nCacheHits = msxbus_counter_cache_hits;
	pStats->nCacheMisses = msxbus_counter_cache_misses;
}

int MsxBus_LogWriteCount (void)
{
	return (int) msxbus_wlog_count;
}

int MsxBus_LogWriteGet (int nIndex, uint16_t *pAddr, uint8_t *pSlot, uint8_t *pVal)
{
	if (nIndex < 0 || (unsigned) nIndex >= msxbus_wlog_count)
	{
		return 0;
	}
	unsigned i = (msxbus_wlog_head + MSXBUS_LOG_MAX - msxbus_wlog_count + (unsigned) nIndex) % MSXBUS_LOG_MAX;
	if (pAddr) *pAddr = msxbus_wlog_addr[i];
	if (pSlot) *pSlot = msxbus_wlog_slot[i];
	if (pVal)  *pVal  = msxbus_wlog_val[i];
	return 1;
}

int MsxBus_LogReadCount (void)
{
	return (int) msxbus_rlog_count;
}

int MsxBus_LogReadGet (int nIndex, uint16_t *pAddr, uint8_t *pVal)
{
	if (nIndex < 0 || (unsigned) nIndex >= msxbus_rlog_count)
	{
		return 0;
	}
	unsigned i = (msxbus_rlog_head + MSXBUS_LOG_MAX - msxbus_rlog_count + (unsigned) nIndex) % MSXBUS_LOG_MAX;
	if (pAddr) *pAddr = msxbus_rlog_addr[i];
	if (pVal)  *pVal  = msxbus_rlog_val[i];
	return 1;
}