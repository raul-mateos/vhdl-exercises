# source sim_t_on_limiter.tcl

quit -sim

if {[vsimVersion] >= 2017.09} {
  set opt_args  "-voptargs=+acc -quiet";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.t_on_limiter_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
configure wave -valuecolwidth 150

add wave -noupdate -divider {TESTBENCH}
add wave            /DUT/rst
add wave            /DUT/clk

add wave -unsigned  /DUT/max_t_on
add wave            /DUT/din
add wave            /DUT/dout

add wave -noupdate -divider {T_ON LIMITER}
add wave            /DUT/clk
add wave            /DUT/din_pos_edge
add wave -co orange /DUT/enable

add wave -unsigned  /DUT/time_cnt
add wave            /DUT/time_cnt_end


add wave -noupdate -divider {OUTPUT}
add wave            /DUT/din_r
add wave            /DUT/enable
add wave -co yellow /DUT/dout


set sim_time {3.1 us}

run $sim_time
