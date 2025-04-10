module out_reg (out_in, out_ld, clk, out_out);
	parameter N = 8;
	input signed [N-1:0] out_in;  // Make out_in an N-bit input
	input out_ld, clk;
	output reg signed [N-1:0] out_out;  // Make out_out an N-bit output
	
	always @(posedge clk) begin
		if (out_ld)
			out_out <= out_in;  // Load out_in into out_out when out_ld is high
	end
endmodule
