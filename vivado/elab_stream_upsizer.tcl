# source elab_stream_upsizer.tcl

if {[current_sim -quiet] != ""} {
  close_sim -force;
}

set prj_dir [get_property DIRECTORY [current_project]];

exec xelab --93_mode --incr --relax -prj $prj_dir/stream_upsizer.prj --debug typical --mt auto -log elab_stream_upsizer.log -L xil_defaultlib -L secureip --snapshot stream_upsizer_tb "work.stream_upsizer_tb"
