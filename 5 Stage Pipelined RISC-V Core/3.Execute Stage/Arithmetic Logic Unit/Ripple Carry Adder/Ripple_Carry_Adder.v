module Ripple_Carry_Adder#(parameter width = 32)(
    input [width-1:0] A_i,            // First operand input
    input [width-1:0] B_i,            // Second operand input
    input C_i,                        // Carry-in input
    input Sel_i,                      // Operation selector: 0 for addition, 1 for subtraction
    output [width-1:0] Sum_o,         // Output sum/difference
    output C_o,                       // Carry-out output
    output Overflow_o                 // Overflow flag output
);

    // Temporary variables for operands
    wire [width-1:0] temp_A, temp_B;
    wire [width:0] C;                 // Carry bits
    wire [width-1:0] S;               // Sum bits

    // Preprocess operands based on the operation selected
    assign temp_A = A_i; 
    assign temp_B = !Sel_i ? B_i : (~B_i + 1);  // If Sel_i is 1, use 2's complement for subtraction
    assign C[0] = C_i;                         // Initialize carry-in
    assign Sum_o = S;                          // Connect the sum output
    assign C_o = C[width];                     // Final carry-out
    assign Overflow_o = C[width] ^ C[width-1]; // Overflow detection

    // Generate full adders for each bit
    genvar i;
    generate
        for (i = 0; i < width; i = i + 1) begin
            full_adder FA(
                .A(temp_A[i]), 
                .B(temp_B[i]), 
                .Ci(C[i]), 
                .Sum(S[i]), 
                .Co(C[i + 1]) 
            );
        end
    endgenerate
endmodule

module full_adder (
    input A,         // First bit input
    input B,         // Second bit input
    input Ci,        // Carry-in input
    output Sum,      // Sum output
    output Co        // Carry-out output
);

    // Intermediate wires for XOR and AND operations
    wire A_B, A_Ci, A_B_Ci;

    // Logic gates to calculate sum and carry
    xor (A_B, A, B);
    xor (Sum, A_B, Ci);        // Sum is the XOR of A, B, and Ci
    and (A_B_Ci, A_B, Ci);
    and (A_Ci, A, B);
    or  (Co, A_Ci, A_B_Ci );   // Carry out is determined by ORing these terms
endmodule

