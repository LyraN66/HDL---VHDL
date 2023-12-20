module Fetch_Stage_1#(parameter width = 32)(  // Module definition with a parameter for bit-width
    input clk,                                // Clock input
    input rst,                                // Reset input
    input stall_if,                           // Stall signal input
    input flush_if,                           // Flush signal input
    input [width-1:0] inst_if,                // Instruction input
    input [width-1:0] pc_if,                  // Program counter input
    input [width-1:0] pc_plus_4_if,           // Program counter + 4 input
    
    output [width-1:0] instruction_if_id,     // Instruction output to next stage
    output [width-1:0] programc_if_id,        // Program counter output to next stage
    output [width-1:0] programc_plus_4_if_id  // Program counter + 4 output to next stage
    );
    
    reg [width-1:0] instruction_if_id_reg;   // Register to hold the instruction
    reg [width-1:0] pc_if_id_reg;             // Register to hold the program counter
    reg [width-1:0] pc_plus_4_if_id_reg;      // Register to hold the program counter + 4
    
    assign instruction_if_id = instruction_if_id_reg;       // Assigning register value to output
    assign programc_if_id = pc_if_id_reg;                   // Assigning register value to output
    assign programc_plus_4_if_id = pc_plus_4_if_id_reg;     // Assigning register value to output
    
    always @(posedge clk)begin
        if(rst)begin            // Clear registers on reset
            instruction_if_id_reg <= 32'b0;
            pc_if_id_reg <= 32'b0;
            pc_plus_4_if_id_reg <= 32'b0;
        end
        else if (flush_if)begin // Clear registers on flush
            instruction_if_id_reg <= 32'b0;
            pc_if_id_reg <= 32'b0;
            pc_plus_4_if_id_reg <= 32'b0;
        end
        else if (stall_if)begin // Keep current values on stall
            instruction_if_id_reg <= instruction_if_id_reg;
            pc_if_id_reg <= pc_if_id_reg;
            pc_plus_4_if_id_reg <= pc_plus_4_if_id_reg;
        end
        else begin              // Update registers with new values
            instruction_if_id_reg <= inst_if;
            pc_if_id_reg <= pc_if;
            pc_plus_4_if_id_reg <= pc_plus_4_if;
        end
    end
endmodule
