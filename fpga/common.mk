# See LICENSE for license details.

# Required variables:
# - MODEL
# - PROJECT
# - CONFIG_PROJECT
# - CONFIG
# - FPGA_DIR

CORE = e203
PATCHVERILOG ?= ""



base_dir := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))



# Install RTLs
install: 
	mkdir -p ${PWD}/install
	cp ${PWD}/../rtl/${CORE} ${INSTALL_RTL} -rf
	cp ${FPGA_DIR}/src/system.org ${INSTALL_RTL}/system.v -rf
	sed -i 's/e200/${CORE}/g' ${INSTALL_RTL}/system.v
	sed -i '1i\`define FPGA_SOURCE\'  ${INSTALL_RTL}/core/${CORE}_defines.v

EXTRA_FPGA_VSRCS := 
verilog := $(wildcard ${INSTALL_RTL}/*/*.v)
verilog += $(wildcard ${INSTALL_RTL}/*.v)


# Build .mcs
.PHONY: mcs
mcs : install
	BASEDIR=${base_dir} VSRCS="$(verilog)" EXTRA_VSRCS="$(EXTRA_FPGA_VSRCS)" $(MAKE) -C $(FPGA_DIR) mcs


# Build .bit
.PHONY: bit
bit : install
	BASEDIR=${base_dir} VSRCS="$(verilog)" EXTRA_VSRCS="$(EXTRA_FPGA_VSRCS)" $(MAKE) -C $(FPGA_DIR) bit


.PHONY: setup
setup: 
	BASEDIR=${base_dir} VSRCS="$(verilog)" EXTRA_VSRCS="$(EXTRA_FPGA_VSRCS)" $(MAKE) -C $(FPGA_DIR) setup





# Clean
.PHONY: clean
clean:
	$(MAKE) -C $(FPGA_DIR) clean
	rm -rf fpga_flist
	rm -rf install
	rm -rf vivado.*
	rm -rf novas.*

