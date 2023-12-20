module Logic_Unit#(parameter width = 32)(  // Module definition with parameter for operand width
    input [width-1:0] A_i,                 // First operand input
    input [width-1:0] B_i,                 // Second operand input
    input [1:0] logic_op,                  // Logic operation type
    output reg [width-1:0] Result_o        // Output result of the logic operation
    );

    // Logic operation based on logic_op input
    always @(*) begin
        case (logic_op)
            2'b00: begin  // AND operation
                Result_o = A_i & B_i;
            end
            2'b01: begin  // XOR operation
                Result_o = A_i ^ B_i;
            end
            2'b10: begin  // OR operation
                Result_o = A_i | B_i;
            end
            default: begin  // Default case, output is zero
                Result_o = {(width){1'b0}};
            end
        endcase
    end
endmodule
