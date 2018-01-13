// See LICENSE for license details.

#ifndef _ENV_PHYSICAL_SINGLE_CORE_H
#define _ENV_PHYSICAL_SINGLE_CORE_H

#include "../encoding.h"

//-----------------------------------------------------------------------
// Begin Macro
//-----------------------------------------------------------------------

#define RVTEST_RV64U                                                    \
  .macro init;                                                          \
  .endm

#define RVTEST_RV64UF                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  .endm

#define RVTEST_RV32U                                                    \
  .macro init;                                                          \
  .endm

#define RVTEST_RV32UF                                                   \
  .macro init;                                                          \
  RVTEST_FP_ENABLE;                                                     \
  .endm

#define RVTEST_RV64M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  .endm

#define RVTEST_RV64S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#define RVTEST_RV32M                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_MACHINE;                                                \
  .endm

#define RVTEST_RV32S                                                    \
  .macro init;                                                          \
  RVTEST_ENABLE_SUPERVISOR;                                             \
  .endm

#if __riscv_xlen == 64
# define CHECK_XLEN li a0, 1; slli a0, a0, 31; bgez a0, 1f; RVTEST_PASS; 1:
#else
# define CHECK_XLEN li a0, 1; slli a0, a0, 31; bltz a0, 1f; RVTEST_PASS; 1:
#endif

#define INIT_PMP                                                        \
  la t0, 1f;                                                            \
  csrw mtvec, t0;                                                       \
  li t0, -1;        /* Set up a PMP to permit all accesses */           \
  csrw pmpaddr0, t0;                                                    \
  li t0, PMP_NAPOT | PMP_R | PMP_W | PMP_X;                             \
  csrw pmpcfg0, t0;                                                     \
  .align 2;                                                             \
1:

#define INIT_SPTBR                                                      \
  la t0, 1f;                                                            \
  csrw mtvec, t0;                                                       \
  csrwi sptbr, 0;                                                       \
  .align 2;                                                             \
1:

#define DELEGATE_NO_TRAPS                                               \
  la t0, 1f;                                                            \
  csrw mtvec, t0;                                                       \
  csrwi medeleg, 0;                                                     \
  csrwi mideleg, 0;                                                     \
  csrwi mie, 0;                                                         \
  .align 2;                                                             \
1:

#define RVTEST_ENABLE_SUPERVISOR                                        \
  li a0, MSTATUS_MPP & (MSTATUS_MPP >> 1);                              \
  csrs mstatus, a0;                                                     \
  li a0, SIP_SSIP | SIP_STIP;                                           \
  csrs mideleg, a0;                                                     \

#define RVTEST_ENABLE_MACHINE                                           \
  li a0, MSTATUS_MPP;                                                   \
  csrs mstatus, a0;                                                     \

#define RVTEST_FP_ENABLE                                                \
  li a0, MSTATUS_FS & (MSTATUS_FS >> 1);                                \
  csrs mstatus, a0;                                                     \
  csrwi fcsr, 0

#define RISCV_MULTICORE_DISABLE                                         \
  csrr a0, mhartid;                                                     \
  1: bnez a0, 1b

#define EXTRA_TVEC_USER
#define EXTRA_TVEC_MACHINE
#define EXTRA_INIT
#define EXTRA_INIT_TIMER

#define INTERRUPT_HANDLER j other_exception /* No interrupts should occur */

#define RVTEST_CODE_BEGIN                                               \
        .section .text.init;                                            \
        .align  6;                                                      \
        .weak stvec_handler;                                            \
        .weak mtvec_handler;                                            \
        .globl _start;                                                  \
_start:                                                                 \
        /* reset vector */                                              \
        j reset_vector;                                                 \
        .align 2;                                                       \
trap_vector:                                                            \
        /* test whether the test came from pass/fail */                 \
        /* Bob: since we have added the random irq */                   \
        /* Bob:  we need to save-and-restore the registers: begin */    \
        csrw mscratch, a0;                                              \
        la  a0, test_trap_data ;                                        \
        sw t5, 0(a0);                                                   \
        sw t6, 4(a0);                                                   \
  .pushsection .data; \
  .align 2; \
  test_trap_data: \
  .word 0; \
  .word 0; \
  .popsection \
        /* Bob: since we have added the random irq */                   \
        /* Bob:  we need to save-and-restore the registers: end */      \
        csrr t5, mcause;                                                \
        /* Bob: Here to check irq first: Begin */                   \
        bltz t5, other_interrupts;                                      \
        /* Bob: Here to check irq first: end */      \
        li t6, CAUSE_USER_ECALL;                                        \
        beq t5, t6, write_tohost;                                       \
        li t6, CAUSE_SUPERVISOR_ECALL;                                  \
        beq t5, t6, write_tohost;                                       \
        li t6, CAUSE_MACHINE_ECALL;                                     \
        beq t5, t6, write_tohost;                                       \
        /* Bob: Here to check bus-error : Begin */                   \
        li t6, CAUSE_FETCH_ACCESS;                                     \
        beq t5, t6, ifetch_error_handler;                                      \
        li t6, CAUSE_LOAD_ACCESS;                                     \
        beq t5, t6, load_error_handler;                                      \
        li t6, CAUSE_STORE_ACCESS;                                     \
        beq t5, t6, store_error_handler;                                      \
        /* Bob: Here to check bus-error : end */      \
        /* if an mtvec_handler is defined, jump to it */                \
        la t5, mtvec_handler;                                           \
        beqz t5, 1f;                                                    \
        jr t5;                                                          \
        /* was it an interrupt or an exception? */                      \
  1:    csrr t5, mcause;                                                \
        bgez t5, handle_exception;                                      \
        INTERRUPT_HANDLER;                                              \
handle_exception:                                                       \
        /* we don't know how to handle whatever the exception was */    \
  other_exception:                                                      \
        /* some unhandlable exception occurred */                       \
        /* Bob add IRQ Cause here: begin */                       \
        j 1f ;                                        \
  other_interrupts:                                                      \
        li t6, CAUSE_IRQ_M_SFT ;                                        \
        beq t5, t6, sft_irq_handler;                                       \
        li t6, CAUSE_IRQ_M_TMR ;                                        \
        beq t5, t6, tmr_irq_handler;                                       \
        li t6, CAUSE_IRQ_M_EXT ;                                        \
        beq t5, t6, ext_irq_handler;                                       \
        /* Bob add IRQ Cause here: End */                       \
  1:    ori TESTNUM, TESTNUM, 1337;                                     \
  write_tohost:                                                         \
        /*Bob added code to enable the interrupt enables: begin*/              \
        li a0, MSTATUS_MIE;                                                   \
        csrs mstatus, a0;                                                     \
        /*Bob added code to enable the interrupt enables: end*/              \
        sw TESTNUM, tohost, t5;                                         \
        j write_tohost;                                                 \
        /* Bob add IRQ handler here: begin */                       \
  ext_irq_handler:                                                         \
        /* we need to save-and-restore the registers: begin */    \
        la  a0, test_trap_data ;                                        \
        lw t5, 0(a0);                                                   \
        lw t6, 4(a0);                                                   \
        csrr a0, mscratch;                                              \
        /* we need to save-and-restore the registers: End */    \
      mret;                                         \
  sft_irq_handler:                                                         \
        /* we need to save-and-restore the registers: begin */    \
        la  a0, test_trap_data ;                                        \
        lw t5, 0(a0);                                                   \
        lw t6, 4(a0);                                                   \
        csrr a0, mscratch;                                              \
        /* we need to save-and-restore the registers: End */    \
        mret;                                         \
  tmr_irq_handler:                                                         \
        /* we need to save-and-restore the registers: begin */    \
        la  a0, test_trap_data ;                                        \
        lw t5, 0(a0);                                                   \
        lw t6, 4(a0);                                                   \
        csrr a0, mscratch;                                              \
        /* we need to save-and-restore the registers: End */    \
        mret;                                         \
        /* Bob add IRQ handler here: End */                       \
        /* Bob add bus-error handler here: Begin */                       \
  ifetch_error_handler:                                                         \
        /* we need to save-and-restore the registers: begin */    \
        la  a0, test_trap_data ;                                        \
        lw t5, 0(a0);                                                   \
        lw t6, 4(a0);                                                   \
        csrr a0, mbadaddr;                                              \
        csrr a0, mscratch;                                              \
        /* we need to save-and-restore the registers: End */    \
        mret;                                         \
        /* Bob add handler here: End */                       \
  load_error_handler:                                                         \
        /* we need to save-and-restore the registers: begin */    \
        la  a0, test_trap_data ;                                        \
        lw t5, 0(a0);                                                   \
        lw t6, 4(a0);                                                   \
        csrr a0, mbadaddr;                                              \
        csrr a0, mscratch;                                              \
        /* we need to save-and-restore the registers: End */    \
        mret;                                         \
        /* Bob add handler here: End */                       \
  store_error_handler:                                                         \
        /* we need to save-and-restore the registers: begin */    \
        la  a0, test_trap_data ;                                        \
        lw t5, 0(a0);                                                   \
        lw t6, 4(a0);                                                   \
        csrr a0, mbadaddr;                                              \
        csrr a0, mscratch;                                              \
        /* we need to save-and-restore the registers: End */    \
        mret;                                         \
        /* Bob add bus-error handler here: End */                       \
reset_vector:                                                           \
        /* Bob Initialize t5 and t6 here: Begin */                       \
        mv t5, x0;                                                  \
        mv t6, x0;                                                  \
        /* Bob Initialize t5 and t6 here: End */                       \
        RISCV_MULTICORE_DISABLE;                                        \
        /*INIT_SPTBR;*/                                                     \
        /*INIT_PMP;*/                                                       \
        /*DELEGATE_NO_TRAPS;*/                                              \
        li TESTNUM, 0;                                                  \
        la t0, trap_vector;                                             \
        /*Bob added code to enable the interrupt enables: begin*/              \
        li a0, MSTATUS_MIE;                                                   \
        csrs mstatus, a0;                                                     \
        li a0, 0xFFFFFFFF;                                                   \
        csrs mie, a0;                                                     \
        /*Bob added code to enable the interrupt enables: End*/              \
        csrw mtvec, t0;                                                 \
        /*CHECK_XLEN;*/                                                     \
        /* if an stvec_handler is defined, delegate exceptions to it */ \
post_mtvec:  la t0, stvec_handler;                                           \
        beqz t0, 1f;                                                    \
        csrw stvec, t0;                                                 \
        li t0, (1 << CAUSE_LOAD_PAGE_FAULT) |                           \
               (1 << CAUSE_STORE_PAGE_FAULT) |                          \
               (1 << CAUSE_FETCH_PAGE_FAULT) |                          \
               (1 << CAUSE_MISALIGNED_FETCH) |                          \
               (1 << CAUSE_USER_ECALL) |                                \
               (1 << CAUSE_BREAKPOINT);                                 \
        csrw medeleg, t0;                                               \
        csrr t1, medeleg;                                               \
        bne t0, t1, other_exception;                                    \
1:      csrwi mstatus, 0;                                               \
        /*Bob added code to enable the interrupt enables: begin*/              \
        li a0, MSTATUS_MPIE;                                                   \
        csrs mstatus, a0;                                                     \
        li a0, 0x0;/*We need to enable the ecc exception */                                                   \
        csrw 0xbfc, a0;                                                     \
        fence.i;                                                     \
        /*Bob added code to enable the interrupt enables: end*/              \
        /*Bob added code to enable the PLL: begin{*/              \
        li t0, 2560; /*Wait loops before switch to PLL*/  \
waitloop1: addi t0, t0, -1;                                                     \
        bnez t0, waitloop1;                                                     \
        li t2, 0x10008008;/*Set the pll bypass to 0*/                                                     \
        lw t0, 0(t2);                                                     \
        li t1, (1<<18);                                                     \
        xor t1, t1, -1;                                                     \
        and t0, t0, t1;                                                     \
        sw t0, 0(t2);                                                     \
        li t0, 1024; /*Wait loops before change PLL param */  \
waitloop2: addi t0, t0, -1;                                                     \
        lw t3, 0(t2);/*Intentially add a strange inscturciton here*/                                                     \
        bnez t0, waitloop2;                                                     \
        lw t0, 0(t2);/*Set pll bypass to 1*/                                                     \
        li t1, (1<<18);                                                     \
        or t0, t0, t1;                                                     \
        sw t0, 0(t2);                                                     \
        lw t0, 0(t2);/*Change N from 2 to 3*/                                                     \
        li t1, 1;                                                     \
        or t0, t0, t1;                                                     \
        sw t0, 0(t2);                                                     \
        lw t0, 0(t2);/*Change M from 32 to 33*/                                                     \
        li t1, (1<<5);                                                     \
        or t0, t0, t1;                                                     \
        sw t0, 0(t2);                                                     \
        li t0, 2560; /*Wait loops before switch to PLL*/  \
waitloop3: addi t0, t0, -1;                                                     \
        bnez t0, waitloop3;                                                     \
        lw t0, 0(t2);                                                     \
        li t1, (1<<18);                                                     \
        xor t1, t1, -1;                                                     \
        and t0, t0, t1;                                                     \
        sw t0, 0(t2);                                                     \
        li t0, 256; /*Wait loops before div the PLL*/  \
waitloop4: addi t0, t0, -1;                                                     \
        bnez t0, waitloop4;                                                     \
        li t2, 0x1000800C;/*Set the plloutdiv div1 to 0, and div ratio is 2*/                                                     \
        lw t0, 0(t2);                                                     \
        li t1, (1<<8);                                                     \
        xor t1, t1, -1;                                                     \
        and t0, t0, t1;                                                     \
        li t1, 0x2;                                                     \
        or t0, t0, t1;                                                     \
        sw t0, 0(t2);                                                     \
        li t0, 1024; /*Wait loops before change PLL param */  \
        /*Bob added code to enable the PLL: end}*/              \
        init;                                                           \
        EXTRA_INIT;                                                     \
        EXTRA_INIT_TIMER;                                               \
        la t0, 1f;                                                      \
        csrw mepc, t0;                                                  \
        csrr a0, mhartid;                                               \
        mret;                                                           \
1:

//-----------------------------------------------------------------------
// End Macro
//-----------------------------------------------------------------------

#define RVTEST_CODE_END                                                 \
        unimp

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#define RVTEST_PASS                                                     \
        fence;                                                          \
        li TESTNUM, 1;                                                  \
        ecall

#define TESTNUM gp
#define RVTEST_FAIL                                                     \
        fence;                                                          \
1:      beqz TESTNUM, 1b;                                               \
        sll TESTNUM, TESTNUM, 1;                                        \
        or TESTNUM, TESTNUM, 1;                                         \
        ecall

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define EXTRA_DATA

#define RVTEST_DATA_BEGIN                                               \
        EXTRA_DATA                                                      \
        .pushsection .tohost,"aw",@progbits;                            \
        .align 6; .global tohost; tohost: .dword 0;                     \
        .align 6; .global fromhost; fromhost: .dword 0;                 \
        .popsection;                                                    \
        .align 4; .global begin_signature; begin_signature:

#define RVTEST_DATA_END .align 4; .global end_signature; end_signature:

#endif
