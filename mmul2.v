`include "mmul2_validator.v"
`include "mmul2_arbiter.v"

module mmul2 #(
    // Rows of Matrix A
    parameter unsigned RA = 0,
    // Columns of Matrix A
    parameter unsigned CA = 0,
    // Rows of Matrix B
    parameter unsigned RB = 0,
    // Columns of Matrix B
    parameter unsigned CB = 0,
    // Bitwidth of each element
    parameter unsigned W = 32
) (
    input clk,
    input enable,
    input [RA*CA*W-1:0] A,
    input [RB*CB*W-1:0] B,
    output reg [RA*CB*W-1:0] C,
    output wire completed
);

integer unsigned i;
integer unsigned j;
integer unsigned k;
integer unsigned l;
integer unsigned m;

integer unsigned n = RB; // or CA

wire valid;

mmul2_validator #(
    .RA(RA),
    .CA(CA),
    .RB(RB),
    .CB(CB)
) validator (
    .valid(valid)
);

mmul2_arbiter #(
    .RA(RA),
    .CA(CA),
    .RB(RB),
    .CB(CB)
) arbiter (
    .clk(clk),
    .i(i),
    .j(j),
    .k(k),
    .done(completed)
);


initial begin
    $dumpfile("mmul2.vcd");
    $dumpvars(0, mmul2);
    i = 0;
    j = 0;
    k = 0;
    $display("Initializing i, j, k to 0");

    for (l = 0; l < RA; l++) begin
        for (m = 0; m < CB; m++) begin
            C[l*CB*W + m*W +: W] = 0;
        end
    end
    l = 0;
    m = 0;
    $display("Initialized C matrix to %B", C);

    wait (valid);
    $display("Matrix dimensions are valid");
end

always @(posedge clk or posedge enable) begin
    if (enable && valid && !completed) begin
        if (k == n-1) begin
            k = 0;
            if (j == CB-1) begin
                j = 0;
                if (i == RA-1) begin
                    i = 0;
                end else i++;
            end else j++;
        end else k++;
        C[i*CB*W + j*W +: W] = C[i*CB*W+j*W+:W] + A[i*CA*W+k*W+:W] * B[k*CB*W+j*W+:W];
        $monitor("i=%d, j=%d, k=%d", i, j, k);
    end
end



endmodule