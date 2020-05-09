// In the AddRoundKey step, the subkey is combined with the state. For each round, a subkey is 
// derived from the main key using the Rijndael's key schedule; each subkey is the same size as the
// state. The subkey is added by combining each byte of the state with the corresponding byte of the
// subkey using bitwise XOR.
module AddRndKey_top(
    input   [127:0] ip,
    input   [127:0] ip_key,
    input   enable,
    output  [127:0] op
);

/* Bitwise XOR-ing of state and round key */
assign op = enable ? (ip ^ ip_key) : ip;

endmodule
