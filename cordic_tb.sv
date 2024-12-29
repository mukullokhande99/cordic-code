`timescale 1ns / 1ps

module cordic_tb;

    // Parameters
    parameter n = 8;
    parameter INT_BITS = 4;
    parameter FRAC_BITS = 4;
    parameter CORDIC_ITERATIONS_STAGE1 = 4;
    parameter CORDIC_ITERATIONS_STAGE2 = 5;

    // Inputs
    reg signed [n-1:0] x;
    reg sel;

    // Outputs
    wire signed [n-1:0] activation_out;

    cordic_2stage_af #(.n(n))
        uut (.x(x), .sel(sel), .activation_out(activation_out));

    
    reg clk = 0;
    always #5 clk = ~clk;

    initial begin
        
        x = 8'b01010101; 
        sel = 0; 
        #100;

        
        sel = 1;
        #100;

        
        x = 8'b00110011;
        #100;

    end

endmodule
