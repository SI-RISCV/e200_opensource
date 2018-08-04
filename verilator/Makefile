vdir = ../rtl/e203
vsrc = tb_verilator.v $(foreach d,$(wildcard $(vdir)/*),$(wildcard $(d)/*.*v*))
csrc = sim.cpp
objdir = obj
obj = $(csrc:%.cpp=%)
vflags = --cc --exe --Mdir $(objdir) +incdir+$(vdir)/core +incdir+$(vdir)/perips \
	 --top-module tb_verilator \
	 -Wno-WIDTH -Wno-UNOPTFLAT -Wno-CASEINCOMPLETE -Wno-LITENDIAN
vflags_extra = --trace


.PHONY: all
all: $(objdir)/$(obj)

$(objdir)/$(obj): $(vsrc) $(csrc)
	verilator $(vflags) $(vflags_extra) -o $(notdir $(obj)) $(csrc) $(vsrc)
	make -C $(objdir) -f Vtb_verilator.mk

.PHONY: clean
clean:
	rm -rf $(objdir)

