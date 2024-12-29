`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2024 19:18:14
// Design Name: 
// Module Name: cordic
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


module cordic(
    input [15:0]AF_in,
    input sigOrTan,ReluOrCoric,
    input wire clk,simd_sel,rst,shift_mode,
    output [15:0]AF_out    
    );
    //ReluOrCoric=1 relu and for 0 cordic
    reg [15:0]xin=16'b0010011010100011,yin=16'b0;
    reg [15:0]one=16'b0010000000000000;
    wire ecarry0,ecarry1,carry0,carry1;
    wire [15:0]onePlusERaisToNegInp,ERaisToNegInp,xout,yout,zout;
    wire [15:0] carryERaisToNegInp;
   
    nstages_cordic_hyperbolic(xin,yin,AF_in,xout, yout, zout,clk, rst, simd_sel, shift_mode);
    
    simd_adder_16(ERaisToNegInp,ecarry0,ecarry1,yout,xout,1'b1,1'b1,simd_sel);
    assign carryERaisToNegInp = {ecarry0,ERaisToNegInp[15:1]};
    simd_adder_16(onePlusERaisToNegInp,carry0,carry1,one,carryERaisToNegInp,1'b0,1'b0,simd_sel);
    
    wire zin=16'b0;
    wire [15:0]DIVout;
    // sigOrTan=1 sig 
    wire [0:15]divx=sigOrTan?one:xout ,divy=sigOrTan?{carry0,onePlusERaisToNegInp[15:1]}:yout;
    nstages_divisonunit( divx,divy,16'b0,,, DIVout,  clk,  rst,  simd_sel,  shift_mode);
    
    assign AF_out=ReluOrCoric?AF_in[15]?16'b0:AF_in:DIVout;
endmodule

module full_adder(sum,cout,a,b,cin);
input a,b,cin;
output sum,cout;
assign sum=a^b^cin;
assign cout=((a^b)&cin)|(a&b);
endmodule

module simd_adder_16 (out, cout0, cout1, a, b, add_sub0, add_sub1, simd_sel);
input [15:0]a, b;
input add_sub0,add_sub1, simd_sel;
output cout0, cout1;
output [15:0]out;
wire [15:0]t;
full_adder fa0(out[0], t[0], a[0], add_sub0?(~b[0]+1'b1):b[0], 1'b0);
generate
    genvar i;
    for (i = 1; i < 16; i = i + 1)
     begin : full_adder_instances
        if(i!=8)
         begin
         full_adder fa(out[i], t[i], a[i], add_sub0?(~b[i]):b[i], t[i-1]);
         end
        else
         begin
          full_adder fa(out[i], t[i], a[i], add_sub1?(~b[i]+1'b1):b[i], ((~simd_sel)&t[i-1]));
         end 
    end
endgenerate
assign cout1=t[15];
assign cout0=t[7];
endmodule

module shifter(input wire [15:0] x, input wire [3:0] amt, input wire shift_mode,simd_mode,output wire [15:0]y );
wire [15:0] imm1,imm2,imm3;

//simd_mode=1 two 8 bits else 16 bits
//shift_mode=1 arithmetic else logical
assign imm1 = simd_mode ? (amt[3] ? {16{x[15]}}: x): (amt[3] ? {(shift_mode?{8{x[15]}}:8'b0),x[15:8]}: x);
//assign imm1 = simd_mode ? x: (amt[3] ? {(shift_mode?{8{x[15]}}:8'b0),x[15:8]}: x);
assign imm2 = simd_mode ? (amt[2] ? {(shift_mode?{4{imm1[15]}}:4'b0),imm1[15:12],(shift_mode?{4{imm1[7]}}:4'b0),imm1[7:4]} : imm1)
                        : (amt[2] ? {(shift_mode?{4{imm1[15]}}:4'b0),imm1[15:4]}: imm1);
assign imm3 = simd_mode ? (amt[1] ? {(shift_mode?{2{imm2[15]}}:2'b0),imm2[15:10],(shift_mode?{2{imm2[7]}}:2'b0),imm2[7:2]}: imm2):(amt[1] ? {{2{imm2[15]}},imm2[15:2]}: imm2);
assign y =  simd_mode ? (amt[0] ? {(shift_mode?imm3[15]:1'b0),imm3[15:9],(shift_mode?imm3[7]:1'b0),imm3[7:1]}: imm3):(amt[0] ? {(shift_mode?imm3[15]:1'b0),imm3[15:1]}: imm3);

endmodule

module dff_16bit_pipelinereg(clk, in, out, reset);
input clk, reset;
input [15:0]in;
output reg [15:0]out;
always @(posedge clk, negedge reset)
 begin
   if(!reset)
     out=16'b0;
   else
     out=in;
 end    
endmodule

module lutf(
    input [3:0] in,
    output reg [15:0] out
);

// Declare memory array to store LUT values
reg [15:0] lut_memory [0:15];

// Initialize LUT memory with desired output values for each input combination
initial begin
    lut_memory[0]  = 16'b0001000110010000;
lut_memory[1]  =  16'b0000100000101100;
lut_memory[2]  =  16'b0000010000000100;
lut_memory[3]  =  16'b0000001000000000;
lut_memory[4]  =  16'b0000000100000000;
lut_memory[5]  =  16'b0000000010000000;
lut_memory[6]  =  16'b0000000001000000;
lut_memory[7]  =  16'b0000000000100000;
lut_memory[8]  =  16'b0000000000010000;
lut_memory[9]  =  16'b0000000000001000;
lut_memory[10]  =  16'b0000000000000100;
lut_memory[11]  =  16'b0000000000000010;
lut_memory[12]  =  16'b0000000000000001;
lut_memory[13]  =  16'b00000000000000001;
lut_memory[14]  =  16'b000000000000000001;

end

// Read from LUT memory based on input 'in'
always @* begin
    out = lut_memory[in];
end

endmodule

module lutd(
    input [3:0] in,
    output reg [15:0] out
);
// Declare memory array to store LUT values
reg [15:0] lut_memory [0:15];
// Initialize LUT memory with desired output values for each input combination
initial begin
    lut_memory[0]  = 16'b0001000110010000;
lut_memory[1]  =  16'b0000100000101100;
lut_memory[2]  =  16'b0000010000000100;
lut_memory[3]  =  16'b0000001000000000;
lut_memory[4]  =  16'b0000000100000000;
lut_memory[5]  =  16'b0000000010000000;
lut_memory[6]  =  16'b0000000001000000;
lut_memory[7]  =  16'b0000000000100000;
lut_memory[8]  =  16'b0000000000010000;
lut_memory[9]  =  16'b0000000000001000;
lut_memory[10]  =  16'b0000000000000100;
lut_memory[11]  =  16'b0000000000000010;
lut_memory[12]  =  16'b0000000000000001;
lut_memory[13]  =  16'b00000000000000001;
lut_memory[14]  =  16'b000000000000000001;
end
// Read from LUT memory based on input 'in'
always @* begin
    out = lut_memory[in];
end
endmodule

module stage_cordic_hyp #(parameter stage=0) (x0, y0, z0, px0, py0, pz0, simd_sel, shift_mode,clk,rst);
input [15:0]x0, y0,z0;
input simd_sel, shift_mode, clk, rst;
wire coutx10,coutx11,couty10,couty11,coutz10,coutz11;
output [15:0]px0, py0, pz0;
wire [15:0]shifteroutx1, shifterouty1, x1, y1, z1;
wire [15:0]lutout;

lutf l(.out(lutout),.in(stage));
//for output x1
simd_adder_16 simd_adder1x1(.out(x1),.cout0(coutx10),.cout1(coutx11),.a(x0),.b(shifteroutx1),.add_sub0(z0[7]),.add_sub1(z0[15]),.simd_sel(simd_sel));
shifter      shifter1x1(.x(y0), .y(shifteroutx1), .amt(stage+1), .simd_mode(simd_sel), .shift_mode(shift_mode));
//for output y1
simd_adder_16 simd_adder1y1(.out(y1),.cout0(couty10),.cout1(couty11),.a(y0),.b(shifterouty1),.add_sub0(z0[7]),.add_sub1(z0[15]),.simd_sel(simd_sel));
shifter      shifter1y1(.x(x0), .y(shifterouty1), .amt(stage+1), .simd_mode(simd_sel), .shift_mode(shift_mode));
//for output z1
simd_adder_16 simd_adder1z1(.out(z1),.cout0(coutz10),.cout1(coutz11),.a(z0),.b(lutout),.add_sub0(~z0[7]),.add_sub1(~z0[15]),.simd_sel(simd_sel));

//pipelineregister first stage
dff_16bit_pipelinereg s1regx1(.clk(clk),.reset(rst),.in((simd_sel)?{coutx11,x1[15:9],coutx10,x1[7:1]}:{coutx11,x1[15:1]}),.out(px0));
dff_16bit_pipelinereg s1regy1(.clk(clk),.reset(rst),.in((simd_sel)?{couty11,y1[15:9],couty10,y1[7:1]}:{couty11,y1[15:1]}),.out(py0));
dff_16bit_pipelinereg s1regz1(.clk(clk),.reset(rst),.in((simd_sel)?{coutz11,z1[15:9],coutz10,z1[7:1]}:{coutz11,z1[15:1]}),.out(pz0));

endmodule

module nstages_cordic_hyperbolic(input [15:0]xin,yin,zin, output [15:0]xout, yout, zout, input clk, input rst, input simd_sel, input shift_mode);
 parameter N=16;

 wire [15:0]tx[N-1:0];
 wire [15:0]ty[N-1:0];
 wire [15:0]tz[N-1:0];
 stage_cordic_hyp  #(0) stage0(.x0(xin), .y0(yin), .z0(zin), .px0(tx[0]), .py0(ty[0]), .pz0(tz[0]), .simd_sel(simd_sel), .shift_mode(shift_mode),.clk(clk),.rst(rst));
 generate
    genvar i;
    for (i = 1; i <N; i = i + 1)
     begin : pipelinestages_instances
       stage_cordic_hyp #(i) stage(.x0(tx[i-1]), .y0(ty[i-1]), .z0(tz[i-1]), .px0(tx[i]), .py0(ty[i]), .pz0(tz[i]), .simd_sel(simd_sel), .shift_mode(shift_mode),.clk(clk),.rst(rst));  
    end
endgenerate
    assign xout=tx[N-1];  
   assign yout = ty[N-1];
   assign    zout = tz[N-1];
endmodule

module stage_divisionunit #(parameter stage=0)(x0,y0,z0, px0,py0,pz0,clk,rst,simd_sel,shift_mode);

input [15:0]x0,y0,z0;
input clk,rst,simd_sel,shift_mode;
output [15:0]px0,py0,pz0;

wire [15:0]shifterouty1,lutout,y1,z1;
wire couty10,couty11,coutz10,coutz11;

//for output Y1
simd_adder_16 simd_adder1y1(.out(y1),.cout0(couty10),.cout1(couty11),.a(y0),.b(shifterouty1),.add_sub0(/* /),.add_sub1(/ */),.simd_sel(simd_sel));
shifter      shifter1x0(.x(x0), .y(shifterouty1), .amt(stage+1), .simd_mode(simd_sel), .shift_mode(shift_mode));

//for output Z1
simd_adder_16 simd_adder1z1(.out(z1),.cout0(coutz10),.cout1(coutz11),.a(z0),.b(lutout),.add_sub0(~z0[7]),.add_sub1(~z0[15]),.simd_sel(simd_sel));
lutd l(.out(lutout),.in(stage));

//pipelined register outputs
dff_16bit_pipelinereg s1regx1(.clk(clk),.reset(rst),.in(x0),.out(px0));
dff_16bit_pipelinereg s1regy1(.clk(clk),.reset(rst),.in((simd_sel)?{couty11,y1[15:9],couty10,y1[7:1]}:{couty11,y1[15:1]}),.out(py0));
dff_16bit_pipelinereg s1regz1(.clk(clk),.reset(rst),.in((simd_sel)?{coutz11,z1[15:9],coutz10,z1[7:1]}:{coutz11,z1[15:1]}),.out(pz0));

endmodule

module nstages_divisonunit(input [15:0]xin,yin,zin, output [15:0]xout, yout, zout, input clk, input rst, input simd_sel, input shift_mode);
 parameter N=8;

 wire [15:0]tx[N-1:0];
 wire [15:0]ty[N-1:0];
 wire [15:0]tz[N-1:0];
 stage_divisionunit  #(0) stage0(.x0(xin), .y0(yin), .z0(zin), .px0(tx[0]), .py0(ty[0]), .pz0(tz[0]), .simd_sel(simd_sel), .shift_mode(shift_mode),.clk(clk),.rst(rst));
 generate
    genvar i;
    for (i = 1; i <N; i = i + 1)
     begin : pipelinestages_instances
     stage_divisionunit #(i) stage(.x0(tx[i-1]), .y0(ty[i-1]), .z0(tz[i-1]), .px0(tx[i]), .py0(ty[i]), .pz0(tz[i]), .simd_sel(simd_sel), .shift_mode(shift_mode),.clk(clk),.rst(rst));  
    end
endgenerate
    assign xout=tx[N-1];  
   assign yout = ty[N-1];
   assign    zout = tz[N-1];
endmodule