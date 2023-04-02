// nco.v

// Generated using ACDS version 17.1 590

`timescale 1 ps / 1 ps
module nco (
		input  wire        clk,       // clk.clk
		input  wire        clken,     //  in.clken
		input  wire [31:0] phi_inc_i, //    .phi_inc_i
		output wire [11:0] fsin_o,    // out.fsin_o
		output wire [11:0] fcos_o,    //    .fcos_o
		output wire        out_valid, //    .out_valid
		input  wire        reset_n    // rst.reset_n
	);

	nco_nco_ii_0 nco_ii_0 (
		.clk       (clk),       // clk.clk
		.reset_n   (reset_n),   // rst.reset_n
		.clken     (clken),     //  in.clken
		.phi_inc_i (phi_inc_i), //    .phi_inc_i
		.fsin_o    (fsin_o),    // out.fsin_o
		.fcos_o    (fcos_o),    //    .fcos_o
		.out_valid (out_valid)  //    .out_valid
	);

endmodule
