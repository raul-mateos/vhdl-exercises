# source sim_tx_module_v3.tcl

quit -sim

if {[vsimVersion] >= 2018.08} {
  set opt_args  "-voptargs=+acc -quiet";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.tx_module_v3_tb

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
add wave            /tx_frame 
add wave            /tx_clk   

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
add wave -unsigned  /DUT/len_cnt
add wave -co orange /DUT/len_tc

add wave -unsigned  /DUT/hb_cnt
add wave -co yellow /DUT/hb_ceo

add wave -unsigned  /DUT/bit_cnt
add wave            /DUT/bit_ceo

add wave -noupdate -divider {TX_MODULE OUTPUT}
add wave            /DUT/txd      
add wave            /DUT/tx_frame 
add wave            /DUT/tx_clk   


set sim_time {10 us}

run $sim_time
