# source sim_dac_serial_port.tcl

xsim dac_serial_port_tb -log sim_dac_serial_port.log

# Herarchical definitions:
set tb          /dac_serial_port_tb


add_wave_divider {TESTBENCH}
add_wave              $tb/DUT/rst
add_wave              $tb/DUT/clk

add_wave -radix hex   $tb/DUT/data_in
add_wave              $tb/DUT/tx_rqt
add_wave              $tb/DUT/tx_ack

add_wave              $tb/DUT/dac_sync_n
add_wave              $tb/DUT/dac_sclk
add_wave              $tb/DUT/dac_din

if {1} {
  add_wave_divider {DAC SERIAL PORT}
  add_wave                    $tb/DUT/clk
  add_wave -radix hex         $tb/DUT/data_in
  add_wave                    $tb/DUT/tx_rqt
  add_wave                    $tb/DUT/tx_ack
  add_wave                    $tb/DUT/state
  add_wave                    $tb/DUT/half_bit_cnt
  add_wave                    $tb/DUT/half_bit_end
  
  add_wave -radix unsigned    $tb/DUT/bit_cnt
  add_wave                    $tb/DUT/last_bit
  
  add_wave                    $tb/DUT/shift_load
  add_wave                    $tb/DUT/shift_en
  add_wave                    $tb/DUT/shift_reg  
  
  add_wave_divider {SERIAL PORT}
  add_wave -color magenta     $tb/DUT/sync_n
  add_wave                    $tb/DUT/sclk  
  add_wave -radix bin         $tb/DUT/din  
}

set sim_time {2us}
set sim_time {2.1us}

run $sim_time

# close_sim -force
