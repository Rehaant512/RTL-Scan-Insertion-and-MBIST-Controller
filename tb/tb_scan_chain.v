`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2026 15:51:34
// Design Name: 
// Module Name: tb_scan_chain
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
module tb_scan_chain;

    reg clk;
    reg rst_n;
    reg [3:0] data_in;
    reg scan_en;
    reg scan_in;

    wire [3:0] data_out;
    wire scan_out;

    scan_dut uot (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out),
        .scan_en(scan_en),
        .scan_in(scan_in),
        .scan_out(scan_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        data_in = 4'b0000;
        scan_en = 0;
        scan_in = 0;

        $display("--- Starting ATPG Scan Simulation ---");

        #20 rst_n = 1;

        $display("STEP 1: Shifting in test pattern '1011'...");
        scan_en = 1;

        scan_in = 1'b1; #10; 
        scan_in = 1'b1; #10; 
        scan_in = 1'b0; #10; 
        scan_in = 1'b1; #10; 

        $display("STEP 2: Capturing logic response...");
        scan_en = 0;
        data_in = 4'b0101;
        
        #10;                 
        $display("STEP 3: Shifting out the captured results...");
        scan_en = 1;

        #10; 
        #10; 
        #10; 
        #10; 

        $display("--- Scan Simulation Complete ---");
        $finish;
    end

endmodule
