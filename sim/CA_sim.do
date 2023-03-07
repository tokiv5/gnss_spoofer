restart -f
force -freeze sim:/l1_ca_generator/clk 0 0, 1 {5000 ps} -r {10 ns}
force -freeze sim:/l1_ca_generator/ENABLE 1 0
force -freeze sim:/l1_ca_generator/rst 1 0
force -freeze sim:/l1_ca_generator/SAT 31 0
run 8 ns
force -freeze sim:/l1_ca_generator/rst 0 0
run 2 ns
run 250 ns