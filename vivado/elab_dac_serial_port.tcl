# source elab_dac_serial_port.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --relax -prj $prj_dir/dac_serial_port.prj --debug typical --mt auto -log elab_dac_serial_port.log -L xil_defaultlib -L secureip --snapshot dac_serial_port_tb "work.dac_serial_port_tb"

#  --93_mode --incr