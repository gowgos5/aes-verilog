// In the SubBytes step, each byte in the state array is replaced with a SubByte element using
// an 8-bit substitution box. This operation provides non-linearity in the cipher.
module subBytes_top(
    input   [127:0] ip,
    input   enable,
    output  [127:0] op
);

wire [127:0] out;

assign op = enable ? out : ip;

/* Instantiate 16 aes_sbox units */
genvar i;
generate
    for (i=0; i<16; i=i+1)
    begin: GEN_SBOX
        aes_sbox sbox(
            .ip(ip[8*i +: 8]),
            .op(out[8*i +: 8])
        );
    end
endgenerate

endmodule
