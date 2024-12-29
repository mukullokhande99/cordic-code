`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2023 09:22:26 AM
// Design Name: 
// Module Name: axi_memory_interface_tb
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


module axi_memory_interface_tb();

    reg aclk, aresetn;
    wire [31:0] axi_awaddr;
    wire axi_awvalid, axi_awready;
    wire [31:0] axi_wdata;
    wire axi_wvalid, axi_wready;
    wire [31:0] axi_araddr;
    wire axi_arvalid, axi_arready;
    wire [31:0] axi_rdata;
    wire axi_rvalid, axi_rready;
    integer in_file;

    axi_memory_interface_top dut (
        .aclk(aclk),
        .aresetn(aresetn),
        .axi_awaddr(axi_awaddr),
        .axi_awvalid(axi_awvalid),
        .axi_awready(axi_awready),
        .axi_wdata(axi_wdata),
        .axi_wvalid(axi_wvalid),
        .axi_wready(axi_wready),
        .axi_araddr(axi_araddr),
        .axi_arvalid(axi_arvalid),
        .axi_arready(axi_arready),
        .axi_rdata(axi_rdata),
        .axi_rvalid(axi_rvalid),
        .axi_rready(axi_rready)
    );



    initial begin

        aclk = 0;
        aresetn = 0;
        in_file = $fopen("S:/verilog_codes/project_work_SA_para16x16_32/input_image.bin", "rb");

 
$fclose(in_file);
    end



endmodule
