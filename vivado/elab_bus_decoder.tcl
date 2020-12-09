# source elab_bus_decoder.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/bus_decoder.prj --debug typical --mt auto -log elab_bus_decoder.log -L xil_defaultlib -L secureip --snapshot bus_decoder_tb "work.bus_decoder_tb"
