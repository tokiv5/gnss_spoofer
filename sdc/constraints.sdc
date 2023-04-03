set_instance_assignment -name VIRTUAL_PIN ON -to INCR_SAT
set_instance_assignment -name VIRTUAL_PIN ON -to phaseSAT
set_instance_assignment -name VIRTUAL_PIN ON -to max_acc_out
create_clock -name "clk" -period 48875ps [get_ports {clk}]
set_false_path -from [get_ports {reset}]
