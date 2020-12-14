# source elab_mono_stable.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/mono_stable.prj --debug typical --mt auto -log elab_mono_stable.log -L xil_defaultlib -L secureip --snapshot mono_stable_tb "work.mono_stable_tb"
