// AES controller. Used for controlling the AES core.
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
// Asynchronous reset
always @ (posedge clk or negedge rstn)
begin
    if (~rstn)
    begin
        for (i=0; i<N; i=i+1)
        begin
            // Clear all registers
            reg_rndNo[i] <= 4'b0;
            reg_done[i] <= 1'b0;
        end
    end
    else if (start)
    begin
        // Update state of implicit FSM (11 states in total)
        reg_rndNo[0] <= (rndNo < 10) ? (rndNo + 1) : 4'b0;
        reg_done[0] <= (rndNo == 10);
        
        // Time interleaving
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
assign enbAR = 1'b1;   // (rndNo >= 0) && (rndNo <= 10)
assign enbKS = (rndNo >= 1) && (rndNo <= 10);

assign accept = (rndNo == 0);   // Notify core to accept new inputs at round 0
assign completed_round = 10'b1000000000 >> (10 - rndNo);
assign rndNo = reg_rndNo[N-1];
assign done = reg_done[N-1];

endmodule
