module Register_File_1#(parameter width = 32)(  // Module definition with parameter for register width
    input clk,                                // Clock input
    input rst_i,                              // Reset input
    input write_enable,                       // Write enable signal
    input [4:0] rs1_addr,                     // Source register 1 address
    input [4:0] rs2_addr,                     // Source register 2 address
    input [4:0] rd_addr,                      // Destination register address
    input inst_branch,                        // Branch instruction flag
    input [width-1:0] write_data_input,       // Data to write into the register
    output [width-1:0] rs1_data_output,       // Output data from source register 1
    output [width-1:0] rs2_data_output        // Output data from source register 2
    );

    // Register array declaration
    reg [width-1:0] registers [0:width-1];    // Array of registers

    // Read logic with forwarding
    assign rs1_data_output = ((rd_addr == rs1_addr) && !inst_branch) ? write_data_input : registers[rs1_addr];
    assign rs2_data_output = ((rd_addr == rs2_addr) && !inst_branch) ? write_data_input : registers[rs2_addr];

    // Initialize registers to 0
    integer i;
    initial begin
        for(i=0;i<32;i=i+1)begin
            registers[i] = 32'b0;
        end
    end
    
    always @(posedge clk)begin
        if(rst_i)begin
            registers [0] <= {(width){1'b0}};
            registers [1] <= {(width){1'b0}};
            registers [2] <= {(width){1'b0}};
            registers [3] <= {(width){1'b0}};
            registers [4] <= {(width){1'b0}};
            registers [5] <= {(width){1'b0}};
            registers [6] <= {(width){1'b0}};
            registers [7] <= {(width){1'b0}};
            registers [8] <= {(width){1'b0}};
            registers [9] <= {(width){1'b0}};
            registers [10] <= {(width){1'b0}};
            registers [11] <= {(width){1'b0}};
            registers [12] <= {(width){1'b0}};
            registers [13] <= {(width){1'b0}};
            registers [14] <= {(width){1'b0}};
            registers [15] <= {(width){1'b0}};
            registers [16] <= {(width){1'b0}};
            registers [17] <= {(width){1'b0}};
            registers [18] <= {(width){1'b0}};
            registers [19] <= {(width){1'b0}};
            registers [20] <= {(width){1'b0}};
            registers [21] <= {(width){1'b0}};
            registers [22] <= {(width){1'b0}};
            registers [23] <= {(width){1'b0}};
            registers [24] <= {(width){1'b0}};
            registers [25] <= {(width){1'b0}};
            registers [26] <= {(width){1'b0}};
            registers [27] <= {(width){1'b0}};
            registers [28] <= {(width){1'b0}};
            registers [29] <= {(width){1'b0}};
            registers [30] <= {(width){1'b0}};
            registers [31] <= {(width){1'b0}};
        end
        else begin
            if(rd_addr!=0)begin
                registers [rd_addr] <= (write_enable) ? (write_data_input) : (registers [rd_addr]);
            end
        end
        
    end
endmodule
