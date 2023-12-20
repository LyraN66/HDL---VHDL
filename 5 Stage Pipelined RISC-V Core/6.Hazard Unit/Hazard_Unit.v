module Hazard_Unit_1#(parameter width = 32)(
    // Inputs for Forwarding Unit
    input [4:0] i_rs1_addr_id_ex_out,         // Source register 1 address from ID/EX stage
    input [4:0] i_rs2_addr_id_ex_out,         // Source register 2 address from ID/EX stage
    input [4:0] i_rd_addr_ex_mem_out,         // Destination register address from EX/MEM stage
    input [4:0] i_i_rd_addr_mem_wb_out,       // Destination register address from MEM/WB stage
    input i_RegWrite_ex_mem_out,              // Register write signal from EX/MEM stage
    input RegWrite_mem_wb_out,                // Register write signal from MEM/WB stage
    output reg [1:0] Forward_A,               // Forwarding control for source A
    output reg [1:0] Forward_B,               // Forwarding control for source B

    // Inputs for handling Load Word stall
    input [4:0] rs1_addr_if_id_out,           // Source register 1 address from IF/ID stage
    input [4:0] rs2_addr_if_id_out,           // Source register 2 address from IF/ID stage
    input [4:0] rd_addr_id_ex_out,            // Destination register address from ID/EX stage
    input [2:0] ResultSrc_id_ex_out,          // Result source signal from ID/EX stage
    output pc_Stall,                          // Stall signal for PC
    output if_Stall,                          // Stall signal for IF stage
    output id_Flush,                          // Flush signal for ID stage

    // Inputs for branch
    input PCSrc_hzd,                          // Branch decision signal
    output Flush_if,                          // Flush signal for IF stage

    // Inputs for ALU busy and valid
    input busy_alu,                           // ALU busy signal
    input valid_alu,                          // ALU valid signal
    output id_Stall,                          // Stall signal for ID stage
    output ex_Stall,                          // Stall signal for EX stage
    output mem_Stall                          // Stall signal for MEM stage
);

    // Detecting Load Word stall condition
    wire lwstall = (ResultSrc_id_ex_out == 3'b001) && 
                   ((rs1_addr_if_id_out == rd_addr_id_ex_out) || 
                    (rs2_addr_if_id_out == rd_addr_id_ex_out)) ? 1'b1 : 1'b0;

    // Stall and flush control logic
    assign pc_Stall = lwstall || (busy_alu && !valid_alu);
    assign if_Stall = lwstall || (busy_alu && !valid_alu);
    assign id_Stall = busy_alu && !valid_alu;
    assign id_Flush = lwstall || PCSrc_hzd;
    assign Flush_if = PCSrc_hzd;

    // Forwarding logic for handling data hazards
    always @(*) begin
        // Forwarding for source A
        if ((i_rs1_addr_id_ex_out == i_rd_addr_ex_mem_out) && i_RegWrite_ex_mem_out && (i_rs1_addr_id_ex_out != 0)) begin
            Forward_A = 2'b10;
        end
        else if ((i_rs1_addr_id_ex_out == i_i_rd_addr_mem_wb_out) && RegWrite_mem_wb_out && (i_rs1_addr_id_ex_out != 0)) begin
            Forward_A = 2'b01;
        end
        else begin
            Forward_A = 2'b00;
        end

        // Forwarding for source B
        if ((i_rs2_addr_id_ex_out == i_rd_addr_ex_mem_out) && i_RegWrite_ex_mem_out && (i_rs2_addr_id_ex_out != 0)) begin
            Forward_B = 2'b10;
        end
        else if ((i_rs2_addr_id_ex_out == i_i_rd_addr_mem_wb_out) && RegWrite_mem_wb_out && (i_rs2_addr_id_ex_out != 0)) begin
            Forward_B = 2'b01;
        end
        else begin
            Forward_B = 2'b00;
        end
    end
endmodule
