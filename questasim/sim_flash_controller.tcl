# source sim_flash_controller.tcl

quit -sim

if {[vsimVersion] >= 2018.08} {
  set opt_args  "-voptargs=+acc";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.flash_controller_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150

add wave -noupdate -divider {TESTBENCH}
add wave            /DUT/rst
add wave            /DUT/clk
add wave            /dbg_rd_data

add wave -noupdate -divider {FLASH CONTROLLER}
add wave            /DUT/usr_rqt
add wave -co orange /DUT/usr_done
add wave -hex       /DUT/usr_addr
add wave            /DUT/usr_rnw
add wave -hex       /DUT/usr_wr_data
add wave -hex       /DUT/usr_rd_data
add wave            /DUT/clk

add wave            /DUT/state
add wave -unsigned  /DUT/next_phase_len
add wave            /DUT/phase_init
add wave -unsigned  /DUT/phase_len_cnt
add wave            /DUT/phase_end

add wave -noupdate -divider {OUTPUT CONTROL}
add wave -co yellow /DUT/access_start

add wave            /DUT/flash_dout_oe
add wave            /DUT/flash_din_ce


add wave -hex       /DUT/flash_addr
add wave -hex       /DUT/flash_data
add wave            /DUT/flash_cs_n
add wave            /DUT/flash_we_n
add wave            /DUT/flash_oe_n



set sim_time {450 ns}

run $sim_time
