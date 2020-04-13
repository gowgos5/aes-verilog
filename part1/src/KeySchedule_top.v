module KeySchedule_top(
    input   [127:0] ip_key,
    input   enable,
    input   [3:0] rndNo,
    output  [127:0] op_key
);

wire [31:0] rcon;
wire [31:0] rot_word;
wire [31:0] sub_word;
wire [31:0] xor_word[3:0];

/* 1. RotWord */
assign rot_word = { ip_key[23:0], ip_key[31:24] };

/* 3. XOR */
assign xor_word[3] = ip_key[127:96] ^ sub_word ^ rcon;
assign xor_word[2] = ip_key[95:64] ^ xor_word[3];
assign xor_word[1] = ip_key[63:32] ^ xor_word[2];
assign xor_word[0] = ip_key[31:0] ^ xor_word[1];

assign op_key = enable ? { xor_word[3], xor_word[2], xor_word[1], xor_word[0] } : ip_key;

/* RCON */
aes_rcon rcon(.rndNo(rndNo), .rcon(rcon));

/* 2. SubBytes */
genvar i;
generate
    for (i=0; i<4; i=i+1)
    begin: GEN_SBOX
        aes_sbox sbox(
            .ip(ip[(rot_word*8)+:8]),
            .op(out[(sub_word*8)+:8])
        );
    end
endgenerate

endmodule
