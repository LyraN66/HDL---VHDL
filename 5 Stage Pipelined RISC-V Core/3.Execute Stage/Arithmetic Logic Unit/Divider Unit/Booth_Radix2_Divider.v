module Booth_Radix2_Divider#(parameter width = 32)(  // Module definition with parameter for operand width
    input clk,                                     // Clock input
    input rst_i,                                   // Reset input
    input [width-1:0] divident,                    // Dividend input
    input [width-1:0] divisor,                     // Divisor input
    input return_remainder_or_queotient,           // Flag to return remainder (1) or quotient (0)
    input start_flag,                              // Start operation flag
    output reg busy_o,                             // Output flag indicating operation in progress
    output reg valid_o,                            // Output flag indicating valid result
    output reg error_o,                            // Output flag indicating error (like division by zero)
    output reg [width-1:0] result_o                // Output result of the division
    );

    reg [2*width:0] A_Q_reg;                       // Combined register for A and Q
    reg [width:0] B_reg;                           // Register for the divisor
    reg [5:0] count;                               // Counter for the division steps
    reg start_reg;                                 // Internal start flag
    reg clear_reg;                                 // Flag to clear internal registers
    
    // Intermediate wires for the division process
    wire [2*width:0] A_Q_reg_shift = A_Q_reg << 1; // Shift combined A and Q register left by 1
    wire [width:0] A_subtract_B = A_Q_reg_shift[2*width:width] + B_reg; // Subtract B from upper half of A_Q
    wire [width-1:0] remainder = A_Q_reg[2*width-1:width];  // Extract remainder
    wire [width-1:0] queotient = A_Q_reg[width-1:0];        // Extract quotient

    // Main sequential logic for performing division
    always @(posedge clk) begin
        if(rst_i) begin  // Reset logic
            A_Q_reg <= {(2*width+1){1'b0}};
            B_reg <= {(width+1){1'b0}};
            count <= {(width+1){1'b0}};
            busy_o <= 1'b0;
            valid_o <= 1'b0;
            result_o <= {(width){1'b0}};
            start_reg <= 1'b0;
            clear_reg <= 1'b0;
            error_o <= 1'b0;
        end
        else if(start_flag && (divisor != 0)) begin  // Start division process
            A_Q_reg <= {{(width+1){1'b0}}, divident};
            B_reg <= (~({1'b0, divisor}) + 1);  // Calculate two's complement of divisor
            busy_o <= 1'b1;
            error_o <= 1'b0;
            count <= width;
            start_reg <= 1'b1;
        end
        else if(start_reg) begin  // Division operation
            A_Q_reg <= A_Q_reg_shift;  // Shift left operation
            if(A_subtract_B[width]) begin
                A_Q_reg[0] <= 1'b0;
            end
            else begin
                A_Q_reg[0] <= 1'b1;
                A_Q_reg[2*width:width] <= A_subtract_B;
            end
            if(!count) begin  // Check if division steps are completed
                busy_o <= 1'b0;
                valid_o <= 1'b1;
                result_o <= return_remainder_or_queotient ? remainder : queotient;
                clear_reg <= 1'b1;
                start_reg <= 1'b0;
            end
            else begin
                count <= count - 1;
            end
        end
        else if(clear_reg) begin  // Clear internal registers
            A_Q_reg <= {(2*width+1){1'b0}};
            B_reg <= {(width+1){1'b0}};
            valid_o <= 1'b0;
            busy_o <= 1'b0;
            clear_reg <= 1'b0;
        end
        else if(start_flag && !divisor) begin  // Error case: Division by zero
            error_o <= 1'b1;
        end
    end
endmodule
