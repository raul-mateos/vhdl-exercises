# source sim_TOF_meter.tcl

quit -sim

if {[vsimVersion] >= 2018.08} {
  set opt_args  "-voptargs=+acc";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.TOF_meter_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150

add wave -noupdate -divider {TESTBENCH}
add wave                /rst
add wave                /clk

add wave                /start
add wave                /echo
add wave -unsigned      /data
add wave                /overrange

add wave -noupdate -divider {TESTBENCH}
add wave                /DUT/rst
add wave                /DUT/clk
add wave                /DUT/state
add wave -unsigned      /DUT/tof_cnt
add wave -co magenta    /DUT/tof_max
add wave                /DUT/tof_clr
add wave                /DUT/tof_inc
add wave                /DUT/tof_vld


set sim_time {10.0 us}
set sim_time {1.32 ms}

run $sim_time
