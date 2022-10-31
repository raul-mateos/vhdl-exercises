# source sim_moving_average_lite.tcl

quit -sim

if {[vsimVersion] >= 2017.09} {
  set opt_args  "-voptargs=+acc";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.moving_average_lite_tb


set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150

add wave -noupdate -divider {TESTBENCH}
add wave              /rst
add wave              /clk

add wave -signed      /din
add wave              /din_vld

add wave -signed      /dout
add wave              /dout_vld

add wave -noupdate -divider {MOVING AVERAGE}
add wave -signed      /DUT/mem_dout
add wave -signed      /DUT/acc

add wave -noupdate -divider {OUTPUT}
set ANLG_MAX  [expr +(2**15)]
set ANLG_MIN  [expr -(2**15)]
set ANLG_HEIGHT 50

add wave -noupdate -format Analog-Step -height $ANLG_HEIGHT -max $ANLG_MAX -min $ANLG_MIN -decimal /DUT/din
add wave -noupdate -format Analog-Step -height $ANLG_HEIGHT -max $ANLG_MAX -min $ANLG_MIN -decimal /DUT/dout


set sim_time {1.2 us}
set sim_time {20.5 us}

run $sim_time
