module subBytes_top(
    input   [127:0] ip,
    input   enable,
    output  [127:0] op
);

wire [127:0] out;

/* Instantiate 16 aes_sbox units */
genvar i;
generate
    for (i=0; i<16; i=i+1)
    begin: GEN_SBOX
        aes_sbox sbox(
            .ip(ip[i*8+:8]),
            .op(out[i*8+:8])
        );
    end
endgenerate

assign op = enable ? out : ip;

endmodule
