# source setup_prj.tcl

set script_dir [file dirname [file normalize [info script]]];

config_webtalk -user off
config_webtalk -install off

set prj_name "vhdl-exercises";
set prj_dir  $script_dir;
set prj_part  "xc7a100tcsg324-1";

set project [create_project -force -part $prj_part $prj_name $prj_dir];


set vivado_path $::env(XILINX_Vivado);
set board_file [file join $vivado_path "data/boards/board_files/nexys4_ddr"];
if {[file exists $board_file] && [file isdirectory $board_file]} {
  set_property board_part "digilentinc.com:nexys4_ddr:part0:1.1" $project;
}

set_property "TARGET_LANGUAGE" "VHDL" $project;
set prj_dir  [get_property DIRECTORY [current_project]];
cd $prj_dir
