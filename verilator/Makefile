# Copyright 2018 Tomas Brabec
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SHELL=bash

vdir = ../rtl/e203
vsrc = tb_verilator.v $(foreach d,$(wildcard $(vdir)/*),$(wildcard $(d)/*.*v*))
csrc = sim.cpp
cflags =
objdir = obj
obj = $(csrc:%.cpp=%)
vflags = $(if $(cflags),-CFLAGS $(cflags)) --cc --exe --Mdir $(objdir) +incdir+$(vdir)/core +incdir+$(vdir)/perips \
	 --top-module tb_verilator \
	 -Wno-WIDTH -Wno-UNOPTFLAT -Wno-CASEINCOMPLETE -Wno-LITENDIAN
vflags_extra = --trace

isa_test_patts ?= rv32ui* rv32um* rv32uc* rv32ua* rv32mi*
isa_test_dir ?= ../riscv-tools/riscv-tests/isa/generated
isa_tests ?= $(basename $(notdir $(wildcard $(foreach p,$(isa_test_patts),$(isa_test_dir)/$(p).verilog))))


.PHONY: help
help:
	@echo -e "Usage:\n\tmake [ooptions] [target] [<variable>=<value>]"
	@echo -e "\nTargets:"
	@echo -e "  help        prints this help message"
	@echo -e "  list-tests  lists available ISA tests"
	@echo -e "  build       creates a testbench binary ($(objdir)/$(obj))"
	@echo -e "  regression  runs all tests listed by 'list-tests'"
	@echo -e "  test-<name> runs a single test"
	@echo -e "  clean       delete all outputs"
	@echo -e "\nVariables:"
	@echo -e "  isa_test_patts   space separated list of patterns of ISA tests"
	@echo -e "                   (actual: '$(isa_test_patts)')"
	@echo -e "  isa_tests        space separated list of tests to run for 'regression',"
	@echo -e "                   use 'make list' to display the corresponding list"
	@echo -e "  cflags           extra C++ compiler flags"
	@echo -e "                   use cflags='-DVCDTRACE=1' to enable VCD dump into dump.vcd file."
	@echo -e "\nExamples:"
	@echo -e "  make build test-rv32ui-p-xori"
	@echo -e "  make regression isa_tests=rv32ui-p-xori"
	@echo -e "  make regression isa_patts='rv32ui*'"
	@echo -e ""

.PHONY: list-tests list
list list-tests:
	@echo $(isa_tests)


.PHONY: all build
all build: $(objdir)/$(obj)

$(objdir)/$(obj): $(vsrc) $(csrc)
	verilator $(vflags) $(vflags_extra) -o $(notdir $(obj)) $(csrc) $(vsrc)
	make -C $(objdir) -f Vtb_verilator.mk

.PHONY: clean
clean:
	rm -rf $(objdir) results dump.vcd && for f in *.verilog; do if [ -L $${f} ]; then unlink $${f}; fi; done

.PHONY: regression
regression: $(isa_tests:%=test-%)

test-%: $(isa_test_dir)/%.verilog
	@test -e $*.verilog || ln -s $<
	@mkdir -p results && echo "Running '$*' test ..." && $(objdir)/$(obj) +TESTCASE=$* > results/$*.log

