`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2023 07:50:01 PM
// Design Name: 
// Module Name: twos_comp
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


module twos_comp(
    input [3:0] num_in,
    output reg [3:0] twos_comp_out
);

    always @(*) begin
        // If the input number is positive, the 2's complement is the same as the input.
        if (num_in[3] == 0) begin
            twos_comp_out = num_in;
        end
        // If the input number is negative, compute the 2's complement.
        else begin
            twos_comp_out = ~num_in + 1;
        end
    end

endmodule

