`timescale 1ns / 1ps
module CordicActivation (
    input wire signed [15:0] x,
    output wire signed [15:0] sigmoid_y,
    output wire signed [15:0] tanh_y
);

    wire signed [15:0] sigmoid_angle;
    wire signed [15:0] tanh_angle;
    wire signed [15:0] sigmoid_gain;
    wire signed [15:0] tanh_gain;
    reg signed [15:0] sigmoid_precision_adjusted_gain;
    reg signed [15:0] tanh_precision_adjusted_gain;

    assign sigmoid_angle = x;
    assign tanh_angle = x;
    
    assign sigmoid_gain = 16'b1000000000000000;
    assign tanh_gain = 16'b1000000000000000;
    
    always @(*) begin
        if (x >= 12'h3C0) begin
            sigmoid_precision_adjusted_gain <= sigmoid_gain << 1;
            tanh_precision_adjusted_gain <= tanh_gain << 1;
        end
        else begin
            sigmoid_precision_adjusted_gain <= sigmoid_gain;
            tanh_precision_adjusted_gain <= tanh_gain;
        end
    end

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign sigmoid_angle = sigmoid_angle - (x >> i);
            assign tanh_angle = tanh_angle - (x >> i);
            assign sigmoid_gain = sigmoid_gain + (sigmoid_precision_adjusted_gain >> i);
            assign tanh_gain = tanh_gain + (tanh_precision_adjusted_gain >> i);
        end
    endgenerate

    // Sigmoid calculation
    assign sigmoid_y = sigmoid_approx(-sigmoid_gain * sigmoid_angle);

    // Tanh calculation
    //assign tanh_y = tanh_approx(-2 * tanh_gain * tanh_angle);

    // Iterative exponential approximation function
    function signed [15:0] sigmoid_approx;
        input signed [15:0] value;
        reg signed [16:0] result;
        reg signed [16:0] term;
        integer i;
        begin
            result = 17'b1_0000_0000_0000_0000; // Initialize result to 1.0 in Q16.0 format
            term = 17'b1_0000_0000_0000_0000;   // Initialize term to 1.0 in Q16.0 format
            for (i = 0; i < 8; i = i + 1) begin
                term = (term * value) >> 16; // Multiply and shift for approximation
                result = result + term;
            end
            return result;
        end
    endfunction
endmodule

