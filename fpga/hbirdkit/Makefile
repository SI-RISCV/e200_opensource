VIVADO ?= vivado
VIVADOFLAGS := \
	-nojournal -mode batch \
	-source script/board.tcl \
	-source script/prologue.tcl

VIVADOFLAGS_SETUP := \
	-nojournal -mode gui \
	-source script/board.tcl \
	-source script/prologue_setup.tcl

# Path to a program in raw binary format to be flashed into the address that the
# bootrom jumps to.
FLASHED_PROGRAM ?=

bit := obj/system.bit
$(bit): script/impl.tcl  script/init.tcl
	VSRCS="$(VSRCS)" EXTRA_VSRCS="$(EXTRA_VSRCS)" $(VIVADO) $(VIVADOFLAGS) -source script/init.tcl -source script/impl.tcl

.PHONY: bit
bit: $(bit)

mcs := obj/system.mcs
$(mcs): $(bit)
	$(VIVADO) $(VIVADOFLAGS) script/cfgmem.tcl -tclargs $@ $^ $(FLASHED_PROGRAM)

.PHONY: mcs
mcs: $(mcs)

.PHONY: setup
setup:
	VSRCS="$(VSRCS)" EXTRA_VSRCS="$(EXTRA_VSRCS)" $(VIVADO) $(VIVADOFLAGS_SETUP) -source script/init_setup.tcl 


.PHONY: clean
clean::
	rm -rf -- .Xil .ip_user_files *.os obj src/generated usage_statistics_webtalk.xml usage_statistics_webtalk.html *.log
