# source sim_pwm_generator_simple.tcl

xsim pwm_generator_simple_tb -log sim_pwm_generator_simple.log

# Herarchical definitions:
set tb          /pwm_generator_simple_tb


add_wave_divider {TESTBENCH}
add_wave                    $tb/DUT/rst
add_wave                    $tb/DUT/clk

add_wave -radix unsigned    $tb/DUT/period
add_wave -radix unsigned    $tb/DUT/duty_cycle
add_wave -color orange      $tb/DUT/pwm_out

add_wave_divider {PWM GENERATOR}
add_wave                    $tb/DUT/rst
add_wave                    $tb/DUT/clk

add_wave -radix unsigned    $tb/DUT/carrier
add_wave                    $tb/DUT/period_end
add_wave -radix unsigned    $tb/DUT/duty_cycle_reg
add_wave -color magenta     $tb/DUT/match
add_wave                    $tb/DUT/pwm_out

add_wave_divider {ANALOG}

set ANLG_MAX  1000
set ANLG_MIN  0
set ANLG_HEIGHT 40

#  add_wave -noupdate -format Analog-Step -height $ANLG_HEIGHT -max $ANLG_MAX -min $ANLG_MIN -radix unsigned    $tb/DUT/carrier
add_wave -radix unsigned    $tb/DUT/carrier


set sim_time {1400us}
run $sim_time

# close_sim -force
