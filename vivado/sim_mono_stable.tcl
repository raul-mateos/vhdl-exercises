# source sim_mono_stable.tcl

xsim mono_stable_tb -log sim_mono_stable.log

# Herarchical definitions:
set tb          /mono_stable_tb


add_wave_divider {TESTBENCH}
add_wave                  $tb/rst
add_wave                  $tb/clk

add_wave                  $tb/trigger
add_wave -radix unsigned  $tb/pulse_length
add_wave -color orange    $tb/pulse


add_wave_divider {DUT}
add_wave                  $tb/DUT/clk
add_wave                  $tb/DUT/trigger_r
add_wave                  $tb/DUT/pos_edge
add_wave                  $tb/DUT/pulse_init
add_wave -color yellow    $tb/DUT/pulse_i
add_wave -radix unsigned  $tb/DUT/pulse_cnt
add_wave                  $tb/DUT/pulse_end

set sim_time {5.2us}
run $sim_time

# close_sim -force
