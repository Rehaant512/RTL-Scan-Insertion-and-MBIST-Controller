`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2026 15:50:45
// Design Name: 
// Module Name: dut_top
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
module dut_top #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 8
)(
    input  wire clk,
    input  wire rst_n,         
    input  wire bist_start,     
    input  wire inject_fault,   
    
    output wire bist_done,     
    output wire bist_fail     
);

    wire bist_we;
    wire bist_re;
    wire [ADDR_WIDTH-1:0] bist_addr;
    wire [DATA_WIDTH-1:0] bist_wdata;
    wire [DATA_WIDTH-1:0] sram_rdata;

    mbist_controller #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) u_mbist_ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .bist_start(bist_start),
        .sram_rdata(sram_rdata),     
        .bist_we(bist_we),           
        .bist_re(bist_re),       
        .bist_addr(bist_addr),     
        .bist_wdata(bist_wdata),
        .bist_done(bist_done),
        .bist_fail(bist_fail)
    );

    target_memory #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) u_target_mem (
        .clk(clk),
        .we(bist_we),                
        .re(bist_re),                
        .addr(bist_addr),            
        .wdata(bist_wdata),          
        .rdata(sram_rdata),          
        .inject_fault(inject_fault)  
    );

endmodule
