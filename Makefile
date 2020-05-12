.PHONY: all
all: miniOS.img

X64 = 1

BITS = 64
XFLAGS = -DDEBUG -std=gnu11 -m64 -DX64 -mcmodel=kernel -mtls-direct-seg-refs -mno-red-zone
LDFLAGS = -m elf_x86_64 -nodefaultlibs

FSGSBASE=$(shell cat /proc/cpuinfo|grep fsgsbase)
ifneq ($(strip $(FSGSBASE)),)
   XFLAGS+= -D__FSGSBASE__
endif
OUT = out

HOST_CC ?= gcc

OPT ?= -O2
ARCHOBJ_DIR =.archobj
DOBJ_DIR =.dobj
KOBJ_DIR = .kobj
OBJS := $(addprefix $(KOBJ_DIR)/,$(OBJS))
AOBJs :=
KOBJS :=
DOBJS :=
MODULEC_SOURCES = $(shell find module -name "*.c")
MODULEC_OBJECTS = $(patsubst %.c, %.o, $(MODULEC_SOURCES))

LIBS_SOURCES = $(shell find libs -name "*.c")
LIBS_OBJECTS = $(patsubst %.c, %.o, $(LIBS_SOURCES))
LIBS_ASMSOURCES = $(shell find libs -name "*.S")
LIBS_ASMOBJECTS = $(patsubst %.S, %.o, $(LIBS_ASMSOURCES))
OBJS := $(addprefix $(ARCHOBJ_DIR)/,$(AOBJS)) \
          $(addprefix $(KOBJ_DIR)/,$(KOBJS)) $(addprefix $(DOBJ_DIR)/,$(DOBJS))
OBJS += $(MODULEC_OBJECTS) $(LIBS_OBJECTS) $(LIBS_ASMOBJECTS)
# Cross-compiling (e.g., on Mac OS X)
CROSS_COMPILE ?=

# If the makefile can't find QEMU, specify its path here
QEMU ?= qemu-system-x86_64

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)gas
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
cc-option = $(shell if $(CC) $(1) -S -o /dev/null -xc /dev/null \
        > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)

CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -Wall -Werror
CFLAGS += -g -Wall -MD -D__KERNEL__ -fno-omit-frame-pointer
CFLAGS += -ffreestanding -fno-common -nostdlib -I arch/x86_64/include -Iinclude -I bsd/sys \
  -gdwarf-2 $(XFLAGS) $(OPT) -fno-stack-protector
CFLAGS += $(call cc-option, -fno-stack-protector, "")
CFLAGS += $(call cc-option, -fno-stack-protector-all, "")
ASFLAGS = -gdwarf-2 -Wa,-divide -D__ASSEMBLY__ -Iinclude -I arch/x86_64/include $(XFLAGS)

MODULEC_FLAGS=$(CFLAGS) -D_MODULE
$(KOBJ_DIR)/%.o: kernel/%.c
	@mkdir -p $(KOBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(KOBJ_DIR)/%.o: kernel/%.S
	@mkdir -p $(KOBJ_DIR)
	$(CC) $(ASFLAGS) -c -o $@ $<
$(ARCHOBJ_DIR)/%.o: arch/x86_64/%.c
	@mkdir -p $(ARCHOBJ_DIR)
	(CC) $(CFLAGS) -c -o $@ $<

$(ARCHOBJ_DIR)/%.o: arch/x86_64/%.S
	@mkdir -p $(ARCHOBJ_DIR)
	@mkdir -p $(ARCHOBJ_DIR)/lib
	$(CC) $(ASFLAGS) -c -o $@ $<

$(DOBJ_DIR)/%.o: drivers/%.c
	@mkdir -p $(DOBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(DOBJ_DIR)/%.o: drivers/%.S
	@mkdir -p $(DOBJ_DIR)
	$(CC) $(ASFLAGS) -c -o $@ $<

.c.o:
	$(CC) $(MODULEC_FLAGS) -c $< -o $@
.S.o:
	$(CC) $(ASFLAGS)  -c -o $@ $<
$(OUT)/bootblock: bootloader/bootasm.S bootloader/bootmain.c
	@mkdir -p $(OUT)
	$(CC) -fno-builtin -fno-pic -m32 -nostdinc -fno-stack-protector -Iinclude \
  		-Os -o $(OUT)/bootmain.o -c bootloader/bootmain.c
	$(CC) -fno-builtin -fno-pic -m32 -nostdinc -Iarch/x86_64/include -Iinclude \
   	-o $(OUT)/bootasm.o -c bootloader/bootasm.S
	$(LD) -m elf_i386 -nodefaultlibs --omagic -e start -Ttext 0x7C00 \
		-o $(OUT)/bootblock.o $(OUT)/bootasm.o $(OUT)/bootmain.o
	$(OBJDUMP) -S $(OUT)/bootblock.o > $(OUT)/bootblock.asm
	$(OBJCOPY) -S -O binary -j .text $(OUT)/bootblock.o $(OUT)/bootblock
		../tools/sign.pl $(OUT)/bootblock
clean:
	rm -rf $(OUT) $(FS_DIR) $(UOBJ_DIR) $(KOBJ_DIR) $(ARCHOBJ_DIR) $(DOBJ_DIR)
	rm -f kernel/vectors.S miniOS.img miniOSmemfs.img  .gdbinit
	rm -rf $(MODULEC_OBJECTS)
	rm -rf $(LIBS_OBJECTS)
ifndef CPUS
CPUS := $(shell grep -c ^processor /proc/cpuinfo 2>/devs/null || sysctl -n hw.ncpu)
endif
QEMUOPTS =-enable-kvm -cpu host,+x2apic -vga vmware -display vnc=192.168.10.2:10 \
	-hdb miniOS.img -smp $(CPUS) -m 512 $(QEMUEXTRA)

miniOS.img: $(OUT)/bootblock
	dd if=/dev/zero of=miniOS.img count=10000
	dd if=$(OUT)/bootblock of=miniOS.img conv=notrunc

qemu: miniOS.img
	@echo Ctrl+a h for help
	$(QEMU) -serial mon:stdio  -nographic $(QEMUOPTS)