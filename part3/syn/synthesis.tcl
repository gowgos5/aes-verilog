# analyse HDL source files
analyze -format verilog {../src/aes_sbox.v ../src/subBytes_top.v ../src/shiftRows_top.v ../src/matrix_mult.v ../src/MixCol_top.v ../src/AddRndKey_top.v ../src/KeySchedule_top.v ../src/AESCore.v ../src/AEScntx.v ../src/AES_top.v}

# elaborate top
elaborate AES_top -architecture verilog

# source constraint file
source constraint.tcl

# compile top module
compile

# retime design
optimize_registers -minimum_period_only -check_design -verbose -print_critical_loop -clock clk

# report critical path
redirect -tee report_timing_setup.txt {report_timing -delay max}
redirect -tee report_timing_hold.txt {report_timing -delay min}

# report area
redirect -tee report_area.txt {report_area}
