# See LICENSE for license details.

#*****************************************************************************
# fcmp.S
#-----------------------------------------------------------------------------
#
# Test f{eq|lt|le}.d instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FP_CMP_OP_D_fcmp( 2, feq.d, 0x00, 1, -1.36, -1.36)
  TEST_FP_CMP_OP_D_fcmp( 3, fle.d, 0x00, 1, -1.36, -1.36)
  TEST_FP_CMP_OP_D_fcmp( 4, flt.d, 0x00, 0, -1.36, -1.36)

  TEST_FP_CMP_OP_D_fcmp( 5, feq.d, 0x00, 0, -1.37, -1.36)
  TEST_FP_CMP_OP_D_fcmp( 6, fle.d, 0x00, 1, -1.37, -1.36)
  TEST_FP_CMP_OP_D_fcmp( 7, flt.d, 0x00, 1, -1.37, -1.36)

  # Only sNaN should signal invalid for feq.
  TEST_FP_CMP_OP_D_fcmp( 8, feq.d, 0x00, 0, NaN, 0)
  TEST_FP_CMP_OP_D_fcmp( 9, feq.d, 0x00, 0, NaN, NaN)
  TEST_FP_CMP_OP_D_fcmp(10, feq.d, 0x10, 0, sNaN, 0)

  # qNaN should signal invalid for fle/flt.
  TEST_FP_CMP_OP_D_fcmp(11, flt.d, 0x10, 0, NaN, 0)
  TEST_FP_CMP_OP_D_fcmp(12, flt.d, 0x10, 0, NaN, NaN)
  TEST_FP_CMP_OP_D_fcmp(13, flt.d, 0x10, 0, sNaN, 0)
  TEST_FP_CMP_OP_D_fcmp(14, fle.d, 0x10, 0, NaN, 0)
  TEST_FP_CMP_OP_D_fcmp(15, fle.d, 0x10, 0, NaN, NaN)
  TEST_FP_CMP_OP_D_fcmp(16, fle.d, 0x10, 0, sNaN, 0)

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
