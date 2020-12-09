# source sim_tx_uart.tcl

xsim tx_uart_tb -log sim_tx_uart.log

# Herarchical definitions:
set tb          /tx_uart_tb

add_wave_divider {TESTBENCH}
add_wave                    $tb/rst
add_wave                    $tb/clk

add_wave -radix unsigned    $tb/baud_rate
add_wave                    $tb/enable

add_wave -radix hex         $tb/tx_byte
add_wave                    $tb/tx_rqt
add_wave                    $tb/tx_ack

add_wave -radix bin         $tb/txd

add_wave_divider {TX UART}
add_wave                    $tb/DUT/clk
add_wave -radix hex         $tb/DUT/tx_byte
add_wave                    $tb/DUT/tx_rqt
add_wave                    $tb/DUT/tx_ack
add_wave                    $tb/DUT/state
add_wave                    $tb/DUT/cnt_clr
add_wave -radix unsigned    $tb/DUT/prescaler_cnt
add_wave -co orange         $tb/DUT/prescaler_end

add_wave                    $tb/DUT/bit_inc
add_wave -radix unsigned    $tb/DUT/bit_cnt
#add_wave                   $tb/DUT/bit_end

add_wave                    $tb/DUT/shift_ld
add_wave                    $tb/DUT/shift_en
add_wave -radix bin         $tb/DUT/shift_reg  

add_wave -radix bin         $tb/DUT/parity
#add_wave -radix bin        $tb/DUT/parity2
add_wave -co magenta        $tb/DUT/txd

set sim_time {2us}
set sim_time {500us}

run $sim_time

# close_sim -force

