# source sim_bus_decoder.tcl

quit -sim

if {[vsimVersion] >= 2017.09} {
  set opt_args  "-voptargs=+acc -quiet";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.bus_decoder_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
configure wave -valuecolwidth 150

add wave -noupdate -divider {TESTBENCH}
add wave -unsigned  /DUT/C_ADDR_WIDTH
add wave -hex       /DUT/C_BASE_ADDR
add wave -hex       /DUT/C_HIGH_ADDR


add wave            /DUT/bus_sel
add wave -hex       /DUT/bus_addr
add wave            /DUT/dev_sel

add wave -noupdate -divider {bus_decoder}
add wave -unsigned  /DUT/N_dec
add wave -hex       /DUT/bus_addr_up

set sim_time {660 us}

run $sim_time
