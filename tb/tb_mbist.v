`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2026 15:51:09
// Design Name: 
// Module Name: tb_mbist
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
module tb_mbist;

    reg clk;
    reg rst_n;
    reg bist_start;
    reg inject_fault;
    
    wire bist_done;
    wire bist_fail;

    dut_top #(
        .ADDR_WIDTH(4),
        .DATA_WIDTH(8)
    ) uot (
        .clk(clk),
        .rst_n(rst_n),
        .bist_start(bist_start),
        .inject_fault(inject_fault),
        .bist_done(bist_done),
        .bist_fail(bist_fail)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        bist_start = 0;
        inject_fault = 0;

        $display("--- Starting MBIST Simulation ---");

        #20 rst_n = 1;
        
        $display("RUN 1: Testing healthy memory (inject_fault = 0)");
        #10 bist_start = 1;
        #10 bist_start = 0;

        wait(bist_done || bist_fail);
        
        if (bist_done && !bist_fail)
            $display("RUN 1 PASSED: Memory is healthy bist_done asserted.");
        else
            $display("RUN 1 FAILED: Unexpected error in healthy memory.");

        #50 rst_n = 0; 
        #20 rst_n = 1;
        
        $display("RUN 2: Testing defective memory (inject_fault = 1)");
        inject_fault = 1; 
        #10 bist_start = 1;
        #10 bist_start = 0;

        wait(bist_done || bist_fail);
        
        if (bist_fail)
            $display("RUN 2 PASSED: MBIST successfully caught the Stuck-At-0 fault bist_fail asserted.");
        else
            $display("RUN 2 FAILED: MBIST missed the defect.");

        #50 $display("--- Simulation Complete ---");
        $finish;
    end

endmodule
