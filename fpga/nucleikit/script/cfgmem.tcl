lassign $argv mcsfile bitfile datafile

set iface spix4
set size 16
set bitaddr 0x000000

write_cfgmem -format mcs -interface $iface -size $size \
  -loadbit "up ${bitaddr} ${bitfile}" \
  -loaddata [expr {$datafile ne "" ? "up 0x000000 ${datafile}" : ""}] \
  -file $mcsfile -force
