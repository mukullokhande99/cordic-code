`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2023 11:37:06 PM
// Design Name: 
// Module Name: approx_compressor
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


module approx_compressor(input p,q,r,s,
    output reg sum, cout
);
//p=0/1 depending on Add/sub
//q=a,r=b,s=cin
    /*reg u=p^q;
    reg v=r^s;
    reg w=p|q;
    reg x=r|s;
    reg y=p&q;
    reg z=r&s;
    */
    always@(*)
    begin
    sum <= ((~(p|q))&(r^s)) | ((~(r|s))&(p^q)) | ((r&s)&(p|q)) | ((p&q)&(r|s)) ;
    cout <= ((p|q)&(r|s)) | ((p&q)|(r&s));
    /*sum <= ((~w)&v) | ((~x)&u) | (z&w)|(y&x) ;
    cout <= (w&x) | (y|z);*/
    end
    /*
    assign sum = ((~(p|q))&(r^s)) | ((~(r|s))&(p^q)) | ((r&s)&(p|q)) | ((p&q)&(r|s)) ;
    assign cout = ((p|q)&(r|s)) | ((p&q)|(r&s));
*/
endmodule
