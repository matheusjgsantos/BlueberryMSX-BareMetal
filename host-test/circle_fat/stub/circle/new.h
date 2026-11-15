//
// Minimal host-build stand-in for circle/new.h (placement new with a heap id).
//
#ifndef _circle_new_h
#define _circle_new_h

#include <stddef.h>
#include <stdlib.h>

enum THeapType
{
	HEAP_ANY = 0,
	HEAP_LOW,
	HEAP_HIGH,
	HEAP_DMA30
};

inline void *operator new (size_t nSize, THeapType)
{
	return malloc (nSize);
}

inline void operator delete (void *pBlock, THeapType)
{
	free (pBlock);
}

#endif
