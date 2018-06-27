The Simulation Directory
================

Problem #1
-----------

We noted some users have difficulty to read the Makefile to understand what is going on for this directory.

  * Please just follow the Chapter 17 (section 17.4) of Book《手把手教你设计CPU：RISC-V处理器篇》to understand how to run it.
  * Currently we use opensourced EDA iverilog by default, and if you need to use the commercial EDA tools, you need to update the bin/run.makefile to support your EDA tools (such as VCS+Verdi), if you dont know how to support VCS+Verdi, you can contact Bob Hu via (微信公众号：硅农亚历山大).

Problem #2
-----------

Some users want to know how to run the demo_gpio/dhrystone/coremark tests in the simulation environment, which was running basically in the FPGA board before. Please use the below command to run demo_gpio/dhrystone/coremark respectively:
   
   `make run_test TESTCASE=$PWD/../riscv-tools/fpga_test4sim/demo_gpio4sim/demo_gpio4sim`
   
   `make run_test TESTCASE=$PWD/../riscv-tools/fpga_test4sim/dhrystone4sim/dhrystone4sim`
   
   `make run_test TESTCASE=$PWD/../riscv-tools/fpga_test4sim/coremark4sim/coremark4sim`

   Well, definitely you need to compile the RTL before running above tests, what? you dont know how to compile... read the book, please just follow the Chapter 17 (section 17.4) of Book《手把手教你设计CPU：RISC-V处理器篇》to understand how to run it.
