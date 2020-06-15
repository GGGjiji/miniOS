#include "types.h"
#define COM1	0x3f8
static int uart;  
static inline void outb(u8 val, u16 port)
{
    asm volatile ("outb %0, %1"::"a" (val), "dN" (port));
}

static inline u8 inb(u16 port)
{
    u8 r;
    asm volatile ("inb %1, %0":"=a" (r):"dN" (port));
    return r;
}

void uart_early_init(void)
{
    // Turn off the FIFO
    outb(0, COM1 + 2);

    // 9600 baud, 8 data bits, 1 stop bit, parity off.
    outb(0x80, COM1 + 3);       // Unlock divisor
    outb(115200 / 9600, COM1 + 0);
    outb(0, COM1 + 1);
    outb(0x03, COM1 + 3);       // Lock divisor, 8 data bits.
    outb(0, COM1 + 4);
    outb(0x01, COM1 + 1);       // Enable receive interrupts.

    // If status is 0xFF, no serial port.
    if (inb(COM1 + 5) == 0xFF)
        return;
    uart = 1;
}

void uart_putc(int c)
{
    outb(c, COM1 + 0);
}

void uart_putint(int xx, int base, int sgn)
{
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';
  while(--i >= 0)
    uart_putc(buf[i]);
}

int print_uart(const char *fmt, ...)
{
    	uart_early_init();
	int state,i,c;
	state = 0;
	uint *ap;
	ap = (uint*)(void*)&fmt + 1;
	for(i = 0; fmt[i];i ++)
	{
		c = fmt[i] & 0xff;
		if(state == 0){
			if(c == '%'){
				state = '%';		
			}else{
				uart_putc(c);
			}
		} else if(state == '%'){
			if(c == 'd'){
				uart_putint(*ap,10,1);
				ap++;
			}
			else if(c == 'x'){
				uart_putint(*ap,16,1);
				ap++;
			}
			else if(c == 's'){
				char *s = (char*)*ap;
				ap++;
				if(s == 0)
				  s = "(null)";
				while(*s != 0){
				  uart_putc(*s);
				  s++;
				}
			}
			else {
				uart_putc('%');
				uart_putc(c);
			}
			state = 0;
		}
	}
    return 0;
}

void panic(char *s)
{
	print_uart(s);
}
