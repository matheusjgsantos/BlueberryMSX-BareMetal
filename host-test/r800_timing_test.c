/* r800_timing_test.c -- measure the R800 core's Z80-mode instruction timing.
 *
 * The bare-metal port now runs a TIME budget per 60 Hz frame (msx_step_frame
 * uses MSX_FRAME_TICKS *R800 master ticks), matching the reference blueMSX MSX
 * board's timer-driven execution. This test checks the core's per-instruction
 * systemTime advance against the blueMSX model (CPU_ENABLE_M1), and reports how
 * many instructions a frame holds, so the time budget can be validated.
 *
 * systemTime ticks at R800_MASTER_FREQUENCY = 21477270 Hz; with the default
 * Z80 frequency (3579545) it advances freqAdjust = 6 ticks per one Z80
 * T-state.  So measured_ticks / 6 == T-states.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "msx.h"
#include "R800.h"

#define CODE_BASE 0x4100
#define DATA_BASE 0x5000

static MSX_SubSlot *g_ss;
static R800        *g_z80;

static void poke (uint16_t addr, uint8_t v) { g_ss->data[addr] = v; }
static uint8_t peek (uint16_t addr)         { return g_ss->data[addr]; }

/* Execute exactly one instruction placed at CODE_BASE.  Returns the number
 * of systemTime ticks it charged. */
static uint32_t run (const uint8_t *code, int n)
{
	uint16_t addr = CODE_BASE;
	int i;

	for (i = 0; i < n && (CODE_BASE + i) < DATA_BASE; i++)
		poke ((uint16_t)(CODE_BASE + i), code[i]);

	/* sane register bank for every test */
	g_z80->regs.PC.W  = CODE_BASE;
	g_z80->regs.SP.W  = DATA_BASE;
	g_z80->regs.HL.W  = DATA_BASE;
	g_z80->regs.BC.W  = 0x0000;
	g_z80->regs.DE.W  = 0x0000;
	g_z80->regs.AF.W  = 0x0000;
	g_z80->regs.IX.W  = DATA_BASE;
	g_z80->regs.IY.W  = DATA_BASE;
	g_z80->regs.halt  = 0;
	g_z80->intState   = 2; /* INT_HIGH */

	SystemTime t0 = r800GetSystemTime (g_z80);
	r800ExecuteInstruction (g_z80);
	SystemTime t1 = r800GetSystemTime (g_z80);
	return t1 - t0;
}

typedef struct {
	const char *name;
	uint8_t     code[4];
	int         len;
	int         expect_ts;   /* documented Z80 T-states */
	int         nfetch;      /* 1 normal, 2 for CB/ED/DD/FD-prefixed */
} TIMING;

static int g_fail = 0;

static void one (TIMING t)
{
	uint32_t ticks = run (t.code, t.len);
	double   ts    = ticks / 6.0;
	/* blueMSX model (CPU_ENABLE_M1): opcode fetch is MEMOP(3T) + M1(2T) = 5T,
	 * i.e. 1T more than the documented 4T opcode fetch per M1, so an
	 * instruction measures documented + nfetch. */
	int blue = t.expect_ts + t.nfetch;
	printf ("  %-14s ticks=%-5u ts=%5.1f  doc=%2d  blueMSX=%2d\n",
		t.name, (unsigned) ticks, ts, t.expect_ts, blue);
	if (ts < blue - 0.5 || ts > blue + 0.5)
	{
		g_fail++;
		printf ("    ^^ MISMATCH (observed %.1f vs blueMSX %d)\n", ts, blue);
	}
}

int main (void)
{
	MSX_Machine *m = msx_create ();
	int i;

	for (i = 0; i < 4; i++) m->activeSlot[i] = (3 | (0 << 2));
	g_ss  = &m->slots[3].subslots[0];
	g_z80 = (R800 *)m->z80;

	/* Fill an image so memory operands have data (and stack holds 0x4000). */
	memset (g_ss->data, 0x00, 0x10000);
	g_ss->size = 0x10000;   /* make slot_read_mem serve ss->data */
	poke (DATA_BASE + 0, 0x00);   /* RET/JR targets -> 0x4000 */
	poke (DATA_BASE + 1, 0x40);

	printf ("cpuMode=%d freqZ80=%u DLY_MEM=%u DLY_MEMOP=%u DLY_M1=%u "
		"DLY_LD=%u DLY_ADD8=%u DLY_CALL=%u DLY_RET=%u DLY_PUSH=%u\n",
		(int)g_z80->cpuMode, (unsigned)g_z80->frequencyZ80,
		(unsigned)g_z80->delay[0], (unsigned)g_z80->delay[1],
		(unsigned)g_z80->delay[5], (unsigned)g_z80->delay[21],
		(unsigned)g_z80->delay[12], (unsigned)g_z80->delay[15],
		(unsigned)g_z80->delay[27], (unsigned)g_z80->delay[25]);
	printf ("R800 Z80-mode instruction timing (freqAdjust=6 ticks/T-state)\n");
	printf ("Frame budget: %d ticks = 59659 T-states at 60 Hz\n\n",
		MSX_FRAME_TICKS);

	TIMING t[] = {
		{"NOP",       {0x00},                   1,  4, 1},
		{"LD B,C",    {0x41},                   1,  4, 1},
		{"LD A,r",    {0x78},                   1,  4, 1},
		{"XOR A",     {0xAF},                   1,  4, 1},
		{"EX DE,HL",  {0xEB},                   1,  4, 1},
		{"INC A",     {0x3C},                   1,  4, 1},
		{"INC HL",    {0x23},                   1,  6, 1},
		{"LD A,n",    {0x3E,0x11},              2,  7, 1},
		{"LD A,(HL)", {0x7E},                   1,  7, 1},
		{"LD (HL),A", {0x77},                   1,  7, 1},
		{"ADD A,n",   {0xC6,0x11},              2,  7, 1},
		{"LD A,(BC)", {0x0A},                   1,  7, 1},
		{"LD A,(nn)", {0x3A,0x00,0x50},         3, 13, 1},
		{"LD (nn),A", {0x32,0x00,0x50},         3, 13, 1},
		{"LD HL,nn",  {0x21,0x11,0x22},         3, 10, 1},
		{"ADD HL,BC", {0x09},                   1, 11, 1},
		{"JP nn",     {0xC3,0x00,0x40},         3, 10, 1},
		{"JR e",      {0x18,0xFE},              2, 12, 1},
		{"DJNZ",      {0x10,0xFE},              2, 13, 1},   /* taken */
		{"CALL nn",   {0xCD,0x00,0x40},         3, 17, 1},
		{"RET",       {0xC9},                   1, 10, 1},
		{"PUSH BC",   {0xC5},                   1, 11, 1},
		{"POP BC",    {0xC1},                   1, 10, 1},
		{"EX (SP),HL",{0xE3},                   1, 19, 1},
		{"IN A,(n)",  {0xDB,0x98},              2, 11, 1},
		{"OUT (n),A", {0xD3,0x98},              2, 11, 1},
		{"EI",        {0xFB},                   1,  4, 1},
		{"DI",        {0xF3},                   1,  4, 1},
		{"RLD",       {0xED,0x6F},              2, 18, 2},
		{"IM 1",      {0xED,0x56},              2,  8, 2},
		{"LDI",       {0xED,0xA0},              2, 16, 2},
	};
	int n = (int)(sizeof (t) / sizeof (t[0]));
	for (i = 0; i < n; i++) one (t[i]);

	/* ---- representative game-logic loop: run a whole frame of T-states ---- */
	{
		/* A small routine: LD A,(HL) / INC HL / CP n / JR z / DEC B /
		 * DJNZ back / CALL sub / RET.  We measure how many instructions
		 * fit in one 60 Hz frame's worth of systemTime ticks. */
		const uint8_t prog[] = {
			0x7E,             /* LD A,(HL)  */
			0x23,             /* INC HL     */
			0xFE, 0x00,       /* CP 0       */
			0x28, 0x01,       /* JR Z,+1    */
			0x00,             /* NOP        */
			0x06, 0x20,       /* LD B,0x20  */
			0x10, 0xFE,       /* DJNZ self  */
			0x18, 0xE7        /* JR back to LD A,(HL) */
		};
		for (i = 0; i < (int)sizeof (prog); i++)
			poke ((uint16_t)(CODE_BASE + i), prog[i]);

		g_z80->regs.PC.W = CODE_BASE;
		g_z80->regs.HL.W = DATA_BASE;
		g_z80->regs.halt = 0;

		SystemTime start = r800GetSystemTime (g_z80);
		unsigned instr = 0;
		/* one frame = MSX_FRAME_TICKS master ticks */
		while ((uint32_t)(r800GetSystemTime (g_z80) - start)
				< (uint32_t) MSX_FRAME_TICKS)
		{
			r800ExecuteInstruction (g_z80);
			if (++instr > 200000u) break;
		}
		SystemTime el = r800GetSystemTime (g_z80) - start;
		printf ("\nFrame workload loop: %u instructions in %u ticks "
			"(%.1f T-states) => %.2f T/instr\n",
			instr, (unsigned) el, el / 6.0, el / 6.0 / instr);
		printf ("  => time-driven frame budget yields ~%u instructions/frame "
			"(the old fixed budget was 12000)\n", instr);
	}

	printf ("\n%d timing mismatch(es)\n", g_fail);
	msx_destroy (m);
	return g_fail ? 1 : 0;
}
