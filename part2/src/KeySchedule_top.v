// Produces the required round keys from the initial cipher key
module KeySchedule_top(
    input   [127:0] ip_key,
    input   enable,
    input   [3:0] rndNo,
    output  [127:0] op_key
);

reg [31:0] rcon;
wire [31:0] rot_word;
wire [31:0] sub_word;
wire [31:0] xor_word [3:0];

/* Step 1: Apply RotWord transformation */
assign rot_word = { ip_key[23:0], ip_key[31:24] };

/* Step 3: XOR */
assign xor_word[3] = ip_key[127:96] ^ sub_word ^ rcon;
assign xor_word[2] = ip_key[95:64] ^ xor_word[3];
assign xor_word[1] = ip_key[63:32] ^ xor_word[2];
assign xor_word[0] = ip_key[31:0] ^ xor_word[1];

assign op_key = enable ? { xor_word[3], xor_word[2], xor_word[1], xor_word[0] } : ip_key;

/* Lookup table for round constant (RCON) */
always @ (rndNo)
begin
    case (rndNo)
        4'h1: rcon=32'h01000000;
        4'h2: rcon=32'h02000000;
        4'h3: rcon=32'h04000000;
        4'h4: rcon=32'h08000000;
        4'h5: rcon=32'h10000000;
        4'h6: rcon=32'h20000000;
        4'h7: rcon=32'h40000000;
        4'h8: rcon=32'h80000000;
        4'h9: rcon=32'h1b000000;
        4'ha: rcon=32'h36000000;
        default: rcon=32'h00000000;
    endcase
end

/* Step 2. Apply SubBytes transformation */
/* Instantiate 4 aes_sbox units */
genvar i;
generate
    for (i=0; i<4; i=i+1)
    begin: GEN_SBOX
        aes_sbox sbox(
            .ip(rot_word[8*i +: 8]),
            .op(sub_word[8*i +: 8])
        );
    end
endgenerate

endmodule
