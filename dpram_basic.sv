module dpram_basic(clk_port1, clk_port2, en_port1, en_port2, ctrl_port1, ctrl_port2, addr_in_port1, addr_in_port2, data_in_port1, data_out_port1, data_in_port2, data_out_port2);

parameter a_length = 10;
parameter d_length = 32;
parameter depth=1024;

input clk_port1, clk_port2, en_port1, en_port2, ctrl_port1, ctrl_port2;
input [a_length-1:0] addr_in_port1, addr_in_port2;
input [d_length-1:0] data_in_port1, data_in_port2;

output reg [d_length-1:0] data_out_port1,data_out_port2;

reg [d_length-1:0] mem [depth-1:0];
reg ctrl_port1_reg, ctrl_port2_reg;

always@(posedge clk_port1)
begin 
	if(en_port1)
		begin
			if(ctrl_port1)
				mem[addr_in_port1] <= data_in_port1;
			else
				data_out_port1 <= mem[addr_in_port1];
		end
end

always@(posedge clk_port2)
begin 
	if(en_port2)
		begin
			if(ctrl_port2)
				mem[addr_in_port2] <= data_in_port2;
			else
				data_out_port2 <= mem[addr_in_port2];
		end
end

always@(*)
begin
	if(addr_in_port1 == addr_in_port2)
	begin
		ctrl_port1_reg <= 1'b0;
		ctrl_port2_reg <= 1'b0;
	end
	else
	begin
		ctrl_port1_reg <= ctrl_port1;
		ctrl_port2_reg <= ctrl_port2;
	end
end

endmodule