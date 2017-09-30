#!/bin/bash
serial_number=0
rm ~/e200_opensource/riscv-tools/riscv-tests/isa/rv32imc_${serial_number}/*.S -rf
num=1
while(( $num<=101 ))
do
    rm output/test* -rf
    make gen 
    cp output/test.S ~/e200_opensource/riscv-tools/riscv-tests/isa/rv32imc_${serial_number}/test${num}.S -rf
    let "num++"
done
