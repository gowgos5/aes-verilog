module AES_top(
//from testbench
input  clk,
input  start,
input  rstn,
input  [127:0] plain_text,
input  [127:0] cipher_key,
//to testbench
output  done,
output  [9:0] completed_round,
output  [127:0] cipher_text
);
////enter your code here
endmodule
