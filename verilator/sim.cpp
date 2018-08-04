#include "Vtb_verilator.h"
#include <verilated.h>

#if VM_TRACE
#include <verilated_vcd_c.h>
#endif

vluint64_t simtime = 0;       // Current simulation time
				// This is a 64-bit integer to reduce wrap over issues and
				// allow modulus.  You can also use a double, if you wish.

double sc_time_stamp () {       // Called by $time in Verilog
	return simtime;       // converts to double, to match
				// what SystemC does
}

int main(int argc, char **argv, char **env) {
	Verilated::commandArgs(argc, argv);
	Vtb_verilator* top = new Vtb_verilator;
	int cnt;
	simtime = 0;

#if VM_TRACE
	Verilated::traceEverOn(true);
        VerilatedVcdC* tfp = new VerilatedVcdC;
//	top->trace (tfp, 99);
//        tfp->open ("simx.vcd");
#endif

	// reset
	top->rst_n = 1;
	top->clk = 0;
	top->eval();
//#if VM_TRACE
//	tfp->dump(simtime);
//#endif
	simtime++;
	top->rst_n = 0;
	top->eval();
//#if VM_TRACE
//	tfp->dump(simtime);
//#endif
	simtime++;
	top->rst_n = 1;
	top->eval();
//#if VM_TRACE
//	tfp->dump(simtime);
//#endif
	simtime++;

	while (!Verilated::gotFinish() && cnt < (1 << 15)) {
		top->clk = 1;
		top->eval();
//#if VM_TRACE
//		tfp->dump(simtime);
//#endif
		simtime++;
		top->clk = 0;
		top->eval();
//#if VM_TRACE
//		tfp->dump(simtime);
//#endif
		simtime++;
		cnt++;
	}
	delete top;

#if VM_TRACE
//	tfp->close();
	delete tfp;
#endif

	if (!Verilated::gotFinish()) {
		printf("Simulation time out! Forced stop ...\n");
		return 1;
	} else {
#if VM_COVERAGE
		VerilatedCov::write("coverage.dat");
#endif // VM_COVERAGE
		return 0;
	}
}
