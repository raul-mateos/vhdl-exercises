# source elab_mux_one_hot.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/mux_one_hot.prj --debug typical --mt auto -log elab_mux_one_hot.log -L xil_defaultlib -L secureip --snapshot mux_one_hot_gen "work.mux_one_hot_gen"
