# See LICENSE for license details.

#*****************************************************************************
# i2c.S
#-----------------------------------------------------------------------------
#
# Test soc
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

    # Set GPIO IOF0 12,13
  li a1, 0x3<<12 
  li t0, 0x10012038
  sw a1, 0(t0)


  # Access the I2C registers

    # Write Prescale as 00
  li a1, 0x1 
  li t0, 0x10042000
  sb a1, 0(t0)

  li a1, 0x0 
  li t0, 0x10042001
  sb a1, 0(t0)

    # Write 0x80 to CTR to enable core
  li t0, 0x10042002
  li a1, 0x80 
  sb a1, 0(t0)

     #1 Set the Transmit Register TXR with a value of Slave address + Write bit.
  li t0, 0x10042003
  li a1, 0xfe 
  sb a1, 0(t0)

     #2 Set the Command Register CR to 8’h90 to enable the START and WRITE.
     #This starts the transmission on the I2C bus.
  li t0, 0x10042004
  li a1, 0x90 
  sb a1, 0(t0)

#loop:
#  li t0, 0xFF
#  li t1, -1
#  add t0,t0,t1
#  bnez t0, loop 

  li TESTNUM, 1
2:
  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

data1: .word 0
data2: .word 0

RVTEST_DATA_END
