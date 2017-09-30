int main(void);

void handle_trap(unsigned int mcause, unsigned int mepc, unsigned int sp)
{
    while (1)
        ;
}

void _exit(int status)
{
    // Make sure gcc doesn't inline _exit, so we can actually set a breakpoint
    // on it.
    volatile int i = 42;
    while (i)
        ;
    // _exit isn't supposed to return.
    while (1)
        ;
}

void _init()
{
    _exit(main());
}
