//
// teelog.h
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//
// CDevice that tees every write to both a target device (UART console) and
// the log ring buffer, so CLogger output is visible on serial AND via the
// HTTP /log endpoint.
//

#ifndef _msx_teelog_h
#define _msx_teelog_h

#include <circle/device.h>

#include "apilog.h"

class CTeeLogDevice : public CDevice
{
public:
	CTeeLogDevice (CDevice *pTarget) : m_pTarget (pTarget)
	{
	}

	int Write (const void *pBuffer, size_t nCount) override
	{
		LogAppend (pBuffer, nCount);

		if (m_pTarget != 0)
		{
			m_pTarget->Write (pBuffer, nCount);
		}

		return (int) nCount;
	}

private:
	CDevice *m_pTarget;
};

#endif
