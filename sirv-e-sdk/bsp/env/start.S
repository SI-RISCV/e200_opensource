// See LICENSE for license details.

// See LICENSE for license details.

#include "encoding.h"

	.section .init
	.globl _start
	.type _start,@function

_start:
.option push
.option norelax
	la gp, __global_pointer$
.option pop
	la sp, _sp

	/* Bob: Load code section from flash to ITCM */
	la a0, _itcm_lma
	la a1, _itcm
    beq a0, a1, 2f  /*If the ITCM phy-address same as the logic-address, then quit*/
	la a2, _eitcm
	bgeu a1, a2, 2f
1:
	lw t0, (a0)
	sw t0, (a1)
	addi a0, a0, 4
	addi a1, a1, 4
	bltu a1, a2, 1b
2:

	/* Load data section */
	la a0, _data_lma
	la a1, _data
	la a2, _edata
	bgeu a1, a2, 2f
1:
	lw t0, (a0)
	sw t0, (a1)
	addi a0, a0, 4
	addi a1, a1, 4
	bltu a1, a2, 1b
2:

	/* Clear bss section */
	la a0, __bss_start
	la a1, _end
	bgeu a0, a1, 2f
1:
	sw zero, (a0)
	addi a0, a0, 4
	bltu a0, a1, 1b
2:

	/* Call global constructors */
	la a0, __libc_fini_array
	call atexit
	call __libc_init_array

	/* Enable FPU */
	li t0, MSTATUS_FS
	csrs mstatus, t0
	csrr t1, mstatus
	and t1, t1, t0
	beqz t1, 1f
    /*
	fssr x0
    */
1:

	/* argc = argv = 0 */
	li a0, 0
	li a1, 0
	call main
	tail exit

1:
	j 1b
