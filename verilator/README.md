ISA Tests under Verilator
=========================

This folder contains a Verilator testbench to exercise RTL against ISA
[riscv-tests](https://github.com/riscv/riscv-tests).

The testbench was tested with Verilator 3.924 and should work out of the box
with 3.922 (as the 1st version supporting SV `assert property`). For earlier
versions one needs to verilate with `+define+DISABLE_SV_ASSERTIONS=1`.

Limitations
-----------

- Regressions support pre-compiled versions of [riscv-tests](https://github.com/riscv/riscv-tests)
  available in `riscv-tools/riscv-tests/isa/generated` folder.

- Hard-coded number of clock cycles. The C++ testbench forces the simulation
  to stop after 1024 cycles. This may be changed in `sim.cpp`.

- The RTL code needs to be verilated with `--trace` option and a VCD trace
  instance created in the C++ testbench. Otherwise the simulation does not
  work/converge.

Installing Verilator
--------------------

### Installing Packaged Version ###

Instructions from https://github.com/ucb-bar/riscv-sodor

- Ubuntu 17.04 and on

      sudo apt install pkg-config verilator
      
- Ubuntu 16.04 and earlier

      sudo apt install pkg-config
      wget http://mirrors.kernel.org/ubuntu/pool/universe/v/verilator/verilator_3.900-1_amd64.deb
      sudo dpkg -i verilator_3.900-1_amd64.deb

### Building from Source ###

Instructions adapted from https://github.com/ucb-bar/riscv-sodor

    # install packages needed for compilation
    sudo apt-get install make autoconf g++ flex bison libfl-dev
    
    # optionally install GtkWave
    sudo apt-get install gtkwave
    
    # obtain a released version
    # (alternatively clone a git repo: http://git.veripool.org/git/verilator)
    wget https://www.veripool.org/ftp/verilator-3.924.tgz
    tar -xzf verilator-3.924.tgz
    
    # compile
    # (when intending to install, consider using ./configure --prefix=<path>)
    cd verilator*
    unset VERILATOR_ROOT
    ./configure && make
    
    # set environment
    export VERILATOR_ROOT=$PWD
    export PATH=$PATH:$VERILATOR_ROOT/bin

Building Testbench
------------------

To build with default settings:

    make build

To enable VCD dump into `dump.vcd`. Note that the dumping support is compiled
into the testbench binary and hence you need to rebuild to turn it on and off.

    make build cflags='-DVCDTRACE=1'

To build with Verilator prior to 3.922:

    make build vflags_extra='--trace +define+DISABLE_SV_ASSERTION=1'

Running
-------

To run the supported regression test suite:

    make regression

To run a full regression test suite (including e.g. floating-point ISA tests):

    make regression isa_test_patts='*'

To run a single test:

    # either run as a regression suite of one test
    make regression isa_tests=rv32ui-p-xori
    
    # or run as a single test
    make test-rv32ui-p-xori

