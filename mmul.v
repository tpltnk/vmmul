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
    output reg [M*L*WIDTH-1:0] mat_axb,
    output reg done,
    output reg invalid
);

reg signed [WIDTH-1:0] mat_a_tmp [doneM-1:0][N-1:0];
reg signed [WIDTH-1:0] mat_b_tmp [K-1:0][L-1:0];
reg signed [WIDTH-1:0] mat_axb_tmp [M-1:0][L-1:0];
reg signed [WIDTH*2-1:0] prod_tmp;

integer i = 0;
integer j = 0;
integer k = 0;

// initializer integers
integer l = 0;
integer m = 0;

initial begin
    $dumpfile("mmul.vcd");
    $dumpvars(0, mmul);

    if (N != K) begin
        $display("Dimension mismatch: N=%d, K=%d", N, K);
        invalid = 1;
        $stop;
    end
    if (!M || !N || !K || !L) begin
        $display("Dimension cannot be zero: [M=%d, N=%d], [K=%d, L=%d]", M, N, K, L);
        invalid = 1;
        $stop;
    end
    // initialize temporary matrices to mat_a and mat_b inputs

    for (l = 0; l < M; l++) begin
        for (m = 0; m < N; m++) begin
            mat_a_tmp[l][m] = mat_a[(l*M+m)*WIDTH+:WIDTH];
        end
    end

    l = 0;
    m = 0;

    for (l = 0; l < K; l++) begin
        for (m = 0; m < L; m++) begin
            mat_b_tmp[l][m] = mat_b[(l*K+m)*WIDTH+:WIDTH];
        end
    end

    l = 0;
    m = 0;
    
    for (l = 0; l < M; l++) begin
        for (m = 0; m < L; m++) begin
            mat_axb_tmp[l][m] = 0;
        end
    end

    l = 0;
    m = 0;

    $display("mat_a_tmp=%b\nmat_b_tmp=%b", mat_a_tmp, mat_b_tmp);
end

always @(posedge clk or posedge reset)
begin
    if (reset) begin
        i = 0;
        j = 0;
        k = 0;
        done = 0;

        for (l = 0; l < M; l++) begin
            for (m = 0; m < N; m++) begin
                mat_a_tmp[l][m] = 0;
            end
        end

        l = 0;
        m = 0;

        for (l = 0; l < K; l++) begin
            for (m = 0; m < L; m++) begin
                mat_b_tmp[l][m] = 0;
            end
        end

        l = 0;
        m = 0;

        for (l = 0; l < M; l++) begin
            for (m = 0; m < L; m++) begin
                mat_axb_tmp[l][m] = 0;
            end
        end

        l = 0;
        m = 0;
        $display("RESET: %d", reset);
    end
    else if (enable && !done) begin
        $display("mat_a_tmp[%d][%d]=%d, mat_b_tmp[%d][%d]=%d", i, k, mat_a_tmp[i][k], k, j, mat_b_tmp[k][j]);
        prod_tmp = mat_a_tmp[i][k] * mat_b_tmp[k][j];
        mat_axb_tmp[i][j] = mat_axb_tmp[i][j] + prod_tmp[WIDTH-1:0];
        if (k == K-1) begin
            k = 0;
            if (j == L-1) begin 
                j = 0;
                if (i == M-1) begin
                    i = 0;
                    done = 1;
                end else i++;
            end else j++;
        end else k++;
        $display("mat_a=%b\nmat_b=%b", mat_a, mat_b);
        $display("i=%d, j=%d, k=%d, prod_tmp=%d, mat_axb_tmp=%d", i, j, k, prod_tmp, mat_axb_tmp[i][j]);
    end
    else if (done == 1) begin
        for (i = 0; i < M; i++) begin
            for (j = 0; j < L; j++) begin
                mat_axb[(i*M+j)*WIDTH+:WIDTH] = mat_axb_tmp[i][j];
            end
        end
    end
end
endmodule
