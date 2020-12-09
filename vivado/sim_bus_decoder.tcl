# source sim_bus_decoder.tcl

xsim bus_decoder_tb -log sim_bus_decoder.log

# Herarchical definitions:
set tb          /bus_decoder_tb


add_wave_divider {TESTBENCH}
add_wave -radix unsigned  $tb/DUT/C_ADDR_WIDTH
add_wave -radix hex       $tb/DUT/C_BASE_ADDR
add_wave -radix hex       $tb/DUT/C_HIGH_ADDR


add_wave                  $tb/DUT/bus_sel
add_wave -radix hex       $tb/DUT/bus_addr
add_wave                  $tb/DUT/dev_sel

add_wave_divider {bus_decoder}
add_wave -radix unsigned  $tb/DUT/N_dec
add_wave -radix hex       $tb/DUT/bus_addr_up

set sim_time {660us}
run $sim_time

# close_sim -force

