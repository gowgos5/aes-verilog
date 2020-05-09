# Analyse HDL source files
analyze -format verilog -autoread {../src}

# Elaborate top module
elaborate AES_top

# Apply constraints
source constraint.tcl

# Apply flatten optimisation
set_flatten true -minimize multiple_output

# Perform synthesis
compile_ultra

# Perform retiming
optimize_registers

# Perform final incremental compile
compile_ultra -incremental

# Report timings
redirect -tee report_timing_setup.txt {report_timing -delay max -significant_digits 3}
redirect -tee report_timing_hold.txt {report_timing -delay min -significant_digits 3}

# Report area
redirect -tee report_area.txt {report_area}
