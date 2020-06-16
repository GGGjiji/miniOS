
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <main>:

extern pde_t *kpgdir;
extern char end[]; // first address after kernel loaded from ELF file

int main(void)
{
80100000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80100004:	83 e4 f0             	and    $0xfffffff0,%esp
80100007:	ff 71 fc             	pushl  -0x4(%ecx)
8010000a:	55                   	push   %ebp
8010000b:	89 e5                	mov    %esp,%ebp
8010000d:	53                   	push   %ebx
8010000e:	51                   	push   %ecx
8010000f:	e8 39 00 00 00       	call   8010004d <__x86.get_pc_thunk.bx>
80100014:	81 c3 f0 1f 00 00    	add    $0x1ff0,%ebx
  char *s = "by GGGjiji!\n";
  int out = print_uart("hello,world\n%s",s);
8010001a:	83 ec 08             	sub    $0x8,%esp
8010001d:	8d 83 28 e8 ff ff    	lea    -0x17d8(%ebx),%eax
80100023:	50                   	push   %eax
80100024:	8d 83 35 e8 ff ff    	lea    -0x17cb(%ebx),%eax
8010002a:	50                   	push   %eax
8010002b:	e8 23 01 00 00       	call   80100153 <print_uart>
  (void)out;
  kinit1(end,P2V(4*1024*1024));
80100030:	83 c4 08             	add    $0x8,%esp
80100033:	68 00 00 40 80       	push   $0x80400000
80100038:	ff b3 fc ff ff ff    	pushl  -0x4(%ebx)
8010003e:	e8 9a 03 00 00       	call   801003dd <kinit1>
  kvmalloc(); 
80100043:	e8 a2 07 00 00       	call   801007ea <kvmalloc>
80100048:	83 c4 10             	add    $0x10,%esp
8010004b:	eb fe                	jmp    8010004b <main+0x4b>

8010004d <__x86.get_pc_thunk.bx>:
8010004d:	8b 1c 24             	mov    (%esp),%ebx
80100050:	c3                   	ret    

80100051 <uart_early_init>:
    asm volatile ("inb %1, %0":"=a" (r):"dN" (port));
    return r;
}

void uart_early_init(void)
{
80100051:	55                   	push   %ebp
80100052:	89 e5                	mov    %esp,%ebp
#include "types.h"
#define COM1	0x3f8
static int uart;  
static inline void outb(u8 val, u16 port)
{
    asm volatile ("outb %0, %1"::"a" (val), "dN" (port));
80100054:	ba fa 03 00 00       	mov    $0x3fa,%edx
80100059:	b8 00 00 00 00       	mov    $0x0,%eax
8010005e:	ee                   	out    %al,(%dx)
8010005f:	ba fb 03 00 00       	mov    $0x3fb,%edx
80100064:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80100069:	ee                   	out    %al,(%dx)
8010006a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010006f:	b8 0c 00 00 00       	mov    $0xc,%eax
80100074:	ee                   	out    %al,(%dx)
80100075:	ba f9 03 00 00       	mov    $0x3f9,%edx
8010007a:	b8 00 00 00 00       	mov    $0x0,%eax
8010007f:	ee                   	out    %al,(%dx)
80100080:	ba fb 03 00 00       	mov    $0x3fb,%edx
80100085:	b8 03 00 00 00       	mov    $0x3,%eax
8010008a:	ee                   	out    %al,(%dx)
8010008b:	ba fc 03 00 00       	mov    $0x3fc,%edx
80100090:	b8 00 00 00 00       	mov    $0x0,%eax
80100095:	ee                   	out    %al,(%dx)
80100096:	ba f9 03 00 00       	mov    $0x3f9,%edx
8010009b:	b8 01 00 00 00       	mov    $0x1,%eax
801000a0:	ee                   	out    %al,(%dx)
}

static inline u8 inb(u16 port)
{
    u8 r;
    asm volatile ("inb %1, %0":"=a" (r):"dN" (port));
801000a1:	ba fd 03 00 00       	mov    $0x3fd,%edx
801000a6:	ec                   	in     (%dx),%al

    // If status is 0xFF, no serial port.
    if (inb(COM1 + 5) == 0xFF)
        return;
    uart = 1;
}
801000a7:	5d                   	pop    %ebp
801000a8:	c3                   	ret    

801000a9 <uart_putc>:

void uart_putc(int c)
{
801000a9:	55                   	push   %ebp
801000aa:	89 e5                	mov    %esp,%ebp
#include "types.h"
#define COM1	0x3f8
static int uart;  
static inline void outb(u8 val, u16 port)
{
    asm volatile ("outb %0, %1"::"a" (val), "dN" (port));
801000ac:	ba f8 03 00 00       	mov    $0x3f8,%edx
801000b1:	8b 45 08             	mov    0x8(%ebp),%eax
801000b4:	ee                   	out    %al,(%dx)
}

void uart_putc(int c)
{
    outb(c, COM1 + 0);
}
801000b5:	5d                   	pop    %ebp
801000b6:	c3                   	ret    

801000b7 <uart_putint>:

void uart_putint(int xx, int base, int sgn)
{
801000b7:	55                   	push   %ebp
801000b8:	89 e5                	mov    %esp,%ebp
801000ba:	57                   	push   %edi
801000bb:	56                   	push   %esi
801000bc:	53                   	push   %ebx
801000bd:	83 ec 2c             	sub    $0x2c,%esp
801000c0:	e8 88 ff ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
801000c5:	81 c3 3f 1f 00 00    	add    $0x1f3f,%ebx
801000cb:	8b 55 08             	mov    0x8(%ebp),%edx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
801000ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801000d2:	74 14                	je     801000e8 <uart_putint+0x31>
801000d4:	89 d0                	mov    %edx,%eax
801000d6:	c1 e8 1f             	shr    $0x1f,%eax
801000d9:	84 c0                	test   %al,%al
801000db:	74 0b                	je     801000e8 <uart_putint+0x31>
    neg = 1;
    x = -xx;
801000dd:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
801000df:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
801000e6:	eb 07                	jmp    801000ef <uart_putint+0x38>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
801000e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
801000ef:	be 00 00 00 00       	mov    $0x0,%esi
  do{
    buf[i++] = digits[x % base];
801000f4:	8d 7d d7             	lea    -0x29(%ebp),%edi
801000f7:	eb 02                	jmp    801000fb <uart_putint+0x44>
801000f9:	89 ce                	mov    %ecx,%esi
801000fb:	8d 4e 01             	lea    0x1(%esi),%ecx
801000fe:	89 d0                	mov    %edx,%eax
80100100:	ba 00 00 00 00       	mov    $0x0,%edx
80100105:	f7 75 0c             	divl   0xc(%ebp)
80100108:	0f b6 94 13 4c e8 ff 	movzbl -0x17b4(%ebx,%edx,1),%edx
8010010f:	ff 
80100110:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
  }while((x /= base) != 0);
80100113:	89 c2                	mov    %eax,%edx
80100115:	85 c0                	test   %eax,%eax
80100117:	75 e0                	jne    801000f9 <uart_putint+0x42>
  if(neg)
80100119:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010011d:	74 08                	je     80100127 <uart_putint+0x70>
    buf[i++] = '-';
8010011f:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
80100124:	8d 4e 02             	lea    0x2(%esi),%ecx
  while(--i >= 0)
80100127:	89 c8                	mov    %ecx,%eax
80100129:	83 e8 01             	sub    $0x1,%eax
8010012c:	78 1d                	js     8010014b <uart_putint+0x94>
8010012e:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
80100132:	8d 7d d7             	lea    -0x29(%ebp),%edi
    uart_putc(buf[i]);
80100135:	83 ec 0c             	sub    $0xc,%esp
80100138:	0f be 06             	movsbl (%esi),%eax
8010013b:	50                   	push   %eax
8010013c:	e8 68 ff ff ff       	call   801000a9 <uart_putc>
80100141:	83 ee 01             	sub    $0x1,%esi
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';
  while(--i >= 0)
80100144:	83 c4 10             	add    $0x10,%esp
80100147:	39 fe                	cmp    %edi,%esi
80100149:	75 ea                	jne    80100135 <uart_putint+0x7e>
    uart_putc(buf[i]);
}
8010014b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010014e:	5b                   	pop    %ebx
8010014f:	5e                   	pop    %esi
80100150:	5f                   	pop    %edi
80100151:	5d                   	pop    %ebp
80100152:	c3                   	ret    

80100153 <print_uart>:

int print_uart(const char *fmt, ...)
{
80100153:	55                   	push   %ebp
80100154:	89 e5                	mov    %esp,%ebp
80100156:	57                   	push   %edi
80100157:	56                   	push   %esi
80100158:	53                   	push   %ebx
80100159:	83 ec 1c             	sub    $0x1c,%esp
8010015c:	e8 ec fe ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
80100161:	81 c3 a3 1e 00 00    	add    $0x1ea3,%ebx
    	uart_early_init();
80100167:	e8 e5 fe ff ff       	call   80100051 <uart_early_init>
	int state,i,c;
	state = 0;
	uint *ap;
	ap = (uint*)(void*)&fmt + 1;
	for(i = 0; fmt[i];i ++)
8010016c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010016f:	0f b6 07             	movzbl (%edi),%eax
80100172:	84 c0                	test   %al,%al
80100174:	0f 84 19 01 00 00    	je     80100293 <print_uart+0x140>
8010017a:	83 c7 01             	add    $0x1,%edi
8010017d:	8d 55 0c             	lea    0xc(%ebp),%edx
80100180:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100183:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			}
			else if(c == 's'){
				char *s = (char*)*ap;
				ap++;
				if(s == 0)
				  s = "(null)";
8010018a:	8d 8b 44 e8 ff ff    	lea    -0x17bc(%ebx),%ecx
80100190:	89 4d dc             	mov    %ecx,-0x24(%ebp)
	state = 0;
	uint *ap;
	ap = (uint*)(void*)&fmt + 1;
	for(i = 0; fmt[i];i ++)
	{
		c = fmt[i] & 0xff;
80100193:	0f b6 f0             	movzbl %al,%esi
		if(state == 0){
80100196:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010019a:	75 1a                	jne    801001b6 <print_uart+0x63>
			if(c == '%'){
8010019c:	83 fe 25             	cmp    $0x25,%esi
8010019f:	0f 84 cf 00 00 00    	je     80100274 <print_uart+0x121>
				state = '%';		
			}else{
				uart_putc(c);
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	56                   	push   %esi
801001a9:	e8 fb fe ff ff       	call   801000a9 <uart_putc>
801001ae:	83 c4 10             	add    $0x10,%esp
801001b1:	e9 ce 00 00 00       	jmp    80100284 <print_uart+0x131>
			}
		} else if(state == '%'){
801001b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801001ba:	0f 85 c4 00 00 00    	jne    80100284 <print_uart+0x131>
			if(c == 'd'){
801001c0:	83 fe 64             	cmp    $0x64,%esi
801001c3:	75 28                	jne    801001ed <print_uart+0x9a>
				uart_putint(*ap,10,1);
801001c5:	83 ec 04             	sub    $0x4,%esp
801001c8:	6a 01                	push   $0x1
801001ca:	6a 0a                	push   $0xa
801001cc:	8b 75 e0             	mov    -0x20(%ebp),%esi
801001cf:	ff 36                	pushl  (%esi)
801001d1:	e8 e1 fe ff ff       	call   801000b7 <uart_putint>
				ap++;
801001d6:	89 f0                	mov    %esi,%eax
801001d8:	83 c0 04             	add    $0x4,%eax
801001db:	89 45 e0             	mov    %eax,-0x20(%ebp)
801001de:	83 c4 10             	add    $0x10,%esp
			}
			else {
				uart_putc('%');
				uart_putc(c);
			}
			state = 0;
801001e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801001e8:	e9 97 00 00 00       	jmp    80100284 <print_uart+0x131>
		} else if(state == '%'){
			if(c == 'd'){
				uart_putint(*ap,10,1);
				ap++;
			}
			else if(c == 'x'){
801001ed:	83 fe 78             	cmp    $0x78,%esi
801001f0:	75 25                	jne    80100217 <print_uart+0xc4>
				uart_putint(*ap,16,1);
801001f2:	83 ec 04             	sub    $0x4,%esp
801001f5:	6a 01                	push   $0x1
801001f7:	6a 10                	push   $0x10
801001f9:	8b 75 e0             	mov    -0x20(%ebp),%esi
801001fc:	ff 36                	pushl  (%esi)
801001fe:	e8 b4 fe ff ff       	call   801000b7 <uart_putint>
				ap++;
80100203:	89 f0                	mov    %esi,%eax
80100205:	83 c0 04             	add    $0x4,%eax
80100208:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010020b:	83 c4 10             	add    $0x10,%esp
			}
			else {
				uart_putc('%');
				uart_putc(c);
			}
			state = 0;
8010020e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100215:	eb 6d                	jmp    80100284 <print_uart+0x131>
			}
			else if(c == 'x'){
				uart_putint(*ap,16,1);
				ap++;
			}
			else if(c == 's'){
80100217:	83 fe 73             	cmp    $0x73,%esi
8010021a:	75 3a                	jne    80100256 <print_uart+0x103>
				char *s = (char*)*ap;
8010021c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010021f:	8b 30                	mov    (%eax),%esi
				ap++;
80100221:	83 c0 04             	add    $0x4,%eax
80100224:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(s == 0)
80100227:	85 f6                	test   %esi,%esi
				  s = "(null)";
80100229:	0f 44 75 dc          	cmove  -0x24(%ebp),%esi
				while(*s != 0){
8010022d:	0f b6 06             	movzbl (%esi),%eax
80100230:	84 c0                	test   %al,%al
80100232:	74 49                	je     8010027d <print_uart+0x12a>
				  uart_putc(*s);
80100234:	83 ec 0c             	sub    $0xc,%esp
80100237:	0f be c0             	movsbl %al,%eax
8010023a:	50                   	push   %eax
8010023b:	e8 69 fe ff ff       	call   801000a9 <uart_putc>
				  s++;
80100240:	83 c6 01             	add    $0x1,%esi
			else if(c == 's'){
				char *s = (char*)*ap;
				ap++;
				if(s == 0)
				  s = "(null)";
				while(*s != 0){
80100243:	0f b6 06             	movzbl (%esi),%eax
80100246:	83 c4 10             	add    $0x10,%esp
80100249:	84 c0                	test   %al,%al
8010024b:	75 e7                	jne    80100234 <print_uart+0xe1>
			}
			else {
				uart_putc('%');
				uart_putc(c);
			}
			state = 0;
8010024d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100254:	eb 2e                	jmp    80100284 <print_uart+0x131>
				  uart_putc(*s);
				  s++;
				}
			}
			else {
				uart_putc('%');
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	6a 25                	push   $0x25
8010025b:	e8 49 fe ff ff       	call   801000a9 <uart_putc>
				uart_putc(c);
80100260:	89 34 24             	mov    %esi,(%esp)
80100263:	e8 41 fe ff ff       	call   801000a9 <uart_putc>
80100268:	83 c4 10             	add    $0x10,%esp
			}
			state = 0;
8010026b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100272:	eb 10                	jmp    80100284 <print_uart+0x131>
	for(i = 0; fmt[i];i ++)
	{
		c = fmt[i] & 0xff;
		if(state == 0){
			if(c == '%'){
				state = '%';		
80100274:	c7 45 e4 25 00 00 00 	movl   $0x25,-0x1c(%ebp)
8010027b:	eb 07                	jmp    80100284 <print_uart+0x131>
			}
			else {
				uart_putc('%');
				uart_putc(c);
			}
			state = 0;
8010027d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100284:	83 c7 01             	add    $0x1,%edi
    	uart_early_init();
	int state,i,c;
	state = 0;
	uint *ap;
	ap = (uint*)(void*)&fmt + 1;
	for(i = 0; fmt[i];i ++)
80100287:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
8010028b:	84 c0                	test   %al,%al
8010028d:	0f 85 00 ff ff ff    	jne    80100193 <print_uart+0x40>
			}
			state = 0;
		}
	}
    return 0;
}
80100293:	b8 00 00 00 00       	mov    $0x0,%eax
80100298:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010029b:	5b                   	pop    %ebx
8010029c:	5e                   	pop    %esi
8010029d:	5f                   	pop    %edi
8010029e:	5d                   	pop    %ebp
8010029f:	c3                   	ret    

801002a0 <panic>:

void panic(char *s)
{
801002a0:	55                   	push   %ebp
801002a1:	89 e5                	mov    %esp,%ebp
801002a3:	53                   	push   %ebx
801002a4:	83 ec 10             	sub    $0x10,%esp
801002a7:	e8 a1 fd ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
801002ac:	81 c3 58 1d 00 00    	add    $0x1d58,%ebx
	print_uart(s);
801002b2:	ff 75 08             	pushl  0x8(%ebp)
801002b5:	e8 99 fe ff ff       	call   80100153 <print_uart>
}
801002ba:	83 c4 10             	add    $0x10,%esp
801002bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801002c0:	c9                   	leave  
801002c1:	c3                   	ret    
801002c2:	66 90                	xchg   %ax,%ax

801002c4 <multiboot_header>:
801002c4:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
801002ca:	00 00                	add    %al,(%eax)
801002cc:	fe 4f 52             	decb   0x52(%edi)
801002cf:	e4                   	.byte 0xe4

801002d0 <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
801002d0:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
801002d3:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
801002d6:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
801002d9:	b8 00 10 10 00       	mov    $0x101000,%eax
  movl    %eax, %cr3
801002de:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
801002e1:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
801002e4:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
801002e9:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
801002ec:	bc 60 30 10 80       	mov    $0x80103060,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
801002f1:	b8 00 00 10 80       	mov    $0x80100000,%eax
  jmp *%eax
801002f6:	ff e0                	jmp    *%eax

801002f8 <kfree>:
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
    kfree(p);
}

void kfree(char *v)
{
801002f8:	55                   	push   %ebp
801002f9:	89 e5                	mov    %esp,%ebp
801002fb:	56                   	push   %esi
801002fc:	53                   	push   %ebx
801002fd:	e8 4b fd ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
80100302:	81 c3 02 1d 00 00    	add    $0x1d02,%ebx
80100308:	8b 75 08             	mov    0x8(%ebp),%esi
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010030b:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
80100311:	75 15                	jne    80100328 <kfree+0x30>
80100313:	81 fe a0 30 10 80    	cmp    $0x801030a0,%esi
80100319:	72 0d                	jb     80100328 <kfree+0x30>
8010031b:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80100321:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80100326:	76 0f                	jbe    80100337 <kfree+0x3f>
    panic("kfree");
80100328:	83 ec 0c             	sub    $0xc,%esp
8010032b:	8d 83 5d e8 ff ff    	lea    -0x17a3(%ebx),%eax
80100331:	50                   	push   %eax
80100332:	e8 69 ff ff ff       	call   801002a0 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80100337:	83 ec 04             	sub    $0x4,%esp
8010033a:	68 00 10 00 00       	push   $0x1000
8010033f:	6a 01                	push   $0x1
80100341:	56                   	push   %esi
80100342:	e8 ec 01 00 00       	call   80100533 <memset>

  if(kmem.use_lock)
80100347:	83 c4 10             	add    $0x10,%esp
8010034a:	8d 05 60 30 10 80    	lea    0x80103060,%eax
80100350:	83 78 34 00          	cmpl   $0x0,0x34(%eax)
80100354:	74 0c                	je     80100362 <kfree+0x6a>
    acquire(&kmem.lock);
80100356:	83 ec 0c             	sub    $0xc,%esp
80100359:	50                   	push   %eax
8010035a:	e8 98 01 00 00       	call   801004f7 <acquire>
8010035f:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
  r->next = kmem.freelist;
80100362:	8d 05 60 30 10 80    	lea    0x80103060,%eax
80100368:	8b 50 38             	mov    0x38(%eax),%edx
8010036b:	89 16                	mov    %edx,(%esi)
  kmem.freelist = r;
8010036d:	89 70 38             	mov    %esi,0x38(%eax)
  if(kmem.use_lock)
80100370:	83 78 34 00          	cmpl   $0x0,0x34(%eax)
80100374:	74 0c                	je     80100382 <kfree+0x8a>
    release(&kmem.lock);
80100376:	83 ec 0c             	sub    $0xc,%esp
80100379:	50                   	push   %eax
8010037a:	e8 93 01 00 00       	call   80100512 <release>
8010037f:	83 c4 10             	add    $0x10,%esp
}
80100382:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100385:	5b                   	pop    %ebx
80100386:	5e                   	pop    %esi
80100387:	5d                   	pop    %ebp
80100388:	c3                   	ret    

80100389 <freerange>:
  char *s = "kernel init 2!\n";
  print_uart(s);
}

void freerange(void *vstart, void *vend)
{
80100389:	55                   	push   %ebp
8010038a:	89 e5                	mov    %esp,%ebp
8010038c:	57                   	push   %edi
8010038d:	56                   	push   %esi
8010038e:	53                   	push   %ebx
8010038f:	83 ec 0c             	sub    $0xc,%esp
80100392:	e8 b6 fc ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
80100397:	81 c3 6d 1c 00 00    	add    $0x1c6d,%ebx
8010039d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801003a0:	8b 45 08             	mov    0x8(%ebp),%eax
801003a3:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801003a9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801003af:	81 c6 00 10 00 00    	add    $0x1000,%esi
801003b5:	39 f7                	cmp    %esi,%edi
801003b7:	72 1c                	jb     801003d5 <freerange+0x4c>
    kfree(p);
801003b9:	83 ec 0c             	sub    $0xc,%esp
801003bc:	8d 86 00 f0 ff ff    	lea    -0x1000(%esi),%eax
801003c2:	50                   	push   %eax
801003c3:	e8 30 ff ff ff       	call   801002f8 <kfree>

void freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801003c8:	81 c6 00 10 00 00    	add    $0x1000,%esi
801003ce:	83 c4 10             	add    $0x10,%esp
801003d1:	39 fe                	cmp    %edi,%esi
801003d3:	76 e4                	jbe    801003b9 <freerange+0x30>
    kfree(p);
}
801003d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801003d8:	5b                   	pop    %ebx
801003d9:	5e                   	pop    %esi
801003da:	5f                   	pop    %edi
801003db:	5d                   	pop    %ebp
801003dc:	c3                   	ret    

801003dd <kinit1>:
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void kinit1(void *vstart, void *vend)
{
801003dd:	55                   	push   %ebp
801003de:	89 e5                	mov    %esp,%ebp
801003e0:	56                   	push   %esi
801003e1:	53                   	push   %ebx
801003e2:	e8 66 fc ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
801003e7:	81 c3 1d 1c 00 00    	add    $0x1c1d,%ebx
  initlock(&kmem.lock, "kmem");
801003ed:	83 ec 08             	sub    $0x8,%esp
801003f0:	8d 83 63 e8 ff ff    	lea    -0x179d(%ebx),%eax
801003f6:	50                   	push   %eax
801003f7:	8d 35 60 30 10 80    	lea    0x80103060,%esi
801003fd:	56                   	push   %esi
801003fe:	e8 d9 00 00 00       	call   801004dc <initlock>
  kmem.use_lock = 0;
80100403:	c7 46 34 00 00 00 00 	movl   $0x0,0x34(%esi)
  freerange(vstart, vend);
8010040a:	83 c4 08             	add    $0x8,%esp
8010040d:	ff 75 0c             	pushl  0xc(%ebp)
80100410:	ff 75 08             	pushl  0x8(%ebp)
80100413:	e8 71 ff ff ff       	call   80100389 <freerange>
  char *s = "kernel init 1!\n";
  print_uart(s);
80100418:	8d 83 68 e8 ff ff    	lea    -0x1798(%ebx),%eax
8010041e:	89 04 24             	mov    %eax,(%esp)
80100421:	e8 2d fd ff ff       	call   80100153 <print_uart>
}
80100426:	83 c4 10             	add    $0x10,%esp
80100429:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010042c:	5b                   	pop    %ebx
8010042d:	5e                   	pop    %esi
8010042e:	5d                   	pop    %ebp
8010042f:	c3                   	ret    

80100430 <kinit2>:

void kinit2(void *vstart, void *vend)
{
80100430:	55                   	push   %ebp
80100431:	89 e5                	mov    %esp,%ebp
80100433:	53                   	push   %ebx
80100434:	83 ec 0c             	sub    $0xc,%esp
80100437:	e8 11 fc ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
8010043c:	81 c3 c8 1b 00 00    	add    $0x1bc8,%ebx
  freerange(vstart, vend);
80100442:	ff 75 0c             	pushl  0xc(%ebp)
80100445:	ff 75 08             	pushl  0x8(%ebp)
80100448:	e8 3c ff ff ff       	call   80100389 <freerange>
  kmem.use_lock = 1;
8010044d:	8d 05 60 30 10 80    	lea    0x80103060,%eax
80100453:	c7 40 34 01 00 00 00 	movl   $0x1,0x34(%eax)
  char *s = "kernel init 2!\n";
  print_uart(s);
8010045a:	8d 83 78 e8 ff ff    	lea    -0x1788(%ebx),%eax
80100460:	89 04 24             	mov    %eax,(%esp)
80100463:	e8 eb fc ff ff       	call   80100153 <print_uart>
}
80100468:	83 c4 10             	add    $0x10,%esp
8010046b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010046e:	c9                   	leave  
8010046f:	c3                   	ret    

80100470 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char* kalloc(void)
{
80100470:	55                   	push   %ebp
80100471:	89 e5                	mov    %esp,%ebp
80100473:	56                   	push   %esi
80100474:	53                   	push   %ebx
80100475:	e8 d3 fb ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
8010047a:	81 c3 8a 1b 00 00    	add    $0x1b8a,%ebx
  struct run *r;

  if(kmem.use_lock)
80100480:	8d 05 60 30 10 80    	lea    0x80103060,%eax
80100486:	83 78 34 00          	cmpl   $0x0,0x34(%eax)
8010048a:	74 3a                	je     801004c6 <kalloc+0x56>
    acquire(&kmem.lock);
8010048c:	83 ec 0c             	sub    $0xc,%esp
8010048f:	89 c6                	mov    %eax,%esi
80100491:	50                   	push   %eax
80100492:	e8 60 00 00 00       	call   801004f7 <acquire>
  r = kmem.freelist;
80100497:	8b 76 38             	mov    0x38(%esi),%esi
  if(r)
8010049a:	83 c4 10             	add    $0x10,%esp
8010049d:	85 f6                	test   %esi,%esi
8010049f:	74 0b                	je     801004ac <kalloc+0x3c>
    kmem.freelist = r->next;
801004a1:	8b 16                	mov    (%esi),%edx
801004a3:	8d 05 60 30 10 80    	lea    0x80103060,%eax
801004a9:	89 50 38             	mov    %edx,0x38(%eax)
  if(kmem.use_lock)
801004ac:	8d 05 60 30 10 80    	lea    0x80103060,%eax
801004b2:	83 78 34 00          	cmpl   $0x0,0x34(%eax)
801004b6:	74 1b                	je     801004d3 <kalloc+0x63>
    release(&kmem.lock);
801004b8:	83 ec 0c             	sub    $0xc,%esp
801004bb:	50                   	push   %eax
801004bc:	e8 51 00 00 00       	call   80100512 <release>
801004c1:	83 c4 10             	add    $0x10,%esp
801004c4:	eb 0d                	jmp    801004d3 <kalloc+0x63>
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
801004c6:	8d 05 60 30 10 80    	lea    0x80103060,%eax
801004cc:	8b 70 38             	mov    0x38(%eax),%esi
  if(r)
801004cf:	85 f6                	test   %esi,%esi
801004d1:	75 ce                	jne    801004a1 <kalloc+0x31>
    kmem.freelist = r->next;
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801004d3:	89 f0                	mov    %esi,%eax
801004d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801004d8:	5b                   	pop    %ebx
801004d9:	5e                   	pop    %esi
801004da:	5d                   	pop    %ebp
801004db:	c3                   	ret    

801004dc <initlock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void initlock(struct spinlock *lk, char *name)
{
801004dc:	55                   	push   %ebp
801004dd:	89 e5                	mov    %esp,%ebp
801004df:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801004e2:	8b 55 0c             	mov    0xc(%ebp),%edx
801004e5:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801004e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801004ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801004f5:	5d                   	pop    %ebp
801004f6:	c3                   	ret    

801004f7 <acquire>:

void acquire(struct spinlock *lk)
{
801004f7:	55                   	push   %ebp
801004f8:	89 e5                	mov    %esp,%ebp
801004fa:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uintp newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801004fd:	b9 01 00 00 00       	mov    $0x1,%ecx
80100502:	89 c8                	mov    %ecx,%eax
80100504:	f0 87 02             	lock xchg %eax,(%edx)
//  pushcli(); // disable interrupts to avoid deadlock.
//  if(holding(lk))
//    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80100507:	85 c0                	test   %eax,%eax
80100509:	75 f7                	jne    80100502 <acquire+0xb>
    ;

  __sync_synchronize();
8010050b:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
//  lk->cpu = mycpu();
//  getcallerpcs(&lk, lk->pcs);
}
80100510:	5d                   	pop    %ebp
80100511:	c3                   	ret    

80100512 <release>:

// Release the lock.
void release(struct spinlock *lk)
{
80100512:	55                   	push   %ebp
80100513:	89 e5                	mov    %esp,%ebp
80100515:	8b 45 08             	mov    0x8(%ebp),%eax
//  if(!holding(lk))
//    panic("release");

  lk->pcs[0] = 0;
80100518:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010051f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

  __sync_synchronize();
80100526:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010052b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

//  popcli();
}
80100531:	5d                   	pop    %ebp
80100532:	c3                   	ret    

80100533 <memset>:
#include "types.h"
#include "x86.h"

void* memset(void *dst, int c, uint n)
{
80100533:	55                   	push   %ebp
80100534:	89 e5                	mov    %esp,%ebp
80100536:	57                   	push   %edi
80100537:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
8010053a:	89 d7                	mov    %edx,%edi
8010053c:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010053f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100542:	fc                   	cld    
80100543:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
80100545:	89 d0                	mov    %edx,%eax
80100547:	5f                   	pop    %edi
80100548:	5d                   	pop    %ebp
80100549:	c3                   	ret    

8010054a <deallocuvm>:
  }
  return &pgtab[PTX(va)];
}

int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010054a:	55                   	push   %ebp
8010054b:	89 e5                	mov    %esp,%ebp
8010054d:	57                   	push   %edi
8010054e:	56                   	push   %esi
8010054f:	53                   	push   %ebx
80100550:	83 ec 0c             	sub    $0xc,%esp
80100553:	e8 f5 fa ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
80100558:	81 c3 ac 1a 00 00    	add    $0x1aac,%ebx
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010055e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100561:	39 45 10             	cmp    %eax,0x10(%ebp)
80100564:	0f 83 8a 00 00 00    	jae    801005f4 <deallocuvm+0xaa>
    return oldsz;

  a = PGROUNDUP(newsz);
8010056a:	8b 45 10             	mov    0x10(%ebp),%eax
8010056d:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80100573:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80100579:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010057c:	76 73                	jbe    801005f1 <deallocuvm+0xa7>
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010057e:	89 f2                	mov    %esi,%edx
80100580:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80100583:	8b 45 08             	mov    0x8(%ebp),%eax
80100586:	8b 04 90             	mov    (%eax,%edx,4),%eax
80100589:	a8 01                	test   $0x1,%al
8010058b:	74 1b                	je     801005a8 <deallocuvm+0x5e>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010058d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100592:	89 f1                	mov    %esi,%ecx
80100594:	c1 e9 0a             	shr    $0xa,%ecx
80100597:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
8010059d:	8d bc 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%edi
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
801005a4:	85 ff                	test   %edi,%edi
801005a6:	75 0b                	jne    801005b3 <deallocuvm+0x69>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801005a8:	c1 e2 16             	shl    $0x16,%edx
801005ab:	8d b2 00 f0 3f 00    	lea    0x3ff000(%edx),%esi
801005b1:	eb 33                	jmp    801005e6 <deallocuvm+0x9c>
    else if((*pte & PTE_P) != 0){
801005b3:	8b 07                	mov    (%edi),%eax
801005b5:	a8 01                	test   $0x1,%al
801005b7:	74 2d                	je     801005e6 <deallocuvm+0x9c>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801005b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801005be:	75 0f                	jne    801005cf <deallocuvm+0x85>
        panic("kfree");
801005c0:	83 ec 0c             	sub    $0xc,%esp
801005c3:	8d 83 5d e8 ff ff    	lea    -0x17a3(%ebx),%eax
801005c9:	50                   	push   %eax
801005ca:	e8 d1 fc ff ff       	call   801002a0 <panic>
      char *v = P2V(pa);
      kfree(v);
801005cf:	83 ec 0c             	sub    $0xc,%esp
801005d2:	05 00 00 00 80       	add    $0x80000000,%eax
801005d7:	50                   	push   %eax
801005d8:	e8 1b fd ff ff       	call   801002f8 <kfree>
      *pte = 0;
801005dd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801005e3:	83 c4 10             	add    $0x10,%esp

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801005e6:	81 c6 00 10 00 00    	add    $0x1000,%esi
801005ec:	39 75 0c             	cmp    %esi,0xc(%ebp)
801005ef:	77 8d                	ja     8010057e <deallocuvm+0x34>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801005f1:	8b 45 10             	mov    0x10(%ebp),%eax
}
801005f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    

801005fc <freevm>:

void freevm(pde_t *pgdir)
{
801005fc:	55                   	push   %ebp
801005fd:	89 e5                	mov    %esp,%ebp
801005ff:	57                   	push   %edi
80100600:	56                   	push   %esi
80100601:	53                   	push   %ebx
80100602:	83 ec 0c             	sub    $0xc,%esp
80100605:	e8 43 fa ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
8010060a:	81 c3 fa 19 00 00    	add    $0x19fa,%ebx
  uint i;

  if(pgdir == 0)
80100610:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100614:	75 0f                	jne    80100625 <freevm+0x29>
    panic("freevm: no pgdir");
80100616:	83 ec 0c             	sub    $0xc,%esp
80100619:	8d 83 88 e8 ff ff    	lea    -0x1778(%ebx),%eax
8010061f:	50                   	push   %eax
80100620:	e8 7b fc ff ff       	call   801002a0 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80100625:	83 ec 04             	sub    $0x4,%esp
80100628:	6a 00                	push   $0x0
8010062a:	68 00 00 00 80       	push   $0x80000000
8010062f:	ff 75 08             	pushl  0x8(%ebp)
80100632:	e8 13 ff ff ff       	call   8010054a <deallocuvm>
80100637:	8b 75 08             	mov    0x8(%ebp),%esi
8010063a:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80100640:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
80100643:	8b 06                	mov    (%esi),%eax
80100645:	a8 01                	test   $0x1,%al
80100647:	74 16                	je     8010065f <freevm+0x63>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80100649:	83 ec 0c             	sub    $0xc,%esp
8010064c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100651:	05 00 00 00 80       	add    $0x80000000,%eax
80100656:	50                   	push   %eax
80100657:	e8 9c fc ff ff       	call   801002f8 <kfree>
8010065c:	83 c4 10             	add    $0x10,%esp
8010065f:	83 c6 04             	add    $0x4,%esi
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80100662:	39 fe                	cmp    %edi,%esi
80100664:	75 dd                	jne    80100643 <freevm+0x47>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80100666:	83 ec 0c             	sub    $0xc,%esp
80100669:	ff 75 08             	pushl  0x8(%ebp)
8010066c:	e8 87 fc ff ff       	call   801002f8 <kfree>
}
80100671:	83 c4 10             	add    $0x10,%esp
80100674:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100677:	5b                   	pop    %ebx
80100678:	5e                   	pop    %esi
80100679:	5f                   	pop    %edi
8010067a:	5d                   	pop    %ebp
8010067b:	c3                   	ret    

8010067c <setupkvm>:
  return 0;
}

// Set up kernel part of a page table.
pde_t* setupkvm(void)
{
8010067c:	55                   	push   %ebp
8010067d:	89 e5                	mov    %esp,%ebp
8010067f:	57                   	push   %edi
80100680:	56                   	push   %esi
80100681:	53                   	push   %ebx
80100682:	83 ec 3c             	sub    $0x3c,%esp
80100685:	e8 c3 f9 ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
8010068a:	81 c3 7a 19 00 00    	add    $0x197a,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80100690:	e8 db fd ff ff       	call   80100470 <kalloc>
80100695:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100698:	85 c0                	test   %eax,%eax
8010069a:	0f 84 1e 01 00 00    	je     801007be <setupkvm+0x142>
    return 0;
  memset(pgdir, 0, PGSIZE);
801006a0:	83 ec 04             	sub    $0x4,%esp
801006a3:	68 00 10 00 00       	push   $0x1000
801006a8:	6a 00                	push   $0x0
801006aa:	50                   	push   %eax
801006ab:	e8 83 fe ff ff       	call   80100533 <memset>
801006b0:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801006b3:	8d 83 1c 00 00 00    	lea    0x1c(%ebx),%eax
801006b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
801006bc:	8d 83 5c 00 00 00    	lea    0x5c(%ebx),%eax
801006c2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801006c5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
801006c8:	8b 51 0c             	mov    0xc(%ecx),%edx
801006cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801006ce:	8b 71 04             	mov    0x4(%ecx),%esi
static int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801006d1:	8b 11                	mov    (%ecx),%edx
801006d3:	89 d0                	mov    %edx,%eax
801006d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801006da:	89 c7                	mov    %eax,%edi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801006dc:	8b 49 08             	mov    0x8(%ecx),%ecx
801006df:	8d 54 0a ff          	lea    -0x1(%edx,%ecx,1),%edx
801006e3:	29 f2                	sub    %esi,%edx
801006e5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801006eb:	89 55 d0             	mov    %edx,-0x30(%ebp)
801006ee:	29 c6                	sub    %eax,%esi
801006f0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801006f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006f6:	83 c8 01             	or     $0x1,%eax
801006f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
801006fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
801006ff:	01 f8                	add    %edi,%eax
80100701:	89 45 e0             	mov    %eax,-0x20(%ebp)
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80100704:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80100707:	89 f8                	mov    %edi,%eax
80100709:	c1 e8 16             	shr    $0x16,%eax
8010070c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
8010070f:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80100712:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(*pde & PTE_P){
80100715:	8b 30                	mov    (%eax),%esi
80100717:	f7 c6 01 00 00 00    	test   $0x1,%esi
8010071d:	74 0e                	je     8010072d <setupkvm+0xb1>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010071f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80100725:	81 c6 00 00 00 80    	add    $0x80000000,%esi
8010072b:	eb 2c                	jmp    80100759 <setupkvm+0xdd>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010072d:	e8 3e fd ff ff       	call   80100470 <kalloc>
80100732:	89 c6                	mov    %eax,%esi
80100734:	85 c0                	test   %eax,%eax
80100736:	74 5c                	je     80100794 <setupkvm+0x118>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80100738:	83 ec 04             	sub    $0x4,%esp
8010073b:	68 00 10 00 00       	push   $0x1000
80100740:	6a 00                	push   $0x0
80100742:	50                   	push   %eax
80100743:	e8 eb fd ff ff       	call   80100533 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80100748:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010074e:	83 c8 07             	or     $0x7,%eax
80100751:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80100754:	89 01                	mov    %eax,(%ecx)
80100756:	83 c4 10             	add    $0x10,%esp
  }
  return &pgtab[PTX(va)];
80100759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010075c:	c1 e8 0a             	shr    $0xa,%eax
8010075f:	25 fc 0f 00 00       	and    $0xffc,%eax
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80100764:	01 c6                	add    %eax,%esi
80100766:	74 2c                	je     80100794 <setupkvm+0x118>
      return -1;
    if(*pte & PTE_P)
80100768:	f6 06 01             	testb  $0x1,(%esi)
8010076b:	74 0f                	je     8010077c <setupkvm+0x100>
      panic("remap");
8010076d:	83 ec 0c             	sub    $0xc,%esp
80100770:	8d 83 99 e8 ff ff    	lea    -0x1767(%ebx),%eax
80100776:	50                   	push   %eax
80100777:	e8 24 fb ff ff       	call   801002a0 <panic>
    *pte = pa | perm | PTE_P;
8010077c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010077f:	0b 45 cc             	or     -0x34(%ebp),%eax
80100782:	89 06                	mov    %eax,(%esi)
    if(a == last)
80100784:	39 7d d0             	cmp    %edi,-0x30(%ebp)
80100787:	74 20                	je     801007a9 <setupkvm+0x12d>
      break;
    a += PGSIZE;
80100789:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010078f:	e9 68 ff ff ff       	jmp    801006fc <setupkvm+0x80>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80100794:	83 ec 0c             	sub    $0xc,%esp
80100797:	ff 75 d4             	pushl  -0x2c(%ebp)
8010079a:	e8 5d fe ff ff       	call   801005fc <freevm>
      return 0;
8010079f:	83 c4 10             	add    $0x10,%esp
801007a2:	b8 00 00 00 00       	mov    $0x0,%eax
801007a7:	eb 1a                	jmp    801007c3 <setupkvm+0x147>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801007a9:	83 45 c8 10          	addl   $0x10,-0x38(%ebp)
801007ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801007b0:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
801007b3:	0f 85 0c ff ff ff    	jne    801006c5 <setupkvm+0x49>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
801007b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801007bc:	eb 05                	jmp    801007c3 <setupkvm+0x147>
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801007be:	b8 00 00 00 00       	mov    $0x0,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
801007c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007c6:	5b                   	pop    %ebx
801007c7:	5e                   	pop    %esi
801007c8:	5f                   	pop    %edi
801007c9:	5d                   	pop    %ebp
801007ca:	c3                   	ret    

801007cb <switchkvm>:
  char *s = "kvmalloc init!\n";
  print_uart(s);
}

void switchkvm(void)
{
801007cb:	55                   	push   %ebp
801007cc:	89 e5                	mov    %esp,%ebp
801007ce:	e8 52 00 00 00       	call   80100825 <__x86.get_pc_thunk.ax>
801007d3:	05 31 18 00 00       	add    $0x1831,%eax
  lcr3(V2P(kpgdir));    // switch to the kernel page table
801007d8:	8d 05 9c 30 10 80    	lea    0x8010309c,%eax
}

static inline void
lcr3(uintp val) 
{
  asm volatile("mov %0,%%cr3" : : "r" (val));
801007de:	8b 00                	mov    (%eax),%eax
801007e0:	05 00 00 00 80       	add    $0x80000000,%eax
801007e5:	0f 22 d8             	mov    %eax,%cr3
}
801007e8:	5d                   	pop    %ebp
801007e9:	c3                   	ret    

801007ea <kvmalloc>:
    }
  return pgdir;
}

void kvmalloc(void)
{
801007ea:	55                   	push   %ebp
801007eb:	89 e5                	mov    %esp,%ebp
801007ed:	53                   	push   %ebx
801007ee:	83 ec 04             	sub    $0x4,%esp
801007f1:	e8 57 f8 ff ff       	call   8010004d <__x86.get_pc_thunk.bx>
801007f6:	81 c3 0e 18 00 00    	add    $0x180e,%ebx
  kpgdir = setupkvm();
801007fc:	e8 7b fe ff ff       	call   8010067c <setupkvm>
80100801:	8d 15 9c 30 10 80    	lea    0x8010309c,%edx
80100807:	89 02                	mov    %eax,(%edx)
  switchkvm();
80100809:	e8 bd ff ff ff       	call   801007cb <switchkvm>
  char *s = "kvmalloc init!\n";
  print_uart(s);
8010080e:	83 ec 0c             	sub    $0xc,%esp
80100811:	8d 83 9f e8 ff ff    	lea    -0x1761(%ebx),%eax
80100817:	50                   	push   %eax
80100818:	e8 36 f9 ff ff       	call   80100153 <print_uart>
}
8010081d:	83 c4 10             	add    $0x10,%esp
80100820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100823:	c9                   	leave  
80100824:	c3                   	ret    

80100825 <__x86.get_pc_thunk.ax>:
80100825:	8b 04 24             	mov    (%esp),%eax
80100828:	c3                   	ret    
