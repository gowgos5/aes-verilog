// In the MixColumns step, the four bytes of each column of the state are combined using an 
// invertible linear transformation.
module MixCol_top(
    input   [127:0] ip,
    input   enable,
    output  [127:0] op
);

wire [127:0] out;

assign op = enable ? out : ip;

/* Instantiate 4 matrix_mult units */
genvar i;
generate
    for (i=0; i<4; i=i+1)
    begin: GEN_MULT
        matrix_mult mult(
            .ip(ip[32*i +: 32]),
            .op(out[32*i +: 32])
        );
    end
endgenerate

endmodule
