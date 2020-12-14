# source sim_stream_upsizer.tcl

quit -sim

if {[vsimVersion] >= 2017.09} {
  set opt_args  "-voptargs=+acc";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.stream_upsizer_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150

add wave -noupdate -divider {TESTBENCH}
add wave            /DUT/rst
add wave            /DUT/clk

add wave -hex       /DUT/din
add wave            /DUT/din_start
add wave            /DUT/din_end
add wave            /DUT/din_vld

add wave -hex       /DUT/dout
add wave            /DUT/dout_strb
add wave            /DUT/dout_start
add wave            /DUT/dout_end
add wave            /DUT/dout_vld

add wave -noupdate -divider {UPSIZER}
add wave -bin       /DUT/byte_sel
add wave            /DUT/first_word
add wave            /DUT/last_byte


set sim_time {400 ns}

run $sim_time
