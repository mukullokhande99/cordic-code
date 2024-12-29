`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2023 08:42:31 AM
// Design Name: 
// Module Name: axi_memory_interface_top
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


module axi_memory_interface_top(
    input wire aclk,
    input wire aresetn
);
    parameter a_length = 10;
    parameter d_length = 32;
    // Instantiate the AXI Lite interface
    wire [31:0] axi_awaddr;
    wire axi_awvalid, axi_awready;
    wire [31:0] axi_wdata;
    wire axi_wvalid, axi_wready;
    wire [31:0] axi_araddr;
    wire axi_arvalid, axi_arready;
    wire [31:0] axi_rdata;
    wire axi_rvalid, axi_rready;

    axi_lite_interface axi_lite_inst (
        .aclk(aclk),
        .aresetn(aresetn),
        .awaddr(axi_awaddr),
        .awvalid(axi_awvalid),
        .awready(axi_awready),
        .wdata(axi_wdata),
        .wvalid(axi_wvalid),
        .wready(axi_wready),
        .araddr(axi_araddr),
        .arvalid(axi_arvalid),
        .arready(axi_arready),
        .rdata(axi_rdata),
        .rvalid(axi_rvalid),
        .rready(axi_rready)
    );

    // Instantiate the dual-port RAM module
    wire clk_port1, clk_port2, en_port1, en_port2, ctrl_port1, ctrl_port2;
    wire [a_length-1:0] addr_in_port1, addr_in_port2;
    wire [d_length-1:0] data_in_port1, data_in_port2;
    wire [d_length-1:0] data_out_port1, data_out_port2;

    dpram_basic ram_inst (
        .clk_port1(aclk),
        .clk_port2(aclk), // Assuming same clock for both modules
        .en_port1(axi_awvalid && axi_awready),
        .en_port2(axi_awvalid && axi_awready), // Assuming same enable condition
        .ctrl_port1(axi_awvalid), // Assuming write when valid
        .ctrl_port2(1'b0), // Assuming read is disabled for port2
        .addr_in_port1(axi_awaddr),
        .addr_in_port2(axi_awaddr), // Assuming same address for both modules
        .data_in_port1(axi_wdata),
        .data_in_port2(32'h0), // No data in port2
        .data_out_port1(data_out_port1),
        .data_out_port2(data_out_port2)
    );

endmodule
