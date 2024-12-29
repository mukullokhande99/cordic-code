`timescale 1ns / 1ps

module shift_4b(
    input [3:0]data_input,
    input shift_carry,
    input sel,
    output reg op_drop,
    output reg [3:0] data_output
);
reg p;

always@(*)
begin
p <= sel ? shift_carry:(data_input[3]?1'b1:1'b0);
data_output <= {p, data_input[3:1]};
op_drop <= data_input[0];
end        
 endmodule