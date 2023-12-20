module PC_Counter_1#(parameter width = 32)(  // Module definition with parameter for bit-width
    input clk,                                // Clock input
    input rst_i,                              // Reset input
    input stall,                              // Stall input to hold the PC value
    input [width-1:0] Pc_Next,                // Input for the next PC value
    output reg [width-1:0] pc                 // Output PC value
    );
    
    always @(posedge clk)begin
        if(rst_i)begin
            pc <= 32'h80000000;               // Set PC to starting address on reset
        end
        else if (stall)begin
            pc <= pc;                         // Hold current PC value on stall
        end
        else begin
            pc <= Pc_Next;                    // Update PC to next value
        end
    end
endmodule
