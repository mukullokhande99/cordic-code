`timescale 1ns / 1ps

module cordic_stage(input [7:0]x0,y0,z0, input [2:0] rom_addr, input clk,sel,/*input act_sel,*/ output reg [7:0]x1,y1,z1,rom_op/*act_out*/);
//sel= 8/2x4b act_sel= tan/sig
//signz
//reg m=-1;
reg op_drop1,op_drop2;
reg [1:0]coutx, couty,coutz;
//reg couts_denom;
reg [7:0]imm1,imm2;
//reg [7:0] ez;
reg di;
//reg sig_ez; //for denom,num of sigmoid
//opsel=-mdi=-(-1)di=di
shift_8b a1(.data_input(x0),.sel(sel),.op_drop(op_drop1),.data_output(imm1));
code_addsub a2(.a(x0),.b(imm2),.cin(2'b00),.sel(sel),.op_sel(di),.sum(x1),.cout(coutx));

//opsel=di
shift_8b b1(.data_input(y0),.sel(sel),.op_drop(op_drop2),.data_output(imm2));
code_addsub b2(.a(y0),.b(imm1),.cin(2'b00),.sel(sel),.op_sel(di),.sum(y1),.cout(couty));

//addr_in_port=1 for stage i=1 
//opsel=-di
rom1_cordic c1(.clk_port1(clk), .en_port1(1'b1), .addr_in_port1(rom_addr),.data_out_port1(rom_op));    
code_addsub c2(.a(z0),.b(rom_op),.cin(2'b00),.sel(sel),.op_sel(~di),.sum(z1),.cout(coutz));

//sinh +cosh=ez
//code_addsub p1(.a(x1),.b(y1),.cin(2'b00),.sel(sel),.op_sel(1'b0),.sum(ez),.cout(couts_denom));

always@(posedge clk)
begin
di<=z0[7];
//act_out= act_sel?(y1/x1):(ez/1+ez);
end

endmodule
