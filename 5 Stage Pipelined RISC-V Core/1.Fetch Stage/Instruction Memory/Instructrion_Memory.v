module Instruction_Memory_1#(parameter width = 32)(  // Module definition with parameter for bit-width
    input [width-1:0] address,                       // Input address for reading instruction
    output [width-1:0] instruction                   // Output instruction at the given address
    );
    
    reg [width-1:0] memory_big [0:1920];             // Memory array to store instructions
    // reg [width-1:0] memory_bubble [0:31];         // Additional memory array, currently commented out
    
    initial begin
        $readmemh("instruction_memory_file.mem",memory_big);  // Initialize memory_big with data from file
        // $readmemh("bubble_sort.s",memory_bubble);           // Initialize memory_bubble with data, currently commented out
    end
    
    wire [11:0] indexed_value = address[30:0] / 4;  // Calculate index by dividing address by 4
    // assign instruction = memory_bubble [indexed_value];  // Assign instruction from memory_bubble, currently commented out
    assign instruction = memory_big [indexed_value]; // Assign instruction from memory_big based on calculated index
    
endmodule
