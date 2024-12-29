`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2023 10:09:36 PM
// Design Name: 
// Module Name: cordic_fp16
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


module cordic_fp16(fp16_input, tanh_output, sigmoid_output);
    input [15:0] fp16_input;
    output reg [15:0] tanh_output;
    output reg [15:0] sigmoid_output;

    reg [15:0] x, y, z;
    reg [15:0] x_new, y_new, z_new;
    reg [3:0] i;
    reg d;

    // Constants for CORDIC iterations
    reg [15:0] K [0:3];
    initial begin
        K[0] = 0.549306;
        K[1] = 0.255412;
        K[2] = 0.125657;
        K[3] = 0.062581;
        //K[0] = atan(1) = ?/4, K[1] = atan(1/2), K[2] = atan(1/4), K[3] = atan(1/8)
    end

    // CORDIC algorithm for fp16 numbers
    always @(*) begin
        x = fp16_input;
        y = 16'b0;
        z = 16'b0;

        for (i = 0; i < 4; i = i + 1) begin
            d = (x < 16'h0000) ? 1 : 0;
            x_new = x - (d ? (y >> 16) : - (y >> 16));
            y_new = y + (d ? (x >> 16) : - (x >> 16));
            z_new = z + (d ? K[i] : -K[i]);

            x = x_new;
            y = y_new;
            z = z_new;
        end

        tanh_output = y >> 1;
        sigmoid_output = (16'h1 << 15) / (1 + ((16'h1 << 1) >> y));
    end
endmodule

