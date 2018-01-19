# See LICENSE for license details.

#*****************************************************************************
# bus.S
#-----------------------------------------------------------------------------
#
# Test breakpoints, if they are implemented.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN



####################################################################
#
# Test the 0x4000_0000 address which is the subsys_mem AXI example slave
#

  li a0, 0x40000000
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
2:

####################################################################
#
# Test the which is the subsys_periperl AXI/APB/Wishbone example slave
#  * Example-AXI      : 0x1004 0000 -- 0x1004 0FFF
#  * Example-APB      : 0x1004 1000 -- 0x1004 1FFF
#  * Example-WishBone : 0x1004 2000 -- 0x1004 2FFF
#

  li a0, 0x10040000
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
2:
  li a0, 0x10041000
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
2:
  li a0, 0x10042000
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
2:


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
