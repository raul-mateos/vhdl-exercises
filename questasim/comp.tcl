# source comp.tcl


#----

set rtl_src_path        ../vhdl_src

#set questa_version [exec vcom -version];
#set ver_number [lindex $questa_version 2];

if {[vsimVersion] >= 2017.09} {
  set no_opt  "-O0";
} else {
  set no_opt  "-no_opt";
}


vcom $no_opt -93 -work work       $rtl_src_path/t_on_limiter.vhd
vcom $no_opt -93 -work work       $rtl_src_path/t_on_limiter_tb.vhd




vcom $no_opt -93 -work work       $rtl_src_path/bus_decoder.vhd
vcom $no_opt -93 -work work       $rtl_src_path/bus_decoder_carry.vhd
vcom $no_opt -93 -work work       $rtl_src_path/bus_decoder_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/mux_one_hot.vhd
vcom $no_opt -93 -work work       $rtl_src_path/mux_one_hot_gen.vhd

vcom $no_opt -93 -work work       $rtl_src_path/mono_stable.vhd
vcom $no_opt -93 -work work       $rtl_src_path/mono_stable_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/t_on_limiter.vhd
vcom $no_opt -93 -work work       $rtl_src_path/t_on_limiter_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/pwm_generator_simple.vhd
vcom $no_opt -93 -work work       $rtl_src_path/pwm_generator_simple_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/pwm_generator.vhd
vcom $no_opt -93 -work work       $rtl_src_path/pwm_generator_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/TOF_meter.vhd
vcom $no_opt -93 -work work       $rtl_src_path/TOF_meter_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/moving_average_lite.vhd
vcom $no_opt -93 -work work       $rtl_src_path/moving_average_lite_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/moving_average.vhd
vcom $no_opt -93 -work work       $rtl_src_path/moving_average_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/stream_upsizer.vhd
vcom $no_opt -93 -work work       $rtl_src_path/stream_upsizer_tb.vhd

#vcom $no_opt -93 -work work       $rtl_src_path/dac_serial_port_2.vhd
vcom $no_opt -93 -work work       $rtl_src_path/dac_serial_port.vhd
vcom $no_opt -93 -work work       $rtl_src_path/dac_serial_port_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/tx_uart.vhd
vcom $no_opt -93 -work work       $rtl_src_path/tx_uart_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/flash_controller.vhd
vcom $no_opt -93 -work work       $rtl_src_path/flash_mem.vhd
vcom $no_opt -93 -work work       $rtl_src_path/flash_controller_tb.vhd


vcom $no_opt -93 -work work       $rtl_src_path/decoder.vhd
vcom $no_opt -93 -work work       $rtl_src_path/ring_counter_2.vhd

