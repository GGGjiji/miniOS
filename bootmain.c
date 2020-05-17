
/*
void bootmain(void)
{
  short *p = (short *)0xb8000;
  int i;
  for (i=0;i<12;i++) {
    *p++=72|0x700;
  }
}
*/

void bootmain(void)
{
	short *p = (short *)0xb8000;
	*p++ = 72|0x700; 	//	h
	*p++ = 101|0x700;	//	e
	*p++ = 108|0x700;	//	l
	*p++ = 108|0x700;	//	l
	*p++ = 111|0x700;	//	o
	*p++ = 87|0x700;	//	w
	*p++ = 111|0x700;	//	o
	*p++ = 114|0x700;	//	r
	*p++ = 108|0x700;	//	l
	*p++ = 100|0x700;	//	d
}
