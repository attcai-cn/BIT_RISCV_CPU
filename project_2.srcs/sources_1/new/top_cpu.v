`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/09 14:01:10
// Design Name: 
// Module Name: top_cpu
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

module top_cpu(
    input wire clk,
    input wire rst
);

    // 定义连接信号

    // PC
    wire [31:0] instr;  // 指令
    wire [31:0] pc_val;     // 当前PC
    wire jump;        // 是否跳转
    wire [31:0] offset;  // 跳转偏移量

    // 寄存器堆
    wire [4:0] rs1;         // 源寄存器1
    wire [4:0] rs2;         // 源寄存器2
    wire [4:0] rd;          // 目的寄存器
    wire [31:0] read_data1; // 读数据1
    wire [31:0] read_data2; // 读数据2
    wire [31:0] write_data; // 写数据

    // CU
    wire [6:0] opcode;      // 操作码
    wire [2:0] funct3;      // 功能码3
    wire [6:0] funct7;      // 功能码7
    wire c1, c2, dmem_we, reg_we; // 控制信号
    wire [3:0] alu_op; // ALU控制信号
    wire [2:0] branch_type; // BRU控制信号
    wire [1:0] c3;

    // BRU
    // wire [31:0] offset; PC 已经定义
    // wire jump; PC 已经定义
    wire [19:0] jal_offset;
    wire [11:0] branch_offset;
    // wire [2:0] branch_type; CU 已经定义

    // ALU
    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] Result;
    wire [3:0] ALUOp;
    // reg RoundingMode = 1'b0; // 00: Round towards Zero/ No round
    wire SF, CF, ZF, OF, PF;

    // data_memory
    wire [31:0] r_dmem_data;

    wire [11:0]imm_I, imm_S;
    wire [31:0] imm;
    wire [19:0] imm_U;

    reg execute_enable = 0; // 标志位,控制是否开始执行指令

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            execute_enable <= 0; // 复位时将标志位设为 0,禁止执行
        end else begin
            if (~execute_enable) begin
                execute_enable <= 1; // 复位结束后将标志位设为 1,允许执行
            end
        end
    end

    // PC寄存器
    pc pc(
        .clk(clk),
        .rst(rst),
        .jmp(jump),
        .offset(offset), //input offset
        .execute_enable(execute_enable),
        .pc(pc_val)
    );

    // 指令存储器
    instruction_memory instr_mem (
        ._addr(pc_val),
        .execute_enable(execute_enable),
        .jmp(jump),
        .idata(instr)
    );

    // 2级流水线-IFID-EX寄存器/////////////////////////////////////////////////

    wire [31:0] ex_instr;
    wire [31:0] ex_pc;


    pipeline_reg pipe_reg (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_val),
        .instr_in(instr),
        .jmp(jump),
        .pc_out(ex_pc),
        .instr_out(ex_instr)
    );

    assign jal_offset = ex_instr[31:12];
    assign branch_offset = {ex_instr[31:25], ex_instr[11:7]};

    // BRU
    branch_unit bru (
        .br_offset(branch_offset),
        .jal_offset(jal_offset),
        .reg_data1(read_data1),
        .reg_data2(read_data2),
        .branch_type(branch_type),
        .execute_enable(execute_enable),
        .jump(jump),
        .offset(offset)
    );

    assign opcode = ex_instr[6:0];
    assign funct3 = ex_instr[14:12];
    assign funct7 = ex_instr[31:25];
    control_unit cu (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .alu_op(alu_op),
        .branch(branch_type),
        .dmem_we(dmem_we),
        .reg_we(reg_we)
    );

    // ALU
    assign imm_I = ex_instr[31:20];
    assign imm_S = {ex_instr[31:25], ex_instr[11:7]};
    assign imm = c1 ? {{20{imm_S[11]}}, imm_S} :  
            {{20{imm_I[11]}}, imm_I};

    assign A = read_data1;
    assign B = c2 ? read_data2 : 
            imm;
    ALU alu (
        .A(A),
        .B(B),
        .ALUOp(alu_op),
        .RoundingMode(1'b0),
        .execute_enable(execute_enable),
        .Result(Result),
        .SF(SF),
        .CF(CF),
        .ZF(ZF),
        .OF(OF),
        .PF(PF)
    );


    // 寄存器堆
    assign rs1 = ex_instr[19:15];
    assign rs2 = ex_instr[24:20];
    assign rd = ex_instr[11:7];
    assign imm_U = {ex_instr[31:12], 12'b0};
    assign write_data = (c3 == 2'd0) ? imm_U :
                        (c3 == 2'd1) ? (ex_pc + 4) :
                        (c3 == 2'd2) ? Result :
                        (c3 == 2'd3) ? r_dmem_data:
                        32'b0;

    regfile reg_file (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .reg_we(reg_we),
        .execute_enable(execute_enable),
        .wb_data(write_data),
        .rs_data(read_data1),
        .rt_data(read_data2)
    );


    // 数据存储器
    data_memory data_mem (
        .clk(clk),
        .rst(rst),
        .we(dmem_we),
        .execute_enable(execute_enable),
        ._addr(Result),
        .write_data(read_data2),
        .read_data(r_dmem_data)
    );


endmodule
