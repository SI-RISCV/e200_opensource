#include "encoding.h"

        .global         main

        .section        .text
main:
        # MISA is only readable from machine mode
        csrr    t0, CSR_MISA
        csrr    t0, CSR_MISA
        csrr    t0, CSR_MISA
        csrr    t0, CSR_MISA
