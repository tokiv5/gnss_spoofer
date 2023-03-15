restart -f
add wave sim:/acqusition_tb/*
add wave acqusition_tb/uut/i_out_16(3)
add wave acqusition_tb/uut/q_out_16(3)
add wave acqusition_tb/uut/sin_in
add wave acqusition_tb/uut/cos_in
add wave acqusition_tb/uut/mult_i(3)
add wave acqusition_tb/uut/mult_q(3)
add wave acqusition_tb/uut/i_accum(3)
add wave acqusition_tb/uut/q_accum(3)
add wave acqusition_tb/uut/i_accum_16(3)
add wave acqusition_tb/uut/q_accum_16(3)
add wave acqusition_tb/uut/i_square(3)
add wave acqusition_tb/uut/q_square(3)
add wave acqusition_tb/uut/max_accum(3)
add wave acqusition_tb/uut/epoch
add wave acqusition_tb/uut/epoch_accum
add wave acqusition_tb/uut/RP_GEN(3)/ie/r0/PRN_out
add wave acqusition_tb/uut/phase_period_epoch
add wave acqusition_tb/uut/code_phase
add wave acqusition_tb/uut/phaseSAT
add wave acqusition_tb/uut/max_accum
add wave acqusition_tb/uut/local_incr
add wave acqusition_tb/uut/local_incr_16
add wave acqusition_tb/uut/local_input
add wave acqusition_tb/uut/DOPPLER
add wave acqusition_tb/uut/RP_GEN(3)/ie/r0/L0/cont_epoch
run 210000