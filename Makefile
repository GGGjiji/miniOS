# Default make target
.PHONY: all
all: miniOS.img	

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

miniOS.img: bootblock kernel
	dd if=/dev/zero of=miniOS.img count=10000
	dd if=bootblock of=miniOS.img conv=notrunc
	dd if=kernel of=miniOS.img seek=1 conv=notrunc

bootblock:
	@mkdir out
	make -f ./bootload/Makefile

kernel:
	make -f ./src/Makefile
	
clean:
	find -name "*.o" -o -name "*.d" -o -name "*.d" -o -name "*.asm" \
	-o -name "bootblock" -o -name "*.img" -o -name "kernel" \
	-o -name "initcode.out" -o -name "initcode" \
	|xargs rm -rfv
	rm -rf out


ifndef CPUS
CPUS := 1
endif
QEMUOPTS = -drive file=miniOS.img,index=0,media=disk,format=raw -smp 1 -m 512 $(QEMUEXTRA)

qemu: miniOS.img
	$(QEMU) -serial mon:stdio $(QEMUOPTS)
