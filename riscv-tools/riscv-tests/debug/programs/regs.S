#if XLEN == 64
# define LREG ld
# define SREG sd
# define REGBYTES 8
#else
# define LREG lw
# define SREG sw
# define REGBYTES 4
#endif

#include "encoding.h"

        .global main
main:
        nop
        j       main

write_regs:
        SREG    x2, 0(x1)
        SREG    x3, 8(x1)
        SREG    x4, 16(x1)
        SREG    x5, 24(x1)
        SREG    x6, 32(x1)
        SREG    x7, 40(x1)
        SREG    x8, 48(x1)
        SREG    x9, 56(x1)
        SREG    x10, 64(x1)
        SREG    x11, 72(x1)
        SREG    x12, 80(x1)
        SREG    x13, 88(x1)
        SREG    x14, 96(x1)
        SREG    x15, 104(x1)
        SREG    x16, 112(x1)
        SREG    x17, 120(x1)
        SREG    x18, 128(x1)
        SREG    x19, 136(x1)
        SREG    x20, 144(x1)
        SREG    x21, 152(x1)
        SREG    x22, 160(x1)
        SREG    x23, 168(x1)
        SREG    x24, 176(x1)
        SREG    x25, 184(x1)
        SREG    x26, 192(x1)
        SREG    x27, 200(x1)
        SREG    x28, 208(x1)
        SREG    x29, 216(x1)
        SREG    x30, 224(x1)
        SREG    x31, 232(x1)

        csrr    x1, CSR_MSCRATCH

all_done:
        j       all_done

        .balign  16
data:
        .fill   64, 8, 0
