restart -f
add wave sim:/acqusition_tb/*
add wave acqusition_tb/uut/iq_accum(3)
add wave acqusition_tb/uut/max_accum(3)
add wave acqusition_tb/uut/phase_period_epoch
add wave acqusition_tb/uut/code_phase
add wave acqusition_tb/uut/phaseSAT
add wave acqusition_tb/uut/max_accum
add wave acqusition_tb/uut/CA_GEN/code_count
run 10000