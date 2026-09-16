//
// msx_task.h
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#ifndef _msx_msx_task_h
#define _msx_msx_task_h

#include <circle/sched/task.h>

class CKernel;

// Cooperative task that advances the MSX machine one VDP frame at a time,
// paced to roughly 60 FPS.
class CMsxTask : public CTask
{
public:
	CMsxTask (CKernel *pKernel) : CTask (16 * 1024), m_pKernel (pKernel) {}

private:
	void Run (void) override;

	CKernel *m_pKernel;
};

#endif
