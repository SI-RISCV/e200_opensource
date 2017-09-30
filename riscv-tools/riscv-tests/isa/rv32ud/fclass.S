# See LICENSE for license details.

#*****************************************************************************
# fclass.S
#-----------------------------------------------------------------------------
#
# Test fclass.d instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64UF
RVTEST_CODE_BEGIN

  #-------------------------------------------------------------
  # Arithmetic tests
  #-------------------------------------------------------------

  TEST_FCLASS_D_fclass( 2, 1 << 0, 0xfff0000000000000 )
  TEST_FCLASS_D_fclass( 3, 1 << 1, 0xbff0000000000000 )
  TEST_FCLASS_D_fclass( 4, 1 << 2, 0x800fffffffffffff )
  TEST_FCLASS_D_fclass( 5, 1 << 3, 0x8000000000000000 )
  TEST_FCLASS_D_fclass( 6, 1 << 4, 0x0000000000000000 )
  TEST_FCLASS_D_fclass( 7, 1 << 5, 0x000fffffffffffff )
  TEST_FCLASS_D_fclass( 8, 1 << 6, 0x3ff0000000000000 )
  TEST_FCLASS_D_fclass( 9, 1 << 7, 0x7ff0000000000000 )
  TEST_FCLASS_D_fclass(10, 1 << 8, 0x7ff0000000000001 )
  TEST_FCLASS_D_fclass(11, 1 << 9, 0x7ff8000000000000 )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
