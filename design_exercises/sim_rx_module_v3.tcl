# source sim_rx_module_v3.tcl

quit -sim

if {[vsimVersion] >= 2018.08} {
  set opt_args  "-voptargs=+acc -quiet";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.rx_module_v3_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150


add wave -noupdate -divider {TESTBENCH}
add wave            /rst      
add wave            /clk      
add wave            /rxd
add wave            /rx_frame  
add wave            /rx_clk  
add wave -hex       /dout  
add wave            /dout_vld      

add wave -noupdate -divider {RX MODULE}
add wave            /DUT/rst      
add wave            /DUT/clk      
add wave            /DUT/rxd
add wave            /DUT/rx_frame
add wave            /DUT/rx_clk

add wave -co yellow /DUT/neg_edge

add wave            /DUT/shift_en
add wave -bin       /DUT/shift_reg
add wave -unsigned  /DUT/bit_cnt
add wave            /DUT/bit_ceo
add wave -hex       /DUT/dout  
add wave            /DUT/dout_vld      



set sim_time {8 us}

run $sim_time
