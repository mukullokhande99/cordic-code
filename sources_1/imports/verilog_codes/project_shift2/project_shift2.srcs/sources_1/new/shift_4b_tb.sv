`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2023 12:24:16 AM
// Design Name: 
// Module Name: shift_4b_tb
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


module shift_4b_tb();

  reg [3:0] data_input;
  reg shift_carry;
  reg sel;

  wire op_drop;
  wire [3:0] data_output;

  shift_4b dut (
    .data_input(data_input),
    .shift_carry(shift_carry),
    .sel(sel),
    .op_drop(op_drop),
    .data_output(data_output)
  );

  initial begin
    data_input = 4'b1101;
    shift_carry = 1;
    sel = 1;

    #10 data_input = 4'b0010;
    #10 shift_carry = 0;
    #10 sel = 0;

  end

endmodule

