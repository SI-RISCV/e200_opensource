#! /bin/bash
#
# Script to build RISC-V ISA simulator, proxy kernel
# Tools will be installed to $PREFIX.

PREFIX=$PWD/prebuilt_tools/prefix
. build.common

echo "Starting RISC-V Toolchain build process"

build_project riscv-fesvr --prefix=$PREFIX
build_project riscv-isa-sim --prefix=$PREFIX --with-fesvr=$PREFIX  --enable-commitlog
build_project riscv-tests --prefix=$PREFIX/riscv32-none-embed --with-xlen=32

echo -e "\\nRISC-V Toolchain installation completed!"
