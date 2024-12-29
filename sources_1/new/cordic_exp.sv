`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2023 11:59:21 AM
// Design Name: 
// Module Name: cordic_exp
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


module cordic_exp(input [7:0]x,y,z, input clk,sel,act_sel, output reg [7:0]xn,yn,zn,act_out);
reg [3:0]di;
reg [1:0]couts_denom1,couts_denom2;
reg [7:0] ez1,ez2;
reg [7:0] rom_op1, rom_op2,rom_op3, rom_op4;
reg [7:0] x1,y1,z1;
reg [7:0] x2,y2,z2;
reg [7:0] x3,y3,z3;

cordic_stage stage1(.x0(x),.y0(y),.z0(z), .rom_addr(3'b000), .clk(clk),.sel(sel),.x1(x1),.y1(y1),.z1(z1),.rom_op(rom_op1));
cordic_stage stage2(.x0(x1),.y0(y1),.z0(z1), .rom_addr(3'b001), .clk(clk),.sel(sel),.x1(x2),.y1(y2),.z1(z2),.rom_op(rom_op2));
cordic_stage stage3(.x0(x2),.y0(y2),.z0(z2), .rom_addr(3'b010), .clk(clk),.sel(sel),.x1(x3),.y1(y3),.z1(z3),.rom_op(rom_op3));
cordic_stage stage4(.x0(x3),.y0(y3),.z0(z3), .rom_addr(3'b011), .clk(clk),.sel(sel),.x1(xn),.y1(yn),.z1(zn),.rom_op(rom_op4));

//sinh +cosh=ez
code_addsub p1(.a(xn),.b(yn),.cin(2'b00),.sel(sel),.op_sel(1'b0),.sum(ez1),.cout(couts_denom1));
code_addsub p2(.a(xn),.b(yn),.cin(2'b01),.sel(sel),.op_sel(1'b0),.sum(ez2),.cout(couts_denom2));

always@(posedge clk)
begin
di<=z[7];
act_out= act_sel?(yn/xn):(ez1/ez2);
end

endmodule
