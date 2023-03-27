create_clock -name "clk" -period 48875ps [get_ports {clk}]
set_false_path -from [get_ports {reset}]
