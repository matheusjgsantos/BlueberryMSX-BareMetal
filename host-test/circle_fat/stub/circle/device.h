//
// Minimal host-build stand-in for circle/device.h.
// The FAT driver only uses Read/Write/Seek on the partition device.
//
#ifndef _circle_device_h
#define _circle_device_h

#include <circle/types.h>

class CDevice
{
public:
	CDevice (CDevice *pParent = 0)
	:	m_pParent (pParent)
	{
	}

	virtual ~CDevice (void)
	{
	}

	virtual int Read (void *pBuffer, size_t nCount)
	{
		(void) pBuffer;
		(void) nCount;
		return -1;
	}

	virtual int Write (const void *pBuffer, size_t nCount)
	{
		(void) pBuffer;
		(void) nCount;
		return -1;
	}

	virtual u64 Seek (u64 ullOffset)
	{
		(void) ullOffset;
		return (u64) -1;
	}

	virtual u64 GetSize (void) const
	{
		return (u64) -1;
	}

	virtual int IOCtl (unsigned long ulCmd, void *pData)
	{
		(void) ulCmd;
		(void) pData;
		return -1;
	}

	virtual boolean RemoveDevice (void)
	{
		return FALSE;
	}

private:
	CDevice *m_pParent;
};

#endif
