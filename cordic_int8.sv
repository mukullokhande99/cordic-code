`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2023 10:11:32 PM
// Design Name: 
// Module Name: cordic_int8
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


module cordic_int8(int_input, tanh_output, sigmoid_output);
    input [7:0] int_input;
    output reg [7:0] tanh_output;
    output reg [7:0] sigmoid_output;

    reg [7:0] x, y;
    reg [7:0] x_new, y_new;
    reg [3:0] i;
    reg d;

    // Constants for CORDIC iterations
    reg [7:0] K [0:3];
    initial begin
        K[0] = 3'b001;  // 0.549306
        K[1] = 3'b000;  // 0.255412
        K[2] = 3'b000;  // 0.125657
        K[3] = 3'b000;  // 0.062581
    end

    // CORDIC algorithm for integer inputs
    always @(*) begin
        x = int_input;
        y = 8'b0;

        for (i = 0; i < 4; i = i + 1) begin
            d = (x < 8'h00) ? 1 : 0;
            x_new = x - (d ? (y >> i) : - (y >> i));
            y_new = y + (d ? (x >> i) : - (x >> i));

            x = x_new;
            y = y_new;
        end

        tanh_output = y >> 1;
        sigmoid_output = 8'hff / (1 + (8'hff >> y));
    end
endmodule
