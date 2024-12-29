`timescale 1ns / 1ps

module cordic_stage1_tb();
  reg [7:0] z0;
  reg clk;
  reg sel;
  reg [3:0] rom_addr;
  reg [7:0]x0;
  reg [7:0] y0;
  wire [7:0] x1, y1, z1,rom_op;

  cordic_stage stage1 (
    .x0(x0),.y0(y0),.z0(z0),.clk(clk),.sel(sel),.rom_addr(rom_addr),
    .x1(x1),.y1(y1),.z1(z1),.rom_op(rom_op) );

 
  always #5 clk = ~clk; 

  initial begin
    clk=0;
    x0=8'b00100110;
    y0=8'b00000000;
    z0=8'b00010000;
    rom_addr=3'b000;
    sel = 1'b1;

    #35;

  end

endmodule

