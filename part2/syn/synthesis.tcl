# Analyse HDL source files
analyze -format verilog -autoread {../src}

# Elaborate top module
elaborate AES_top

# Apply constraints
source constraint.tcl

# Perform synthesis
compile

# Report timings
redirect -tee report_timing_setup.txt {report_timing -delay max -significant_digits 3}
redirect -tee report_timing_hold.txt {report_timing -delay min -significant_digits 3}

# Report area
redirect -tee report_area.txt {report_area}

# Display a summary of all violations in the current design
report_constraint -all_violators
