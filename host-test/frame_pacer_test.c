#include <stdio.h>
#include "frame_pacer.h"

#define CHECK(expr) do { if (!(expr)) { \
    printf("FAIL line %d: %s\n", __LINE__, #expr); return 1; } } while (0)

int main (void)
{
    FramePacer pacer;
    // Vary frame work, including near-budget rendering and logging.
    const unsigned work[] = {1000, 8000, 16000};
    const uint32_t starts[] = {0, 0xFFFF0000u};
    for (unsigned s = 0; s < 2; s++) {
        uint32_t now = starts[s];
        frame_pacer_reset(&pacer, now);
        for (unsigned i = 0; i < 600; i++) {
            now += work[i % 3];
            unsigned wait = frame_pacer_finish(&pacer, now);
            CHECK(wait <= 16667);
            now += wait;
            CHECK((uint32_t)(now - starts[s]) == (uint64_t)(i + 1) * 1000000 / 60);
        }
        CHECK((uint32_t)(now - starts[s]) == 10000000);
        CHECK(pacer.late == 0 && pacer.resync == 0);
    }
    frame_pacer_reset(&pacer, 0);
    CHECK(frame_pacer_finish(&pacer, 18000) == 0);
    CHECK(pacer.late == 1 && pacer.resync == 0);
    CHECK(frame_pacer_finish(&pacer, 26000) == 7333); // small overrun recovered
    CHECK(frame_pacer_finish(&pacer, 200000) == 0); // long stall: abandon old deadline
    CHECK(pacer.resync == 1);
    CHECK(frame_pacer_finish(&pacer, 208000) == 8666);
    frame_pacer_reset(&pacer, 3000000000u); // resume/reset must discard timing debt
    CHECK(frame_pacer_finish(&pacer, 3000001000u) == 15666);
    CHECK(pacer.late == 0 && pacer.resync == 0);
    frame_pacer_reset(&pacer, 0);
    for (unsigned i = 1; i <= 120; i++)
        CHECK(frame_pacer_finish(&pacer, i * 25000) == 0); // overloaded: never add sleep
    CHECK(pacer.resync > 0);
    puts("PASS: 60 Hz deadlines, variable work, wraparound, overload and resume");
    return 0;
}
