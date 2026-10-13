/* Isolated PSG (AY-3-8910) test.
 *
 * Reference semantics: openMSX src/sound/AY8910.cc (+ MSXPSG.cc for the port
 * protocol), which is what src/chips/sound/psg.c implements:
 *   - one emulation tick = 16 master clocks (NATIVE_FREQ = 3579545/16)
 *   - tone half period = max(1, fine | coarse<<8) ticks -> f = clock/(32*period)
 *   - noise period    = 2*max(1, R6 & 0x1F) ticks
 *   - envelope step   = EFINE + 256*ECOARSE ticks
 *   - output bit      = (toneOn | toneDisabled) & (noiseOn | noiseDisabled)
 *   - volume          = 2^((v-15)/2) (3 dB per step, openMSX/blueMSX/FluBBa),
 *                     v=0 silent
 *   - 17 bit noise LFSR, Galois form: r = (r>>1) ^ ((r&1)<<13) ^ ((r&1)<<16)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "msx_types.h"
#include "psg.h"

#define MASTER_CLOCK	3579545
#define CLOCKS_PER_TICK	16

static int g_nFailures = 0;
static int g_nChecks = 0;

static void check (int bCondition, const char *pWhat)
{
	g_nChecks++;
	if (!bCondition)
	{
		g_nFailures++;
		printf ("FAIL: %s\n", pWhat);
	}
}

/* Render nTicks ticks at one tick per sample, so every sample is a state
 * sample and zero crossings can be counted exactly. */
static unsigned render_ticks (PSG *psg, Int16 *out, unsigned nTicks)
{
	return psg_render (psg, out, nTicks, nTicks * CLOCKS_PER_TICK);
}

/* Count rising edges of the sign of the output (the PSG output is centred). */
static int count_rising (const Int16 *out, unsigned n)
{
	int nEdges = 0;
	int nPrev = (out[0] > 0) ? 1 : 0;

	for (unsigned i = 1; i < n; i++)
	{
		int nNow = (out[i] > 0) ? 1 : 0;
		if (nNow > nPrev) nEdges++;
		nPrev = nNow;
	}
	return nEdges;
}

/* ---------------------------------------------------------------- tone */

static void test_tone_frequency (void)
{
	/* Period 16 -> 3579545/(32*16) = 6988 Hz. Over one second that is about
	 * 6988 rising edges (one per half period). */
	PSG *psg = psg_create ();
	Int16 buf[8192];

	check (psg != NULL, "psg_create");
	if (!psg) return;

	/* Channel A: tone on, noise OFF (R7 bits 3-5), volume 15, no envelope.
	 * Noise must be switched off, otherwise the mix bit is toneOut & noiseOut
	 * and the fast LFSR adds edges of its own. */
	psg_write (psg, 7, 0x38);
	psg_write (psg, 8, 15);
	psg_write (psg, 0, 16);
	psg_write (psg, 1, 0);

	/* One second of samples at one tick each: 3579545/16 = 223721 ticks. */
	unsigned n = 223721 / 2;			/* keep the stack small */
	int nEdges = 0;
	unsigned done = 0;
	while (done < n)
	{
		unsigned chunk = (n - done > 4096) ? 4096 : (n - done);
		render_ticks (psg, buf, chunk);
		nEdges += count_rising (buf, chunk);
		done += chunk;
	}

	/* One rising edge per full square wave period, i.e. f = clock/(32*period).
	 * n samples of one tick each span n/223721 seconds. */
	double fExpected = (double) MASTER_CLOCK / (32.0 * 16.0);
	double dSeconds = (double) n * CLOCKS_PER_TICK / (double) MASTER_CLOCK;
	int nExpected = (int) (fExpected * dSeconds + 0.5);

	printf ("tone period 16: %d rising edges (expected ~%d for %u samples)\n",
		nEdges, nExpected, n);
	check (nEdges > 0, "tone: output toggles");
	check (abs (nEdges - nExpected) <= 2, "tone: rising edge count matches clock/(32*period)");

	psg_destroy (psg);
}

static void test_tone_period_clamp (void)
{
	PSG *psg = psg_create ();
	Int16 buf[256];

	if (!psg) { check (0, "psg_create"); return; }

	psg_write (psg, 7, 0x38);
	psg_write (psg, 8, 15);
	psg_write (psg, 0, 0);
	psg_write (psg, 1, 0);

	/* period 0 must behave like period 1: output toggles on every tick, i.e.
	 * every sample alternates. */
	render_ticks (psg, buf, 32);
	int nFlips = 0;
	for (int i = 1; i < 32; i++)
		if ((buf[i] > 0) != (buf[i - 1] > 0)) nFlips++;
	check (nFlips == 31, "tone: period 0 behaves like period 1 (toggles each tick)");

	/* A longer period must toggle far less often. */
	psg_write (psg, 0, 200);
	psg_write (psg, 1, 0);
	render_ticks (psg, buf, 256);
	nFlips = 0;
	for (int i = 1; i < 256; i++)
		if ((buf[i] > 0) != (buf[i - 1] > 0)) nFlips++;
	check (nFlips > 0 && nFlips <= 2, "tone: period 200 toggles about every 200 ticks");

	psg_destroy (psg);
}

/* -------------------------------------------------------------- volume */

static void test_volume_table (void)
{
	PSG *psg = psg_create ();
	Int16 buf[8];

	if (!psg) { check (0, "psg_create"); return; }

	/* Tone and noise both disabled in R7 -> the mix bit is always 1, so the
	 * output is a constant +volume. The table is scaled to 1/3 of full scale
	 * (psg.c): three centred channels must sum within Int16 without ever
	 * hitting the clamp (the old unscaled table showed peak=32768
	 * constantly). Per-channel peak = 10922. */
	psg_write (psg, 7, 0x3F);
	psg_write (psg, 8, 15);
	render_ticks (psg, buf, 8);
	check (buf[0] == 10922 && buf[7] == 10922, "volume 15 = full scale when tone+noise off");

	psg_write (psg, 8, 0);
	render_ticks (psg, buf, 8);
	check (buf[0] == 0, "volume 0 = silence");

	/* Volume 8 is 2^((8-15)/2) = 0.0884 of the peak (3 dB/step law)
	 * -> 0.0884*10922 = 965. */
	psg_write (psg, 8, 8);
	render_ticks (psg, buf, 8);
	check (buf[0] == 965, "volume 8 = 2^((8-15)/2) of full scale");

	/* Logarithmic 3 dB steps: volume 13 is exactly half of the peak,
	 * volume 11 is a quarter. */
	psg_write (psg, 8, 13);
	render_ticks (psg, buf, 8);
	check (buf[0] == 5461, "volume 13 = half of full scale");

	psg_write (psg, 8, 11);
	render_ticks (psg, buf, 8);
	check (buf[0] == 2731, "volume 11 = quarter of full scale");

	psg_destroy (psg);
}

static void test_mixer_rule (void)
{
	PSG *psg = psg_create ();
	Int16 buf[64];

	if (!psg) { check (0, "psg_create"); return; }

	/* Channel A only: volume 4 (241 after the 1/3 table scaling).
	 * R7 bit 0 = 1 (tone A off), bits 3-5 = 0 (noise on), so the mix bit is
	 * noiseOut & 1 -> alternating at the noise rate. */
	psg_write (psg, 8, 4);
	psg_write (psg, 7, 0x01);			/* tone A off, noise enabled */
	psg_write (psg, 6, 0);			/* noise period 2 -> fastest */
	render_ticks (psg, buf, 64);

	int nPos = 0, nNeg = 0, nFlips = 0;
	for (int i = 0; i < 64; i++)
	{
		if (buf[i] > 0) nPos++;
		else if (buf[i] < 0) nNeg++;
		else check (0, "mixer: sample is never 0 with volume > 0");
		if (i > 0 && (buf[i] > 0) != (buf[i - 1] > 0)) nFlips++;
	}
	check (nPos > 0 && nNeg > 0, "mixer: noise-only output is both polarities");
	check (nFlips > 4, "mixer: noise-only output changes at the noise rate");
	check ((buf[0] == 241 || buf[0] == -241) &&
	       (buf[1] == 241 || buf[1] == -241),
	       "mixer: noise-only amplitude = channel volume");

	/* Tone enabled and noise enabled -> mix bit = tone & noise. */
	psg_write (psg, 0, 4);
	psg_write (psg, 1, 0);
	psg_write (psg, 7, 0x00);
	render_ticks (psg, buf, 64);
	int nEdges = count_rising (buf, 64);
	check (nEdges > 0, "mixer: tone and noise both on still produces edges");

	psg_destroy (psg);
}

/* ---------------------------------------------------------------- noise */

static void test_noise_lfsr (void)
{
	PSG *psg = psg_create ();
	Int16 buf[512];

	if (!psg) { check (0, "psg_create"); return; }

	/* Noise-only channel A, volume 15, fastest noise period: one LFSR step per
	 * 2 ticks. Compare the sign sequence with the recurrence. */
	psg_write (psg, 7, 0x01);
	psg_write (psg, 8, 15);
	psg_write (psg, 6, 0);
	render_ticks (psg, buf, 512);

	UInt32 rng = 1;				/* openMSX resets random = 1 */
	int nBad = 0;
	for (unsigned i = 0; i < 512; i += 2)
	{
		/* one step per 2 ticks: state before the sample is the current one */
		int nExpect = (int) (rng & 1);
		int nGot = buf[i] > 0 ? 1 : 0;
		if (nExpect != nGot) nBad++;
		rng = (rng >> 1) ^ ((rng & 1) << 13) ^ ((rng & 1) << 16);
	}
	check (nBad == 0, "noise: LFSR output follows the Galois recurrence");

	/* The 17 bit register must never be zero (that would be a stuck state). */
	check (psg->noise_rng != 0, "noise: LFSR is never all zeroes");

	psg_destroy (psg);
}

/* ------------------------------------------------------------- envelope */

static void test_envelope_decay (void)
{
	PSG *psg = psg_create ();
	Int16 buf[64];

	if (!psg) { check (0, "psg_create"); return; }

	/* Channel A volume 15 with the envelope enabled, shape 0 (decay, no
	 * continue), envelope period 1 -> one step per tick, level 15 -> 0. */
	psg_write (psg, 7, 0x3F);			/* all tone+noise off: constant */
	psg_write (psg, 8, 0x10 | 15);		/* volume 15 + envelope bit */
	psg_write (psg, 11, 1);			/* EFINE */
	psg_write (psg, 12, 0);			/* ECOARSE */
	psg_write (psg, 13, 0x00);		/* shape 0 */

	render_ticks (psg, buf, 40);

	int nMonotonic = 1;
	for (int i = 1; i < 40; i++)
		if (buf[i] > buf[i - 1]) { nMonotonic = 0; break; }
	check (buf[0] == 10922, "envelope: shape 0 starts at full volume");
	check (nMonotonic, "envelope: shape 0 decays monotonically");
	check (buf[39] == 0, "envelope: shape 0 ends at silence and holds");

	/* Holding: after the decay, further ticks must not change anything. */
	render_ticks (psg, buf, 40);
	check (buf[0] == 0, "envelope: continue=0 holds the final level");

	psg_destroy (psg);
}

static void test_envelope_attack (void)
{
	PSG *psg = psg_create ();
	Int16 buf[40];

	if (!psg) { check (0, "psg_create"); return; }

	/* Shape 0x0C = continue|attack: rises from silence to full volume. */
	psg_write (psg, 7, 0x3F);
	psg_write (psg, 8, 0x10 | 0);
	psg_write (psg, 11, 1);
	psg_write (psg, 12, 0);
	psg_write (psg, 13, 0x0C);
	render_ticks (psg, buf, 20);

	int nRising = 1;
	for (int i = 1; i < 20; i++)
		if (buf[i] < buf[i - 1]) { nRising = 0; break; }
	check (buf[0] == 0, "envelope: attack shape starts at silence");
	check (nRising, "envelope: attack shape rises monotonically");

	psg_destroy (psg);
}

static void test_envelope_used_over_volume (void)
{
	PSG *psg = psg_create ();
	Int16 buf[16];

	if (!psg) { check (0, "psg_create"); return; }

	/* Fixed volume 0 must stay silent even when an envelope is running. */
	psg_write (psg, 7, 0x3F);
	psg_write (psg, 8, 0);			/* volume 0, no envelope bit */
	psg_write (psg, 11, 1);
	psg_write (psg, 12, 0);
	psg_write (psg, 13, 0x0C);		/* attack envelope running */
	render_ticks (psg, buf, 16);
	check (buf[15] == 0, "envelope ignored unless R8-R10 bit 4 is set");

	/* Now enable it. The attack shape is a repeating sawtooth, so restart it
	 * and look for any non-zero sample rather than a fixed index. */
	psg_write (psg, 13, 0x0C);		/* restart the envelope */
	psg_write (psg, 8, 0x10);
	render_ticks (psg, buf, 16);
	int nAny = 0;
	for (int i = 0; i < 16; i++) if (buf[i] > 0) nAny++;
	check (nAny > 0, "envelope bit 4 in R8 selects the envelope level");

	psg_destroy (psg);
}

/* ------------------------------------------------------------ registers */

static void test_registers (void)
{
	PSG *psg = psg_create ();

	if (!psg) { check (0, "psg_create"); return; }

	psg_set_reg_latch (psg, 0x93);
	check (psg_get_reg_latch (psg) == 3, "0xA0 latch masks the register number to 4 bits");

	psg_write (psg, 1, 0xFF);
	check (psg_read (psg, 1) == 0x0F, "read mask R1 = 0x0F");
	psg_write (psg, 6, 0xFF);
	check (psg_read (psg, 6) == 0x1F, "read mask R6 = 0x1F");
	psg_write (psg, 13, 0xFF);
	check (psg_read (psg, 13) == 0x0F, "read mask R13 = 0x0F");
	psg_write (psg, 0, 0x5A);
	check (psg_read (psg, 0) == 0x5A, "read mask R0 = 0xFF");
	check (psg_read (psg, 16) == 0xFF, "register numbers >= 16 read as 0xFF");

	/* Out of range writes are ignored, not stored. */
	psg_write (psg, 20, 0x11);
	check (psg_read (psg, 4) == 0x00, "register numbers >= 16 are ignored on write");

	/* Coarse tune uses only bits 0-3 (openMSX regMask / setPeriod). */
	psg_write (psg, 1, 0xF0);
	psg_write (psg, 0, 0x00);
	check (psg->tone_period[0] == 1, "coarse tune uses bits 0-3 only (0xF0 -> period 1)");

	psg_write (psg, 1, 0x03);
	check (psg->tone_period[0] == 0x300, "period = fine + 256*(coarse & 0x0F)");

	psg_destroy (psg);
}

/* -------------------------------------------------------------- io ports */

static void test_io_ports (void)
{
	PSG *psg = psg_create ();

	if (!psg) { check (0, "psg_create"); return; }

	/* Power-on: R7 = 0, both ports are inputs, so R14/R15 read the
	 * external pins (0xFF pull-ups), never the zeroed register latch. */
	psg_write (psg, 14, 0x00);
	check (psg_read (psg, 14) == 0xFF, "R14 input reads pins (0xFF), not the latch");

	/* Input pins win over a previously stored latch value too. */
	psg_write (psg, 14, 0x55);
	check (psg_read (psg, 14) == 0xFF, "R14 input reads 0xFF even after a write");

	/* Port A output (R7 bit 6): the latch reads back. */
	psg_write (psg, 7, 0x40);
	check (psg_read (psg, 14) == 0x55, "R14 output reads the register latch");

	/* Port B: R7 bit 7 selects the direction. */
	psg_write (psg, 7, 0x00);
	psg_write (psg, 15, 0xAA);
	check (psg_read (psg, 15) == 0xFF, "R15 input reads pins (0xFF), not the latch");
	psg_write (psg, 7, 0x80);
	check (psg_read (psg, 15) == 0xAA, "R15 output reads the register latch");

	/* The classic joystick read sequence: R7 = 0xB8 (port A input,
	 * port B output), write R15 = 0x8F, then read R14 for the joystick.
	 * A 0x00 read would CPL+AND 3Fh to 0x3F = all directions and both
	 * triggers pressed, permanently. */
	psg_write (psg, 7, 0xB8);
	psg_write (psg, 15, 0x8F);
	check (psg_read (psg, 14) == 0xFF, "R14 reads 0xFF with R7 = 0xB8");
	check (psg_read (psg, 15) == 0x8F, "R15 output latch reads back 0x8F");

	psg_destroy (psg);
}

/* ---------------------------------------------------------------- render */

static void test_render_api (void)
{
	PSG *psg = psg_create ();
	Int16 buf[100];

	if (!psg) { check (0, "psg_create"); return; }

	check (psg_render (psg, buf, 0, 1000) == 0, "render with 0 samples returns 0");
	check (psg_render (psg, NULL, 10, 1000) == 0, "render with NULL buffer returns 0");
	check (psg_render (psg, buf, 100, 59659) == 100, "render returns the sample count");

	/* The clock remainder must not drift: one MSX frame is 59659 master
	 * clocks, i.e. 3728 ticks + 11 leftover master clocks. */
	check (psg->clock_rem == 59659 % CLOCKS_PER_TICK, "master clock remainder is carried over");

	/* Headroom: three centred channels of +-10922 sum to +-32766, so the
	 * peak lands exactly one LSB below the clamp - loud trios never clip
	 * (the old unscaled table constantly saturated: peak=32768). */
	psg_write (psg, 7, 0x3F);
	psg_write (psg, 8, 15);
	psg_write (psg, 9, 15);
	psg_write (psg, 10, 15);
	psg_render (psg, buf, 4, 4 * CLOCKS_PER_TICK);
	check (buf[0] == 32766, "three full channels fill to 32766 without clipping");

	/* And the negative side: with tone+noise all on the sum still must stay
	 * inside Int16 - never wrap (values are bounded by +-32766). */
	psg_write (psg, 7, 0x00);
	psg_write (psg, 6, 0);
	psg_render (psg, buf, 64, 64 * CLOCKS_PER_TICK);
	int nInRange = 1;
	for (int i = 0; i < 64; i++)
		if (buf[i] < -32766 || buf[i] > 32766) nInRange = 0;
	check (nInRange, "output stays inside int16 (never wraps)");

	/* A huge cycle count must be clamped, not overflow the accumulator. */
	check (psg_render (psg, buf, 10, 0xFFFFFFFFu) == 10, "render survives an absurd clock count");

	psg_destroy (psg);
}

static void test_reset (void)
{
	PSG *psg = psg_create ();
	Int16 buf[32];

	if (!psg) { check (0, "psg_create"); return; }

	psg_write (psg, 7, 0x3F);
	psg_write (psg, 8, 15);
	psg_write (psg, 0, 20);
	psg_write (psg, 6, 5);
	render_ticks (psg, buf, 32);

	psg_reset (psg);
	check (psg_read (psg, 8) == 0, "reset clears the registers");
	check (psg->tone_period[0] == 1, "reset restores the tone period");
	check (psg->noise_period == 2, "reset restores the noise period");
	check (psg->env_step == 0x1F, "reset restores the envelope step");
	check (psg->noise_rng == 1, "reset restores the noise LFSR seed");

	psg_render (psg, buf, 8, 8 * CLOCKS_PER_TICK);
	check (buf[0] == 0, "reset silences the output");

	psg_destroy (psg);
}

int main (void)
{
	test_tone_frequency ();
	test_tone_period_clamp ();
	test_volume_table ();
	test_mixer_rule ();
	test_noise_lfsr ();
	test_envelope_decay ();
	test_envelope_attack ();
	test_envelope_used_over_volume ();
	test_registers ();
	test_io_ports ();
	test_render_api ();
	test_reset ();

	printf ("\nPSG checks: %d, failures: %d\n", g_nChecks, g_nFailures);
	printf ("RESULT: %s\n", g_nFailures == 0 ? "PASS" : "FAIL");
	return g_nFailures == 0 ? 0 : 1;
}
