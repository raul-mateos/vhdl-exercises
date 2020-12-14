# source elab_pwm_generator.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/pwm_generator.prj --debug typical --mt auto -log elab_pwm_generator.log -L xil_defaultlib -L secureip --snapshot pwm_generator_tb "work.pwm_generator_tb"
