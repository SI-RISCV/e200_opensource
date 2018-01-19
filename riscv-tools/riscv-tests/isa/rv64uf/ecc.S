# See LICENSE for license details.

#*****************************************************************************
# ecc.S
#-----------------------------------------------------------------------------
#
# Test breakpoints, if they are implemented.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN


  .pushsection .data; \
  .align 2; \
  test_ecc_data: \
  .word 0; \
  .word 0; \
  .popsection \
  la t5, test_ecc_data 
  la t6, test_ecc_data 
  la a0, test_ecc_data 

####################################################################
#
# Test the ITCM behavior if the itcm_nohold is set
#

  li t0, 0xFFFFFFFF
    # Set the ITCMNOHOLD CSR to 1
  csrw 0xbfd, t0 

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  bne a1, t1, end
  jalr t0, t1, 0
2:
  li t0, 0x0
    # Set the ITCMNOHOLD CSR to 0
  csrw 0xbfd, t0 
#
# 
#
####################################################################


####################################################################
#
# Test the fence.I
#
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence.I
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence.I
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence.I
  bne a1, t1, end
  jalr t0, t1, 0
2:
#
# 
#
####################################################################


####################################################################
#
# Test the ECC disabled behavior
  li t0, 0x0
    # Set the ECC-CTRL CSR to 0
  csrw 0xbfc, t0 
#
  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence.I
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence.I
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence
  bne a1, t1, end
  jalr t0, t1, 0
2:

  la a1, 2f 
  sw a1, 0(a0)
  lw t1, 0(a0)
  fence.I
  bne a1, t1, end
  jalr t0, t1, 0
2:
#
# 
#
####################################################################


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
