module control_unit (
    input clk,             
    input reset,           
    input start,           
    input eq1, eq2,        
    input pos1, pos2, neg1, neg2, 
    output reg a_ld,      
    output reg sel1,      
    output reg sel2,
    output reg [1:0] sel3,     
    output reg b_ld,      
    output reg Counter_ld,  
    output reg sub_en,     
    output reg add_en,     
    output reg O_ld,      
    output reg Counter_dec,   
    output reg Right_enable, Left_enable, 
    output reg [1:0] sel_mux_A_sig, sel_mux_B_sig, sel_mux_O_sig 
);

    parameter IDLE = 3'b000;
    parameter LOAD = 3'b001;
    parameter SUBTRACT_1 = 3'b010;
    parameter SUBTRACT_2 = 3'b011;
    parameter ADD = 3'b100;
    parameter SHIFT = 3'b101;    
    parameter OUTCHECK = 3'b110;
    parameter DONE = 3'b111;

    reg [2:0] current_state, next_state; 
    reg check1, check2;


    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state; 
    end

    
    always @(*) begin
      
        a_ld = 0;
        b_ld = 0;
        Counter_ld = 0;
        O_ld = 0;
        Counter_dec = 0;
        Right_enable = 0;
        Left_enable = 0;
        sel_mux_A_sig = 2'b00;
        sel_mux_B_sig = 2'b00;
        sel_mux_O_sig = 2'b00;
        sel1 = 0;
        sel2 = 0;
        sel3 = 0;
        sub_en = 0;
        add_en = 0;
        
       
  
  if (current_state == IDLE) begin
            if (start) 
                next_state = LOAD; 
            end
  else if (current_state == LOAD) begin
            a_ld = 1;
            sel_mux_A_sig = 2'b00; 
            b_ld = 1;
            sel_mux_B_sig = 2'b00;
            O_ld=1;
            sel_mux_O_sig=2'b00; 
            Counter_ld = 1; 
            next_state = SUBTRACT_1; 
            end
  else if (current_state == SUBTRACT_1) begin
            sel1 = 1'b0;
            if (neg1) begin
                sel3 = 2'b00;
                sub_en = 1'b1;
                sel_mux_A_sig = 2'b10;  
                a_ld = 1;
                check1 = 1;
            end
            else if (pos1) begin
				check1 = 0;
                sub_en = 0;
                sel_mux_A_sig = 2'b00;
                a_ld = 0;
            end
			 next_state = SUBTRACT_2; 
end
 else if (current_state == SUBTRACT_2) begin
            sel2 =1'b0;
            if (neg2) begin
                sel3 = 2'b01;
                sub_en = 1'b1;
                sel_mux_B_sig = 2'b10;  
                b_ld = 1;
                check2 = 1;
            end else if (pos2) begin
			check2 = 0;
                sub_en = 0;
                sel_mux_B_sig = 2'b00;
                b_ld = 0;
            end
              next_state = ADD; 

            end
 
 
else if (current_state == ADD) begin
    sel1 = 1'b1;  // Set this control signal for the ADD state

    case (eq1)
        1: begin
            // If eq1 == 1, transition to SHIFT without setting the addition signals
            next_state = SHIFT;
        end

        0: begin
            // If eq1 != 1, proceed with addition
            add_en = 1;              // Enable addition
            sel_mux_O_sig = 2'b01;   // Select appropriate mux for O
            O_ld = 1;                // Load O register

            next_state = SHIFT;     // Transition to SHIFT state after addition
        end

     
    endcase
end

  else if (current_state == SHIFT) begin
            Left_enable = 1;
            Right_enable = 1;
            a_ld = 1;
            sel_mux_A_sig = 2'b01;
            b_ld = 1;
            sel_mux_B_sig = 2'b01;
            Counter_dec = 1;
            sel2 = 1;
            if (eq2) begin 
                next_state = OUTCHECK; 
            end else begin
                next_state = ADD; 
            end
            end

  else if (current_state == OUTCHECK) begin
            if (check1 != check2) begin
                sub_en = 1;
                sel3 = 2'b10;
                O_ld = 1;
                sel_mux_O_sig = 2'b10;
                
                next_state = DONE;
            end else 
                next_state = DONE;
            end
  else if (current_state == DONE) begin
             
            end
            end

endmodule
