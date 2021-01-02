.all: kernel

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

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)gas
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
cc-option = $(shell if $(CC) $(1) -S -o /dev/null -xc /dev/null \
        > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)

CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -fno-omit-frame-pointer -O -nostdinc
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
INCLUDES = -I /home/chhss/Github/miniOS/head

OBJS = \
	/home/chhss/Github/miniOS/out/main.o		\
	/home/chhss/Github/miniOS/out/print_uart.o	\
	/home/chhss/Github/miniOS/out/entry.o		

SRC=/home/chhss/Github/miniOS/src
OUT=/home/chhss/Github/miniOS/out
KS=/home/chhss/Github/miniOS/Kernel
LDFILE=/home/chhss/Github/miniOS/Kernel/kernel.ld
ASM=/home/chhss/Github/miniOS/out/kernel.asm
KERNEL=/home/chhss/Github/miniOS

$(OUT)%.o :$(SRC)%.c
	$(CC) $(INCLUDES) $(CFLAGS) -c -o $@ $<

$(OUT)%.o :$(KS)%.S
	$(CC) $(INCLUDES) $(CFLAGS) -c -o $@ $<	

kernel:$(OBJS) $(LDFILE)
	$(LD) $(LDFLAGS) -T $(LDFILE) -o $(KERNEL)/kernel $(OBJS)
	$(OBJDUMP) -S $(KERNEL)/kernel > $(ASM)
	$(OBJDUMP) -t $(KERNEL)/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(OUT)/kernel.sym
	