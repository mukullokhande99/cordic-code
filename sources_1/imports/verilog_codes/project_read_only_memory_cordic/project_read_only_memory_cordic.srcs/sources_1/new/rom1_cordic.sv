`timescale 1ns / 1ps
module rom1_cordic(clk_port1, en_port1, addr_in_port1,data_out_port1);

parameter a_length = 3;
parameter d_length = 8;
parameter depth=8;

input clk_port1, en_port1;
input [a_length-1:0] addr_in_port1;

output reg [d_length-1:0] data_out_port1;

reg [d_length-1:0] mem [depth-1:0];

initial
begin
$readmemb("bin_memory_file.mem", mem, 0, 7);
end

always@(posedge clk_port1)
begin 
	if(en_port1)
		begin
		     data_out_port1 <= mem[addr_in_port1];
		end
end

endmodule