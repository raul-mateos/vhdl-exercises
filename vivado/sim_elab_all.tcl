# source sim_elab_all.tcl

set prj_dir  [get_property DIRECTORY [current_project]];

source "$prj_dir/elab_bus_decoder.tcl"
source "$prj_dir/elab_mux_one_hot.tcl"

  source "$prj_dir/elab_mono_stable.tcl"
  source "$prj_dir/elab_t_on_limiter.tcl"
  source "$prj_dir/elab_pwm_generator_simple.tcl"
  source "$prj_dir/elab_pwm_generator.tcl"
  source "$prj_dir/elab_TOF_meter.tcl"
  source "$prj_dir/elab_moving_average.tcl"
  source "$prj_dir/elab_stream_upsizer.tcl"
  source "$prj_dir/elab_dac_serial_port.tcl"
source "$prj_dir/elab_tx_uart.tcl"
  source "$prj_dir/elab_flash_controller.tcl"
 