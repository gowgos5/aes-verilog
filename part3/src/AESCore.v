// Performs AES operations
module AESCore #(N=4)(
    // from testbench
    input   clk,
    input   rstn,
    input   [127:0] plain_text,
    input   [127:0] cipher_key,

    // from controller
    input   accept,
    input   [3:0] rndNo,
    input   enbSB,
    input   enbSR,
    input   enbMC,
    input   enbAR,
    input   enbKS,

    // to testbench
    output  [127:0] cipher_text
);

wire [127:0] inKS;
wire [127:0] inSB;
wire [127:0] outKS;
wire [127:0] outSB;
wire [127:0] outSR;
wire [127:0] outMC;
wire [127:0] outAR;

reg [127:0] reg_round_key [N-1:0];
reg [127:0] reg_cipher_text [N-1:0];

integer i;
// Asynchronous reset
always @ (posedge clk or negedge rstn)
begin
    if (~rstn)
    begin
        for (i=0; i<N; i=i+1)
        begin
            // Clear all registers
            reg_round_key[i] <= 128'h0;
            reg_cipher_text[i] <= 128'h0;
        end
    end
    else
    begin
        reg_round_key[0] <= outKS;      // Save output of KeySchedule to generate round keys
        reg_cipher_text[0] <= outAR;    // Save output of AddRoundKey for updating cipher text

        for (i=1; i<N; i=i+1)
        begin
            reg_round_key[i] <= reg_round_key[i-1];
            reg_cipher_text[i] <= reg_cipher_text[i-1];
        end
    end
end

// Round 0: plain text / cipher key
// Round 1 onwards: intermediate cipher text / round key
assign inSB = accept ? plain_text : reg_cipher_text[N-1];
assign inKS = accept ? cipher_key : reg_round_key[N-1];
assign cipher_text = reg_cipher_text[N-1];

KeySchedule_top key_schedule(
    .ip_key(inKS),
    .enable(enbKS),
    .rndNo(rndNo),
    .op_key(outKS)
);

subBytes_top sub_bytes(
    .ip(inSB),
    .enable(enbSB),
    .op(outSB)
);

shiftRows_top shift_rows(
    .ip(outSB),
    .enable(enbSR),
    .op(outSR)
);

MixCol_top mix_col(
    .ip(outSR),
    .enable(enbMC),
    .op(outMC)
);

AddRndKey_top add_rndkey(
    .ip(outMC),
    .ip_key(outKS),
    .enable(enbAR),
    .op(outAR)
);

endmodule
