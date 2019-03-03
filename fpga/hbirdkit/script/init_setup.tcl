proc recglob { basedir pattern } {
  set dirlist [glob -nocomplain -directory $basedir -type d *]
  set findlist [glob -nocomplain -directory $basedir $pattern]
  foreach dir $dirlist {
    set reclist [recglob $dir $pattern]
    set findlist [concat $findlist $reclist]
  }
  return $findlist
}

proc findincludedir { basedir pattern } {
  #find all subdirectories containing ".vh" files
  set vhfiles [recglob $basedir $pattern]
  set vhdirs {}
  foreach match $vhfiles {
    lappend vhdirs [file dir $match]
  }
  set uniquevhdirs [lsort -unique $vhdirs]
  return $uniquevhdirs
}

file mkdir $ipdir
update_ip_catalog -rebuild

source [file join $scriptdir ip.tcl]

# AR 58526 <http://www.xilinx.com/support/answers/58526.html>
set_property GENERATE_SYNTH_CHECKPOINT {false} [get_files -all {*.xci}]
set obj [get_ips]
generate_target all $obj
export_ip_user_files -of_objects $obj -no_script -force

set obj [current_fileset]

# Xilinx bug workaround
# scrape IP tree for directories containing .vh files
# [get_property include_dirs] misses all IP core subdirectory includes if user has specified -dir flag in create_ip
set property_include_dirs [get_property include_dirs $obj]
set ip_include_dirs [concat $property_include_dirs [findincludedir $ipdir "*.vh"]]
set ip_include_dirs [concat $ip_include_dirs [findincludedir $srcdir "*.h"]]
set ip_include_dirs [concat $ip_include_dirs [findincludedir $srcdir "*.vh"]]


read_ip [glob -directory $ipdir [file join * {*.xci}]]

synth_design -include_dirs ${wrkdir}/../../install/rtl/core/ -top $top  -rtl
