module AESCore(
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
    output reg [127:0] cipher_text
);

wire [127:0] inKS;
wire [127:0] inSB;
wire [127:0] outKS;
wire [127:0] outSB;
wire [127:0] outSR;
wire [127:0] outMC;
wire [127:0] outAR;
reg [127:0] round_key;

always @ (posedge clk)
begin
    if (~rstn)
    begin
        round_key <= 128'b0;
        cipher_text <= 128'b0;
    end
    else
    begin
        round_key <= outKS;
        cipher_text <= outAR;
    end
end

assign inSB = accept ? plain_text : cipher_text;
assign inKS = accept ? cipher_key : round_key;

KeySchedule_top key_schedule (
    .ip_key(inKS),
    .enable(enbKS),
    .rndNo(rndNo),
    .op_key(outKS)
);

subBytes_top sub_bytes (
    .ip(inSB),
    .enable(enbSB),
    .op(outSB)
);

shiftRows_top shift_rows (
    .ip(outSB),
    .enable(enbSR),
    .op(outSR)
);

MixCol_top mix_col (
    .ip(outSR),
    .enable(enbMC),
    .op(outMC)
);

AddRndKey_top add_rndkey (
    .ip(outMC),
    .ip_key(outKS),
    .enable(enbAR),
    .op(outAR)
);

endmodule
