# See LICENSE for license details.

#*****************************************************************************
# fcvt.S
#-----------------------------------------------------------------------------
#
# Test fcvt.d.{wu|w|lu|l}, fcvt.s.d, and fcvt.d.s instructions.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_INT_FP_OP_D_fcvt(2,  fcvt.d.w,                   2.0,  2);
  TEST_INT_FP_OP_D_fcvt(3,  fcvt.d.w,                  -2.0, -2);

  TEST_INT_FP_OP_D_fcvt(4, fcvt.d.wu,                   2.0,  2);
  TEST_INT_FP_OP_D_fcvt(5, fcvt.d.wu,            4294967294, -2);

 # TEST_INT_FP_OP_D_fcvt(6,  fcvt.d.l,                   2.0,  2);
 # TEST_INT_FP_OP_D_fcvt(7,  fcvt.d.l,                  -2.0, -2);

 # TEST_INT_FP_OP_D_fcvt(8, fcvt.d.lu,                   2.0,  2);
 # TEST_INT_FP_OP_D_fcvt(9, fcvt.d.lu, 1.8446744073709552e19, -2);

  TEST_FCVT_S_D_fcvt(10, -1.5, -1.5)
  TEST_FCVT_D_S_fcvt(11, -1.5, -1.5)

TEST_CASE_fcvt(12, a0, 0x7ff80000, 0x00000000,
    la a1, test_data_22;
    fld f2, 0(a1);
    fcvt.s.d f2, f2;
    fcvt.d.s f2, f2;
    fsd f2, 0(a1);
    lw  a3, 0(a1);
    lw  a4, 4(a1);
    ) 


  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

test_data_22:
.dword 0x7ffcffffffff8004

RVTEST_DATA_END
