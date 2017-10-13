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

# Here we just repeatedly execute WFI to enter into sleep mode, and in our tb
#   we have a force interrupt randomly, which will wake the core up again and again
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
  wfi
# Here to disable the MIE again
  csrwi mstatus, 0;
   # Clear the macuse
  csrwi mcause, 0;
  wfi
        csrr t5, mcause
        bnez t5, end 
  wfi
        csrr t5, mcause
        bnez t5, end 
  wfi
        csrr t5, mcause
        bnez t5, end 
  wfi
        csrr t5, mcause
        bnez t5, end 
  wfi
        csrr t5, mcause
        bnez t5, end 
  wfi
        csrr t5, mcause
        bnez t5, end 
  wfi
        csrr t5, mcause
        bnez t5, end 
  wfi
        csrr t5, mcause
        bnez t5, end 
  wfi
        csrr t5, mcause
        bnez t5, end 
  wfi
        csrr t5, mcause
        bnez t5, end 
  li TESTNUM, 1
end:
  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

data1: .word 0
data2: .word 0

RVTEST_DATA_END
