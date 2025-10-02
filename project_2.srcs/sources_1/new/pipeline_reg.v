`timescale 1ns / 1ps


module pipeline_reg (
    input wire clk,
    input wire rst,
    input wire [31:0] pc_in,
    input wire [31:0] instr_in,
    input wire jmp,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);
    // 在第一个周期，或者跳转时插入nop指令:x00000013
    reg [31:0] nop = 32'h00000013;
    reg init_nop = 1'b1;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 32'b0;
        end else begin    
            pc_out <= pc_in;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instr_out <= nop;
        end else begin
            if (init_nop) begin
                instr_out <= nop;
                init_nop <= 1'b0;
            end else if (jmp) begin
                instr_out <= nop;
            end else begin
                instr_out <= instr_in;
            end
            // instr_out <= (jmp || init_nop) ? nop : instr_in;
        end
    end


endmodule