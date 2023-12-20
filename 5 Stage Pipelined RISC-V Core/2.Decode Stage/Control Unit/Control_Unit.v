module Control_Unit_1(
    input [6:0] op,                    // Opcode input
    input [2:0] funct3,                // Function 3-bit field input
    input [6:0] funct7_5,              // Function 7-bit field input (Instr30)
    input comparison_out,              // Output of comparison logic

    // Output control signals
    output reg [2:0] ResultSrc,        // Determines the source of the result
    output reg Mem_Write,              // Control signal for memory write operations
    output reg [4:0] Alu_Control,      // Control signal for ALU operations
    output reg AluSrc,                 // Control signal to select ALU source
    output reg [2:0] ImmSrc,           // Control signal to select immediate source
    output reg jalr_ctrl,              // Control signal for JALR instruction
    output reg Reg_Write,              // Control signal for register write operations
    output ins_branch,                 // Signal indicating branch instruction
    output ins_jump                    // Signal indicating jump instruction
    );

    // Determine if the instruction is branch or jump
    assign ins_branch = (op==7'd99) ? (1'b1) : (1'b0);
    assign ins_jump = (op==7'd111) ? (1'b1) : (1'b0);
    
    always @(*)begin
        case (op)
            7'd3:begin
              case (funct3)
//                  3'b000: begin   // lb
//                      /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00000; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
//                  end
//                  3'b001: begin   // lh
//                      /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01010; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
//                  end
                  3'b010: begin   // lw
                      /*PCSrc = 1'b0;*/ ResultSrc = 3'b001; Mem_Write = 1'b0; Alu_Control = 5'b00000; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                  end
//                  3'b011: begin   // lbu
//                      /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00111; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
//                  end
//                  3'b100: begin   // lhu
//                      /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00011; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
//                  end
              endcase
            end
            7'd19:begin 
                case (funct3)
                    3'b000: begin   // addi
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00000; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                    3'b001: begin   // slli
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01010; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                    3'b010: begin   // slti
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01110; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                    3'b011: begin   // sltiu
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00111; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                    3'b100: begin   // xori
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00011; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                    3'b101: begin   // srli - srai
                        if(funct7_5 == 7'b0000000)begin   // srli
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01011; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                        else if (funct7_5 == 7'b0100000)begin          // srai
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01100; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                    end
                    3'b110: begin   // ori
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00100; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                    3'b111: begin   // andi
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00010; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                endcase
            end
            7'd23:begin // auipc
                /*PCSrc = 1'b0;*/ ResultSrc = 3'b100; Mem_Write = 1'b0; Alu_Control = 5'b00000; AluSrc = 1'b1; ImmSrc = 3'b011; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
            end
            7'd55:begin // lui
                /*PCSrc = 1'b0;*/ ResultSrc = 3'b011; Mem_Write = 1'b0; Alu_Control = 5'b00000; AluSrc = 1'b1; ImmSrc = 3'b011; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
            end
            7'd35:begin
              case (funct3)
//                  3'b000: begin   // sb
//                      /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00000; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
//                  end
//                  3'b001: begin   // sh
//                      /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01010; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
//                  end
                  3'b010: begin   // sw
                      /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b1; Alu_Control = 5'b00000; AluSrc = 1'b1; ImmSrc = 3'b001; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                  end
              endcase
            end
            7'd51:begin
                case (funct3)
                    3'b000: begin   // add - sub
                        if(funct7_5 == 7'b0000000)begin   // add
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00000; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                        else if (funct7_5 == 7'b0100000)begin          // sub
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00001; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                    end
                    3'b001: begin   // sll
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01010; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                    3'b010: begin   // slt
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01110; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                    3'b011: begin   
                        if(funct7_5 == 7'b0000000)begin// sltu
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00111; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                        else if (funct7_5 == 7'b0000001)begin // mulhu
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01111; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                    end
                    3'b100: begin   // xor
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00011; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                    3'b101: begin   // srl - sra
                        if(funct7_5 == 7'b0000000)begin   // srl
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01011; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                        else if (funct7_5 == 7'b0000001)begin          // divu
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b10000; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                        else if (funct7_5 == 7'b0100000)begin          // sra
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01100; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                    end
                    3'b110: begin   // or
                        /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00100; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                    end
                    3'b111: begin   // 
                        if(funct7_5 == 7'b0000000)begin   // and
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00010; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                        else if (funct7_5 == 7'b0000001)begin // remu
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b10001; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
                        end
                    end
                endcase
            end
            7'd99:begin // there might be problem in comparison part
                case (funct3)
                    3'b000: begin   // beq
                        if(comparison_out)begin     // taken
                            /*PCSrc = 1'b1;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00101; AluSrc = 1'b0; ImmSrc = 3'b010; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                        else begin                  // not taken
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00101; AluSrc = 1'b0; ImmSrc = 3'b010; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                    end
                    3'b001: begin   // bne
                        if(comparison_out)begin     // taken
                            /*PCSrc = 1'b1;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01000; AluSrc = 1'b0; ImmSrc = 3'b010; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                        else begin                  // not taken
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01000; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                    end
                    3'b100: begin   // blt
                        if(comparison_out)begin     // taken
                            /*PCSrc = 1'b1;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01110; AluSrc = 1'b0; ImmSrc = 3'b010; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                        else begin                  // not taken
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01110; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                    end
                    3'b101: begin   // bge
                        if(comparison_out)begin     // taken
                            /*PCSrc = 1'b1;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01101; AluSrc = 1'b0; ImmSrc = 3'b010; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                        else begin                  // not taken
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b01101; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                    end
                    3'b110: begin   // bltu
                        if(comparison_out)begin     // taken
                            /*PCSrc = 1'b1;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00111; AluSrc = 1'b0; ImmSrc = 3'b010; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                        else begin                  // not taken
                            /*PCSrc = 1'b0;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00111; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                    end
                    3'b111: begin   // bgeu
                        if(comparison_out)begin     // taken
                            /*PCSrc = 1'b1;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00110; AluSrc = 1'b0; ImmSrc = 3'b010; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                        else begin                  // not taken
                            /*PCSrc = 1'b1;*/ ResultSrc = 3'b000; Mem_Write = 1'b0; Alu_Control = 5'b00110; AluSrc = 1'b0; ImmSrc = 3'b000; Reg_Write = 1'b0; jalr_ctrl = 1'b0;
                        end
                    end
                endcase
            end 
            7'd103:begin // jalr
                /*PCSrc = 1'b1;*/ ResultSrc = 3'b010; Mem_Write = 1'b0; Alu_Control = 5'b00000; AluSrc = 1'b1; ImmSrc = 3'b000; Reg_Write = 1'b1; jalr_ctrl = 1'b1;
            end
            7'd111:begin // jal
                /*PCSrc = 1'b1;*/ ResultSrc = 3'b010; Mem_Write = 1'b0; Alu_Control = 5'b00000; AluSrc = 1'b1; ImmSrc = 3'b100; Reg_Write = 1'b1; jalr_ctrl = 1'b0;
            end
        endcase
    end
endmodule
