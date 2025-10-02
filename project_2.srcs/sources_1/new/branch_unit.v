`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/10 13:42:13
// Design Name: 
// Module Name: branch_unit
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


module branch_unit(
    input wire [11:0] br_offset,    // 分支偏移量
    input wire [19:0] jal_offset,   // 跳转偏移量
    input wire [31:0] reg_data1,    // 寄存器数据1
    input wire [31:0] reg_data2,    // 寄存器数据2
    input wire [2:0] branch_type,   // 分支类型
    input wire execute_enable,      // 执行使能位
    output reg jump,                // 是否跳转
    output reg [31:0] offset        // 跳转偏移量
);

    wire [31:0] imm_branch;
    wire [31:0] imm_jump;

    // 立即数重新排序 19 位符号扩展
    assign imm_branch = {{20{br_offset[11]}}, br_offset[0], br_offset[10:1], 1'b0};

    // 立即数重新排序 11 位符号扩展
    assign imm_jump = {{12{jal_offset[19]}}, jal_offset[7:0], jal_offset[8], jal_offset[18:9], 1'b0};

    always @(*) begin
        // 执行使能判断
        if (execute_enable) begin
            // 分支判断
            case(branch_type)
                3'b000: begin   // beq
                    jump = (reg_data1 == reg_data2);
                    offset = imm_branch;
                end
                3'b001: begin   // bne
                    jump = (reg_data1 != reg_data2);
                    offset = imm_branch;
                end
                3'b011: begin   // blt
                    // jump = $signed (reg_data1) < $signed (reg_data2);
                    if (reg_data1[31] == 1 && reg_data2[31] == 0) begin
                        // reg_data1 是负数, reg_data2 是正数, reg_data1 更小
                        jump = 1;
                    end else if (reg_data1[31] == reg_data2[31]) begin
                        // 两个数同号, 直接比较数值大小
                        jump = reg_data1 < reg_data2;
                    end else begin
                        // reg_data1 是正数, reg_data2 是负数, reg_data2 更小
                        jump = 0;
                    end
                    offset = imm_branch;
                end
                3'b010: begin   // bge
                    // jump = $signed (reg_data1) >= $signed (reg_data2);
                    if (reg_data1[31] == 0 && reg_data2[31] == 1) begin
                        // reg_data1 是正数, reg_data2 是负数, reg_data1 更大
                        jump = 1;
                    end else if (reg_data1[31] == reg_data2[31]) begin
                        // 两个数同号, 直接比较数值大小
                        jump = reg_data1 >= reg_data2;
                    end else begin
                        // reg_data1 是负数, reg_data2 是正数, reg_data2 更大
                        jump = 0;
                    end
                    offset = imm_branch;
                end
                3'b110: begin   // jal
                    jump = 1;
                    offset = imm_jump;
                end
                default: begin
                    jump = 0;
                    offset = 0;
                end
            endcase
        end else begin
            // 执行使能为 0 时, 不跳转
            jump = 0;
            offset = 0;
        end
    end

endmodule
