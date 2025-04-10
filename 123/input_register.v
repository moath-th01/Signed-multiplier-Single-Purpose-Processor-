module inp_reg (inp_in, inp_out, inp_ld, clk, reset);
	parameter N = 8;
	input signed [N-1:0] inp_in;
	input inp_ld, clk, reset;
	output reg signed [N-1:0] inp_out;
	
	always @(posedge clk or posedge reset) begin
		if (reset)
			inp_out <= 0;  // Reset the register value to 0
		else if (inp_ld)
			inp_out <= inp_in;  // Load inp_in into inp_out when inp_ld is high
	end
endmodule
