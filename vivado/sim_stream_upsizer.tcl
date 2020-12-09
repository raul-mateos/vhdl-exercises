# source sim_stream_upsizer.tcl

xsim stream_upsizer_tb -log sim_stream_upsizer.log

# Herarchical definitions:
set tb          /stream_upsizer_tb


add_wave_divider {TESTBENCH}
add_wave            $tb/DUT/rst
add_wave            $tb/DUT/clk

add_wave -radix hex       $tb/DUT/din
add_wave            $tb/DUT/din_start
add_wave            $tb/DUT/din_end
add_wave            $tb/DUT/din_vld

add_wave -radix hex       $tb/DUT/dout
add_wave            $tb/DUT/dout_strb
add_wave            $tb/DUT/dout_start
add_wave            $tb/DUT/dout_end
add_wave            $tb/DUT/dout_vld

add_wave_divider {UPSIZER}
add_wave -radix bin       $tb/DUT/byte_sel
add_wave            $tb/DUT/first_word
add_wave            $tb/DUT/last_byte


set sim_time {400ns}

run $sim_time
