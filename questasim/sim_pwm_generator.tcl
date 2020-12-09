# source sim_pwm_generator.tcl

quit -sim

if {[vsimVersion] >= 2018.08} {
  set opt_args  "-voptargs=+acc -quiet";
} else {
  set opt_args  "-novopt +acc";
}

vsim $opt_args -t 1ps work.pwm_generator_tb

set NumericStdNoWarnings 1
configure wave -signalnamewidth 1
configure wave -namecolwidth  160
configure wave -valuecolwidth 150


add wave -noupdate -divider {TESTBENCH}
add wave              /DUT/rst
add wave              /DUT/clk

add wave -unsigned    /DUT/period
add wave -unsigned    /DUT/duty_cycle
add wave -co orange   /DUT/pwm_out

add wave -noupdate -divider {SYSTEM TOP}
add wave              /DUT/rst
add wave              /DUT/clk

add wave              /DUT/state
add wave -unsigned    /DUT/carrier
add wave -co orange   /DUT/up_down
add wave              /DUT/carrier_max
add wave              /DUT/carrier_min

add wave              /DUT/period_end
add wave -co magenta  /DUT/pwm_out


add wave -noupdate -divider {ANALOG}

set ANLG_MAX  500
set ANLG_MIN  0
set ANLG_HEIGHT 80

add wave -noupdate -format Analog-Step -height $ANLG_HEIGHT -max $ANLG_MAX -min $ANLG_MIN -unsigned    /DUT/carrier



set sim_time {1 ms}

run $sim_time
