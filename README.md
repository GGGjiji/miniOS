# miniOS
A small 32-bit OS 

### File Structure
.
├── bootload
│   ├── bootasm.S
│   ├── bootmain.c
│   └── sign.pl
├── head
│   ├── asm.h
│   ├── defs.h
│   ├── elf.h
│   ├── memlayout.h
│   ├── mmu.h
│   ├── param.h
│   ├── proc.h
│   ├── types.h
│   └── x86.h
├── Kernel
│   ├── entry.S
│   └── kernel.ld
├── Makefile
├── README.md
└── src
    └── main.c

#### bootload
See more detailed explanation at this site [bootasm.S](https://blog.csdn.net/DWLVXW0325/article/details/106344099).
[bootmain.c](https://blog.csdn.net/DWLVXW0325/article/details/106378930).

### update log
#### 2020.5.17
Only have bootblock process. Print "HelloWorld" on screen.

#### 2020.5.19
Mkdir some folder, and rebuild the file structure. updata the Makefile. 

#### 2020.5.21
Have a problem with"cannot represent relocation type BFD_RELOC_64".Try to fix it.

### 2020.5.24
Print "hello world" with bootload and kernel.
Fix the problem with kernel.(although copy the code from xv6 with 32-bit OS system).

### 2020.5.31
Add debug function -- Print_uart(),which uses UART to print string on the terminal.

### 2020.6.7
Add kalloc function, but still has some problems.
