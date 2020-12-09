# source elab_pwm_generator_simple.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/pwm_generator_simple.prj --debug typical --mt auto -log elab_pwm_generator_simple.log -L xil_defaultlib -L secureip --snapshot pwm_generator_simple_tb "work.pwm_generator_simple_tb"
