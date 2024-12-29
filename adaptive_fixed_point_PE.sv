`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2023 05:39:36 PM
// Design Name: 
// Module Name: adaptive_fixed_point_PE
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


module adaptive_fixed_point_PE #(parameter dec_part=3, mantissa_part=12, flag=1 )
( input init,rstn, clock, PE_finish, input [dec_part+mantissa_part:0] image, weight, output reg [2*dec_part+ 2*mantissa_part + flag:0]out, output reg [dec_part+mantissa_part:0]  out1, out2, output reg init_out1, init_out2,stop );
                
          
    
    
    reg [dec_part + mantissa_part :0] out1_reg, out2_reg;
    reg init_out1_reg, init_out2_reg;
    reg [2*dec_part + 2*mantissa_part  + flag :0] acc_reg = 0;
    reg [dec_part + mantissa_part :0] mult_reg = 0;
    reg [dec_part + mantissa_part :0] mul1_reg = 0;
    wire [2*dec_part + 2*mantissa_part :0] result ;
    wire [2*dec_part + 2*mantissa_part :0] result_imm ;
    reg [2*dec_part + 2*mantissa_part :0] product = 0;
    reg [3:0] state = 4'b0000;
    reg [2*dec_part + 2*mantissa_part  + flag :0] out_reg;
    
    wire [dec_part + mantissa_part :0] mult;
    wire [dec_part + mantissa_part :0] mul1;
    wire [dec_part + mantissa_part :0] acc ;
    wire [dec_part + mantissa_part :0] acc1 ;
    
    
    assign result [2*dec_part + 2*mantissa_part  - 1 : 0] = result_imm [2*dec_part + 2*mantissa_part ] ? (~result_imm [2*dec_part + 2*mantissa_part - 1 : 0] + 1):result_imm [2*dec_part + 2*mantissa_part  - 1 : 0];
    assign result [2*dec_part + 2*mantissa_part ] = result_imm [2*dec_part + 2*mantissa_part ];
    assign out[2*dec_part + 2*mantissa_part + flag -1 :0] = acc_reg[2*dec_part + 2*mantissa_part + flag] ? (~acc_reg[2*dec_part + 2*mantissa_part  + flag -1 :0] +1) : acc_reg[2*dec_part +2*mantissa_part  + flag -1 :0];
    assign out [2*dec_part + 2*mantissa_part + flag] = acc_reg [2*dec_part + 2*mantissa_part + flag];
    
    assign mult   = mult_reg;
    assign mul1 = mul1_reg;
    assign acc  = acc_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;
    assign init_out1 = init_out1_reg;
    assign init_out2 = init_out2_reg;
    
    
    
 multiplier_fxp #(dec_part, mantissa_part) multiply  (.weight(weight), .image(image),   .product(result_imm));
    
    always @(posedge clock) begin
        if (!rstn) begin
            acc_reg <= 0;
            out1_reg        <= 0;
            out2_reg        <= 0;
            stop            <= 0;
        end 
        
        else begin
        
            if (PE_finish) begin             
                stop            <= 1;                
            end
                
            else if (init) begin
            
                if (!(acc_reg[2*dec_part + 2*mantissa_part  + flag] ^ result[2*dec_part + 2*mantissa_part])) begin    
                    
                    acc_reg [2*dec_part + 2*mantissa_part + flag - 1:0]     <= acc_reg[2*dec_part + 2*mantissa_part + flag-1:0] + result[2*dec_part + 2*mantissa_part-1:0];
                    acc_reg [2*dec_part + 2*mantissa_part + flag] <= acc_reg [2*dec_part + 2*mantissa_part + flag];
                    
                end
                
                else if (acc_reg[2*dec_part + 2*mantissa_part + flag - 1:0] > result[2*dec_part + 2*mantissa_part-1:0]) begin
                
                    acc_reg [2*dec_part + 2*mantissa_part + flag - 1:0]     <= acc_reg[2*dec_part + 2*mantissa_part  + flag-1:0] - result[2*dec_part + 2*mantissa_part-1:0];
                    acc_reg [2*dec_part + 2*mantissa_part + flag] <= acc_reg [2*dec_part + 2*mantissa_part + flag];
                    
                end
                
                else begin
                
                    acc_reg [2*dec_part + 2*mantissa_part + flag - 1:0]     <= - acc_reg[2*dec_part + 2*mantissa_part + flag-1:0] + result[2*dec_part + 2*mantissa_part-1:0];
                    acc_reg [2*dec_part + 2*mantissa_part + flag] <= result[2*dec_part + 2*mantissa_part];
                
                end
                    
                out1_reg            <= image;
                out2_reg            <= weight;   
                init_out1_reg       <= init;
                init_out2_reg       <= init;
                
            end 
                   
        end

    end
    
 endmodule


