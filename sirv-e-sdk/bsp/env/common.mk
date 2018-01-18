# See LICENSE for license details.

ifndef _SIFIVE_MK_COMMON
_SIFIVE_MK_COMMON := # defined

.PHONY: all
all: $(TARGET)


ENV_DIR = $(BSP_BASE)/env
LIBWRAP_DIR = $(BSP_BASE)/libwrap
PLATFORM_DIR = $(ENV_DIR)/$(BOARD)

ASM_SRCS += $(ENV_DIR)/start.S
ASM_SRCS += $(ENV_DIR)/entry.S
C_SRCS += $(PLATFORM_DIR)/init.c
C_SRCS += $(ENV_DIR)/sirv_printf.c

C_SRCS += $(LIBWRAP_DIR)/stdlib/malloc.c 
C_SRCS += $(LIBWRAP_DIR)/sys/open.c  
C_SRCS += $(LIBWRAP_DIR)/sys/lseek.c  
C_SRCS += $(LIBWRAP_DIR)/sys/read.c  
C_SRCS += $(LIBWRAP_DIR)/sys/write.c  
C_SRCS += $(LIBWRAP_DIR)/sys/fstat.c  
C_SRCS += $(LIBWRAP_DIR)/sys/stat.c  
C_SRCS += $(LIBWRAP_DIR)/sys/close.c  
C_SRCS += $(LIBWRAP_DIR)/sys/link.c  
C_SRCS += $(LIBWRAP_DIR)/sys/unlink.c  
C_SRCS += $(LIBWRAP_DIR)/sys/execve.c  
C_SRCS += $(LIBWRAP_DIR)/sys/fork.c  
C_SRCS += $(LIBWRAP_DIR)/sys/getpid.c  
C_SRCS += $(LIBWRAP_DIR)/sys/kill.c  
C_SRCS += $(LIBWRAP_DIR)/sys/wait.c  
C_SRCS += $(LIBWRAP_DIR)/sys/isatty.c  
C_SRCS += $(LIBWRAP_DIR)/sys/times.c  
C_SRCS += $(LIBWRAP_DIR)/sys/sbrk.c  
C_SRCS += $(LIBWRAP_DIR)/sys/_exit.c  
C_SRCS += $(LIBWRAP_DIR)/misc/write_hex.c


LINKER_SCRIPT := $(PLATFORM_DIR)/link.lds

INCLUDES += -I$(BSP_BASE)/include
INCLUDES += -I$(BSP_BASE)/drivers/
INCLUDES += -I$(ENV_DIR)
INCLUDES += -I$(PLATFORM_DIR)

TOOL_DIR = $(BSP_BASE)/../toolchain/bin

LDFLAGS += -T $(LINKER_SCRIPT) -nostartfiles -Wl,--gc-sections -Wl,--wrap=scanf -Wl,--wrap=malloc -Wl,--wrap=printf  -Wl,--check-sections

LDFLAGS += -L$(ENV_DIR)

ASM_OBJS := $(ASM_SRCS:.S=.o)
C_OBJS := $(C_SRCS:.c=.o)

LINK_OBJS += $(ASM_OBJS) $(C_OBJS)
LINK_DEPS += $(LINKER_SCRIPT)

CLEAN_OBJS += $(TARGET) $(LINK_OBJS)

CFLAGS += -g
CFLAGS += -march=$(RISCV_ARCH)
CFLAGS += -mabi=$(RISCV_ABI)
CFLAGS += -mcmodel=medany  -ffunction-sections -fdata-sections -fno-builtin-printf -fno-builtin-malloc

$(TARGET): $(LINK_OBJS) $(LINK_DEPS)
	$(CC) $(CFLAGS) $(INCLUDES) $(LINK_OBJS) -o $@ $(LDFLAGS)

$(ASM_OBJS): %.o: %.S $(HEADERS)
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

$(C_OBJS): %.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) $(INCLUDES) -include sys/cdefs.h -c -o $@ $<

.PHONY: clean
clean:
	rm -f $(CLEAN_OBJS)

endif # _SIFIVE_MK_COMMON
