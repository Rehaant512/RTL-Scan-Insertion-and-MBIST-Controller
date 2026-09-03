`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2026 15:50:25
// Design Name: 
// Module Name: target_memory
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
module target_memory #(
    parameter ADDR_WIDTH = 4,   
    parameter DATA_WIDTH = 8    
)(
    input  wire clk,
    input  wire we,           
    input  wire re,           
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0] wdata, 
    output reg  [DATA_WIDTH-1:0] rdata,  

    input  wire inject_fault  
);

    reg [DATA_WIDTH-1:0] sram_array [0:(1<<ADDR_WIDTH)-1];

    always @(posedge clk) begin
        if (we) begin
            sram_array[addr] <= wdata;
        end
    end

    always @(posedge clk) begin
        if (re) begin
            if (inject_fault)
                rdata <= sram_array[addr] | { {(DATA_WIDTH-1){1'b0}}, 1'b1 };
            else
                rdata <= sram_array[addr];
        end
    end

endmodule
