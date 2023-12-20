module Data_Memory_1#(parameter width = 32)(
    input clk,                           // Clock input
    input rst_i,                         // Reset input
    input [width-1:0] alu_result,        // Address input from ALU result
    input [width-1:0] wd_data,           // Write data input
    input write_enable,                  // Write enable signal
    output [width-1:0] rd                // Read data output
);
      
    // Memory declaration
    reg [width-1:0] data_memory [0:150]; // Data memory array

    // Initialize memory to zero
    integer i;
    initial begin
        for (i = 0; i < 150; i = i + 1) begin
            data_memory[i] = 32'b0;
        end
    end

    // Calculate index value based on ALU result
    wire [7:0] index_value = alu_result[7:0];

    // Read data from memory unless write is enabled
    assign rd = (!write_enable) ? data_memory[index_value] : 32'b0;
    
    // Memory write logic on positive clock edge
    always @(posedge clk) begin
        if(rst_i)begin
            // Reset logic if needed can be added here
        end
        else begin
            // Write data to memory if write enable is asserted
            if(write_enable) begin
                data_memory[index_value] <= wd_data;
            end
        end
    end
endmodule
