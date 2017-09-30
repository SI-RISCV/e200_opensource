#ifndef ENTRY_S
#define ENTRY_S

#include "encoding.h"

#define STACK_SIZE 512

#if XLEN == 64
# define LREG ld
# define SREG sd
# define REGBYTES 8
#else
# define LREG lw
# define SREG sw
# define REGBYTES 4
#endif

  .section      .text.entry
  .globl _start
_start:
  j handle_reset

nmi_vector:
  j nmi_vector

trap_vector:
  j trap_entry

handle_reset:
  // If misa doesn't exist (or is following an old spec where it has a
  // different number), skip the next block.
  la t0, 3f
  csrw mtvec, t0
  csrwi mstatus, 0

  // make sure these registers exist by seeing if either S or U bits
  // are set before attempting to zero them out.
  csrr   t1, misa
  addi   t2, x0, 1 	
  slli   t2, t2, 20 // U_EXTENSION
  and    t2, t1, t2
  bne    x0, t2, 1f
  addi   t2, x0, 1
  slli   t2, t2, 18 // S_EXTENSION	
  and    t2, t1, t2
  bne    x0, t2, 1f
  j 2f
1:
  csrwi mideleg, 0
  csrwi medeleg, 0
2:
  csrwi mie, 0
3:
  la t0, trap_entry
  csrw mtvec, t0
  csrwi mstatus, 0

  # initialize global pointer
.option push
.option norelax
  la gp, __global_pointer$
.option pop

  # initialize stack pointer
  la sp, stack_top

  # Clear all hardware triggers
  li    t0, ~0
1:
  addi  t0, t0, 1
  csrw  CSR_TSELECT, t0
  csrw  CSR_TDATA1, zero
  csrr  t1, CSR_TSELECT
  beq   t0, t1, 1b

  # perform the rest of initialization in C
  j _init


trap_entry:
  addi sp, sp, -32*REGBYTES

  SREG x1, 1*REGBYTES(sp)
  SREG x2, 2*REGBYTES(sp)
  SREG x3, 3*REGBYTES(sp)
  SREG x4, 4*REGBYTES(sp)
  SREG x5, 5*REGBYTES(sp)
  SREG x6, 6*REGBYTES(sp)
  SREG x7, 7*REGBYTES(sp)
  SREG x8, 8*REGBYTES(sp)
  SREG x9, 9*REGBYTES(sp)
  SREG x10, 10*REGBYTES(sp)
  SREG x11, 11*REGBYTES(sp)
  SREG x12, 12*REGBYTES(sp)
  SREG x13, 13*REGBYTES(sp)
  SREG x14, 14*REGBYTES(sp)
  SREG x15, 15*REGBYTES(sp)
  SREG x16, 16*REGBYTES(sp)
  SREG x17, 17*REGBYTES(sp)
  SREG x18, 18*REGBYTES(sp)
  SREG x19, 19*REGBYTES(sp)
  SREG x20, 20*REGBYTES(sp)
  SREG x21, 21*REGBYTES(sp)
  SREG x22, 22*REGBYTES(sp)
  SREG x23, 23*REGBYTES(sp)
  SREG x24, 24*REGBYTES(sp)
  SREG x25, 25*REGBYTES(sp)
  SREG x26, 26*REGBYTES(sp)
  SREG x27, 27*REGBYTES(sp)
  SREG x28, 28*REGBYTES(sp)
  SREG x29, 29*REGBYTES(sp)
  SREG x30, 30*REGBYTES(sp)
  SREG x31, 31*REGBYTES(sp)

  csrr a0, mcause
  csrr a1, mepc
  mv a2, sp
  jal handle_trap
  csrw mepc, a0

  # Remain in M-mode after mret
  li t0, MSTATUS_MPP
  csrs mstatus, t0

  LREG x1, 1*REGBYTES(sp)
  LREG x2, 2*REGBYTES(sp)
  LREG x3, 3*REGBYTES(sp)
  LREG x4, 4*REGBYTES(sp)
  LREG x5, 5*REGBYTES(sp)
  LREG x6, 6*REGBYTES(sp)
  LREG x7, 7*REGBYTES(sp)
  LREG x8, 8*REGBYTES(sp)
  LREG x9, 9*REGBYTES(sp)
  LREG x10, 10*REGBYTES(sp)
  LREG x11, 11*REGBYTES(sp)
  LREG x12, 12*REGBYTES(sp)
  LREG x13, 13*REGBYTES(sp)
  LREG x14, 14*REGBYTES(sp)
  LREG x15, 15*REGBYTES(sp)
  LREG x16, 16*REGBYTES(sp)
  LREG x17, 17*REGBYTES(sp)
  LREG x18, 18*REGBYTES(sp)
  LREG x19, 19*REGBYTES(sp)
  LREG x20, 20*REGBYTES(sp)
  LREG x21, 21*REGBYTES(sp)
  LREG x22, 22*REGBYTES(sp)
  LREG x23, 23*REGBYTES(sp)
  LREG x24, 24*REGBYTES(sp)
  LREG x25, 25*REGBYTES(sp)
  LREG x26, 26*REGBYTES(sp)
  LREG x27, 27*REGBYTES(sp)
  LREG x28, 28*REGBYTES(sp)
  LREG x29, 29*REGBYTES(sp)
  LREG x30, 30*REGBYTES(sp)
  LREG x31, 31*REGBYTES(sp)

  addi sp, sp, 32*REGBYTES
  mret

  // Fill the stack with data so we can see if it was overrun.
  .align 4
stack_bottom:
  .fill STACK_SIZE/4, 4, 0x22446688
stack_top:
#endif
