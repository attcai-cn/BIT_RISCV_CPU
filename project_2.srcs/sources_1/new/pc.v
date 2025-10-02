`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 18:02:15
// Design Name: 
// Module Name: pc
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


module pc(
    input wire clk,
    input wire rst,
    input wire jmp,             // 是否跳转
    input wire [31:0] offset,   // 跳转偏移量n 
    input wire execute_enable,  // 执行使能
    output reg [31:0] pc
);
    wire [31:0]next_pc;
    assign next_pc = jmp ? (pc + offset - 4) : (pc + 4);

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 32'b0;
        else if (execute_enable)
            pc <= next_pc;
        else
            pc <= pc;
    end
endmodule
