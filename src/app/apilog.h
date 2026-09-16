//
// apilog.h
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//
// Small lock-free log ring buffer. stdout/stderr (_write) and the CLogger
// (via CTeeLogDevice) append here; the HTTP /log endpoint drains it.
//

#ifndef _msx_apilog_h
#define _msx_apilog_h

#include <stddef.h>

/// Append nCount bytes to the ring buffer. Never blocks, never fails.
void LogAppend (const void *pBuffer, size_t nCount);

/// Number of bytes currently available for reading.
size_t LogAvailable (void);

/// Drain up to nMax bytes from the ring into pOut. Returns number copied.
/// Single-reader design: only the HTTP /log handler calls this.
size_t LogRead (char *pOut, size_t nMax);

#endif
