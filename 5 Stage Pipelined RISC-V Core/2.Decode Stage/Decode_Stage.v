module Decode_Stage_1#(parameter width = 32)(  // Module definition with a parameter for bit-width
    input clk,                                // Clock input
    input rst,                                // Reset input
    input stall_id,                           // Stall signal input for the decode stage
    input flush_id,                           // Flush signal input for the decode stage
    //
    input [width-1:0] i_rs1_id,               // Input source register 1 value
    input [width-1:0] i_rs2_id,               // Input source register 2 value
    input [width-1:0] i_pc_id,                // Input program counter value
    input [4:0] i_rs1_addr_id,                // Address of source register 1
    input [4:0] i_rs2_addr_id,                // Address of source register 2
    input [4:0] i_rd_addr_id,                 // Address of destination register
    input [width-1:0] i_immediate_extended_id,// Extended immediate value
    input [width-1:0] i_pc_plus_4_id,         // Program counter value plus 4
    
    // Control Unit inputs
    input i_Reg_Write_id,                     // Control signal for register write
    input [2:0] i_ResultSrc_id,               // Control signal for result source
    input i_Mem_Write_id,                     // Control signal for memory write
    input i_Jump_id,                          // Control signal for jump instruction
    input i_Branch_id,                        // Control signal for branch instruction
    input [4:0] i_Alu_Control_id,             // Control signal for ALU operation
    input i_AluSrc_id,                        // Control signal for ALU source
    
    // Outputs to the next stage
    output [width-1:0] rs1_id_ex,             // Output source register 1 value
    output [width-1:0] rs2_id_ex,             // Output source register 2 value
    output [width-1:0] pc_id_ex,              // Output program counter value
    output [4:0] rs1_addr_ex,                 // Output source register 1 address
    output [4:0] rs2_addr_ex,                 // Output source register 2 address
    output [4:0] rd_addr_id_ex,               // Output destination register address
    output [width-1:0] immediate_extended_id_ex, // Output extended immediate value
    output [width-1:0] pc_plus_4_id_ex,       // Output program counter value plus 4
    
    // Control Unit outputs
    output Reg_Write_id_ex,                   // Output control signal for register write
    output [2:0] ResultSrc_id_ex,             // Output control signal for result source
    output Mem_Write_id_ex,                   // Output control signal for memory write
    output Jump_id_ex,                        // Output control signal for jump instruction
    output Branch_id_ex,                      // Output control signal for branch instruction
    output [4:0] Alu_Control_id_ex,           // Output control signal for ALU operation
    output AluSrc_id_ex                       // Output control signal for ALU source
    );

    // Assigning inputs to outputs for the next stage
    assign rs1_id_ex = rs1_id_reg;
    assign rs2_id_ex = rs2_id_reg;
    assign pc_id_ex = pc_id_reg;
    assign rs1_addr_ex = rs1_addr_id_reg;
    assign rs2_addr_ex = rs2_addr_id_reg;
    assign rd_addr_id_ex = rd_addr_id_reg;
    assign immediate_extended_id_ex = immediate_extended_id_reg;
    assign pc_plus_4_id_ex = pc_plus_4_id_reg;
    
    // Control Unit assignments
    assign Reg_Write_id_ex = Reg_Write_id_reg;
    assign ResultSrc_id_ex = ResultSrc_id_reg;
    assign Mem_Write_id_ex = Mem_Write_id_reg;
    assign Jump_id_ex = Jump_id_reg;
    assign Branch_id_ex = Branch_id_reg;
    assign Alu_Control_id_ex = Alu_Control_id_reg;
    assign AluSrc_id_ex = AluSrc_top_reg;
    
    // Registers to hold values and control signals for the execution stage
    reg [width-1:0] rs1_id_reg;
    reg [width-1:0] rs2_id_reg;
    reg [width-1:0] pc_id_reg;
    reg [4:0] rs1_addr_id_reg;
    reg [4:0] rs2_addr_id_reg;
    reg [4:0] rd_addr_id_reg;
    reg [width-1:0] immediate_extended_id_reg;
    reg [width-1:0] pc_plus_4_id_reg;
    
    // Control Unit registers
    reg Reg_Write_id_reg;
    reg [2:0] ResultSrc_id_reg;
    reg Mem_Write_id_reg;
    reg Jump_id_reg;
    reg Branch_id_reg;
    reg [4:0] Alu_Control_id_reg;
    reg AluSrc_top_reg;
    
    always @(posedge clk)begin
        if(rst)begin            // Clear all registers on reset
            rs1_id_reg                  <= 32'b0;
            rs2_id_reg                  <= 32'b0;
            pc_id_reg                   <= 32'b0;
            rs1_addr_id_reg             <= 5'b0;
            rs2_addr_id_reg             <= 5'b0;
            rd_addr_id_reg              <= 5'b0;
            immediate_extended_id_reg   <= 32'b0;
            pc_plus_4_id_reg            <= 32'b0;
            
            // Clearing Control Unit registers
            Reg_Write_id_reg            <= 1'b0;
            ResultSrc_id_reg            <= 3'b0;
            Mem_Write_id_reg            <= 1'b0; 
            Jump_id_reg                 <= 1'b0;
            Branch_id_reg               <= 1'b0;
            Alu_Control_id_reg          <= 5'b0;
            AluSrc_top_reg              <= 1'b0;
        end
        else if (flush_id)begin // Clear all registers on flush
            rs1_id_reg                  <= 32'b0;
            rs2_id_reg                  <= 32'b0;
            pc_id_reg                   <= 32'b0;
            rs1_addr_id_reg             <= 5'b0;
            rs2_addr_id_reg             <= 5'b0;
            rd_addr_id_reg              <= 5'b0;
            immediate_extended_id_reg   <= 32'b0;
            pc_plus_4_id_reg            <= 32'b0;
            
            // Clearing Control Unit registers
            Reg_Write_id_reg            <= 1'b0;
            ResultSrc_id_reg            <= 3'b0;
            Mem_Write_id_reg            <= 1'b0; 
            Jump_id_reg                 <= 1'b0;
            Branch_id_reg               <= 1'b0;
            Alu_Control_id_reg          <= 5'b0;
            AluSrc_top_reg              <= 1'b0;
        end
        else if (stall_id)begin // Do nothing - preserve current state
            rs1_id_reg                  <= rs1_id_reg;
            rs2_id_reg                  <= rs2_id_reg;
            pc_id_reg                   <= pc_id_reg;
            rs1_addr_id_reg             <= rs1_addr_id_reg;
            rs2_addr_id_reg             <= rs2_addr_id_reg;
            rd_addr_id_reg              <= rd_addr_id_reg;
            immediate_extended_id_reg   <= immediate_extended_id_reg;
            pc_plus_4_id_reg            <= pc_plus_4_id_reg;
            
            // Preserving Control Unit registers
            Reg_Write_id_reg            <= Reg_Write_id_reg;
            ResultSrc_id_reg            <= ResultSrc_id_reg;
            Mem_Write_id_reg            <= Mem_Write_id_reg; 
            Jump_id_reg                 <= Jump_id_reg;
            Branch_id_reg               <= Branch_id_reg;
            Alu_Control_id_reg          <= Alu_Control_id_reg;
            AluSrc_top_reg              <= AluSrc_top_reg;
        end
        else begin              // Update registers with input values
            rs1_id_reg                  <= i_rs1_id;
            rs2_id_reg                  <= i_rs2_id;
            pc_id_reg                   <= i_pc_id;
            rs1_addr_id_reg             <= i_rs1_addr_id;
            rs2_addr_id_reg             <= i_rs2_addr_id;
            rd_addr_id_reg              <= i_rd_addr_id;
            immediate_extended_id_reg   <= i_immediate_extended_id;
            pc_plus_4_id_reg            <= i_pc_plus_4_id;
            
            // Updating Control Unit registers
            Reg_Write_id_reg            <= i_Reg_Write_id;
            ResultSrc_id_reg            <= i_ResultSrc_id;
            Mem_Write_id_reg            <= i_Mem_Write_id; 
            Jump_id_reg                 <= i_Jump_id;
            Branch_id_reg               <= i_Branch_id;
            Alu_Control_id_reg          <= i_Alu_Control_id;
            AluSrc_top_reg              <= i_AluSrc_id;
        end
    end
endmodule
