// The ShiftRows step operates on the rows of the state; it cyclically shifts the bytes in each
// row by a certain offset.
// 1st row: Unchanged
// 2nd row: Shifted one to the left
// 3rd row: Shifted two to the left
// 4th row: Shifted three to the left
module shiftRows_top(
    input   [127:0] ip,
    input   enable,
    output  [127:0] op
);

wire [127:0] out;

assign out[127:120] = ip[127:120];  // 1st row (unchanged)
assign out[119:112] = ip[87:80];    // 2nd row (offset of 1 byte)
assign out[111:104] = ip[47:40];    // 3rd row (offset of 2 bytes)
assign out[103:96] = ip[7:0];       // 4th row (offset of 3 bytes)

assign out[95:88] = ip[95:88];      // 1st row
assign out[87:80] = ip[55:48];      // 2nd row
assign out[79:72] = ip[15:8];       // 3rd row
assign out[71:64] = ip[103:96];     // 4th row

assign out[63:56] = ip[63:56];      // 1st row
assign out[55:48] = ip[23:16];      // 2nd row
assign out[47:40] = ip[111:104];    // 3rd row
assign out[39:32] = ip[71:64];      // 4th row

assign out[31:24] = ip[31:24];      // 1st row
assign out[23:16] = ip[119:112];    // 2nd row
assign out[15:8] = ip[79:72];       // 3rd row
assign out[7:0] = ip[39:32];        // 4th row

assign op = enable ? out : ip;

endmodule
