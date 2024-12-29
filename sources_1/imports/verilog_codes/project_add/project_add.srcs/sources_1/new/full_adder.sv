`timescale 1ns / 1ps

module full_adder(input a, b, cin,
    output wire sum, cout
);
        assign sum = a ^ b ^ cin;
        assign cout = (a & b) | (cin&(a ^b));
    

endmodule
