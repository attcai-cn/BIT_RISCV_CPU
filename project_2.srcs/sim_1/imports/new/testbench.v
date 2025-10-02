`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/09 14:11:26
// Design Name: 
// Module Name: testbench
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


module testbench(
    );

    reg clk;
    reg rst;

    // Instantiate the CPU
    top_cpu uut(
        .clk(clk),
        .rst(rst)
    );

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        #10 rst = 0; // Release reset after 10 time units
        $display("Starting running..."); 
    end

    // Clock generation
    always #10 clk = ~clk; // 20 time units period

    initial begin
        // Display signals
        $display("Time=%t, PC=%h, Instruction=%h", $time, uut.pc_val, uut.instr);

        // Run simulation for a specific duration
        #16000 $finish;
    end

endmodule
