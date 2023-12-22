# source sim_dna_protect_v1.tcl

quit -sim

if {[vsimVersion] >= 2018.08} {
  set opt_args  "-voptargs=+acc -quiet";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.dna_protect_v1_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
#configure wave -valuecolwidth 100
configure wave -valuecolwidth 150

add wave -noupdate -divider {TESTBENCH}
add wave            /usr_rst
add wave            /usr_clk

add wave            /dna_match
add wave            /dna_timeout

add wave -noupdate -divider {DNA_PROTECT}
add wave -unsigned -radixshowbase 0 /DUT/C_CLK_PERIOD_PS
add wave -unsigned -radixshowbase 0 /DUT/C_TIMEOUT_SEC

add wave              /DUT/usr_rst
add wave              /DUT/usr_clk
add wave              /DUT/state

add wave -unsigned -radixshowbase 0 /DUT/bit_cnt
#add wave -unsigned    /DUT/bit_cnt
add wave              /DUT/bit_clr
add wave              /DUT/bit_inc
add wave              /DUT/bit_end

add wave -hex         /DUT/shift_reg
add wave              /DUT/shift_ld
add wave              /DUT/shift_ce
add wave              /DUT/shift_dout


add wave              /DUT/bit_err
add wave              /DUT/dna_err_i
add wave              /DUT/dna_ok
add wave -co yellow   /DUT/dna_err_vld

#add wave              /DUT/state
#add wave              /DUT/state

add wave              /DUT/usr_rst
add wave              /DUT/usr_clk

add wave              /DUT/usr_dna_ok

add wave -noupdate -divider {TIMEOUT}

add wave -co magenta  /DUT/timeout_run
add wave              /DUT/sec_cnt_clr

add wave              /DUT/prescaler_cnt
add wave              /DUT/prescaler_end

add wave -unsigned -radixshowbase 0 /DUT/sec_cnt
add wave              /DUT/sec_cnt_end

add wave              /DUT/dna_timeout_i


#add wave -co orange   /DUT/prescaler_end


set sim_time {2 us}
set sim_time {500 us}

run $sim_time
