`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2020 12:50:39 PM
// Design Name: 
// Module Name: add
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


module add_sub(
    input [8:0] p,
    input [8:0] q,
    input di,
    input clock,
    input reset,
    output reg [8:0] sum
    );
    always@(posedge clock)
    begin
    if(reset==1)
    begin
    sum<=9'b000000000;
    end
    if(di==1)
    begin
    sum=p+q;
    
    end
    else
    begin
    sum=p-q;
    
    end
    end
endmodule
