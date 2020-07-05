// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "print_uart.h"
#include "kbd.h"

void consoleintr(int (*getc)(void))
{

}

int consoleread(struct inode *ip, char *dst, int n)
{
  return 0;	
}

int consolewrite(struct inode *ip, char *buf, int n)
{
  return 0;	
}

void consoleinit(void)
{
  print_uart("console init!\n");
//  while(uart_read() != -1)
  while(1)
  {
	kbdgetc();
  }
}

