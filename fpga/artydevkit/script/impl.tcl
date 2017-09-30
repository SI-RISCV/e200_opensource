set_param {messaging.defaultLimit} 1000000

read_ip [glob -directory $ipdir [file join * {*.xci}]]

synth_design -include_dirs ${wrkdir}/../../install/rtl/core/ -top $top -flatten_hierarchy rebuilt
write_checkpoint -force [file join $wrkdir post_synth]

opt_design
write_checkpoint -force [file join $wrkdir post_opt]

place_design
write_checkpoint -force [file join $wrkdir post_place]

phys_opt_design
power_opt_design
route_design
write_checkpoint -force [file join $wrkdir post_route]

write_bitstream -force [file join $wrkdir "${top}.bit"]
write_sdf -force [file join $wrkdir "${top}.sdf"]
write_verilog -mode timesim -force [file join ${wrkdir} "${top}.v"]
write_debug_probes -force [file join $wrkdir "${top}.ltx"]

# AR 63042 <http://www.xilinx.com/support/answers/63041.html>:
# Work around the write_mem_info command not supporting "processor-less"
# (non-Microblaze) designs.
set bram_inst [get_cells -hierarchical "bram"]
if {$bram_inst ne ""} {
  source [file join $scriptdir "bram.tcl"]
  write_mmi [file join $wrkdir "${top}.mmi"] $bram_inst
}

if {[info exists bootrom_inst]} {
  puts "Generating bootrom.mmi ..."
  set rom_inst [get_cells -hierarchical "${bootrom_inst}"]
  if {$rom_inst ne ""} {
    source [file join $scriptdir "bram.tcl"]
    write_mmi [file join $wrkdir "bootrom.mmi"] $rom_inst
  }
}

set rptdir [file join $wrkdir report]
file mkdir $rptdir
set rptutil [file join $rptdir utilization.txt]
report_datasheet -file [file join $rptdir datasheet.txt]
report_utilization -hierarchical -file $rptutil
report_clock_utilization -file $rptutil -append
report_ram_utilization -file $rptutil -append -detail
report_timing_summary -file [file join $rptdir timing.txt] -max_paths 10
report_high_fanout_nets -file [file join $rptdir fanout.txt] -timing -load_types -max_nets 25
report_drc -file [file join $rptdir drc.txt]
report_io -file [file join $rptdir io.txt]
report_clocks -file [file join $rptdir clocks.txt]
