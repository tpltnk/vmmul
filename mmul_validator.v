module mmul_validator #(
    // Rows of Matrix A
    parameter unsigned RA = 0,
    // Columns of Matrix A
    parameter unsigned CA = 0,
    // Rows of Matrix B
    parameter unsigned RB = 0,
    // Columns of Matrix B
    parameter unsigned CB = 0
) 
(
    output reg valid
);

initial begin
    if (CA != RB) begin
        $display("Dimension mismatch: CA=%d, RB=%d", CA, RB);
        valid = 0;
    end
    else if (!RA || !CA || !RB || !CB) begin
        $display("Dimension cannot be zero: [RA=%d, CA=%d], [RB=%d, CB=%d]", RA, CA, RB, CB);
        valid = 0;
    end
    else begin
        valid = 1;
    end
end

endmodule