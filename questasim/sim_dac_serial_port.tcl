# source sim_dac_serial_port.tcl

quit -sim

if {[vsimVersion] >= 2017.09} {
  set opt_args  "-voptargs=+acc";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.dac_serial_port_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150

add wave -noupdate -divider {TESTBENCH}
add wave            /DUT/rst
add wave            /DUT/clk

add wave -hex       /DUT/data_in
add wave            /DUT/tx_rqt
add wave            /DUT/tx_ack

add wave            /DUT/dac_sync_n
add wave            /DUT/dac_sclk
add wave            /DUT/dac_din

if {1} {
  add wave -noupdate -divider {DAC SERIAL PORT}
  add wave              /DUT/clk
  add wave -hex         /DUT/data_in
  add wave              /DUT/tx_rqt
  add wave              /DUT/tx_ack
  add wave              /DUT/state
  add wave              /DUT/half_bit_cnt
  add wave              /DUT/half_bit_end
  
  add wave -unsigned    /DUT/bit_cnt
  add wave              /DUT/last_bit
  
  add wave              /DUT/shift_load
  add wave              /DUT/shift_en
  add wave              /DUT/shift_reg  
  
  add wave -noupdate -divider {SERIAL PORT}
  add wave -co magenta  /DUT/sync_n
  add wave              /DUT/sclk  
  add wave -literal     /DUT/din  
}

set sim_time {2 us}
set sim_time {2.1 us}

run $sim_time
