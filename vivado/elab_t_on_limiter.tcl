# source elab_t_on_limiter.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/t_on_limiter.prj --debug typical --mt auto -log elab_t_on_limiter.log -L xil_defaultlib -L secureip --snapshot t_on_limiter_tb "work.t_on_limiter_tb"
