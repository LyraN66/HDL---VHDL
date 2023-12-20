module Instruction_Decoder_1#(parameter width = 32)(  // Module definition with parameter for instruction width
    input [width-1:0] instruction,  // Full instruction input
    output reg [20:0] immediate,    // Extracted immediate value
    output reg [6:0] funct7,        // Function field 7-bit
    output reg [4:0] rs2_addr,      // Source register 2 address
    output reg [4:0] rs1_addr,      // Source register 1 address
    output reg [2:0] funct3,        // Function field 3-bit
    output reg [4:0] rd_addr,       // Destination register address
    output reg [6:0] op             // Opcode
    );

    // Initialize outputs to zero
    initial begin
        funct7 = 7'b0; rs2_addr = 5'b0; rs1_addr = 5'b0; funct3 = 3'b0; rd_addr = 5'b0;
        immediate = 21'b0; op = 7'b0;
    end

    // Extract the opcode from the instruction
    wire [6:0] op_instruction = instruction[6:0];

    // Control logic to decode the instruction based on opcode
    always @(*)begin
        case (op_instruction)
            7'd51: begin  // R Type 
                funct7 = instruction[31:25]; rs2_addr = instruction[24:20]; rs1_addr = instruction[19:15]; funct3 = instruction[14:12]; rd_addr = instruction[11:7];
                immediate = 21'b0; op = instruction[6:0];
            end            
            7'd3, 7'd19, 7'd103 : begin  // I Type 
                immediate = {9'b0,instruction[31:20]}; rs1_addr = instruction[19:15]; funct3 = instruction[14:12]; rd_addr = instruction[11:7];
                funct7 = 7'b0; rs2_addr = 5'b0; op = instruction[6:0];
            end
            7'd35: begin  // S Type  
                funct7 = 7'b0; rs2_addr = instruction[24:20]; rs1_addr = instruction[19:15]; funct3 = instruction[14:12]; rd_addr = 5'b0;
                immediate = {9'b0,instruction[31:25],instruction[11:7]}; op = instruction[6:0];
            end
            7'd99: begin  // B Type 
                funct7 = 7'b0; rs2_addr = instruction[24:20]; rs1_addr = instruction[19:15]; funct3 = instruction[14:12]; rd_addr = 5'b0;
                immediate = {8'b0,instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0}; op = instruction[6:0];
            end
            7'd23, 7'd55: begin  // U Type 
                funct7 = 7'b0; rs2_addr = 5'b0; rs1_addr = 5'b0; funct3 = 3'b0; rd_addr = instruction[11:7];
                immediate = {1'b0,instruction[31:12]}; op = instruction[6:0];
            end
            7'd111: begin  // J Type 
                funct7 = 7'b0; rs2_addr = 5'b0; rs1_addr = 5'b0; funct3 = 3'b0; rd_addr = instruction[11:7];
                immediate = {instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0}; op = instruction[6:0];
            end
            default:begin
                funct7 = 7'b0; rs2_addr = 5'b0; rs1_addr = 5'b0; funct3 = 3'b0; rd_addr = 5'b0;
                immediate = 21'b0; op = 7'b0;
            end
        endcase
    end
endmodule
