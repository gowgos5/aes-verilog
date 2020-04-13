module AEScntx(
    // from testbench
    input   clk,
    input   start,
    input   rstn,

    // to AEScore
    output  accept,
    output reg [3:0] rndNo = 0,
    output  enbSB,
    output  enbSR,
    output  enbMC,
    output  enbAR,
    output  enbKS,

    // to testbench
    output reg done = 0,
    output  [9:0] completed_round
);

always @ (posedge clk)
begin
    if (~rstn)
    begin
        rndNo <= 0;
        done <= 0;
    end
    else if (start)
    begin
        rndNo <= (rndNo < 10) ? (rndNo + 1) : 0;
        done <= (rndNo == 10);
    end
end

assign enbSB = (rndNo >= 1) && (rndNo <= 10);
assign enbSR = (rndNo >= 1) && (rndNo <= 10);
assign enbMC = (rndNo >= 1) && (rndNo <= 9);
assign enbAR = (rndNo >= 0) && (rndNo <= 10);
assign enbKS = (rndNo >= 1) && (rndNo <= 10);
assign accept = (rndNo == 0);
assign completed_round = (rndNo == 0) ? 0 : (1 << rndNo);

endmodule
