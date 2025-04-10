module adder(a, b,enable, out);
	parameter N = 16;
	input signed [N-1:0] a;
	input signed [N-1:0] b;
	output reg signed [N-1:0] out;  
  input enable;
	always @(*) begin
	if (enable)	
		  
			   out = a + b;
	end    
endmodule

module subtractor(a, b,enable, out);
	parameter N = 16;
	input signed [N-1:0] a, b;
	output reg signed [N-1:0] out;  
    input enable;
	always @(*) begin
	if (enable)
			   out = a - b;
	    end
endmodule
