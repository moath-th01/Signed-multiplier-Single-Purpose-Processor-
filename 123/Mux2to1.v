module mux2to1( a, b, sel, out);
  parameter N=8;
  input [N-1:0]a;
  input [N-1:0] b;
  input sel;       // Inputs
  output reg [N-1:0] out;        // Output as a reg type

  always @(*) begin
    if (sel) 
      out = b;      // Select 'b' if 'sel' is 1
    else 
      out = a;      // Select 'a' if 'sel' is 0
  end
endmodule


module mux4to1 #(parameter N=8) (
    input [N-1:0] a,   // 8-bit input a
    input [N-1:0] b,   // 8-bit input b
    input [N-1:0] c,   // 8-bit input c
    input [N-1:0] d,   // 8-bit input d
    input [1:0] sel,   // 2-bit select signal
    output reg [N-1:0] out  // Output as reg type
);

    always @(*) begin
        case (sel)
            2'b00: out = a;   // When sel = 00, select a
            2'b01: out = b;   // When sel = 01, select b
            2'b10: out = c;   // When sel = 10, select c
            2'b11: out = d;   // When sel = 11, select d
            default: out = d; // Default case (if invalid sel)
        endcase
    end

endmodule




