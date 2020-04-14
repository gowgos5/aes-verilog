module AEScntx #(N=4)(
    // from testbench
    input   clk,
    input   start,
    input   rstn,

    // to AEScore
    output  accept,
    output  [3:0] rndNo,
    output  enbSB,
    output  enbSR,
    output  enbMC,
    output  enbAR,
    output  enbKS,

    // to testbench
    output  done,
    output  [9:0] completed_round
);

reg [3:0] reg_rndNo [N-1:0];
reg reg_done [N-1:0];

integer i;
always @ (posedge clk or negedge rstn)
begin
    if (~rstn)
    begin
        for (i=0; i<N; i=i+1)
        begin
            reg_rndNo[i] <= 4'b0;
            reg_done[i] <= 1'b0;
        end
    end
    else if (start)
    begin
        reg_rndNo[0] <= (rndNo < 10) ? (rndNo + 1) : 4'b0;
        reg_done[0] <= (rndNo == 10);
        
        for (i=1; i<N; i=i+1)
        begin
            reg_rndNo[i] <= reg_rndNo[i-1];
            reg_done[i] <= reg_done[i-1];
        end
    end
end

assign enbSB = (rndNo >= 1) && (rndNo <= 10);
assign enbSR = (rndNo >= 1) && (rndNo <= 10);
assign enbMC = (rndNo >= 1) && (rndNo <= 9);
assign enbAR = (rndNo >= 0) && (rndNo <= 10);
assign enbKS = (rndNo >= 1) && (rndNo <= 10);

assign accept = (rndNo == 0);
assign completed_round = (rndNo == 0) ? 10'b0 : (10'b1 << (rndNo-1));
assign rndNo = reg_rndNo[N-1];
assign done = reg_done[N-1];

endmodule
