#!/bin/bash

# Compile and run V9938 tests
cd /home/opencode/MSX/BlueberryMSX-BareMetal

echo "Compiling V9938 tests..."
gcc ${V9938_TEST_CFLAGS:-} -O1 -Wall -Wextra -Iinclude -Isrc/chips/vdp host-test/v9938_test.c src/chips/vdp/v9938.c src/chips/vdp/tms9918.c host-test/trace_stub.c -o /tmp/v9938_test

if [ $? -eq 0 ]; then
    echo "Running V9938 tests..."
    /tmp/v9938_test
    if [ $? -eq 0 ]; then
        echo "V9938 tests passed!"
    else
        echo "V9938 tests failed!"
        exit 1
    fi
else
    echo "Compilation failed!"
    exit 1
fi

set -e
gcc ${V9938_TEST_CFLAGS:-} -O1 -Wall -Wextra -Iinclude -Isrc/chips/vdp \
    host-test/v9938_conformance_test.c src/chips/vdp/v9938.c \
    src/chips/vdp/tms9918.c host-test/trace_stub.c -o /tmp/v9938_conformance_test
/tmp/v9938_conformance_test
gcc ${V9938_TEST_CFLAGS:-} -O1 -Wall -Wextra -Iinclude -Isrc/chips/vdp \
    host-test/vdp_raster_split_test.c src/chips/vdp/v9938.c \
    src/chips/vdp/tms9918.c host-test/trace_stub.c -o /tmp/vdp_raster_split_test
/tmp/vdp_raster_split_test
