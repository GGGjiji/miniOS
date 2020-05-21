# Default make target
.PHONY: all
all: miniOS.img

# Cross-compiling (e.g., on Mac OS X)
ifndef CROSS_COMPILE
CROSS_COMPILE := $(shell if i386-jos-elf-objdump -i 2>&1 | grep '^elf32-i386$$' >/dev/null 2>&1; \
	then echo 'i386-jos-elf-'; \
	elif objdump -i 2>&1 | grep 'elf32-i386' >/dev/null 2>&1; \
	then echo ''; \
	else echo "***" 1>&2; \
	echo "*** Error: Couldn't find an i386-*-elf version of GCC/binutils." 1>&2; \
	echo "*** Is the directory with i386-jos-elf-gcc in your PATH?" 1>&2; \
	echo "*** If your i386-*-elf toolchain is installed with a command" 1>&2; \
	echo "*** prefix other than 'i386-jos-elf-', set your TOOLPREFIX" 1>&2; \
	echo "*** environment variable to that prefix and run 'make' again." 1>&2; \
	echo "*** To turn off this error, run 'gmake TOOLPREFIX= ...'." 1>&2; \
	echo "***" 1>&2; exit 1; fi)
endif

# Try to infer the correct QEMU
ifndef QEMU
QEMU = $(shell if which qemu > /dev/null; \
	then echo qemu; exit; \
	elif which qemu-system-i386 > /dev/null; \
	then echo qemu-system-i386; exit; \
	elif which qemu-system-x86_64 > /dev/null; \
	then echo qemu-system-x86_64; exit; \
	else \
	qemu=/Applications/Q.app/Contents/MacOS/i386-softmmu.app/Contents/MacOS/i386-softmmu; \
	if test -x $$qemu; then echo $$qemu; exit; fi; fi; \
	echo "***" 1>&2; \
	echo "*** Error: Couldn't find a working QEMU executable." 1>&2; \
	echo "*** Is the directory containing the qemu binary in your PATH" 1>&2; \
	echo "*** or have you tried setting the QEMU variable in Makefile?" 1>&2; \
	echo "***" 1>&2; exit 1)
endif

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)gas
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
cc-option = $(shell if $(CC) $(1) -S -o /dev/null -xc /dev/null \
        > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)

CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
ASFLAGS = -m32 -gdwarf-2 -Wa,-divide
LDFLAGS += -m $(shell $(LD) -V | grep elf_i386 2>/dev/null | head -n 1)

# Disable PIE when possible (for Ubuntu 16.10 toolchain)
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]no-pie'),)
CFLAGS += -fno-pie -no-pie
endif
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]nopie'),)
CFLAGS += -fno-pie -nopie
endif
CFLAGS+=-fPIC

# path of head files
INCLUDES = -I./head

miniOS.img: bootblock kernel
	dd if=/dev/zero of=miniOS.img count=10000
	dd if=bootblock of=miniOS.img conv=notrunc
	dd if=kernel of=miniOS.img seek=1 conv=notrunc

bootblock: bootload/bootasm.S bootload/bootmain.c
	@mkdir out
	$(CC) $(INCLUDES) $(CFLAGS) -fno-pic -O -nostdinc -I. -o out/bootmain.o -c bootload/bootmain.c
	$(CC) $(INCLUDES) $(CFLAGS) -fno-pic -nostdinc -I. -o out/bootasm.o -c bootload/bootasm.S
	$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 -o out/bootblock.o out/bootasm.o out/bootmain.o
	$(OBJDUMP) -S out/bootblock.o > out/bootblock.asm
	$(OBJCOPY) -S -O binary -j .text out/bootblock.o bootblock 
	./bootload/sign.pl bootblock

kernel: Kernel/entry64.S Kernel/kernel.ld
	$(CC) $(INCLUDES) -m32 -gdwarf-2 -Wa,-divide -o out/entry64.o -c Kernel/entry64.S
	$(LD) $(LDFLAGS) -T Kernel/kernel.ld -o kernel out/entry64.o
	$(OBJDUMP) -S kernel > out/kernel.asm
	$(OBJDUMP) -t kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > out/kernel.sym
	
clean:
	find -name "*.o" -o -name "*.d" -o -name "*.d" -o -name "*.asm" \
	-o -name "bootblock" -o -name "*.img" -o -name "kernel" \
	|xargs rm -rfv
	rm -rf out


ifndef CPUS
CPUS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
endif
QEMUOPTS = -drive file=miniOS.img,index=0,media=disk,format=raw -smp $(CPUS) -m 512 $(QEMUEXTRA)

qemu: miniOS.img
	$(QEMU) -serial mon:stdio $(QEMUOPTS)
