#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "print_uart.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
uint ticks;

void tvinit(void)
{
  int i;
  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  
}

void idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void trap(struct trapframe *tf)
{
  switch(tf->trapno){
    case 32:
      //  timer();
//      print_uart("%d!",tf->trapno);
//      print_uart("TT!");
      break;
    case 33:
      kbdintr();
//      print_uart("1!\n");
      inb(0x60);
      break;
    default:{
      print_uart("%d",tf->trapno);
      print_uart("KK!");
      inb(0x60);
    }
  }
}
