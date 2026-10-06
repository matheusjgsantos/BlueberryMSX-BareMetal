//
// ui_queue_test.c
//
// Host test for the IRQ-safe UI key queue (src/app/ui_queue.h).
//

#include <stdio.h>
#include <string.h>
#include "ui_queue.h"

static int s_nFailures;
static int s_nChecks;

static void check (const char *pName, int bOK)
{
	s_nChecks++;
	if (!bOK)
	{
		s_nFailures++;
		printf ("%-58s FAIL\n", pName);
	}
	else
	{
		printf ("%-58s PASS\n", pName);
	}
}

int main (void)
{
	CUiQueue Q;
	unsigned char ucKey = 0xFF;

	setbuf (stdout, NULL);
	UiQueue_Init (&Q);

	check ("empty queue pops nothing", UiQueue_Pop (&Q, &ucKey) == 0);
	check ("empty queue count is zero", UiQueue_Count (&Q) == 0);

	// ---- FIFO order -------------------------------------------------------
	check ("push succeeds on empty queue", UiQueue_Push (&Q, 11) == 0);
	check ("push succeeds twice", UiQueue_Push (&Q, 22) == 0);
	check ("count reflects two events", UiQueue_Count (&Q) == 2);

	check ("pop returns the first key", UiQueue_Pop (&Q, &ucKey) == 1 && ucKey == 11);
	check ("pop returns the second key", UiQueue_Pop (&Q, &ucKey) == 1 && ucKey == 22);
	check ("queue empty again", UiQueue_Pop (&Q, &ucKey) == 0);
	check ("count back to zero", UiQueue_Count (&Q) == 0);

	// ---- Fill to capacity: the ring keeps SIZE-1 entries ------------------
	UiQueue_Init (&Q);
	int nAccepted = 0;
	for (unsigned i = 0; i < UI_QUEUE_SIZE + 4; i++)
	{
		if (UiQueue_Push (&Q, (unsigned char) (i + 1)) == 0)
		{
			nAccepted++;
		}
	}
	check ("queue holds SIZE-1 events", nAccepted == UI_QUEUE_SIZE - 1);
	check ("count equals capacity", UiQueue_Count (&Q) == UI_QUEUE_SIZE - 1);
	check ("full queue rejects new events", UiQueue_Push (&Q, 200) == -1);

	// Draining a full queue must yield the events in order, oldest first.
	int bOrdered = 1;
	for (unsigned i = 0; i < UI_QUEUE_SIZE - 1; i++)
	{
		if (UiQueue_Pop (&Q, &ucKey) != 1 || ucKey != (unsigned char) (i + 1))
		{
			bOrdered = 0;
		}
	}
	check ("full queue drains in order", bOrdered);
	check ("queue empty after draining", UiQueue_Pop (&Q, &ucKey) == 0);
	check ("push works again after draining", UiQueue_Push (&Q, 99) == 0);
	check ("event after wrap is returned", UiQueue_Pop (&Q, &ucKey) == 1 && ucKey == 99);

	// ---- Wrap-around: 1000 events with a fill/drain mix ------------------
	// Keep a few slots free so the producer never legitimately fills the ring;
	// every pushed event must come back out in order.
	UiQueue_Init (&Q);
	bOrdered = 1;
	unsigned char ucPushed = 1;
	unsigned char ucExpectOut = 1;
	for (unsigned i = 0; i < 1000; i++)
	{
		if (UiQueue_Count (&Q) <= UI_QUEUE_SIZE - 2)
		{
			if (UiQueue_Push (&Q, ucPushed) != 0)
			{
				bOrdered = 0;
				break;
			}
			ucPushed++;
		}
		if (UiQueue_Pop (&Q, &ucKey) != 1 || ucKey != ucExpectOut)
		{
			bOrdered = 0;
			break;
		}
		ucExpectOut++;
	}
	check ("wrap-around keeps FIFO order and never overflows", bOrdered);
	check ("every pushed event was consumed in order",
	       ucExpectOut == ucPushed && UiQueue_Count (&Q) <= 1);

	// ---- Reset clears stale contents -------------------------------------
	UiQueue_Init (&Q);
	UiQueue_Push (&Q, 7);
	UiQueue_Init (&Q);
	check ("re-init empties the queue", UiQueue_Pop (&Q, &ucKey) == 0);
	check ("re-init zeroes the count", UiQueue_Count (&Q) == 0);

	printf ("\nRESULT: %s (%d failures)\n",
		s_nFailures ? "FAIL" : "PASS", s_nFailures);
	return s_nFailures ? 1 : 0;
}
