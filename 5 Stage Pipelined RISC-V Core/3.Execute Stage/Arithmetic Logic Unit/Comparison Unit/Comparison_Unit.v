module Comparison_Unit#(parameter width = 32)(  // Module definition with parameter for operand width
    input [width-1:0] A_i,                     // First operand input
    input [width-1:0] B_i,                     // Second operand input
    input [2:0] cmp_op,                        // Comparison operation type
    output reg [width-1:0] Result_o            // Output result of the comparison
    );

    // Interpreting the inputs as signed values
    wire signed [width-1:0] A_i_wire = A_i;
    wire signed [width-1:0] B_i_wire = B_i;

    // Comparison operations
    wire equal = (A_i == B_i) ? 1'b1 : 1'b0;              // Check if A and B are equal
    wire greater_than = (A_i >= B_i) ? 1'b1 : 1'b0;       // Check if A is greater than or equal to B

    // Evaluate based on comparison operation type
    always @(*)begin
        if(cmp_op==3'b000)begin        // Equal
            Result_o = (equal) ? (32'h00000001):(32'h00000000);
        end
        else if (cmp_op==3'b001)begin  // Not Equal
            Result_o = (!equal) ? (32'h00000001):(32'h00000000);
        end
        else if (cmp_op==3'b010)begin  // Greater
            Result_o = (!equal && greater_than) ? (32'h00000001):(32'h00000000);
        end
        else if (cmp_op==3'b011)begin  // Greater Than
            Result_o = (greater_than) ? (32'h00000001):(32'h00000000);
        end
        else if (cmp_op==3'b100)begin  // Less Than
            Result_o = (!greater_than) ? (32'h00000001):(32'h00000000);
        end
        else if (cmp_op==3'b101)begin  // Less Than signed
            Result_o = (A_i_wire<B_i_wire) ? (32'h00000001):(32'h00000000);
        end
        else if (cmp_op==3'b110)begin  // Greater Than Signed
            Result_o = (A_i_wire>=B_i_wire) ? (32'h00000001):(32'h00000000);
        end
        else begin
            Result_o = {(width){1'b0}};
        end
    end
endmodule
