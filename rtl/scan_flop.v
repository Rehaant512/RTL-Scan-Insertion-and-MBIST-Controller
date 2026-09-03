`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2026 15:47:30
// Design Name: 
// Module Name: scan_flop
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
module scan_flop (
    input wire d,      
    input wire si,    
    input wire se,    
    input wire clk,   
    input wire rst_n,  
    output reg q       
);

    wire d_in = se ? si : d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d_in;
    end

endmodule