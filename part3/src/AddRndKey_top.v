module AddRndKey_top(
    input   [127:0] ip,
    input   [127:0] ip_key,
    input   enable,
    output  [127:0] op
);

/* Bitwise XOR-ing of state and round key */
assign op = enable ? (ip ^ ip_key) : ip;

endmodule
