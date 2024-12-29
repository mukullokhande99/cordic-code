`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2020 12:53:09 PM
// Design Name: 
// Module Name: shift_Reg
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


module Shift_Reg(
    input [8:0] in,
    input clock,
    input reset,
    input [2:0] count,
    output reg [8:0] out_q
    );
    integer my_int;
    always @( count )
            my_int = count;
    always@(posedge clock)
    begin
    if(reset==1) 
    begin
    out_q <= 9'b000000000;
    end
    else
    begin
    
    out_q[8:0]<=(in[8:0]>>>my_int);
   
    end
    end
endmodule
