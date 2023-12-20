module Mux_2#(parameter width = 32)(
    input [2:0] ResultSrc,                 // Control signal to select the output source
    input [width-1:0] alu_result_mux,      // Input from ALU result
    input [width-1:0] data_memory_mux,     // Input from data memory
    input [width-1:0] i_pc_plus4_mux,      // Input from incremented PC
    input [width-1:0] ext_imm_mux,         // Input from extended immediate value
    input [width-1:0] pc_target2_mux,      // Input from PC target
    output reg [width-1:0] output_mux      // Output of the multiplexer
);

    // Logic to select the output based on ResultSrc control signal
    always @(*) begin
        case (ResultSrc)
            3'b000: begin
                output_mux = alu_result_mux;   // Select ALU result
            end
            3'b001: begin
                output_mux = data_memory_mux;  // Select data memory output
            end
            3'b010: begin
                output_mux = i_pc_plus4_mux;   // Select incremented PC value
            end
            3'b011: begin
                output_mux = ext_imm_mux;      // Select extended immediate value
            end
            3'b100: begin
                output_mux = pc_target2_mux;   // Select PC target value
            end
            default: begin
                output_mux = {(width){1'b0}};  // Default output (zero)
            end
        endcase
    end
endmodule
