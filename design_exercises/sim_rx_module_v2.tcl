# source sim_rx_module_v2.tcl

quit -sim

if {[vsimVersion] >= 2018.08} {
  set opt_args  "-voptargs=+acc -quiet";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.rx_module_v2_tb

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
#add wave            /rx_clk  
add wave -hex       /dout  
add wave            /dout_vld      

add wave -noupdate -divider {RX MODULE}
add wave            /DUT/rst      
add wave            /DUT/clk      
add wave            /DUT/rxd
add wave            /DUT/rx_frame
add wave -co orange /DUT/shift_en
add wave -bin       /DUT/shift_reg
add wave -unsigned  /DUT/bit_cnt
add wave            /DUT/bit_tc
add wave -hex       /DUT/dout  
add wave            /DUT/dout_vld      

set sim_time {2.5 us}

run $sim_time
