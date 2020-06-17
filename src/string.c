#include "types.h"
#include "x86.h"

void* memset(void *dst, int c, uint n)
{
  stosb(dst, c, n);
  return dst;
}

int memcmp(const void *v1, const void *v2, uint n)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n--){
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }
  return 0;
}
