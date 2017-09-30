*************************************************************************
Benchmarks for RISCV Processor
-------------------------------------------------------------------------

The benchmarks make use of the RISCV C compiler toolchain. You will need
to include a bmark.mk makefile fragment in each benchmark directory. The
fragment should include the object files and a rule to actually link
these object files into an executable. There are a couple important
points to make about the toolchain.

 + The toolchain sets the stack pointer to memory address 0x20000 so your
   main memory _must_ be larger than 0x20000 bytes or else the stack will
   get wrapped around and overwrite program data.

 + The stack grows down from 0x20000 and your program is loaded at 0x1000.
   If you have a very large program and have lots of very big arrays
   declared on the stack your stack could overwrite your program. Be aware.

 + You cannot use standard clib functions (like memcopy or strcat). You
   cannot use system calls and thus cannot use printf.

 + You cannot access the simulated command line - ie you cannot use argc
   and argv within main.

 + You may have to increase the timeout check in your test harness to
   allow longer programs to run (you can do this from the command line
   option +max-cycles with the standard test harness)

 + The compiler loads the program at 0x1000. It does not insert exception
   setup code. So if you are careful with what C you use it will only
   generate code in the riscv lab1 subset. If you use multiplies, shorts,
   and chars it could generate mul, lh, and lb instructions. Be aware.

 + You can write assembly in C - you need to do this to write tohost to 1
   to indicate when the benchmark is done. Look at the example
   benchmarks to see how this is done. You can find more information
   about how to write assembly in C here:
   http://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html

 + Debugging C compiled code on the RISCV processor is a real pain. It is
   hard to associate the assembly with the C code and there is no
   debugger. So if you encounter a bug in your processor when running a C
   benchmark you can try to debug it, but you might have better luck
   adding more assembly tests to your test suite.

 + To avoid having the compiler try and use a global pointer (ie using
   register 28 to point to a space where small global variables are
   stored) you need to use the -G 0 command line option.
