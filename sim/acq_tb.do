restart -f
add wave sim:/acqusition_tb/*
add wave acqusition_tb/uut/i_out_16(31)
add wave acqusition_tb/uut/q_out_16(31)
add wave acqusition_tb/uut/sin_in
add wave acqusition_tb/uut/cos_in
add wave acqusition_tb/uut/i_accum(31)
add wave acqusition_tb/uut/q_accum(31)
add wave acqusition_tb/uut/max_accum
add wave acqusition_tb/uut/epoch
add wave acqusition_tb/uut/phase_period_epoch
add wave acqusition_tb/uut/code_phase
add wave acqusition_tb/uut/dopplerSAT
add wave acqusition_tb/uut/phaseSAT
run 100