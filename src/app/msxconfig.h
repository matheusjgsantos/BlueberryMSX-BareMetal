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
// cache = a page-window cache over the bus (planned; parsed but unused).
enum MsxBusMode
{
	MsxBusLive = 0,
	MsxBusCache
};

struct MSXConfig
{
	int nLogMode;		// MsxLogMode
	int nLogLevel;		// Circle TLogSeverity (LogNotice default)
	bool bMsxbusEnable;	// hook the bus into emulated slot 0/1 (later)
	bool bMsxbusDump;	// boot cartridge-dump test (this milestone)
	int nMsxbusMode;	// MsxBusMode
	unsigned nDumpBytes;	// bytes to dump per connector
	int nMsxbusSlot1;	// emulated primary slot for board connector 1
	int nMsxbusSlot3;	// emulated primary slot for board connector 3
	int nMsxbusReadDelay;	// post-WAIT settle iterations for memory reads

	MSXConfig (void)
	:	nLogMode (MsxLogUart),
		nLogLevel (3),		// LogNotice
		bMsxbusEnable (true),	// SLOTS (live bus) is the default cartridge
		bMsxbusDump (false),
		nMsxbusMode (MsxBusLive),
		nDumpBytes (0x20000),	// 128 KiB
		nMsxbusSlot1 (1),	// connector 1 -> primary slot 1
		nMsxbusSlot3 (2),	// connector 3 -> primary slot 2 (3 is RAM)
		nMsxbusReadDelay (16)	// WAIT signals ready; less settle than ref's 100
	{
	}
};

/// Load msx.ini via pFs (may be a null or unmounted filesystem; falls back
/// to defaults). Returns TRUE when a file was actually read and parsed.
bool MsxConfig_Load (MSXConfig *pCfg, CFATFileSystem *pFs);

/// "uart"/"off"/"file"/"net" for the serial-decision log line.
const char *MsxLogModeName (int nMode);

#endif