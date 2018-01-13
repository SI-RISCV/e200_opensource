# See LICENSE for license details.

#*****************************************************************************
# bpu_wait.S
#-----------------------------------------------------------------------------
#
# Test bpu, if they are implemented.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

# Here we just repeatedly execute different branch instructions to test its dependency to 
# upfronting LDST or AMO or MUL/DIV or FPU instructions to check if
# there is possible to have deadlock 
#   we have a force interrupt and bus-error randomly, which will push the core
#   into the exceptions again and again


  # Test the JALR depend to the LD instructions
  .pushsection .data; \
  .align 2; \
  test_bpu_wait_data: \
  .word 0; \
  .word 0; \
  .popsection \
  la t5, test_bpu_wait_data 
  la t6, test_bpu_wait_data 
  la a0, test_bpu_wait_data 

     # Make sure to have t1 value equal to 2f, to make sure it is not jumping to away
  la a1, 2f 
  sw a1, 0(a0)
  wfi
  lw t1, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  wfi
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  jalr t0, t1, 0
  wfi

2:
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  jalr t0, t1, 0

  wfi
2:
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  wfi
  lw t1, 0(a0)
  jalr t0, t1, 0

  wfi
2:
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  wfi
  lw t1, 0(a0)
  jalr t0, t1, 0

2:

  # Test the JALR depend to the AMO instructions
     # Is A extension present?
  csrr a2, misa
  andi a2, a2, (1 << ('A' - 'A'))
  beqz a2, 1f

     # Make sure to have t1 value equal to 2f, to make sure it is not jumping to away
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

  wfi
2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  wfi
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  wfi
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  jalr t0, t1, 0

2:
  la a1, 2f 
  wfi
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  wfi
  jalr t0, t1, 0

2:
  wfi
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  wfi
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  wfi
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  wfi
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  wfi
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  wfi
  la a1, 2f 
  sw a1, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  wfi
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  wfi
  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0

2:
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
  wfi
  amoadd.w	t1, t0, 0(a0)
1:
  # Test the JALR depend to the MUL/DIV instructions
2:
    # Make sure to have t1 equal to the 2f
  la t1, 2f 
  li t0, 0x1 
  wfi
  mul t1, t1, t0
  jalr t0, t1, 0
2:
  la t1, 2f 
  li t0, 0x1 
  div t1, t1, t0
  jalr t0, t1, 0
2:
  wfi
  la t1, 2f 
  li t0, 0x1 
  mul t1, t1, t0
  jalr t0, t1, 0
2:
  la t1, 2f 
  li t0, 0x1 
  wfi
  div t1, t1, t0
  jalr t0, t1, 0
2:
  la t1, 2f 
  li t0, 0x1 
  mul t1, t1, t0
  jalr t0, t1, 0
2:
  la t1, 2f 
  li t0, 0x1 
  div t1, t1, t0
  jalr t0, t1, 0
2:
  la t1, 2f 
  wfi
  li t0, 0x1 
  mul t1, t1, t0
  jalr t0, t1, 0
2:
  wfi
  la t1, 2f 
  li t0, 0x1 
  div t1, t1, t0
  jalr t0, t1, 0
2:


  li TESTNUM, 1
  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

data1: .word 0
data2: .word 0

RVTEST_DATA_END
