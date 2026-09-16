//
// httpapi.h
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#ifndef _msx_httpapi_h
#define _msx_httpapi_h

#include <circle/net/httpdaemon.h>

class CKernel;

// HTTP debug/control API for the MSX machine:
//   /         index page
//   /status   live status JSON
//   /log      log ring buffer contents (text/plain)
//   /command  ?cmd=pause|resume|step|reset
//   /regs     coherent CPU/VDP register dump (JSON)
//   /mem      ?addr=0x...&size=N hex dump
class CMsxHttpServer : public CHTTPDaemon
{
public:
	CMsxHttpServer (CNetSubSystem *pNetSubSystem, CKernel *pKernel, u16 nPort);

private:
	CHTTPDaemon *CreateWorker (CNetSubSystem *pNetSubSystem, CSocket *pSocket) override;
	THTTPStatus GetContent (const char  *pPath,
			     const char  *pParams,
			     const char  *pFormData,
			     u8	    *pBuffer,
			     unsigned    *pLength,
			     const char **ppContentType) override;

	void HandleIndex (u8 *pBuffer, unsigned *pLength);
	THTTPStatus HandleStatus (u8 *pBuffer, unsigned *pLength);
	THTTPStatus HandleLog (u8 *pBuffer, unsigned *pLength);
	THTTPStatus HandleCommand (const char *pParams, u8 *pBuffer, unsigned *pLength);
	THTTPStatus HandleRegs (u8 *pBuffer, unsigned *pLength);
	THTTPStatus HandleMem (const char *pParams, u8 *pBuffer, unsigned *pLength);

	CKernel *m_pKernel;
};

#endif
