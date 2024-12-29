`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2023 11:40:31 AM
// Design Name: 
// Module Name: code_addsub2
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



module adder_4bit(
    input signed [3:0] a,
    input signed [3:0] b,
    output signed [3:0] sum
);

    assign sum = a + b;

endmodule

module subtractor_4bit(
    input signed [3:0] a,
    input signed [3:0] b,
    output signed [3:0] difference
);

    assign difference = a - b;

endmodule

module code_addsub2(
    input signed [3:0] a,
    input signed [3:0] b,
    input subtract,
    output reg signed [3:0] result
);

    reg signed [3:0] temp_result;

    assign temp_result = (subtract) ? subtractor_4bit(a, b) : adder_4bit(a, b);

    always @(*)
    begin
        if (temp_result < 0)
            result = temp_result + 16;
        else
            result = temp_result;
    end

endmodule

