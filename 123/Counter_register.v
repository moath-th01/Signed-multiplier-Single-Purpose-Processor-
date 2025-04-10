module Counter_reg (Counter_in, Counter_ld, clk, reset, Counter_dec, Counter_out);
	input [3:0]Counter_in;
	input Counter_ld, Counter_dec, clk, reset;
	output reg [3:0]Counter_out;

	always @(posedge clk or posedge reset) begin
		if (reset)
			Counter_out <= 4'b0;
		else if (Counter_ld)
			Counter_out <= Counter_in;
		else if (Counter_dec && Counter_out > 0)
			Counter_out <= Counter_out - 1;
	end
endmodule

