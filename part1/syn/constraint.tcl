# Clock period = 2 ns
create_clock -period 2 [get_ports clk]

# Input delay = 0.2 ns
set_input_delay 0.2 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]

# Output delay = 0.2 ns
set_output_delay 0.2 -clock clk [all_outputs]

# Load capacitance = 5 fF
set_load 5 [all_outputs]
