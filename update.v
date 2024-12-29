`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2020 05:42:56 PM
// Design Name: 
// Module Name: update
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


module update(
input clock,
input reset,
    output reg [2:0] count
    
    );
   always@(posedge clock)
   begin
   if(reset==1) 
   begin
   count=3'b000;
   end
   else
   begin 
   count=count+3'b001;
   end 
   end
endmodule
