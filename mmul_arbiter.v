module mmul_arbiter #(
    // Rows of Matrix A
    parameter unsigned RA = 0,
    // Columns of Matrix A
    parameter unsigned CA = 0,
    // Rows of Matrix B
    parameter unsigned RB = 0,
    // Columns of Matrix B
    parameter unsigned CB = 0
) (
    input clk,
    input [31:0] i,
    input [31:0] j,
    input [31:0] k,
    output reg completed
);

always @(posedge clk) begin
    completed = k == RB-1 && j == CB-1 && i == RA-1;
end

endmodule