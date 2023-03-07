
module altera_cordic (
	clk,
	areset,
	a,
	c,
	s,
	en);	

	input		clk;
	input		areset;
	input	[15:0]	a;
	output	[12:0]	c;
	output	[12:0]	s;
	input	[0:0]	en;
endmodule
