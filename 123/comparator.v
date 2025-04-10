module comparator( inp1, inp2, inp_positive, inp_negative,inp_equal);
	parameter N = 16;
	input signed [N-1:0]inp1, inp2;
	output  inp_positive, inp_negative,inp_equal;

	assign inp_positive = (inp1 > inp2); 
	assign inp_negative = (inp1 < inp2); 
	 
	assign inp_equal = (inp1 == inp2);
endmodule