`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 14:37:34
// Design Name: 
// Module Name: ALU
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


module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUOp,
    input RoundingMode, // 00: Round towards Zero/ No round, 01: Round to Nearest
    input execute_enable,
    output reg [31:0] Result,
    output reg SF, CF, ZF, OF, PF
);

    always @(*) begin
        if (execute_enable) begin
            case (ALUOp)
                4'b0000: {CF, Result} = A + B;          // Addition
                4'b0001: {CF, Result} = A - B;          // Subtraction
                4'b0010: Result = A & B;                // Bitwise AND
                4'b0011: Result = A | B;                // Bitwise OR
                4'b0100: Result = A ^ B;                // Bitwise XOR
                4'b0101: Result = ~A;                   // Bitwise NOT
                4'b0110: Result = A << B;               // Logical Shift Left
                4'b0111: begin                          // Logical Shift Right
                    case (RoundingMode)
                        1'b0: Result = A >> B; // Round towards Zero (same as no rounding for right shift)
                        1'b1: Result = (A + (1 << (B - 1))) >> B; // Round to Nearest
                        default: Result = A >> B; // Default to no rounding
                    endcase
                end
            endcase 
            ZF = (Result == 0);                         // Zero Flag
            SF = Result[31];                            // Sign Flag
            // S[i] = A[i] ^ B[i] ^ C[i]; C[i] = A[i] ^ B[i] ^ S[i]; OF = C[out] ^ C[31]  
            OF = A[31] ^ B[31] ^ Result[31] ^ CF;       // Overflow Flag
            PF = ~^Result;                              // Parity Flag
        end else begin
            Result = 32'b0;
            SF = 1'b0;
            CF = 1'b0;
            ZF = 1'b0;
            OF = 1'b0;
            PF = 1'b0;
        end
    end
endmodule