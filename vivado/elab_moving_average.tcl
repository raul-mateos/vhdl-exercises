# source elab_moving_average.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/moving_average.prj --debug typical --mt auto -log elab_moving_average.log -L xil_defaultlib -L secureip --snapshot moving_average_tb "work.moving_average_tb"
