module MixCol_top(
    input   [127:0] ip,
    input   enable,
    output  [127:0] op
);

wire [127:0] out;

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

assign op = enable ? out : ip;

endmodule
