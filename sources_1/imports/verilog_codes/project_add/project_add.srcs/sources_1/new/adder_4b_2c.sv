`timescale 1ns / 1ps

module adder_4b_2c(input [3:0] a,b,input cin, input op_sel,output reg [3:0] sum,output reg cout);
    reg [2:0] carry;
    
    //approx_compressor a1(.p(op_sel),.q(a[0]),.r(b[0]),.s(cin),.sum(sum[0]), .cout(carry[0]));
    full_adder adder0(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(carry[0]));
    full_adder adder1(.a(a[1]), .b(b[1]), .cin(carry[0]), .sum(sum[1]), .cout(carry[1]));
    full_adder adder2(.a(a[2]), .b(b[2]), .cin(carry[1]), .sum(sum[2]), .cout(carry[2]));
    full_adder adder3(.a(a[3]), .b(b[3]), .cin(carry[2]), .sum(sum[3]), .cout(cout));

endmodule
