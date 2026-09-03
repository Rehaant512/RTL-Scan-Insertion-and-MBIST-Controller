`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2026 17:29:47
// Design Name: 
// Module Name: scan_dut
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
module scan_dut (
    input  wire clk,
    input  wire rst_n,
    
    input  wire [3:0] data_in,
    output wire [3:0] data_out,
    
    input  wire scan_en,   
    input  wire scan_in,   
    output wire scan_out   
);

    wire [3:0] next_data = ~data_in;

    scan_flop sf0 (
        .d(next_data[0]), 
        .si(scan_in),      
        .se(scan_en),
        .clk(clk),
        .rst_n(rst_n),
        .q(data_out[0])
    );

    scan_flop sf1 (
        .d(next_data[1]), 
        .si(data_out[0]),
        .se(scan_en),
        .clk(clk),
        .rst_n(rst_n),
        .q(data_out[1])
    );

    scan_flop sf2 (
        .d(next_data[2]),  
        .si(data_out[1]),
        .se(scan_en),
        .clk(clk),
        .rst_n(rst_n),
        .q(data_out[2])
    );

    scan_flop sf3 (
        .d(next_data[3]),
        .si(data_out[2]),
        .se(scan_en),
        .clk(clk),
        .rst_n(rst_n),
        .q(data_out[3])
    );
    assign scan_out = data_out[3];

endmodule