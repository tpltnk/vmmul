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

integer i;
integer j;
integer k;

initial begin
    for (i = 0; i <= 2; i++) begin
        for (j = 0; j <= 2; j++) begin
            mat_a_tmp[i][j] = mat_a[(i*3+j)*8+:8];
            mat_b_tmp[i][j] = mat_b[(i*3+j)*8+:8];
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
        for (i = 0; i <= 2; i++) begin
            for (j = 0; j <= 2; j++) begin
                mat_a_tmp[i][j] = 0;
                mat_b_tmp[i][j] = 0;
                mat_a_plus_b_tmp[i][j] = 0;
            end
        end
    end
    else if (enable && !done) begin
        mat_a_plus_b_tmp[i][j] = mat_a_plus_b_tmp[i][j] + mat_a_tmp[i][k] * mat_b_tmp[k][j];
        if (k == 2) begin
            k = 0;
            if (j == 2) begin 
                j = 0;
                if (i == 2) begin
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
        for (i = 0; i <= 2; i++) begin
            for (j = 0; j <= 2; j++) begin
                mat_a_plus_b[(i*3+j)*8+:8] = mat_a_plus_b_tmp[i][j];
            end
        end
    end
end
endmodule
