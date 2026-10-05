#
# Makefile
#
# BlueberryMSX - Bare metal MSX emulator for Raspberry Pi (Circle)
# Target: Raspberry Pi 3, 32-bit ARM (Cortex-A53)
#
# Booted directly from the boot stick via kernel=msx.img (entry point 0x8000).
# Boots C-BIOS (MSX1) and renders the VDP to the framebuffer.
#

TARGET	= msx
RASPPI	= 3
AARCH	= 32

CIRCLEHOME ?= ../../../BlueberryMSX/circle

EXTRAINCLUDE	+= -I../../include \
			-I../core \
			-I../chips \
			-I../chips/z80 \
			-I../chips/vdp

OBJS = main.o \
	kernel.o \
	msx_task.o \
	vdpblit.o \
	apilog.o \
	syscalls.o \
	cbios_roms.o \
	msxdiag_roms.o \
	msx_core.o \
	r800.o \
	tms9918.o

LIBS = $(CIRCLEHOME)/addon/SDCard/libsdcard.a \
	$(CIRCLEHOME)/lib/usb/libusb.a \
	$(CIRCLEHOME)/lib/input/libinput.a \
	$(CIRCLEHOME)/lib/fs/fat/libfatfs.a \
	$(CIRCLEHOME)/lib/fs/libfs.a \
	$(CIRCLEHOME)/lib/sched/libsched.a \
	$(CIRCLEHOME)/lib/libcircle.a

# toolchain newlib (printf, malloc via _sbrk, ...) - recipe-only, like LIBGCC.
# Must select the hard-float multilib to match our objects (-mfloat-abi=hard).
EXTRALIBS += "$(shell $(CC) -mcpu=cortex-a53 -mfloat-abi=hard -mfpu=neon-fp-armv8 -print-file-name=libc.a)"

include $(CIRCLEHOME)/sample/Rules.mk

# Compile the MSX core C sources with Circle's ARM toolchain into local
# objects (the .o files in the source tree are host-build artifacts).
msx_core.o: ../core/msx.c
	@echo "  CC    $@"
	@$(CC) $(CFLAGS) $(C_STANDARD) -c -o $@ $<

r800.o: ../chips/z80/R800.c
	@echo "  CC    $@"
	@$(CC) $(CFLAGS) $(C_STANDARD) -c -o $@ $<

tms9918.o: ../chips/vdp/tms9918.c
	@echo "  CC    $@"
	@$(CC) $(CFLAGS) $(C_STANDARD) -c -o $@ $<
