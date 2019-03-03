set scriptdir [file dirname [info script]]
set commondir [file dirname $scriptdir]
set srcdir [file join $commondir src]
set constrsdir [file join $commondir constrs]

set wrkdir [file join [pwd] obj]
set ipdir [file join $wrkdir ip]

set top {system}

create_project -part $part_fpga -in_memory
set_property -dict [list \
  TARGET_LANGUAGE {Verilog} \
  SIMULATOR_LANGUAGE {Mixed} \
  TARGET_SIMULATOR {XSim} \
  DEFAULT_LIB {xil_defaultlib} \
  IP_REPO_PATHS $ipdir \
  ] [current_project]

proc recglob { basedir pattern } {
  set dirlist [glob -nocomplain -directory $basedir -type d *]
  set findlist [glob -nocomplain -directory $basedir $pattern]
  foreach dir $dirlist {
    set reclist [recglob $dir $pattern]
    set findlist [concat $findlist $reclist]
  }
  return $findlist
}


if {[get_filesets -quiet sources_1] eq ""} {
  create_fileset -srcset sources_1
}
set obj [current_fileset]

set srcmainverilogfiles [recglob $srcdir "*.v"]
add_files -norecurse -fileset $obj $srcmainverilogfiles

if {[info exists ::env(EXTRA_VSRCS)]} {
  set extra_vsrcs [split $::env(EXTRA_VSRCS)]
  foreach extra_vsrc $extra_vsrcs {
    add_files -norecurse -fileset $obj $extra_vsrc
  }
}

if {[info exists ::env(VSRCS)]} {
  set vsrcs [split $::env(VSRCS)]
  foreach vsrc $vsrcs {
    add_files -norecurse -fileset $obj $vsrc
  }
}

## These paths and files should come from the caller, not within this script.
#if {[file exists [file join $srcdir include verilog]]} {
#  add_files -norecurse -fileset $obj [file join $srcdir include verilog DebugTransportModuleJtag.v]
#  add_files -norecurse -fileset $obj [file join $srcdir include verilog AsyncResetReg.v]
#}

if {[get_filesets -quiet sim_1] eq ""} {
  create_fileset -simset sim_1
}
set obj [current_fileset -simset]
add_files -norecurse -fileset $obj [glob -directory $srcdir {*.v}]
set_property TOP {tb} $obj

if {[get_filesets -quiet constrs_1] eq ""} {
  create_fileset -constrset constrs_1
}
set obj [current_fileset -constrset]
add_files -norecurse -fileset $obj [glob -directory $constrsdir {*.xdc}]
