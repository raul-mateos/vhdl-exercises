# source elab_TOF_meter.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/TOF_meter.prj --debug typical --mt auto -log elab_TOF_meter.log -L xil_defaultlib -L secureip --snapshot TOF_meter_tb "work.TOF_meter_tb"
