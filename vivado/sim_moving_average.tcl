# source sim_moving_average.tcl

xsim moving_average_tb -log sim_moving_average.log

# Herarchical definitions:
set tb          /moving_average_tb


add_wave_divider {TESTBENCH}
add_wave                  $tb/rst
add_wave                  $tb/clk

add_wave -radix dec       $tb/din
add_wave                  $tb/din_vld

add_wave -radix dec       $tb/dout
add_wave                  $tb/dout_vld

add_wave_divider {MOVING AVERAGE}
add_wave -radix unsigned  $tb/DUT/din_cnt
add_wave -radix dec       $tb/DUT/mem_dout
add_wave -radix dec       $tb/DUT/acc

add_wave_divider {OUTPUT}
set ANLG_MAX  [expr +(2**15)]
set ANLG_MIN  [expr -(2**15)]
set ANLG_HEIGHT 50

#add_wave -noupdate -format Analog-Step -height $ANLG_HEIGHT -max $ANLG_MAX -min $ANLG_MIN -decimal $tb/DUT/din
#add_wave -noupdate -format Analog-Step -height $ANLG_HEIGHT -max $ANLG_MAX -min $ANLG_MIN -decimal $tb/DUT/dout

add_wave -radix dec       $tb/din
add_wave -radix dec       $tb/dout

set sim_time {1.2us}
set sim_time {20.5us}

run $sim_time
