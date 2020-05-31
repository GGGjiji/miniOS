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

int print_uart(void)
{
    uart_early_init();
//  "hello,world!"
    uart_putc(72);
    uart_putc(101);
    uart_putc(108);
    uart_putc(108);
    uart_putc(111);
    uart_putc(44);
    uart_putc(87);
    uart_putc(111);
    uart_putc(114);
    uart_putc(108);
    uart_putc(100);
    uart_putc(33);
    return 0;
}
