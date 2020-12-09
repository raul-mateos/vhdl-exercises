# source setup_prj.tcl

set script_dir [file dirname [file normalize [info script]]];

set cur_prj [project env];
if {$cur_prj != ""} {
  project close;
}

set prj_dir $script_dir;

cd $prj_dir
project new $prj_dir vhdl-exercises


