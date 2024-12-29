`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2023 01:03:21 PM
// Design Name: 
// Module Name: shift_16b
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
//incomplete

module shift_16b(input [15:0] data_input,
    input [1:0]sel,
    output reg op_drop,
    output reg [15:0] data_output
    );
    reg shift_carry1;
    shift_8b msb(.data_input(data_input[7:4]),.shift_carry(1'b0),.sel(1'b0),.op_drop(shift_carry1),.data_output(data_output[7:4]));
    shift_8b lsb(.data_input(data_input[3:0]),.shift_carry(shift_carry1),.sel(sel),.op_drop(op_drop),.data_output(data_output[3:0]));
    //sel=0 two 4b, sel=1, one 8b
    
endmodule
