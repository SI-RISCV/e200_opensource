# See LICENSE for license details.

#*****************************************************************************
# structural.S
#-----------------------------------------------------------------------------
#
# This test verifies that the FPU correctly obviates structural hazards on its
# writeback port (e.g. fadd followed by fsgnj)
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN
la a1, test_data_22;
li x25, 1 ;
lw x2 , 8(a1);
lw x1 , 16(a1);


# li x2, 0x3FF0000000000000
# li x1, 0x3F800000
#
##define TEST(nops, errcode)     \
#  fmv.d.x  f4, x0    ;\
#  fmv.s.x  f3, x0    ;\
#  fmv.d.x  f2, x2    ;\
#  fmv.s.x  f1, x1    ;\
#  j 1f ;\
#  .align 5        ;\
#1:fmul.d  f4, f2, f2  ;\
#  nops          ;\
#  fsgnj.s f3, f1, f1 ;\
#  fmv.x.d  x4, f4    ;\
#  fmv.x.s  x5, f3    ;\
#  beq     x1, x5, 2f  ;\
#  RVTEST_FAIL ;\
#2:beq     x2, x4, 2f  ;\
#  RVTEST_FAIL; \
#2:fmv.d.x  f2, zero    ;\
#  fmv.s.x  f1, zero    ;\

#define TEST(nops, errcode)     \
  fld      f4, 0(a1) ;\
  flw      f3, 0(a1) ;\
  fld      f2, 8(a1) ;\
  flw      f1, 16(a1);\
  j 1f ;\
  .align 5        ;\
1:fmul.d  f4, f2, f2  ;\
  nops          ;\
  fsgnj.s f3, f1, f1 ;\
  fsd     f4, 24(a1) ;\
  lw      a4, 24(a1) ;\
  lw      a5, 28(a1) ;\
  fmv.x.s  x5, f3    ;\
  beq     x1, x5, 2f  ;\
  RVTEST_FAIL ;\
2:lw      a6, 8(a1)  ;\   
  lw      a7, 12(a1) ;\
  beq     a4, a6, 2f ;\  
  RVTEST_FAIL ;\
2:beq     a5, a7, 2f ;\
  RVTEST_FAIL ;\
2:fld      f2, 0(a1) ;\
  fmv.s.x  f1, zero  ;\



TEST(;,2)
TEST(nop,4)
TEST(nop;nop,6)
TEST(nop;nop;nop,8)
TEST(nop;nop;nop;nop,10)
TEST(nop;nop;nop;nop;nop,12)
TEST(nop;nop;nop;nop;nop;nop,14)

RVTEST_PASS

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA
test_data_22:
.dword 0x0000000000000000//x0 0(a1)
.dword 0x3FF0000000000000//x2 8(a1)
.word  0x3F800000        //x1 16(a1)
.word  0x00000000        //   
.dword 0x0000000000000000//   24(a1)
RVTEST_DATA_END
