#include "encoding.h"
#define PGSHIFT         12

        .global         main

        .section        .text
main:
        # Set up a page table entry that maps 0x0... to 0x8...
        la      t0, page_table
        srli    t0, t0, PGSHIFT
        csrw    CSR_SPTBR, t0

        # update mstatus
        csrr    t1, CSR_MSTATUS
#if XLEN == 32
        li      t0, (MSTATUS_MPRV | (SPTBR_MODE_SV32 << 24))
#else
        li      t0, (MSTATUS_MPRV | (SPTBR_MODE_SV39 << 24))
#endif
        #li      t0, ((VM_SV39 << 24))
        or      t1, t0, t1
        csrw    CSR_MSTATUS, t1

        la      t0, (loop - 0x80000000)
        csrw    CSR_MEPC, t0

        # Exit supervisor mode, entering user mode at loop.
        mret

loop:
        la      t0, data
        lw      t1, 0(t0)
        j       loop

        .section        .data
data:
        .word   0xbead

        .balign 0x1000
page_table:
#if XLEN == 32
        .word   ((0x80000000 >> 2) | PTE_V | PTE_R | PTE_W | PTE_X | PTE_G | PTE_U)
#else
        .word   ((0x80000000 >> 2) | PTE_V | PTE_R | PTE_W | PTE_X | PTE_G | PTE_U)
        .word   0
#endif
