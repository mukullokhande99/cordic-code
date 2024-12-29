`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2023 12:52:57 PM
// Design Name: 
// Module Name: cordic_4stage_tb
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


module cordic_4stage_tb();
  reg clk,sel,act_sel;
  reg [7:0]x,y,z;
  wire [7:0] xn, yn, zn,act_out;

  cordic_exp a1 (
    .x(x),.y(y),.z(z),.clk(clk),.sel(sel), .act_sel(act_sel),
    .xn(xn),.yn(yn),.zn(zn),.act_out(act_out) );

 
  always #5 clk = ~clk; 

  initial begin
    clk=0;
    act_sel=1'b0;
    x=8'b00100110;
    y=8'b00000000;
    z=8'b00010000;
    sel = 1'b1;
    #35;
    act_sel=1'b1;
    #25;

  end

endmodule