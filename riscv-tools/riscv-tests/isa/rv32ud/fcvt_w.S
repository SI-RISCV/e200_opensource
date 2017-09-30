# See LICENSE for license details.

#*****************************************************************************
# fcvt_w.S
#-----------------------------------------------------------------------------
#
# Test fcvt{wu|w|lu|l}.d instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_INT_OP_D_fcvt_w( 2,  fcvt.w.d, 0x01,         -1, -1.1, rtz);
  TEST_FP_INT_OP_D_fcvt_w( 3,  fcvt.w.d, 0x00,         -1, -1.0, rtz);
  TEST_FP_INT_OP_D_fcvt_w( 4,  fcvt.w.d, 0x01,          0, -0.9, rtz);
  TEST_FP_INT_OP_D_fcvt_w( 5,  fcvt.w.d, 0x01,          0,  0.9, rtz);
  TEST_FP_INT_OP_D_fcvt_w( 6,  fcvt.w.d, 0x00,          1,  1.0, rtz);
  TEST_FP_INT_OP_D_fcvt_w( 7,  fcvt.w.d, 0x01,          1,  1.1, rtz);
  TEST_FP_INT_OP_D_fcvt_w( 8,  fcvt.w.d, 0x10,     -1<<31, -3e9, rtz);
  TEST_FP_INT_OP_D_fcvt_w( 9,  fcvt.w.d, 0x10,  (1<<31)-1,  3e9, rtz);

  TEST_FP_INT_OP_D_fcvt_w(12, fcvt.wu.d, 0x10,          0, -3.0, rtz);
  TEST_FP_INT_OP_D_fcvt_w(13, fcvt.wu.d, 0x10,          0, -1.0, rtz);
  TEST_FP_INT_OP_D_fcvt_w(14, fcvt.wu.d, 0x01,          0, -0.9, rtz);
  TEST_FP_INT_OP_D_fcvt_w(15, fcvt.wu.d, 0x01,          0,  0.9, rtz);
  TEST_FP_INT_OP_D_fcvt_w(16, fcvt.wu.d, 0x00,          1,  1.0, rtz);
  TEST_FP_INT_OP_D_fcvt_w(17, fcvt.wu.d, 0x01,          1,  1.1, rtz);
  TEST_FP_INT_OP_D_fcvt_w(18, fcvt.wu.d, 0x10,          0, -3e9, rtz);
  TEST_FP_INT_OP_D_fcvt_w(19, fcvt.wu.d, 0x00, 0xffffffffb2d05e00, 3e9, rtz);

#  TEST_FP_INT_OP_D_fcvt_w(22,  fcvt.l.d, 0x01,         -1, -1.1, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(23,  fcvt.l.d, 0x00,         -1, -1.0, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(24,  fcvt.l.d, 0x01,          0, -0.9, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(25,  fcvt.l.d, 0x01,          0,  0.9, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(26,  fcvt.l.d, 0x00,          1,  1.0, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(27,  fcvt.l.d, 0x01,          1,  1.1, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(28,  fcvt.l.d, 0x00,-3000000000, -3e9, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(29,  fcvt.l.d, 0x00, 3000000000,  3e9, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(20,  fcvt.l.d, 0x10,     -1<<63,-3e19, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(21,  fcvt.l.d, 0x10,  (1<<63)-1, 3e19, rtz);
#
#  TEST_FP_INT_OP_D_fcvt_w(32, fcvt.lu.d, 0x10,          0, -3.0, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(33, fcvt.lu.d, 0x10,          0, -1.0, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(34, fcvt.lu.d, 0x01,          0, -0.9, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(35, fcvt.lu.d, 0x01,          0,  0.9, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(36, fcvt.lu.d, 0x00,          1,  1.0, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(37, fcvt.lu.d, 0x01,          1,  1.1, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(38, fcvt.lu.d, 0x10,          0, -3e9, rtz);
#  TEST_FP_INT_OP_D_fcvt_w(39, fcvt.lu.d, 0x00, 3000000000,  3e9, rtz);
#
  # test negative NaN, negative infinity conversion
  TEST_CASE_fcvt_w(42, x1, 0x00000000, 0x7fffffff, la x1, tdat_d; fld f1,  0(x1); fcvt.w.d x1, f1)
# TEST_CASE_fcvt_w(43, x1, 0x7fffffffffffffff, la x1, tdat_d; fld f1,  0(x1); fcvt.l.d x1, f1)
  TEST_CASE_fcvt_w(44, x1, 0xffffffff, 0x80000000, la x1, tdat_d; fld f1, 16(x1); fcvt.w.d x1, f1)
# TEST_CASE_fcvt_w(45, x1, 0x8000000000000000, la x1, tdat_d; fld f1, 16(x1); fcvt.l.d x1, f1)

  # test positive NaN, positive infinity conversion
  TEST_CASE_fcvt_w(52, x1, 0x00000000, 0x7fffffff, la x1, tdat_d; fld f1,  8(x1); fcvt.w.d x1, f1)
# TEST_CASE_fcvt_w(53, x1, 0x7fffffffffffffff, la x1, tdat_d; fld f1,  8(x1); fcvt.l.d x1, f1)
  TEST_CASE_fcvt_w(54, x1, 0x00000000, 0x7fffffff, la x1, tdat_d; fld f1, 24(x1); fcvt.w.d x1, f1)
# TEST_CASE_fcvt_w(55, x1, 0x7fffffffffffffff, la x1, tdat_d; fld f1, 24(x1); fcvt.l.d x1, f1)

  # test NaN, infinity conversions to unsigned integer
  TEST_CASE_fcvt_w(62, x1, 0xffffffff, 0xffffffff, la x1, tdat_d; fld f1,  0(x1); fcvt.wu.d x1, f1)
  TEST_CASE_fcvt_w(63, x1, 0xffffffff, 0xffffffff, la x1, tdat_d; fld f1,  8(x1); fcvt.wu.d x1, f1)
  TEST_CASE_fcvt_w(64, x1, 0x00000000, 0x00000000, la x1, tdat_d; fld f1, 16(x1); fcvt.wu.d x1, f1)
  TEST_CASE_fcvt_w(65, x1, 0xffffffff, 0xffffffff, la x1, tdat_d; fld f1, 24(x1); fcvt.wu.d x1, f1)
# TEST_CASE_fcvt_w(66, x1, 0xffffffffffffffff, la x1, tdat_d; fld f1,  0(x1); fcvt.lu.d x1, f1)
# TEST_CASE_fcvt_w(67, x1, 0xffffffffffffffff, la x1, tdat_d; fld f1,  8(x1); fcvt.lu.d x1, f1)
# TEST_CASE_fcvt_w(68, x1,                  0, la x1, tdat_d; fld f1, 16(x1); fcvt.lu.d x1, f1)
# TEST_CASE_fcvt_w(69, x1, 0xffffffffffffffff, la x1, tdat_d; fld f1, 24(x1); fcvt.lu.d x1, f1)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

# -NaN, NaN, -inf, +inf
tdat:
.word 0xffffffff
.word 0x7fffffff
.word 0xff800000
.word 0x7f800000

tdat_d:
.dword 0xffffffffffffffff
.dword 0x7fffffffffffffff
.dword 0xfff0000000000000
.dword 0x7ff0000000000000

RVTEST_DATA_END
