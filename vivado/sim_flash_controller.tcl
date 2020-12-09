# source sim_flash_controller.tcl

xsim flash_controller_tb -log sim_flash_controller.log

# Herarchical definitions:
set tb          /flash_controller_tb


add_wave_divider {TESTBENCH}
add_wave                  $tb/DUT/rst
add_wave                  $tb/DUT/clk
add_wave -radix hex       $tb/dbg_rd_data

add_wave_divider {FLASH CONTROLLER}
add_wave                  $tb/DUT/usr_rqt
add_wave -co orange       $tb/DUT/usr_done
add_wave -radix hex       $tb/DUT/usr_addr
add_wave                  $tb/DUT/usr_rnw
add_wave -radix hex       $tb/DUT/usr_wr_data
add_wave -radix hex       $tb/DUT/usr_rd_data
add_wave                  $tb/DUT/clk

add_wave                  $tb/DUT/state
add_wave -radix unsigned  $tb/DUT/next_phase_len
add_wave                  $tb/DUT/phase_init
add_wave -radix unsigned  $tb/DUT/phase_len_cnt
add_wave                  $tb/DUT/phase_end

add_wave_divider {OUTPUT CONTROL}
add_wave -co yellow       $tb/DUT/access_start

add_wave                  $tb/DUT/flash_dout_oe
add_wave                  $tb/DUT/flash_din_ce


add_wave -radix hex       $tb/DUT/flash_addr
add_wave -radix hex       $tb/DUT/flash_data
add_wave                  $tb/DUT/flash_cs_n
add_wave                  $tb/DUT/flash_we_n
add_wave                  $tb/DUT/flash_oe_n


set sim_time {450ns}
run $sim_time

# close_sim -force
