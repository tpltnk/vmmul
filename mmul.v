//! MxN and KxL matmul
//! Quits if N != K (flag invalid)
//! Quits if any of M, N, K, L is zero (flag invalid)

module mmul
#(
    parameter unsigned M = 0,    // rows of mat_a
    parameter unsigned N = 0,    // cols of mat_a
    parameter unsigned K = 0,    // rows of mat_b
    parameter unsigned L = 0,    // cols of mat_b
    parameter unsigned WIDTH = 8 // single element width (in bits)
)
(
    input clk,
    input reset,
    input enable,
    input [M*N*WIDTH-1:0] mat_a,
    input [K*L*WIDTH-1:0] mat_b,
    output reg [M*L*WIDTH-1:0] mat_a_plus_b,
    output reg done,
    output reg invalid
);

reg signed [WIDTH-1:0] mat_a_tmp [M-1:0][L-1:0];
reg signed [WIDTH-1:0] mat_b_tmp [M-1:0][L-1:0];
reg signed [WIDTH-1:0] mat_a_plus_b_tmp [M-1:0][L-1:0];

integer i;
integer j;
integer k;

initial begin
    if (N != K) begin
        $display("Dimension mismatch: N=%d, K=%d", N, K);
        invalid = 1;
        $stop;
    end
    if (!M || !N || !K || !L) begin
        $display("Dimension cannot be zero: M=%d, N=%d, K=%d, L=%d", M, N, K, L);
        invalid = 1;
        $stop;
    end
    // initialize temporary matrices to mat_a and mat_b inputs
    for (i = 0; i < M; i++) begin
        for (j = 0; j < L; j++) begin
            mat_a_tmp[i][j] = mat_a[(i*M+j)*WIDTH+:WIDTH];
            mat_b_tmp[i][j] = mat_b[(i*M+j)*WIDTH+:WIDTH];
            mat_a_plus_b_tmp[i][j] = 0;
        end
    end
end

always @(posedge clk or posedge reset)
begin
    if (reset) begin
        i = 0;
        j = 0;
        k = 0;
        done = 0;
        for (i = 0; i < M; i++) begin
            for (j = 0; j < L; j++) begin
                mat_a_tmp[i][j] = 0;
                mat_b_tmp[i][j] = 0;
                mat_a_plus_b_tmp[i][j] = 0;
            end
        end
    end
    else if (enable && !done) begin
        mat_a_plus_b_tmp[i][j] = mat_a_plus_b_tmp[i][j] + mat_a_tmp[i][k] * mat_b_tmp[k][j];
        if (k == L-1) begin
            k = 0;
            if (j == M-1) begin 
                j = 0;
                if (i == M-1) begin
                    i = 0;
                    done = 1;
                end else begin
                    i++;
                end
            end
            else begin
                j++;
            end
        end else begin
            k++;
        end
    end
    else if (done == 1) begin
        for (i = 0; i < M; i++) begin
            for (j = 0; j < L; j++) begin
                mat_a_plus_b[(i*M+j)*WIDTH+:WIDTH] = mat_a_plus_b_tmp[i][j];
            end
        end
    end
end
endmodule
