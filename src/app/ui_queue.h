//
// ui_queue.h
//
// BlueberryMSX - bare-metal MSX emulator for Raspberry Pi (Circle)
//
// Single-producer / single-consumer byte queue for USB UI hotkeys.
//
// The producer is the USB HID interrupt handler, the consumer is the MSX task.
// Both sides only touch volatile indices and one byte per event: no locks, no
// allocation, nothing that can deadlock or allocate from IRQ context. A full
// queue drops the new event, which is the right trade-off for a key press.
//
// Header-only (and static inline) so it can be unit tested on the host, the
// same way frame_pacer.h is.
//

#ifndef _msx_ui_queue_h
#define _msx_ui_queue_h

#include <stdint.h>

// Must be a power of two so the index wrap is a mask.
#define UI_QUEUE_SIZE 16

typedef struct
{
	volatile unsigned char aQueue[UI_QUEUE_SIZE];
	volatile unsigned nWrite;	// producer index (USB IRQ)
	volatile unsigned nRead;	// consumer index (MSX task)
}
CUiQueue;

static inline void UiQueue_Init (CUiQueue *pQueue)
{
	for (unsigned i = 0; i < UI_QUEUE_SIZE; i++)
	{
		pQueue->aQueue[i] = 0;
	}
	pQueue->nWrite = 0;
	pQueue->nRead = 0;
}

// Returns 0 when the event was stored, -1 when the queue was full.
static inline int UiQueue_Push (CUiQueue *pQueue, unsigned char ucKey)
{
	unsigned nWrite = pQueue->nWrite;
	unsigned nNext = (nWrite + 1) % UI_QUEUE_SIZE;

	if (nNext == pQueue->nRead)
	{
		return -1;
	}

	pQueue->aQueue[nWrite] = ucKey;
	pQueue->nWrite = nNext;
	return 0;
}

// Returns 0 when the queue is empty.
static inline int UiQueue_Pop (CUiQueue *pQueue, unsigned char *pKey)
{
	unsigned nRead = pQueue->nRead;
	if (nRead == pQueue->nWrite)
	{
		return 0;
	}

	*pKey = pQueue->aQueue[nRead];
	pQueue->nRead = (nRead + 1) % UI_QUEUE_SIZE;
	return 1;
}

static inline unsigned UiQueue_Count (const CUiQueue *pQueue)
{
	return (pQueue->nWrite - pQueue->nRead) % UI_QUEUE_SIZE;
}

#endif
