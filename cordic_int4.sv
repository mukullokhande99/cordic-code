`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2023 10:12:55 PM
// Design Name: 
// Module Name: cordic_int4
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


module cordic_int4(int_input, tanh_output, sigmoid_output);
    input [3:0] int_input;  // 4-bit integer input
    output reg [3:0] tanh_output;
    output reg [3:0] sigmoid_output;

    reg [3:0] x, y;
    reg [3:0] x_new, y_new;
    reg [3:0] i;
    reg d;

    // Constants for CORDIC iterations
    reg [3:0] K [0:3];
    initial begin
        K[0] = 4'h4;  // 0.549306
        K[1] = 4'h2;  // 0.255412
        K[2] = 4'h1;  // 0.125657
        K[3] = 4'h1;  // 0.062581
    end

    // CORDIC algorithm for 4-bit integer inputs
    always @(*) begin
        x = int_input;
        y = 4'b0;

        for (i = 0; i < 4; i = i + 1) begin
            d = (x < 4'h0) ? 1 : 0;
            x_new = x - (d ? (y >> i) : - (y >> i));
            y_new = y + (d ? (x >> i) : - (x >> i));

            x = x_new;
            y = y_new;
        end

        tanh_output = y >> 1;
        sigmoid_output = 4'hf / (1 + (4'hf >> y));
    end
endmodule
