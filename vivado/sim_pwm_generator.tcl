# source sim_pwm_generator.tcl

xsim pwm_generator_tb -log sim_pwm_generator.log

# Herarchical definitions:
set tb          /pwm_generator_tb

add_wave_divider {TESTBENCH}
add_wave                    $tb/DUT/rst
add_wave                    $tb/DUT/clk

add_wave -radix unsigned    $tb/DUT/period
add_wave -radix unsigned    $tb/DUT/duty_cycle
add_wave -color orange      $tb/DUT/pwm_out

add_wave_divider {SYSTEM TOP}
add_wave                    $tb/DUT/rst
add_wave                    $tb/DUT/clk

add_wave                    $tb/DUT/state
add_wave -radix unsigned    $tb/DUT/carrier
add_wave -color orange      $tb/DUT/up_down
add_wave                    $tb/DUT/carrier_max
add_wave                    $tb/DUT/carrier_min

add_wave                    $tb/DUT/period_end
add_wave -color magenta     $tb/DUT/pwm_out


add_wave_divider {ANALOG}

set ANLG_MAX  500
set ANLG_MIN  0
set ANLG_HEIGHT 80

#add_wave -noupdate -format Analog-Step -height $ANLG_HEIGHT -max $ANLG_MAX -min $ANLG_MIN -radix unsigned    $tb/DUT/carrier
add_wave -radix unsigned    $tb/DUT/carrier



set sim_time {1ms}
run $sim_time

# close_sim -force
