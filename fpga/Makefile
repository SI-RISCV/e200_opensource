# See LICENSE for license details.
base_dir := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
FPGA_DIR := $(base_dir)/artydevkit
MODEL := e200_fpga_soc_top
INSTALL_RTL ?= $(base_dir)/install/rtl

include common.mk
