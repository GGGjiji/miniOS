
out/bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:

.code16
.globl start
.global hello
start:
  cli #关中断，bios启动的时候可能开启中断
    7c00:	fa                   	cli    
  xorw    %ax,%ax
    7c01:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds
    7c03:	8e d8                	mov    %eax,%ds
  movw    %ax,%es
    7c05:	8e c0                	mov    %eax,%es
  movw    %ax,%ss
    7c07:	8e d0                	mov    %eax,%ss

00007c09 <seta20.1>:
  #打开A20
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c09:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0b:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0d:	75 fa                	jne    7c09 <seta20.1>
  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c0f:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c11:	e6 64                	out    %al,$0x64

00007c13 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c13:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c15:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c17:	75 fa                	jne    7c13 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c19:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1b:	e6 60                	out    %al,$0x60
  #切换到32位保护模式
  lgdt    gdtdesc
    7c1d:	0f 01 16             	lgdtl  (%esi)
    7c20:	70 7c                	jo     7c9e <readsect+0x16>
  movl    %cr0, %eax
    7c22:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE, %eax
    7c25:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c29:	0f 22 c0             	mov    %eax,%cr0
  jmp     $0x8, $start32
    7c2c:	ea                   	.byte 0xea
    7c2d:	31 7c 08 00          	xor    %edi,0x0(%eax,%ecx,1)

00007c31 <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  movw    $0x10, %ax    	  # Our data segment selector
    7c31:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c35:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c37:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7c39:	8e d0                	mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
    7c3b:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
    7c3f:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c41:	8e e8                	mov    %eax,%gs
  movw	  $0x3f8,%dx
    7c43:	66 ba f8 03          	mov    $0x3f8,%dx
  movb 	  $0x41, %al     #41h='A'     
    7c47:	b0 41                	mov    $0x41,%al

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c49:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call    bootmain
    7c4e:	e8 0a 01 00 00       	call   7d5d <bootmain>

00007c53 <spin>:
spin:
  jmp     spin
    7c53:	eb fe                	jmp    7c53 <spin>
    7c55:	8d 76 00             	lea    0x0(%esi),%esi

00007c58 <gdt>:
	...
    7c60:	ff                   	(bad)  
    7c61:	ff 00                	incl   (%eax)
    7c63:	00 00                	add    %al,(%eax)
    7c65:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c6c:	00                   	.byte 0x0
    7c6d:	92                   	xchg   %eax,%edx
    7c6e:	cf                   	iret   
	...

00007c70 <gdtdesc>:
    7c70:	17                   	pop    %ss
    7c71:	00 58 7c             	add    %bl,0x7c(%eax)
	...

00007c76 <waitdisk>:
  entry = (void(*)(void))(elf->entry);
  entry();
}

void waitdisk(void)
{
    7c76:	55                   	push   %ebp
    7c77:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
    7c79:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c7e:	ec                   	in     (%dx),%al
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7c7f:	83 e0 c0             	and    $0xffffffc0,%eax
    7c82:	3c 40                	cmp    $0x40,%al
    7c84:	75 f8                	jne    7c7e <waitdisk+0x8>
    ;
}
    7c86:	5d                   	pop    %ebp
    7c87:	c3                   	ret    

00007c88 <readsect>:

// Read a single sector at offset into dst.
void readsect(void *dst, uint offset)
{
    7c88:	55                   	push   %ebp
    7c89:	89 e5                	mov    %esp,%ebp
    7c8b:	57                   	push   %edi
    7c8c:	56                   	push   %esi
    7c8d:	53                   	push   %ebx
    7c8e:	83 ec 0c             	sub    $0xc,%esp
    7c91:	e8 5a 01 00 00       	call   7df0 <__x86.get_pc_thunk.bx>
    7c96:	81 c3 2e 02 00 00    	add    $0x22e,%ebx
    7c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  // Issue command.
  waitdisk();
    7c9f:	e8 d2 ff ff ff       	call   7c76 <waitdisk>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7ca4:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7ca9:	b8 01 00 00 00       	mov    $0x1,%eax
    7cae:	ee                   	out    %al,(%dx)
    7caf:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7cb4:	89 f0                	mov    %esi,%eax
    7cb6:	ee                   	out    %al,(%dx)
    7cb7:	89 f0                	mov    %esi,%eax
    7cb9:	c1 e8 08             	shr    $0x8,%eax
    7cbc:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cc1:	ee                   	out    %al,(%dx)
    7cc2:	89 f0                	mov    %esi,%eax
    7cc4:	c1 e8 10             	shr    $0x10,%eax
    7cc7:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7ccc:	ee                   	out    %al,(%dx)
    7ccd:	89 f0                	mov    %esi,%eax
    7ccf:	c1 e8 18             	shr    $0x18,%eax
    7cd2:	83 c8 e0             	or     $0xffffffe0,%eax
    7cd5:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cda:	ee                   	out    %al,(%dx)
    7cdb:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7ce0:	b8 20 00 00 00       	mov    $0x20,%eax
    7ce5:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
  outb(0x1F6, (offset >> 24) | 0xE0);
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7ce6:	e8 8b ff ff ff       	call   7c76 <waitdisk>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
    7ceb:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cee:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cf3:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cf8:	fc                   	cld    
    7cf9:	f3 6d                	rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7cfb:	83 c4 0c             	add    $0xc,%esp
    7cfe:	5b                   	pop    %ebx
    7cff:	5e                   	pop    %esi
    7d00:	5f                   	pop    %edi
    7d01:	5d                   	pop    %ebp
    7d02:	c3                   	ret    

00007d03 <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void readseg(uchar* pa, uint count, uint offset)
{
    7d03:	55                   	push   %ebp
    7d04:	89 e5                	mov    %esp,%ebp
    7d06:	57                   	push   %edi
    7d07:	56                   	push   %esi
    7d08:	53                   	push   %ebx
    7d09:	83 ec 1c             	sub    $0x1c,%esp
    7d0c:	e8 df 00 00 00       	call   7df0 <__x86.get_pc_thunk.bx>
    7d11:	81 c3 b3 01 00 00    	add    $0x1b3,%ebx
    7d17:	8b 75 08             	mov    0x8(%ebp),%esi
    7d1a:	8b 7d 10             	mov    0x10(%ebp),%edi
  uchar* epa;

  epa = pa + count;
    7d1d:	89 f0                	mov    %esi,%eax
    7d1f:	03 45 0c             	add    0xc(%ebp),%eax
    7d22:	89 c2                	mov    %eax,%edx
    7d24:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7d27:	89 f8                	mov    %edi,%eax
    7d29:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d2e:	29 c6                	sub    %eax,%esi

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d30:	c1 ef 09             	shr    $0x9,%edi
    7d33:	83 c7 01             	add    $0x1,%edi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d36:	39 f2                	cmp    %esi,%edx
    7d38:	76 1b                	jbe    7d55 <readseg+0x52>
    readsect(pa, offset);
    7d3a:	83 ec 08             	sub    $0x8,%esp
    7d3d:	57                   	push   %edi
    7d3e:	56                   	push   %esi
    7d3f:	e8 44 ff ff ff       	call   7c88 <readsect>
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d44:	81 c6 00 02 00 00    	add    $0x200,%esi
    7d4a:	83 c7 01             	add    $0x1,%edi
    7d4d:	83 c4 10             	add    $0x10,%esp
    7d50:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
    7d53:	77 e5                	ja     7d3a <readseg+0x37>
    readsect(pa, offset);
}
    7d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d58:	5b                   	pop    %ebx
    7d59:	5e                   	pop    %esi
    7d5a:	5f                   	pop    %edi
    7d5b:	5d                   	pop    %ebp
    7d5c:	c3                   	ret    

00007d5d <bootmain>:
#define SECTSIZE  512

void readseg(uchar*, uint, uint);

void bootmain(void)
{
    7d5d:	55                   	push   %ebp
    7d5e:	89 e5                	mov    %esp,%ebp
    7d60:	57                   	push   %edi
    7d61:	56                   	push   %esi
    7d62:	53                   	push   %ebx
    7d63:	83 ec 20             	sub    $0x20,%esp
    7d66:	e8 85 00 00 00       	call   7df0 <__x86.get_pc_thunk.bx>
    7d6b:	81 c3 59 01 00 00    	add    $0x159,%ebx
  uchar* pa;

  elf = (struct elfhdr*)0x10000;  // scratch space

  // Read 1st page off disk
  readseg((uchar*)elf, 4096, 0);
    7d71:	6a 00                	push   $0x0
    7d73:	68 00 10 00 00       	push   $0x1000
    7d78:	68 00 00 01 00       	push   $0x10000
    7d7d:	e8 81 ff ff ff       	call   7d03 <readseg>

  // Is this an ELF executable?
  if(elf->magic != ELF_MAGIC)
    7d82:	83 c4 10             	add    $0x10,%esp
    7d85:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d8c:	45 4c 46 
    7d8f:	75 57                	jne    7de8 <bootmain+0x8b>
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d91:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d96:	8d b0 00 00 01 00    	lea    0x10000(%eax),%esi
  eph = ph + elf->phnum;
    7d9c:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
    7da3:	c1 e0 05             	shl    $0x5,%eax
    7da6:	01 f0                	add    %esi,%eax
    7da8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; ph < eph; ph++){
    7dab:	39 c6                	cmp    %eax,%esi
    7dad:	73 33                	jae    7de2 <bootmain+0x85>
    pa = (uchar*)ph->paddr;
    7daf:	8b 7e 0c             	mov    0xc(%esi),%edi
    readseg(pa, ph->filesz, ph->off);
    7db2:	83 ec 04             	sub    $0x4,%esp
    7db5:	ff 76 04             	pushl  0x4(%esi)
    7db8:	ff 76 10             	pushl  0x10(%esi)
    7dbb:	57                   	push   %edi
    7dbc:	e8 42 ff ff ff       	call   7d03 <readseg>
    if(ph->memsz > ph->filesz)
    7dc1:	8b 4e 14             	mov    0x14(%esi),%ecx
    7dc4:	8b 46 10             	mov    0x10(%esi),%eax
    7dc7:	83 c4 10             	add    $0x10,%esp
    7dca:	39 c1                	cmp    %eax,%ecx
    7dcc:	76 0c                	jbe    7dda <bootmain+0x7d>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    7dce:	01 c7                	add    %eax,%edi
    7dd0:	29 c1                	sub    %eax,%ecx
    7dd2:	b8 00 00 00 00       	mov    $0x0,%eax
    7dd7:	fc                   	cld    
    7dd8:	f3 aa                	rep stos %al,%es:(%edi)
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph++){
    7dda:	83 c6 20             	add    $0x20,%esi
    7ddd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
    7de0:	77 cd                	ja     7daf <bootmain+0x52>
  }

  // Call the entry point from the ELF header.
  // Does not return!
  entry = (void(*)(void))(elf->entry);
  entry();
    7de2:	ff 15 18 00 01 00    	call   *0x10018
}
    7de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7deb:	5b                   	pop    %ebx
    7dec:	5e                   	pop    %esi
    7ded:	5f                   	pop    %edi
    7dee:	5d                   	pop    %ebp
    7def:	c3                   	ret    

00007df0 <__x86.get_pc_thunk.bx>:
    7df0:	8b 1c 24             	mov    (%esp),%ebx
    7df3:	c3                   	ret    
