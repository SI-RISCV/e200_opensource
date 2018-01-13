TARGET := dhrystone

C_SRCS := dhry_stubs.c dhry_1.c dhry_2.c
HEADERS := dhry.h

CFLAGS := -O3 -DTIME -fno-inline -Wno-implicit -mcmodel=medany -fno-common  -mexplicit-relocs -DNOENUM -falign-functions=4


BSP_BASE = ../../bsp
include $(BSP_BASE)/env/common.mk

