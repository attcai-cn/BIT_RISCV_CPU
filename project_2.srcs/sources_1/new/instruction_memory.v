`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 18:02:15
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(
    input wire [31:0] _addr,    // 32位地址
    input wire execute_enable,  // 执行使能位
    input wire jmp,
    output wire [31:0] idata    // 32位指令
);

    reg [31:0] imem [255:0]; // 256个32位指令

    initial begin
        // 加载指令
        $readmemh("D:/vhdl/sort.hex", imem);
    end

    wire [7:0] addr = _addr[9:2]; // _addr 是字节编码，转换为字编码
    assign idata = execute_enable ? (jmp ? 32'h00000013 : imem[addr]) : 32'b0; // 增加执行使能判断
endmodule
