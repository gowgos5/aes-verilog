# Clock period = 0.5 ns
create_clock -period 0.5 [get_ports clk]

# Input delay = 0.1 ns
set_input_delay 0.1 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]

# Output delay = 0.1 ns
set_output_delay 0.1 -clock clk [all_outputs]

# Load capacitance = 5 fF
set_load 5 [all_outputs]
