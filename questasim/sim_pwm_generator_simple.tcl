# source sim_pwm_generator_simple.tcl

quit -sim

if {[vsimVersion] >= 2017.09} {
  set opt_args  "-voptargs=+acc";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.pwm_generator_simple_tb


set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150

add wave -noupdate -divider {TESTBENCH}
add wave            /DUT/rst
add wave            /DUT/clk

add wave -unsigned  /DUT/period
add wave -unsigned  /DUT/duty_cycle
add wave -co orange /DUT/pwm_out

add wave -noupdate -divider {PWM GENERATOR}
add wave              /DUT/rst
add wave              /DUT/clk

add wave -unsigned    /DUT/carrier
add wave              /DUT/period_end
add wave -unsigned    /DUT/duty_cycle_reg
add wave -co magenta  /DUT/match
add wave              /DUT/pwm_out

add wave -noupdate -divider {ANALOG}

set ANLG_MAX  1000
set ANLG_MIN  0
set ANLG_HEIGHT 40

add wave -noupdate -format Analog-Step -height $ANLG_HEIGHT -max $ANLG_MAX -min $ANLG_MIN -unsigned    /DUT/carrier


set sim_time {1400 us}

run $sim_time
