#!/bin/sh
set -e
echo "=== MSX Bare-Metal Toolchain Setup ==="

# 1. ARM toolchain (Circle SDK target)
which arm-none-eabi-gcc >/dev/null 2>&1 || {
    echo "[!] ARM GCC toolchain not found - manual install required:"
    echo "    apt-get update && apt-get install gcc-arm-none-eabi"
}

# 2. Clang for WASM compilation (LLVM backend for VDP/PSG)  
which clang >/dev/null 2>&1 || {
    echo "[!] LLVM/Clang not found - manual install required:"
    echo "    apt-get update && apt-get install clang llvm"
}

# 3. CMake for build system orchestration
which cmake >/dev/null 2>&1 || {
    echo "[!] CMake not found - manual install required:"
    echo "    apt-get update && apt-get install cmake"
}

if [ "$(which arm-none-eabi-gcc)" = "" ] || [ "$(which clang)" = "" ] || [ "$(which cmake)" = "" ]; then
    echo ""
    error_exit=1
fi

# Check for Circle SDK at known locations (absolute paths)
CIRCLE_HOME=""
if [ -d "/home/opencode/MSX/BlueberryMSX/circle/include/circle" ]; then
    CIRCLE_HOME="/home/opencode/MSX/BlueberryMSX/circle"
    echo "[+] Found Circle SDK at $CIRCLE_HOME"
elif [ -d "../circle/include/circle" ]; then
    CIRCLE_HOME="../circle"
    echo "[+] Found Circle SDK at $CIRCLE_HOME"
else
    echo "[!] Circle SDK not found. Expecting at:"
    echo "    /home/opencode/MSX/BlueberryMSX/circle"
fi
export CIRCLEHOME="$CIRCLE_HOME"

# Note: WAMR checkout commented out - requires manual review of integration strategy
# WAMR_DIR="$(pwd)/wamr-sdk"
# if [ ! -d "$WAMR_DIR/assemblyscript" ]; then
#     echo "[+] Cloning WAMR SDK at $WAMR_DIR..."
#     git clone --depth 1 https://github.com/bytecodealliance/wasm-micro-runtime.git "$WAMR_DIR" >/dev/null 2>&1
# fi

if [ "${error_exit}" = "1" ]; then
    echo ""
    echo "[!] Please install missing tools with 'apt-get' commands above, then re-run"
    exit 1
fi

echo "✓ Toolchain setup complete"
