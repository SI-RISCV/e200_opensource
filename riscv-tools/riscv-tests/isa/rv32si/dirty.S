# See LICENSE for license details.

#include "riscv_test.h"
#undef RVTEST_RV64M
#define RVTEST_RV64M RVTEST_RV32M

#undef SPTBR_MODE_SV39
#define SPTBR_MODE_SV39 SPTBR_MODE_SV32

#include "../rv64si/dirty.S"
