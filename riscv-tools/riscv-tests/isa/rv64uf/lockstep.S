# See LICENSE for license details.

#*****************************************************************************
# breakpoint.S
#-----------------------------------------------------------------------------
#
# Test breakpoints, if they are implemented.
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


  li t0, 0xEFEFEFEF
  csrw mscratch, t0;

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

# HOHOHO
  li t0, 0xFFFFFFFF
    # Set the counterstop, cgstop, ITCMNOHOLD CSR to 1
  csrw 0xbff, t0 
  csrw 0xbfe, t0 
  csrw 0xbfd, t0 

##### The Lockstep regs are as below: 
# wire sel_lstepctrl  = (csr_idx == 12'hBE0);// This address is not used by ISA
# wire sel_lstepforc  = (csr_idx == 12'hBE1);// This address is not used by ISA
# wire sel_lstepfdly  = (csr_idx == 12'hBE2);// This address is not used by ISA
# wire sel_lstepecnt  = (csr_idx == 12'hBE3);// This address is not used by ISA
# assign csr_lstep_en        = csr_lstepctrl[0];
# assign csr_lstep_chck_en   = csr_lstepctrl[1];
# assign csr_lstep_rst_en    = csr_lstepctrl[2];

# HOHOHO
# we enable all of them enable
  li t0, 0xFFFFFFFF
  csrw 0xbe0, t0 



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
  wfi
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

2:
  la a1, 2f 
  sw a1, 0(a0)
  wfi
  lw t1, 0(a0)
  wfi
  jalr t0, t1, 0

2:
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  jalr t0, t1, 0


2:
# HOHOHO
# we disable the Lockstep total enable 
  // Only disabled it when current ecnt is 0
  csrr t0, 0xbe3
  li t1, 0
  bne t0, t1, 1f
  li t0, 0xFFFFFFFE
  csrw 0xbe0, t0 
1:




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
# HOHOHO
# we enable the Lockstep total enable 
# we set the halt time out to 0 to avoid the x pollution
  li t0, 0x0
  csrw 0xbe4, t0 
  li t0, 0xFFFFFFFF
  csrw 0xbe0, t0 


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
# HOHOHO
# we disable the Lockstep check enable 
  li t0, 0xFFFFFFFD
  csrw 0xbe0, t0 



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
# HOHOHO
# we enable the Lockstep check enable 
  li t0, 0xFFFFFFFF
  csrw 0xbe0, t0 


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
# HOHOHO
  li t0, 0x0
    # Set the counterstop, cgstop, ITCMNOHOLD CSR to 0
  csrw 0xbff, t0 
  csrw 0xbfe, t0 
  csrw 0xbfd, t0 

  la a1, 2f 
  sw a1, 0(a0)
  amoadd.w	t1, t0, 0(a0)
  jalr t0, t1, 0
2:
# HOHOHO
# we disable the Lockstep reset
  li t0, 0xFFFFFFFB
  csrw 0xbe0, t0 


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
# HOHOHO
# we enable the Lockstep reset
  li t0, 0xFFFFFFFF
  csrw 0xbe0, t0 


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
# HOHOHO
# we set the delay to 0x88
  li t0, 0x88
  csrw 0xbe2, t0 
# we set the halt time out to 0
  li t0, 0x0
  csrw 0xbe4, t0 
# we then force the error 
  csrr t0, 0xbe3
  // Only force it when current ecnt is 1
  li t1, 1
  bne t0, t1, 1f
  li t0, 0xfece
  csrw 0xbe1, t0 
1:
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
# HOHOHO
# we set the delay to 0x0
  li t0, 0x0
  csrw 0xbe2, t0 
# we set the halt time out to 88
  li t0, 0x88
  csrw 0xbe4, t0 
# we then force the error 
  csrr t0, 0xbe3
  // Only force it when current ecnt is 2
  li t1, 2
  bne t0, t1, 1f
  li t0, 0xfece
  csrw 0xbe1, t0 
1:
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

# HOHOHO
# Check the error-cnt
# Only pass if it is 3
  csrr t0, 0xbe3
  li t1, 0x3
  bne t0, t1, 1f
  li TESTNUM, 1
1:
  li t1, 0x0
  csrw 0xbe3, t1
  csrr t0, 0xbe3
  li t1, 0x0
  beq t0, t1, 1f
  li TESTNUM, 0
1:
  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

data1: .word 0
data2: .word 0

RVTEST_DATA_END
