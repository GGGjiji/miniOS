#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "user.h"
#include "print_uart.h"

extern pde_t *kpgdir;
extern char end[]; // first address after kernel loaded from ELF file

int main(void)
{
  char *s = "by GGGjiji!\n";
  int out = print_uart("hello,world\n%s",s);
  (void)out;
  kinit1(end,P2V(4*1024*1024));
  kvmalloc();
  mpinit();
  lapicinit();
  for(;;);
}

pde_t entrypgdir[];  // For entry.S

// The boot page table used in entry.S and entryother.S.
// Page directories (and page tables) must start on page boundaries,
// hence the __aligned__ attribute.
// PTE_PS in a page directory entry enables 4Mbyte pages.

__attribute__((__aligned__(PGSIZE)))
pde_t entrypgdir[NPDENTRIES] = {
  // Map VA's [0, 4MB) to PA's [0, 4MB)
  [0] = (0) | PTE_P | PTE_W | PTE_PS,
  // Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB)
  [KERNBASE>>PDXSHIFT] = (0) | PTE_P | PTE_W | PTE_PS,
};
