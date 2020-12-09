# source elab_tx_uart.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/tx_uart.prj --debug typical --mt auto -log elab_tx_uart.log -L xil_defaultlib -L secureip --snapshot tx_uart_tb "work.tx_uart_tb"
