//
// msxconfig.h
//
// BlueberryMSX - Bare-metal MSX emulator for Raspberry Pi (Circle)
//
// boot-time configuration read from msx.ini on the FAT boot partition.
// Parsed after the EMMC filesystem is mounted (the kernel command line
// cannot carry these settings: CKernelOptions only reads cmdline.txt).
//

#ifndef _msx_msxconfig_h
#define _msx_msxconfig_h

class CFATFileSystem;

// Where the log goes. "net" is accepted and currently behaves like "file"
// (the HTTP drain is a later milestone). The point of every non-"uart"
// choice is to keep the UART off: GPIO 14/15 are IORQ/MREQ on the bus and
// the MSX master clock is independent of the console.
enum MsxLogMode
{
	MsxLogUart = 0,
	MsxLogOff,
	MsxLogFile,
	MsxLogNet
};

// msxbus.mode: live = every emulated cartridge access hits the GPIO bus;
// cache = a read cache over the bus (see MsxBus_SetCacheMode). Cache is fast
// for plain ROM packs; a write-driven mapper stays correct because a write
// flushes the cache, but a read-triggered mapper should use live.
enum MsxBusMode
{
	MsxBusLive = 0,
	MsxBusCache
};

// msxbus.dumpmapper: how the boot cartridge dump walks the cart's banks.
// A raw linear read (0x4000..) only ever captures the four 8 KiB banks the
// cart maps at power-on, so any cart larger than 32 KiB comes out wrapped and
// garbled. The banked modes write the mapper's bank register before reading
// each 8 KiB window, and stop when a bank repeats bank 0 (auto-size).
enum MsxBusDumpMapper
{
	MsxBusDumpLinear = 0,	// legacy 0x4000+i read, no bank switch
	MsxBusDumpKonami,	// Konami (no SCC): bank -> window 2 (0x8000)
	MsxBusDumpKonamiScc,	// Konami SCC: bank -> window 0 (0x5000)
	MsxBusDumpAscii8	// ASCII8: bank -> window 0 (0x6000)
};

enum MsxMapper
{
	MsxMapperAuto = 0,
	MsxMapperNone,
	MsxMapperAscii8,
	MsxMapperKonami,
	MsxMapperKonamiScc,
	MsxMapperNoMapper
};

struct MSXConfig
{
	int nLogMode;		// MsxLogMode
	int nLogLevel;		// Circle TLogSeverity (LogNotice default)
	bool bMsxbusEnable;	// hook the bus into emulated slot 0/1 (later)
	bool bMsxbusDump;	// boot cartridge-dump test (this milestone)
	bool bDiagDump;		// per-frame PPM + bus counter dumps to the FAT card
	bool bMfrProbe;		// boot MegaFlashROM mapper probe (+ force Konami mode)
	int nMsxbusMode;	// MsxBusMode
	unsigned nDumpBytes;	// bytes to dump per connector
	int nDumpMapper;	// MsxBusDumpMapper
	int nMsxbusSlot1;	// emulated primary slot for board connector 1
	int nMsxbusSlot3;	// emulated primary slot for board connector 3
	int nMsxbusReadDelay;	// post-WAIT settle iterations for memory reads
	int nMachine;		// msx.machine: 0=MSX1, 1=MSX2, 2=MSX2+
	int nCartMapper;	// MsxMapper

	MSXConfig (void)
	:	nLogMode (MsxLogUart),
		nLogLevel (3),		// LogNotice
		bMsxbusEnable (true),	// SLOTS (live bus) is the default cartridge
		bMsxbusDump (false),
		bDiagDump (false),	// off: no mid-run SD writes during play
		bMfrProbe (false),	// off: no cart mapper poking by default
		nMsxbusMode (MsxBusCache),	// fast path for plain ROM packs
		nDumpBytes (0x20000),	// 128 KiB
		nDumpMapper (MsxBusDumpLinear),	// legacy linear read
		nMsxbusSlot1 (1),	// connector 1 -> primary slot 1
		nMsxbusSlot3 (2),	// connector 3 -> primary slot 2 (3 is RAM)
		nMsxbusReadDelay (16),	// WAIT signals ready; less settle than ref's 100
		nMachine (0),		// MSX1 (only complete machine type so far)
		nCartMapper (MsxMapperAuto)
	{
	}
};

/// Load msx.ini via pFs (may be a null or unmounted filesystem; falls back
/// to defaults). Returns TRUE when a file was actually read and parsed.
bool MsxConfig_Load (MSXConfig *pCfg, CFATFileSystem *pFs);

/// "uart"/"off"/"file"/"net" for the serial-decision log line.
const char *MsxLogModeName (int nMode);

#endif