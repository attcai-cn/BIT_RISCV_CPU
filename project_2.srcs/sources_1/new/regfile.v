`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/01 21:57:13
// Design Name: 
// Module Name: regfile
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


module regfile(
    input clk, 
    input rst, 
    input reg_we,           // 写使能
    input execute_enable,   // 执行使能位
    input [4:0] rs1,        // 读寄存器地址1
    input [4:0] rs2,        // 读寄存器地址2
    input [4:0] rd,         // 写寄存器的地址
    input [31:0] wb_data,   // 写入的数据
    output [31:0] rs_data,  // 读出数据1
    output [31:0] rt_data   // 读出数据2
);
    
    reg [31:0] gpr[31:0]; // 32个32位寄存器
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            for(i = 0; i < 32; i = i + 1) gpr[i] <= 32'b0;
        end
        else if(execute_enable && reg_we) gpr[rd] <= wb_data; // 增加执行使能判断
    end
    
    assign rs_data = execute_enable ? gpr[rs1] : 32'b0; // 增加执行使能判断
    assign rt_data = execute_enable ? gpr[rs2] : 32'b0; // 增加执行使能判断
    
endmodule