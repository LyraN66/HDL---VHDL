module Extend_1#(parameter width = 32)(  // Module definition with a parameter for bit-width
    input [20:0] ins_immediate,          // 21-bit immediate input from the instruction
    input [2:0] ImmSrc,                  // Control signal to specify the type of immediate
    output reg [width-1:0] immediate_extended  // Output for the sign-extended immediate value
    );

    always @(*)begin
        case (ImmSrc)
            3'b000: begin   // I - Type (Immediate)
                immediate_extended = {{20{ins_immediate[11]}},ins_immediate[11:0]};
            end
            3'b001: begin   // S - Type (Store)
                immediate_extended = {{20{ins_immediate[11]}},ins_immediate[11:0]};
            end
            3'b010: begin   // B - Type (Branch)
                immediate_extended = {{19{ins_immediate[12]}},ins_immediate[12:0]};
            end
            3'b011: begin   // U - Type (Upper immediate)
                immediate_extended = {ins_immediate[19:0],{12{1'b0}}};
            end
            3'b100: begin   // J - Type (Jump)
                immediate_extended = {{11{ins_immediate[20]}},ins_immediate[20:0]};
            end
        endcase
    end
endmodule
