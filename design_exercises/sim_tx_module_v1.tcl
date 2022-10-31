# source sim_tx_module_v1.tcl

quit -sim

if {[vsimVersion] >= 2018.08} {
  set opt_args  "-voptargs=+acc -quiet";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.tx_module_v1_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150


add wave -noupdate -divider {TESTBENCH}
add wave            /rst      
add wave            /clk      
add wave            /usr_din  
add wave            /usr_rqt  
add wave            /usr_ack  
add wave            /txd      

add wave -noupdate -divider {TX_MODULE}
add wave            /DUT/rst      
add wave            /DUT/clk      
add wave            /DUT/usr_din  
add wave            /DUT/usr_rqt  
add wave            /DUT/usr_ack
add wave            /DUT/state
add wave            /DUT/shift_ld
add wave            /DUT/shift_en
add wave            /DUT/shift_reg
add wave            /DUT/cnt_clr
add wave -unsigned  /DUT/bit_cnt
add wave            /DUT/bit_tc

add wave -noupdate -divider {TX_MODULE OUTPUT}
add wave            /DUT/txd      



set sim_time {2 us}

run $sim_time
