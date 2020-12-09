# source elab_flash_controller.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/flash_controller.prj --debug typical --mt auto -log elab_flash_controller.log -L xil_defaultlib -L secureip --snapshot flash_controller_tb "work.flash_controller_tb"
