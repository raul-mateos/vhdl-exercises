# source sim_tx_uart.tcl

quit -sim

if {[vsimVersion] >= 2018.08} {
  set opt_args  "-voptargs=+acc";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.tx_uart_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150

add wave -noupdate -divider {TESTBENCH}
add wave            /rst
add wave            /clk

add wave -unsigned  /baud_rate
add wave            /enable

add wave -hex       /tx_byte
add wave            /tx_rqt
add wave            /tx_ack

add wave -literal   /txd

add wave -noupdate -divider {TX UART}
add wave              /DUT/clk
add wave -hex         /DUT/tx_byte
add wave              /DUT/tx_rqt
add wave              /DUT/tx_ack
add wave              /DUT/state
add wave              /DUT/cnt_clr
add wave -unsigned    /DUT/prescaler_cnt
add wave -co orange   /DUT/prescaler_end

add wave              /DUT/bit_inc
add wave -unsigned    /DUT/bit_cnt
#add wave              /DUT/bit_end

add wave              /DUT/shift_ld
add wave              /DUT/shift_en
add wave -bin         /DUT/shift_reg  

add wave -literal     /DUT/parity
#add wave -literal     /DUT/parity2
add wave -co magenta  /DUT/txd

set sim_time {2 us}
set sim_time {500 us}

run $sim_time
