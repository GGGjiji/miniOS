void initlock(struct spinlock *lk, char *name)
{
	lk->name = name;
	lk->locked = 0;
	lk->cpu = 0;
}

void freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
    kfree(p);
}

void	kinit1(void*, void*)
{
	initlock(&kmem.lock, "kmem");
	kmem.use_lock = 0;
	freerange(vstart, vend);
}
