RISC-V Frontend Server
=========================

About
---------

This repository contains the front-end server library, which facilitates
communication between a host machine and a RISC-V target machine.  It is
usually not meant to be used as a standalone package.

Build Steps
---------------

Execute the following commands to install the library, assuming you've
declared the RISCV environment variable to point to the RISC-V install path:

    $ mkdir build
    $ cd build
    $ ../configure --prefix=$RISCV
    $ make install
