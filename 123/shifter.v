module shifter(shift_dir, shift_in, clk, reset,enable, shift_out);
	parameter N = 8;
	input [N-1:0] shift_in;	
	input shift_dir, clk, reset,enable;
	output reg [N-1:0] shift_out;

	always @(negedge clk or posedge reset) begin
        if (reset)
            shift_out <= 8'b0;               
                      
        else if (enable) begin
            if (shift_dir)
                shift_out <= shift_in >> 1;         
            else
                shift_out <= shift_in << 1;         
        end
    end

endmodule
