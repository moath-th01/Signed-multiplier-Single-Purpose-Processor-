module tb_Datapath;

    // Parameters
    parameter N = 8;  // Bit width of the inputs and outputs

    // Inputs to the Datapath module
    reg [N-1:0] a_in, b_in;
    reg clk, reset, start;

    // Outputs from the Datapath module
    wire [2*N-1:0] result;  // Declare result as wire (multi-bit output)

    // Instantiate the Datapath module
    Datapath #(.N(N)) uut (
        .a_in(a_in),
        .b_in(b_in),
        .clk(clk),
        .reset(reset),
        .start(start),
        .result(result)  // Connect result properly
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5ns (clock period = 10ns)
    end

    // Testbench initialization
    initial begin
        // Initialize the signals
        clk = 0;
        reset = 1;
        start = 0;

        // Apply reset
        #10 reset = 0;

        // Provide inputs
        a_in = 8'd127;  // Load A with 127
        b_in = 8'd128;   // Load B with 30
        start = 1;

        #260 $stop;  // Stop simulation after 260 time units
    end

    // Monitor the output and signals
    initial begin
        $monitor("Time: %0t | Counter: %d | a_in: %b | b_in: %b | Result: %d",
                 $time, uut.Counter1.Counter_out, uut.reg_a.inp_out, uut.reg_b.inp_out, $signed(result));
    end

endmodule
