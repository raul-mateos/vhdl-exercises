# source comp.tcl

#----

set rtl_src_path                                ../rtl
set rtl_src_path                                .


#set questa_version [exec vcom -version];
#set ver_number [lindex $questa_version 2];

if {[vsimVersion] >= 2018.08} {
  set no_opt  "-O0";
} else {
  set no_opt  "-no_opt";
}

vcom $no_opt -93 -work work       $rtl_src_path/tx_module_v1.vhd
vcom $no_opt -93 -work work       $rtl_src_path/tx_module_v1_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/tx_module_v2.vhd
vcom $no_opt -93 -work work       $rtl_src_path/tx_module_v2_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/tx_module_v3.vhd
vcom $no_opt -93 -work work       $rtl_src_path/tx_module_v3_tb.vhd


vcom $no_opt -93 -work work       $rtl_src_path/rx_module_v1.vhd
vcom $no_opt -93 -work work       $rtl_src_path/rx_module_v1_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/rx_module_v2.vhd
vcom $no_opt -93 -work work       $rtl_src_path/rx_module_v2_tb.vhd

vcom $no_opt -93 -work work       $rtl_src_path/rx_module_v3.vhd
vcom $no_opt -93 -work work       $rtl_src_path/rx_module_v3_tb.vhd
