`timescale 1ns / 1ps

module shift_8b(input [7:0] data_input,
    input sel,
    output reg op_drop,
    output reg [7:0] data_output
    );
    reg shift_carry1;
    shift_4b msb(.data_input(data_input[7:4]),.shift_carry(1'b0),.sel(1'b0),.op_drop(shift_carry1),.data_output(data_output[7:4]));
    shift_4b lsb(.data_input(data_input[3:0]),.shift_carry(shift_carry1),.sel(sel),.op_drop(op_drop),.data_output(data_output[3:0]));
    //sel=0 two 4b, sel=1, one 8b
endmodule
