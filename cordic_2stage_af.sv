`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2023 08:03:43 PM
// Design Name: 
// Module Name: cordic_2stage_af
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


module cordic_2stage_af #(parameter n=8,    parameter INT_BITS = 4, // Number of integer bits
    parameter FRAC_BITS = 4, // Number of fractional bits
    parameter CORDIC_ITERATIONS_STAGE1 = 4,
    parameter CORDIC_ITERATIONS_STAGE2 = 5)(
    input wire signed [n-1:0] x, // n-bit input
    input wire sel,
    output wire signed [n-1:0] activation_out
);
    wire signed [n-1:0] x_mapped;
    wire signed [n-1:0] y_stage1, x_stage2, y_stage2;
    wire signed [n-1:0] exp_input;
    wire signed [n-1:0] exp_output;


    // Map input range to [-1, 1]
    assign x_mapped = x >> (n - INT_BITS - FRAC_BITS-1);

    // First stage CORDIC
    generate
        genvar i;
        wire signed [n-1:0] z0_stage1 = sel ? -x_mapped : x_mapped;
        for (i = 0; i < CORDIC_ITERATIONS_STAGE1; i = i + 1) begin : CORDIC_STAGE1
            assign x_mapped = (z0_stage1 >= 0) ? x_mapped - (y_stage1 >> i) : x_mapped + (y_stage1 >> i);
            assign y_stage1 = (z0_stage1 >= 0) ? y_stage1 + (x_mapped >> i) : y_stage1 - (x_mapped >> i);
            assign z0_stage1 = (z0_stage1 >= 0) ? z0_stage1 - (1 << i) : z0_stage1 + (1 << i);
        end
    endgenerate

    // residue angle for the second stage
    assign exp_input = y_stage1;
    assign exp_output = x_mapped;
    wire signed [n-1:0] z0_stage2 = exp_output;

    // Second stage CORDIC
    generate
        genvar j;
        for (j = 0; j < CORDIC_ITERATIONS_STAGE2; j = j + 1) begin : CORDIC_STAGE2
            assign x_stage2 = (z0_stage2 >= 0) ? x_stage2 - (y_stage2 >> j) : x_stage2 + (y_stage2 >> j);
            assign y_stage2 = (z0_stage2 >= 0) ? y_stage2 + (x_stage2 >> j) : y_stage2 - (x_stage2 >> j);
            assign z0_stage2 = (z0_stage2 >= 0) ? z0_stage2 - (1 << j) : z0_stage2 + (1 << j);
        end
    endgenerate

    // Activation computation
    assign activation_out = sel ?
        ((1 << (INT_BITS + FRAC_BITS)) / (1 + y_stage2)) :
        ((1 << (INT_BITS + FRAC_BITS)) * ((2 / (1 + y_stage2)) - 1));
endmodule

