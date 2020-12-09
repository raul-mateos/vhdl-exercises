# source sim_t_on_limiter.tcl

xsim t_on_limiter_tb -log sim_t_on_limiter.log

# Herarchical definitions:
set tb          /t_on_limiter_tb


add_wave_divider {TESTBENCH}
add_wave                  $tb/DUT/rst
add_wave                  $tb/DUT/clk

add_wave -radix unsigned  $tb/DUT/max_t_on
add_wave                  $tb/DUT/din
add_wave                  $tb/DUT/dout

add_wave_divider {T_ON LIMITER}
add_wave                  $tb/DUT/clk
add_wave                  $tb/DUT/din_pos_edge
add_wave -color orange    $tb/DUT/enable

add_wave -radix unsigned  $tb/DUT/time_cnt
add_wave                  $tb/DUT/time_cnt_end


add_wave_divider {OUTPUT}
add_wave                  $tb/DUT/din_r
add_wave                  $tb/DUT/enable
add_wave -color yellow    $tb/DUT/dout


set sim_time {3.1us}
run $sim_time

# close_sim -force
