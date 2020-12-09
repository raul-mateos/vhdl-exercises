# source sim_TOF_meter.tcl

xsim TOF_meter_tb -log sim_TOF_meter.log

# Herarchical definitions:
set tb          /TOF_meter_tb

add_wave_divider {TESTBENCH}
add_wave                  $tb/rst
add_wave                  $tb/clk

add_wave                  $tb/start
add_wave                  $tb/echo
add_wave -radix unsigned  $tb/data
add_wave                  $tb/overrange

add_wave_divider {TESTBENCH}
add_wave                  $tb/DUT/rst
add_wave                  $tb/DUT/clk
add_wave                  $tb/DUT/state
add_wave -radix unsigned  $tb/DUT/tof_cnt
add_wave -color magenta   $tb/DUT/tof_max
add_wave                  $tb/DUT/tof_clr
add_wave                  $tb/DUT/tof_inc
add_wave                  $tb/DUT/tof_vld


set sim_time {10.0us}
set sim_time {1.32ms}

run $sim_time

# close_sim -force
