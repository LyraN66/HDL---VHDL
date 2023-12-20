module Booth_Radix4_Multiplier #(parameter WIDTH = 32)(
    input clk,                            // Clock input
    input rst,                            // Reset input
    input [WIDTH-1:0] rs1,                // First operand input
    input [WIDTH-1:0] rs2,                // Second operand input
    input start,                          // Start signal for multiplication
    output reg [WIDTH-1:0] result,        // Result of multiplication (24 MSBs)
    output reg valid,                     // Signal indicating if result is valid
    output reg busy                       // Signal indicating if unit is busy
);

    // Internal registers
    reg [2*WIDTH-1:0] product = 0;        // Product register
    reg [2*WIDTH-1:0] multiplicand;       // Multiplicand register
    reg [2*WIDTH-1:0] multiplier;         // Multiplier register
    reg [$clog2(WIDTH):0] counter = 0;    // Counter for iteration steps
    reg start_reg = 0;                    // Internal start signal

    // Calculate partial products and their accumulation
    wire [2:0] current_bits = multiplier[2:0]; 
    wire [2*WIDTH-1:0] partial_product0 = multiplicand << (counter * 3);
    wire [2*WIDTH-1:0] partial_product1 = multiplicand << (counter * 3 + 1);
    wire [2*WIDTH-1:0] partial_product2 = multiplicand << (counter * 3 + 2);
    wire [2*WIDTH-1:0] add0 = product + (current_bits[0] ? partial_product0 : 0);
    wire [2*WIDTH-1:0] add1 = add0 + (current_bits[1] ? partial_product1 : 0);
    wire [2*WIDTH-1:0] add2 = add1 + (current_bits[2] ? partial_product2 : 0);

    // Main sequential logic for performing Booth Radix-4 multiplication
    always @(posedge clk) begin
        if (rst) begin  // Reset logic
            start_reg <= 0;
            product <= 0;
            multiplicand <= 0;
            multiplier <= 0;
            counter <= 0;
            valid <= 0;
            busy <= 0;
            result <= 0;
        end else begin
            start_reg <= start;
    
            if ((start_reg || start) && !busy) begin  // Initialize multiplication
                multiplicand <= rs1;
                multiplier <= rs2;
                product <= 0;
                counter <= 0;
                busy <= 1;
                valid <= 0;
                result <= 0;
            end else if (busy && counter < WIDTH/3) begin  // Perform multiplication steps
                product <= add2;
                multiplier <= multiplier >> 3;
                counter <= counter + 1;
            end else if (counter == WIDTH/3) begin  // Complete multiplication
                result <= add2[WIDTH-1:0]; 
                counter <= 0; 
                valid <= 1;
                busy <= 0;
            end else if (valid) begin
                valid <= 0;  // Reset valid signal
            end
        end
    end
endmodule
