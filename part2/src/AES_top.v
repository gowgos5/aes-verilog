module AES_top #(N = 100)(
//from testbench
input clk,
input start,
input rstn,
input [128*N-1:0] plain_text,
input [128*N-1:0] cipher_key,
//to testbench
output done,
output [9:0] completed_round,
output [128*N-1:0] cipher_text
);
////enter your code here
endmodule
