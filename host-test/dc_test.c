/* DC-offset probe for psg.c output.
 *
 * sound.cpp PushFrame claims the mix is centred so no DC blocker is needed
 * (real MSX output coupling caps and blueMSX's AY DC blocker do that job).
 * Centre-holding only guarantees zero mean for 50%-duty toggling voices:
 * a channel with tone+noise disabled (R7 bits set) holds a constant level
 * and does produce DC. This test measures the mean for representative
 * register states.
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "msx_types.h"
#include "psg.h"

#define MASTER_CLOCK	3579545
#define CLOCKS_PER_TICK	16

static double mean_of (const Int16 *out, unsigned n)
{
	double s = 0;
	for (unsigned i = 0; i < n; i++) s += out[i];
	return s / n;
}

/* ~0.25 s at one tick per sample */
#define N_SAMPLES (MASTER_CLOCK / CLOCKS_PER_TICK / 4)

/* The exact integer DC blocker from sound.cpp PushFrame (openMSX form,
 * R = 511/512). Returns the mean after the filter. */
static double apply_blocker (Int16 *buf, unsigned n, Int32 *state)
{
	Int32 t0 = *state;
	for (unsigned i = 0; i < n; i++)
	{
		Int32 x = buf[i];
		Int32 decay = (t0 >= 0) ? (t0 + 256) / 512 : -((-t0 + 256) / 512);
		Int32 t1 = t0 - decay + x;
		Int32 s = t1 - t0;
		if (s > 32767) s = 32767;
		if (s < -32768) s = -32768;
		t0 = t1;
		buf[i] = (Int16) s;
	}
	*state = t0;
	return mean_of (buf, n);
}

static void scenario (const char *name, void (*setup)(PSG *))
{
	PSG *psg = psg_create ();
	static Int16 buf[N_SAMPLES];
	if (!psg) { printf("%-44s psg_create FAILED\n", name); return; }

	setup (psg);
	psg_render (psg, buf, N_SAMPLES, N_SAMPLES * CLOCKS_PER_TICK);

	double m = mean_of (buf, N_SAMPLES);
	double peak = 0;
	for (unsigned i = 0; i < N_SAMPLES; i++)
		if (fabs ((double) buf[i]) > peak) peak = fabs ((double) buf[i]);

	/* Second half only: the blocker needs time to settle. */
	Int32 state = 0;
	apply_blocker (buf, N_SAMPLES / 4, &state);		// settle
	double m2 = apply_blocker (buf + N_SAMPLES / 4, N_SAMPLES * 3 / 4, &state);

	printf ("%-44s mean %8.1f (%5.1f %% of peak)  ->  blocked %8.1f\n",
		name, m, peak ? 100.0 * fabs (m) / peak : 0.0, m2);
	psg_destroy (psg);
}

/* tone 50% duty, noise off, vol 15 */
static void s_tone (PSG *p)
{
	psg_write (p, 7, 0x38);
	psg_write (p, 8, 15);
	psg_write (p, 0, 16);
	psg_write (p, 1, 0);
}

/* tone disabled (held on), noise off, vol 15 -> constant +level */
static void s_held (PSG *p)
{
	psg_write (p, 7, 0x39);	/* A: tone bit=1 + noise bit=1 -> held on */
	psg_write (p, 8, 15);
	psg_write (p, 0, 16);
	psg_write (p, 1, 0);
}

/* noise only, vol 15 */
static void s_noise (PSG *p)
{
	psg_write (p, 7, 0x31);	/* A: tone bit=1 (ignored), noise bit=0 (used) */
	psg_write (p, 8, 15);
	psg_write (p, 6, 16);
}

/* all three channels held on (tone+noise disabled), vol 15 */
static void s_all_held (PSG *p)
{
	psg_write (p, 7, 0x3f);
	psg_write (p, 8, 15);
	psg_write (p, 9, 15);
	psg_write (p, 10, 15);
}

int main (void)
{
	scenario ("tone on, 50% duty, vol 15", s_tone);
	scenario ("tone DISABLED (held on), vol 15", s_held);
	scenario ("noise only, vol 15", s_noise);
	scenario ("3 channels held on, vol 15", s_all_held);
	return 0;
}
