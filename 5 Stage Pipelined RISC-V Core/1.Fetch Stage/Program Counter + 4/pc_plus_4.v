module pc_plus_4_1#(parameter width = 32)(  // Module definition with parameter for bit-width
    input [width-1:0] i_pc,                 // Input for the current program counter (PC) value
    output [width-1:0] pc_plus_4            // Output for PC value incremented by 4
    );
    assign pc_plus_4 = i_pc + 4;            // Increment the input PC value by 4 and assign to output
endmodule
