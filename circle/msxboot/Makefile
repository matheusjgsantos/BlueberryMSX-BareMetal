#
# Makefile - msxboot (Circle HTTP/TFTP chain-boot server for the MSX emulator)
#
# Pi 3B+ (Cortex-A53, 32-bit ARM). Builds msxboot.img which is flashed to the
# SD boot partition and serves an upload UI over HTTP :8080 / TFTP. Uploaded
# images are chain-booted at 0x8000 (the MSX emulator's LOADADDR).
#

CIRCLEHOME ?= ../../../circle

# Target Pi 3B+ / Cortex-A53, 32-bit ARM
RASPPI = 3
AARCH  = 32

# Output name: msxboot.img (referenced by config.txt as kernel=msxboot.img)
TARGET = msxboot

OBJS	= main.o kernel.o httpbootserver.o tftpbootserver.o

LIBS	= $(CIRCLEHOME)/lib/usb/libusb.a \
	  $(CIRCLEHOME)/addon/SDCard/libsdcard.a \
	  $(CIRCLEHOME)/lib/input/libinput.a \
	  $(CIRCLEHOME)/lib/fs/fat/libfatfs.a \
	  $(CIRCLEHOME)/lib/fs/libfs.a \
	  $(CIRCLEHOME)/lib/net/libnet.a \
	  $(CIRCLEHOME)/lib/sched/libsched.a \
	  $(CIRCLEHOME)/lib/libcircle.a

CONTENT	= index.h style.h favicon.h

EXTRACLEAN = $(CONTENT)

include $(CIRCLEHOME)/sample/Rules.mk

%.h: %.html
	@echo "  GEN   $@"
	@$(CIRCLEHOME)/tools/converttool $< > $@

%.h: %.css
	@echo "  GEN   $@"
	@$(CIRCLEHOME)/tools/converttool $< > $@

%.h: %.ico
	@echo "  GEN   $@"
	@$(CIRCLEHOME)/tools/converttool -b $< > $@

httpbootserver.o: $(CONTENT)

-include $(DEPS)
