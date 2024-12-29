`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2023 08:40:25 AM
// Design Name: 
// Module Name: axi_lite_interface
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


module axi_lite_interface(input wire aclk,
    input wire aresetn,
    input wire [31:0] awaddr,
    input wire awvalid,
    input wire awready,
    input wire [31:0] wdata,
    input wire wvalid,
    input wire wready,
    input wire [31:0] araddr,
    input wire arvalid,
    input wire arready,
    output wire [31:0] rdata,
    output wire rvalid,
    input wire rready
);
    reg [31:0] mem[0:1023]; // Assuming 1024 locations for 8-bit pixels (32x32)

    reg [31:0] axi_rdata;
    reg rvalid_reg;

    // AXI write logic
    always @(posedge aclk) begin
        if (!aresetn)
            rvalid_reg <= 0;
        else if (awvalid && awready && wvalid && wready) begin
            mem[awaddr[9:0]] <= wdata[31:0]; // Store wdata lsb[7:0] for 8b
        end
    end

    // AXI read logic
    always @(posedge aclk) begin
        if (!aresetn)
            axi_rdata <= 0;
        else if (arvalid && arready) begin
            axi_rdata <= mem[araddr[9:0]];
        end
    end

    // AXI response valid signal
    always @(posedge aclk) begin
        if (!aresetn)
            rvalid_reg <= 0;
        else if (rready) begin
            rvalid_reg <= 0;
        end else if (arvalid && arready) begin
            rvalid_reg <= 1;
        end
    end
    assign rdata = {mem[araddr[9:0]]}; 
    //assign rdata = {24'h0, mem[araddr[9:0]]}; // Pad 24 zeros to the MSBs
    assign rvalid = rvalid_reg;

endmodule
