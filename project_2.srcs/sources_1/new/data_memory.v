`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 17:55:19
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input wire clk, // 时钟
    input wire rst, // 重置
    input wire we, // 写使能 we = 0 只读，we = 1 读写 
    input wire execute_enable, // 执行使能
    input wire [31:0] _addr,    // 32位地址
    input wire [31:0] write_data, // 写数据
    output wire [31:0] read_data // 读数据
);

    reg [31:0] dmem [255:0]; 
    // 读入初始化数据
    initial begin
        $readmemh("D:/vhdl/data.hex", dmem);
    end

    wire [7:0] addr = _addr[9:2] ; // _addr 是字节编码，转换为字编码
    assign read_data = execute_enable ? dmem[addr] : 32'b0; // 增加执行使能判断
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 重置
            for (i = 0; i < 256; i = i + 1)
                dmem[i] <= dmem[i];
        end 
        else if (execute_enable && we) begin
            // 写数据
            dmem[addr] <= write_data;
        end
    end

endmodule
