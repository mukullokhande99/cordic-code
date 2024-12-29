`timescale 1ns / 1ps

module code_addsub(input [7:0]a,b,
    input [1:0] cin,
    input sel,
    input op_sel,
    output reg [7:0] sum,
    output reg [1:0]cout
);

    reg [1:0]cout_temp;
    
    //sel=1, one 8b; sel=0 two 4b 
    //op_sel=1 Sub; op_sel=0, Add
    adder_4b_2c adder0(.a(a[3:0]), .b(op_sel?(~b[3:0]):b[3:0]), .cin(op_sel?1'b1:cin[0]), .op_sel(op_sel),.sum(sum[3:0]), .cout(cout_temp[0]));
    adder_4b_2c adder1(.a(a[7:4]), .b(op_sel?(~b[7:4]):b[7:4]), .cin(sel?cout_temp[0]: cin[1]), .op_sel(op_sel), .sum(sum[7:4]), .cout(cout_temp[1]));
    
    always@(*)
    begin
     cout<= sel?({1'b0,cout_temp[1]}):({cout_temp[1],cout_temp[0]});
     end

endmodule
