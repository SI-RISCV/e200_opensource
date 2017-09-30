# See LICENSE for license details.

#*****************************************************************************
# ldst.S
#-----------------------------------------------------------------------------
#
# This test verifies that flw, fld, fsw, and fsd work properly.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  la s0, tdat
 # TEST_CASE_ldst(2, a0, 0x40000000bf800000, fld f2, 0(s0); fsd f2, 16(s0); ld a0, 16(s0))
 # TEST_CASE_ldst(3, a0, 0x40000000bf800000, fld f2, 0(s0); fsw f2, 16(s0); ld a0, 16(s0))
 # TEST_CASE_ldst(4, a0, 0x40000000bf800000, flw f2, 0(s0); fsw f2, 16(s0); ld a0, 16(s0))
 # TEST_CASE_ldst(5, a0, 0xc080000040400000, fld f2, 8(s0); fsd f2, 16(s0); ld a0, 16(s0))
 # TEST_CASE_ldst(6, a0, 0xffffffff40400000, flw f2, 8(s0); fsd f2, 16(s0); ld a0, 16(s0))


  TEST_CASE_ldst(2, a0, 0x40000000,0xbf800000, fld f2, 0(s0); fsd f2, 16(s0); lw a3, 16(s0); lw a4, 20(s0))
  TEST_CASE_ldst(3, a0, 0x40000000,0xbf800000, fld f2, 0(s0); fsw f2, 16(s0); lw a3, 16(s0); lw a4, 20(s0))
  TEST_CASE_ldst(4, a0, 0x40000000,0xbf800000, flw f2, 0(s0); fsw f2, 16(s0); lw a3, 16(s0); lw a4, 20(s0))
  TEST_CASE_ldst(5, a0, 0xc0800000,0x40400000, fld f2, 8(s0); fsd f2, 16(s0); lw a3, 16(s0); lw a4, 20(s0))
  TEST_CASE_ldst(6, a0, 0xffffffff,0x40400000, flw f2, 8(s0); fsd f2, 16(s0); lw a3, 16(s0); lw a4, 20(s0))

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

tdat:
.word 0xbf800000//0
.word 0x40000000//4
.word 0x40400000//8
.word 0xc0800000//12
.word 0xdeadbeef//////////16
.word 0xcafebabe
.word 0xabad1dea
.word 0x1337d00d

RVTEST_DATA_END
