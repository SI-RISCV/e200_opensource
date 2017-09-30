Debug Tests
===========

Debugging requires many system components to all work together. The tests here
perform an end-to-end test, communicating with gdb and OpenOCD.
If a simulator or hardware passes all these tests, then you can be pretty
confident that the actual debug interface is functioning correctly.

Targets
=======

64-bit Spike
------------

`./gdbserver.py targets/RISC-V/spike64.py`

32-bit Spike
------------

`./gdbserver.py targets/RISC-V/spike32.py`

32-bit SiFive Core on Supported FPGA Boards & Hardware
------------------------------------------------------

`./gdbserver.py targets/SiFive/E300.py`
`./gdbserver.py targets/SiFive/HiFive1.py`

Custom Target
-------------

For custom targets, you can create a .py file anywhere and pass its path on the
command line. The Targets class in `targets.py` contains documentation on what
every variable means.


Log Files
=========

All output from tests ends up in the `logs/` subdirectory, with one log file
per test. If a test fails, this is where to look.

Debug Tips
==========

You can run just a single test by specifying any part of its name on the
command line, eg: `./gdbserver.py targets/RISC-V/spike64.py S0` runs
SimpleS0Test.  Once that test has failed, you can look at the log file to get
an idea of what might have gone wrong.

You can see what spike is doing by adding `-l` to the spike command, eg.:
`./gdbserver.py --sim_cmd "$RISCV/bin/spike -l" targets/RISC-V/spike32.py Breakpoint`

You can see what OpenOCD is doing by adding `-d` to the OpenOCD command, eg.:
`./gdbserver.py --server_cmd "openocd -d" targets/RISC-V/spike32.py Breakpoint`

You can run gdb under valgrind by passing --gdb, eg.: `./gdbserver.py
--gdb "valgrind riscv64-unknown-elf-gdb" targets/RISC-V/spike64.py
DownloadTest`
