module Datapath #(parameter N = 8) (
    input [N-1:0] a_in,        // 8-bit input a
    input [N-1:0] b_in,        // 8-bit input b
	output [2*N-1:0] result, // Adjust result to be 16 bits
    input clk,                 // Clock signal
    input reset,               // Reset signal
    input start                // Start signal
);
    reg [3:0]Counter = 8;     // 5-bit input BITS
    wire a_ld, b_ld, O_ld;
    wire Counter_ld, Counter_dec;
    wire sel1, sel2;
    wire [1:0] sel3;
    wire Right_enable, Left_enable; 
    wire [1:0] sel_mux_A_sig, sel_mux_B_sig, sel_mux_O_sig;
    wire sub_en, add_en;
    wire pos1, neg1, eq1;
    wire pos2, neg2, eq2;
    wire [2*N-1:0] Left_out, Right_out, Sub_out; // 16-bit signals
    wire [3:0] out_Counter;
    wire [2*N-1:0] out_a, out_b; // 16-bit signals
    wire [2*N-1:0] out_out, add_out; // 16-bit signals
    wire [2*N-1:0] mux1_out, mux2_out, mux3_out; // 16-bit signals
    reg  [2*N-1:0] a, b; // Registers for a and b
    reg  [2*N-1:0] O;    // Register for O
	reg [2*N-1:0] O_in = 0;
	assign result = out_out;
    control_unit control (
        .clk(clk),
        .reset(reset),
        .start(start),  
        .eq1(eq1),
        .eq2(eq2),
        .pos1(pos1), 
        .pos2(pos2),
        .neg1(neg1),
        .neg2(neg2),
        .a_ld(a_ld),
        .b_ld(b_ld),
        .Counter_ld(Counter_ld),
        .sub_en(sub_en),
        .add_en(add_en),
        .O_ld(O_ld),
        .Counter_dec(Counter_dec),
        .Right_enable(Right_enable),
        .Left_enable(Left_enable),
        .sel_mux_A_sig(sel_mux_A_sig),
        .sel_mux_B_sig(sel_mux_B_sig),
        .sel_mux_O_sig(sel_mux_O_sig),
        .sel1(sel1),
        .sel2(sel2),
        .sel3(sel3)
    );

    // Sign extension and mux logic for a
    always @(*) begin
        case (sel_mux_A_sig)
            2'b00: a = {{8{a_in[7]}}, a_in}; // Sign-extended to 16 bits
            2'b01: a = Left_out;             // Shifted value
            2'b10: a = Sub_out;
			2'b11: a = out_a;					// Subtraction result
        endcase
    end

    // Sign extension and mux logic for b
    always @(*) begin
        case (sel_mux_B_sig)
            2'b00: b = {{8{b_in[7]}}, b_in}; // Sign-extended to 16 bits
            2'b01: b = Right_out;            // Shifted value
            2'b10: b = Sub_out;
			2'b11: b = out_b;				// Subtraction result
        endcase
    end

    // Mux logic for O
    always @(*) begin
        case (sel_mux_O_sig)
            2'b00: O = O_in;                 // Original input O
            2'b01: O = add_out;              // Addition result
            2'b10: O = {8'b0, Sub_out};  
			2'b11: O = out_out;				// Zero-padded subtraction result
        endcase
    end

    inp_reg #(.N(2*N)) reg_a (
        .inp_in(a),
        .inp_ld(a_ld),
        .clk(clk),
        .reset(reset),
        .inp_out(out_a)
    );
    
    inp_reg #(.N(2*N)) reg_b (
        .inp_in(b),
        .inp_ld(b_ld),
        .clk(clk),
        .reset(reset),
        .inp_out(out_b)
    );
    
    Counter_reg Counter1 (
        .Counter_in(Counter),
        .Counter_ld(Counter_ld),
        .clk(clk),
        .reset(reset),
        .Counter_out(out_Counter),
        .Counter_dec(Counter_dec)
    );

    mux2to1 #(.N(2*N)) mux1 (
        .a(out_a),
        .b({15'b0, out_b[0]}),
        .sel(sel1),
        .out(mux1_out)
    );

    mux2to1 #(.N(2*N)) mux2 (
        .a(out_b),
        .b({11'b0, out_Counter}),
        .sel(sel2),
        .out(mux2_out)
    );

    mux4to1 #(.N(2*N)) mux3 (
        .a(out_a),
        .b(out_b),
        .c(out_out),
        .d(16'b0),
        .sel(sel3),
        .out(mux3_out)
    );

    comparator #(.N(N)) comp1 (
        .inp1(mux1_out),
        .inp2(8'b0),
        .inp_positive(pos1),
        .inp_negative(neg1),
        .inp_equal(eq1)
    );

    comparator #(.N(N)) comp2 (
        .inp1(mux2_out),
        .inp2(8'b0),
        .inp_positive(pos2),
        .inp_negative(neg2),
        .inp_equal(eq2)
    );

    subtractor #(.N(2*N)) sub1 (
        .a(16'b0),
        .b(mux3_out),
        .out(Sub_out),
        .enable(sub_en)
    );

    adder #(.N(2*N)) add1 (
        .a(out_out),
        .b(out_a),
        .out(add_out),
        .enable(add_en)
    );

    shifter #(.N(2*N)) Right (
        .shift_dir(1'b1),
        .shift_in(out_b),
        .clk(clk),
        .reset(reset),
        .enable(Right_enable), 
        .shift_out(Right_out)
    );

    shifter #(.N(2*N)) LEFT (
        .shift_dir(1'b0),
        .shift_in(out_a), 
        .clk(clk),
        .reset(reset),
        .enable(Left_enable),
        .shift_out(Left_out)
    );

    out_reg #(.N(2*N)) OUTPUT (
        .out_in(O),
        .out_ld(O_ld),
        .clk(clk), 
        .out_out(out_out)
    );

endmodule

