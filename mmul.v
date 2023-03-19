// 3x3 matmul
// each element is 8-bit signed integer

module mmul(
    input clk,
    input reset,
    input enable,
    input [71:0] mat_a, // 9*8=72
    input [71:0] mat_b, // 9*8=72
    output reg [71:0] mat_a_plus_b, // 9*8=72
    output reg done
);

reg signed [7:0] mat_a_tmp [2:0][2:0];
reg signed [7:0] mat_b_tmp [2:0][2:0];
reg signed [7:0] mat_a_plus_b_tmp [2:0][2:0];
reg signed [15:0] temp_prod;

integer i = 0;
integer j = 0;
integer k = 0;

// initializer integers
integer l = 0;
integer m = 0;

initial begin
    for (l = 0; l <= 2; l++) begin
        for (m = 0; m <= 2; m++) begin
            mat_a_tmp[l][m] = mat_a[(l*3+m)*8+:8];
            mat_b_tmp[l][m] = mat_b[(l*3+m)*8+:8];
            mat_a_plus_b_tmp[l][m] = 8'd0;
        end
    end
    // $display("mat_a_tmp=%b, \nmat_b_tmp=%b", mat_a_tmp[0][0], mat_b_tmp[0][0]);
    l = 0;
    m = 0;
end

always @(posedge clk or posedge reset)
begin
    if (reset) begin
        i = 0;
        j = 0;
        k = 0;
        done = 0;
        temp_prod = 0;
        for (l = 0; l <= 2; l++) begin
            for (m = 0; m <= 2; m++) begin
                mat_a_tmp[l][m] = mat_a[(l*3+m)*8+:8];
                mat_b_tmp[l][m] = mat_b[(l*3+m)*8+:8];
                mat_a_plus_b_tmp[l][m] = 8'd0;
            end
        end
        l = 0;
        m = 0;
        $display("RESET: %d", reset);
    end
    else if (enable && !done) begin
        $display("mat_a_tmp=%b, \nmat_b_tmp=%b", mat_a_tmp[i][k], mat_b_tmp[k][j]);
        temp_prod = mat_a_tmp[i][k] * mat_b_tmp[k][j];
        mat_a_plus_b_tmp[i][j] = mat_a_plus_b_tmp[i][j] + temp_prod[7:0];
        if (k == 2) begin
            k = 0;
            if (j == 2) begin 
                j = 0;
                if (i == 2) begin
                    i = 0;
                    done = 1;
                end else i++;
            end else j++;
        end else k++;
        $display("mat_a=%b\nmat_b=%b", mat_a, mat_b);
        $display("i=%d, j=%d, k=%d, temp_prod=%d, mat_a_plus_b_tmp=%d", i, j, k, temp_prod, mat_a_plus_b_tmp[i][j]);
    end
    else if (done) begin
        for (l = 0; l <= 2; l++) begin
            for (m = 0; m <= 2; m++) begin
                mat_a_plus_b[(l*3+m)*8+:8] = mat_a_plus_b_tmp[l][m];
            end
        end
    end
end
endmodule
