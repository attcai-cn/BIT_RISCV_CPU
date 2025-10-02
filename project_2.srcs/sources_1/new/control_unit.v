`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 18:02:15
// Design Name: 
// Module Name: control_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "macro.vh"

module control_unit(
        input [6:0] opcode,
        input [2:0] funct3,
        input [6:0] funct7,
        output c1,
        output c2,
        output [1:0] c3,
        output [3:0] alu_op,
        output [2:0] branch,
        output dmem_we,
        output reg_we
    );

    wire [4:0] instr_id = get_instr_id(opcode, funct3, funct7);
    function [4:0] get_instr_id(input [6:0] opcode, input [2:0] funct3, input [6:0] funct7);
        begin
            case (opcode)
                `OPCODE_R: begin
                    case (funct3)
                        `FUNCT3_ADD: begin
                            case (funct7)
                                `FUNCT7_ADD: get_instr_id = `ID_ADD;
                                `FUNCT7_SUB: get_instr_id = `ID_SUB; 
                                default: get_instr_id = `ID_NULL;
                            endcase
                        end
                        `FUNCT3_XOR: begin
                            case (funct7)
                                `FUNCT7_XOR: get_instr_id = `ID_XOR;
                                default: get_instr_id = `ID_NULL;
                            endcase
                        end
                        `FUNCT3_OR: begin
                            case (funct7)
                                `FUNCT7_OR: get_instr_id = `ID_OR;
                                default: get_instr_id = `ID_NULL;
                            endcase
                        end
                        `FUNCT3_AND: begin
                            case (funct7)
                                `FUNCT7_AND: get_instr_id = `ID_AND;
                                default: get_instr_id = `ID_NULL;
                            endcase
                        end
                        `FUNCT3_SLL: begin
                            case (funct7)
                                `FUNCT7_SLL: get_instr_id = `ID_SLL;
                                default: get_instr_id = `ID_NULL;
                            endcase
                        end
                        `FUNCT3_SRL: begin
                            case (funct7)
                                `FUNCT7_SRL: get_instr_id = `ID_SRL;
                                default: get_instr_id = `ID_NULL;
                            endcase
                        end
                        default: get_instr_id = `ID_NULL;
                    endcase
                end 

                `OPCODE_I: begin
                    case (funct3)
                        `FUNCT3_ORI: get_instr_id = `ID_ORI;
                        `FUNCT3_ADDI: get_instr_id = `ID_ADDI;
                        `FUNCT3_XORI: get_instr_id = `ID_XORI;
                        `FUNCT3_ANDI: get_instr_id = `ID_ANDI;
                        default: get_instr_id = `ID_NULL;
                    endcase
                end

                `OPCODE_L: begin
                    case (funct3)
                        `FUNCT3_LW: get_instr_id = `ID_LW;
                        default: get_instr_id = `ID_NULL;
                    endcase
                end

                `OPCODE_S: begin
                    case (funct3)
                        `FUNCT3_SW: get_instr_id = `ID_SW;
                        default: get_instr_id = `ID_NULL;
                    endcase
                end

                `OPCODE_B: begin
                    case (funct3)
                        `FUNCT3_BLT: get_instr_id = `ID_BLT;
                        `FUNCT3_BEQ: get_instr_id = `ID_BEQ;
                        `FUNCT3_BGE: get_instr_id = `ID_BGE;
                        `FUNCT3_BNE: get_instr_id = `ID_BNE;
                        default: get_instr_id = `ID_NULL;
                    endcase
                end
                `OPCODE_JAL: begin get_instr_id = `ID_JAL; end
                `OPCODE_LUI: begin get_instr_id = `ID_LUI; 
                            $display("lui: opcode = %b, funct3 = %b, funct7 = %b, instr_id = %b", opcode, funct3, funct7, get_instr_id);
                            end
                default: get_instr_id = `ID_NULL;
            endcase
        end
    endfunction

    assign c1 = (instr_id == `ID_SW) ? 1:0; // I 和 S 类型指令的立即数

    reg [19:0] mask_c2 = 20'b0000_0000_1101_0101_1010;
    assign c2 = mask_c2[instr_id];

    assign c3 = get_c3(instr_id);
    function [1:0] get_c3(input [4:0] instr_id);
        begin
            case (instr_id)
                `ID_LUI: get_c3 = 2'b00;
                `ID_JAL: get_c3 = 2'b01;
                `ID_ADD, `ID_ADDI, `ID_SUB, `ID_XOR, `ID_XORI, `ID_OR, `ID_ORI, `ID_AND, `ID_ANDI, `ID_SLL, `ID_SRL: get_c3 = 2'b10;
                `ID_LW: get_c3 = 2'b11;
                default: get_c3 = 2'b00;
            endcase
        end
    endfunction

    assign alu_op = get_alu_op(instr_id);
    function [7:0] get_alu_op(input [4:0] instr_id);
        begin
            case (instr_id)
                `ID_ADD, `ID_ADDI, `ID_LW, `ID_SW: get_alu_op = `ALU_ADD;
                `ID_SUB: get_alu_op = `ALU_SUB;
                `ID_XOR, `ID_XORI: get_alu_op = `ALU_XOR;
                `ID_OR, `ID_ORI: get_alu_op = `ALU_OR;
                `ID_AND, `ID_ANDI: get_alu_op = `ALU_AND;
                `ID_SLL: get_alu_op = `ALU_SLL;
                `ID_SRL: get_alu_op = `ALU_SRL;
                default: get_alu_op = `ALU_NULL;
            endcase
        end
        
    endfunction

    assign branch = get_branch(instr_id);
    function [2:0] get_branch(input [4:0] instr_id);
        begin
            case (instr_id)     
                `ID_BEQ: get_branch = `BR_BEQ;
                `ID_BGE: get_branch = `BR_BGE;
                `ID_BLT: get_branch = `BR_BLT;
                `ID_BNE: get_branch = `BR_BNE;
                `ID_JAL: get_branch = `BR_JAL;
                default: get_branch = `BR_NULL;
            endcase
        end
        
    endfunction

    assign dmem_we = (instr_id == `ID_SW) ? 1:0;

    reg [19:0] mask_reg_we = 20'b0001_1001_1111_1111_1110;
    assign reg_we = mask_reg_we[instr_id];
endmodule
