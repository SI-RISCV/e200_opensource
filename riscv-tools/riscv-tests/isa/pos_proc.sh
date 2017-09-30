#!/bin/bash
for S in "s/ld/lw/g" "s/sd/sw/g";
#"s/srlw/srl/g" "s/subw/sub/g" "s/addiw/addi/g" "s/sllw/sll/g" "s/mulw/mul/g"  "s/sraw/sra/g" "s/remuw/remu/g" "s/srajw/sraj/g" "s/srlw/srl/g" "s/addw/add/g" "s/suiw/sui/g" "s/divuw/divu/g" "s/divw/div/g" "s/remw/rem/g" "s/sraiw/srai/g" "s/slliw/slli/g" "s/lwu/lw/g" "s/srliw/srli/g";
do
    sed -i "${S}" ./rv32imc_*/*.S
done
