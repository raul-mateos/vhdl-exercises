# source sim_mono_stable.tcl

quit -sim

if {[vsimVersion] >= 2018.08} {
  set opt_args  "-voptargs=+acc -quiet";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.mono_stable_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150


add wave -noupdate -divider {TESTBENCH}
add wave            /DUT/rst
add wave            /DUT/clk

add wave            /DUT/trigger
add wave -unsigned  /DUT/pulse_length
add wave -co orange /DUT/pulse


add wave -noupdate -divider {DUT}
add wave            /DUT/clk
add wave            /DUT/trigger_r
add wave            /DUT/pos_edge
add wave            /DUT/pulse_init
add wave -co yellow /DUT/pulse_i
add wave -unsigned  /DUT/pulse_cnt
add wave            /DUT/pulse_end

set sim_time {5.2 us}

run $sim_time
