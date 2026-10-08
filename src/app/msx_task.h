//
// msx_task.h
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//

#ifndef _msx_msx_task_h
#define _msx_msx_task_h

class CKernel;

// Frame loop that advances the MSX machine one VDP frame at a time, paced
// to roughly 60 FPS. Since the multi-core partition this is NOT a Circle
// task: it runs directly on core 1 via CMSXMultiCore::Run(1), because the
// cooperative scheduler is core0-only. Its sleeps poll the system timer
// (see msx_spin_us() in msx_task.cpp).
class CMsxTask
{
public:
	CMsxTask (CKernel *pKernel) : m_pKernel (pKernel) {}

	void Run (void);

private:
	CKernel *m_pKernel;
};

#endif
