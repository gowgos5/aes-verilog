module AEScntx(
    // from testbench
    input   clk,
    input   start,
    input   rstn,

    // to AEScore
    output  accept,
    output reg [3:0] rndNo,
    output  enbSB,
    output  enbSR,
    output  enbMC,
    output  enbAR,
    output  enbKS,

    // to testbench
    output reg done,
    output  [9:0] completed_round
);

always @ (posedge clk or negedge rstn)
begin
    if (~rstn)
    begin
        rndNo <= 4'b0;
        done <= 1'b0;
    end
    else if (start)
    begin
        rndNo <= (rndNo < 10) ? (rndNo + 1) : 4'b0;
        done <= (rndNo == 10);
    end
end

assign enbSB = (rndNo >= 1) && (rndNo <= 10);
assign enbSR = (rndNo >= 1) && (rndNo <= 10);
assign enbMC = (rndNo >= 1) && (rndNo <= 9);
assign enbAR = (rndNo >= 0) && (rndNo <= 10);
assign enbKS = (rndNo >= 1) && (rndNo <= 10);
assign accept = (rndNo == 0);
assign completed_round = (rndNo == 0) ? 10'b0 : (10'b1 << (rndNo-1));

endmodule
