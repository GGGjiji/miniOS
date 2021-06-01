#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "syscall.h"

// User code makes a system call with INT T_SYSCALL.
// System call number in %eax.
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
  *ip = *(int*)(addr);
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();
  print_uart("from!\n");
  print_uart("sz : %d\n",curproc->sz);
  print_uart("addr : %d\n",addr);
  if(addr >= curproc->sz)
    return -1;
  print_uart("after!\n");
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  print_uart("argstr addr : %d\n",addr);
  return fetchstr(addr, pp);
}

extern int sys_exec(void);
extern  int sys_fork(void);

static int (*syscalls[])(void) = {
  [SYS_fork]    sys_fork,
  [SYS_exec]    sys_exec,
};

void syscall(void)
{
  int num;
  struct proc *curproc = myproc();

  num = curproc->tf->eax;
//  print_uart("%d\n",NELEM(syscalls));
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
//  print_uart("unknows sys call : %d\n",num);
//    cprintf("%d %s: unknown sys call %d\n",
//            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
//    print_uart("%s\n",curproc->name);
  }
}
