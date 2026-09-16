//
// main.cpp
//
// BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
//
// Entry point. Chain-booted by msxboot at 0x8000.
//

#include "kernel.h"

#include <circle/startup.h>
#include <stdlib.h>

int main (void)
{
	CKernel kernel;

	if (!kernel.Initialize ())
	{
		return EXIT_FAILURE;
	}

	TShutdownMode mode = kernel.Run ();

	switch (mode)
	{
	case ShutdownReboot:
		return EXIT_REBOOT;

	case ShutdownHalt:
	default:
		return EXIT_HALT;
	}
}
