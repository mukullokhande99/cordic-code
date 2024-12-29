`timescale 1ns / 1ps

module cordic_stage(
    input [8:0] x,
    input [8:0] y,
    input [8:0] z,
    input [8:0] mem,
    input [2:0] count,
    input clock,
    input reset,
    output [8:0] xout,
    output [8:0] yout,
    output [8:0] zout
    );
    wire sgn_z;
    wire [8:0] qwireY;
   
    
    assign sgn_z=z[8];
       add_sub Zpart12(z,mem,sgn_z,clock,reset,zout);
 Shift_Reg Yshifter(x,clock,reset,count,qwireY);
    
    add_sub Ypart(y,qwireY,~sgn_z,clock,reset,yout);
    assign xout=x;
   
     endmodule
