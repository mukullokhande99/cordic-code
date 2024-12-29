`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2020 07:31:06 AM
// Design Name: 
// Module Name: topp
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


module top(
    input [8:0] x,
    input [8:0] y,
    input [8:0] z,
    input clock,
    input reset,
    output  [8:0] yout
    );
   wire [8:0] a,b,c,a1,b1,c1,a2,b2,c2,a3,c3,b3,a4,c4;
   reg [8:0] mem=9'b010000000;
   reg [8:0] mem1=9'b001000000;
   reg [8:0] mem2=9'b000100000;
   reg [8:0] mem3=9'b000010000;
   reg [8:0] mem4=9'b000001000;
   reg [2:0] d1=3'b000;
   reg [2:0] d2=3'b001;
   reg [2:0] d3=3'b010;
   reg [2:0] d4=3'b011;
   reg [2:0] d5=3'b100;
      
   
   cordic_stage stage1(x,y,z,mem,d1,clock,reset,a,b,c);
   cordic_stage stage2(a,b,c,mem1,d2,clock,reset,a1,b1,c1);
  cordic_stage stage3(a1,b1,c1,mem2,d3,clock,reset,a2,b2,c2);
  cordic_stage stage4(a2,b2,c2,mem3,d4,clock,reset,a3,b3,c3);
  cordic_stage stage5(a3,b3,c3,mem4,d5,clock,reset,a4,yout,c4);
 
endmodule
