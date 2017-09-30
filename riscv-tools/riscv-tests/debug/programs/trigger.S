#include "encoding.h"

#if XLEN == 64
# define LREG ld
# define SREG sd
# define REGBYTES 8
#else
# define LREG lw
# define SREG sw
# define REGBYTES 4
#endif

#undef MCONTROL_TYPE
#undef MCONTROL_DMODE
#if __riscv_xlen == 64
# define MCONTROL_TYPE    (0xf<<(64-4))
# define MCONTROL_DMODE   (1<<(64-5))
#else
# define MCONTROL_TYPE    (0xf<<(32-4))
# define MCONTROL_DMODE   (1<<(32-5))
#endif

        .global         main

        .section        .text
main:

        la      a0, data
        li      t0, 0
just_before_read_loop:
        li      t2, 16
read_loop:
        lw      t1, 0(a0)
        addi    t0, t0, 1
        addi    a0, a0, 4
        blt     t0, t2, read_loop

        la      a0, data
just_before_write_loop:
        li      t0, 1
write_loop:
        sw      t0, 0(a0)
        addi    t0, t0, 1
        addi    a0, a0, 4
        blt     t0, t2, write_loop

        j       main_exit

write_store_trigger:
        li      a0, (1<<6) | (1<<1)
        li      a1, 0xdeadbee0
        jal     write_triggers
        la      a0, data
        jal     read_triggers

write_load_trigger:
        li      a0, (1<<6) | (1<<0)
        li      a1, 0xfeedac00
        jal     write_triggers
        la      a0, data
        jal     read_triggers

// Clear triggers so the next test can use them.
clear_triggers:
        li      a0, 0
        jal     write_triggers

main_exit:
        li      a0, 0
        j       _exit

write_triggers:
        // a0: value to write to each tdata1
        // a1: value to write to each tdata2
        li      t0, 0
2:
        csrw    CSR_TSELECT, t0
        csrr    t1, CSR_TSELECT
        bne     t0, t1, 1f
        addi    t0, t0, 1
        csrw    CSR_TDATA2, a1
        csrw    CSR_TDATA1, a0
        j       2b
1:      ret

read_triggers:
        // a0: address where data should be written
        li      t0, 0
2:
        csrw    CSR_TSELECT, t0
        csrr    t1, CSR_TSELECT
        bne     t0, t1, 1f
        addi    t0, t0, 1
        csrr    t1, CSR_TDATA1
        SREG    t1, 0(a0)
        csrr    t1, CSR_TDATA2
        SREG    t1, REGBYTES(a0)
        addi    a0, a0, 2*REGBYTES
        j       2b
1:      SREG    zero, 0(a0)
        ret

        .data
        .align  3
data:   .word   0x40
        .word   0x41
        .word   0x42
        .word   0x43
        .word   0x44
        .word   0x45
        .word   0x46
        .word   0x47
        .word   0x48
        .word   0x49
        .word   0x4a
        .word   0x4b
        .word   0x4c
        .word   0x4d
        .word   0x4e
        .word   0x4f
