`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2026 15:50:06
// Design Name: 
// Module Name: mbist_controller
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
module mbist_controller #(
    parameter ADDR_WIDTH = 4,  
    parameter DATA_WIDTH = 8 
)(
    input  wire clk,
    input  wire rst_n,
    input  wire bist_start,  
    input  wire [DATA_WIDTH-1:0] sram_rdata,

    output reg bist_we,
    output reg bist_re,     
    output reg [ADDR_WIDTH-1:0] bist_addr,   
    output reg [DATA_WIDTH-1:0] bist_wdata,  
    output reg bist_done,   
    output reg bist_fail    
);

    localparam IDLE      = 3'b000;
    localparam M_ELEM_0  = 3'b001; 
    localparam M_ELEM_1R = 3'b010; 
    localparam M_ELEM_1W = 3'b011; 
    localparam DONE      = 3'b100;
    localparam FAIL_STAT = 3'b101;

    reg [2:0] state, next_state;
    reg [ADDR_WIDTH-1:0] addr_counter;
    wire [DATA_WIDTH-1:0] all_zeros = {DATA_WIDTH{1'b0}};
    wire [DATA_WIDTH-1:0] all_ones  = {DATA_WIDTH{1'b1}};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bist_fail <= 1'b0;
            bist_done <= 1'b0;
            addr_counter <= 0;
        end else begin
            state <= next_state;
            if (state == M_ELEM_1R && sram_rdata != all_zeros) begin
                bist_fail <= 1'b1;
            end
            
            
            if (state == IDLE)
                addr_counter <= 0;
            else if (state == M_ELEM_0 || state == M_ELEM_1W)
                addr_counter <= addr_counter + 1;
                
            
            if (state == DONE)
                bist_done <= 1'b1;
        end
    end

   
    always @(*) begin
        
        next_state = state;
        bist_we    = 1'b0;
        bist_re    = 1'b0;
        bist_wdata = all_zeros;
        bist_addr  = addr_counter;

        if (bist_fail) begin
            next_state = FAIL_STAT;
        end else begin
            case (state)
                IDLE: begin
                    if (bist_start) next_state = M_ELEM_0;
                end

                M_ELEM_0: begin
                    bist_we = 1'b1;
                    bist_wdata = all_zeros;
                    if (addr_counter == {ADDR_WIDTH{1'b1}}) 
                        next_state = M_ELEM_1R;
                end

                M_ELEM_1R: begin
                    bist_re = 1'b1;
                    next_state = M_ELEM_1W; 
                end

                M_ELEM_1W: begin
                    bist_we = 1'b1;
                    bist_wdata = all_ones;
                    if (addr_counter == {ADDR_WIDTH{1'b1}})
                        next_state = DONE; 
                    else
                        next_state = M_ELEM_1R;
                end

                DONE: begin
                end
                
                FAIL_STAT: begin
                end

                default: next_state = IDLE;
            endcase
        end
    end

endmodule
