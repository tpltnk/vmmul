`include "mmul.v"
module mmul_tb;

reg [71:0] mat_a;
reg [71:0] mat_b;
wire [71:0] mat_a_plus_b;
reg clk, reset, enable;
wire done;
integer i, j;
reg [7:0] mat_a_plus_b_tmp [2:0][2:0];

initial begin
    clk = 1;
    reset = 1;
    #100;
    reset = 0;
    #5;
    mat_a = { 8'd1, 8'd2, 8'd3, 8'd1, 8'd0, 8'd5, 8'd3, 8'd8, 8'd2 };
    mat_b = { 8'd0, 8'd0, 8'd3, 8'd5, 8'd6, 8'd1, 8'd2, 8'd0, 8'd8 };
    enable = 1;
    #100;
    wait (done);
    #5;
    for (i = 0; i <= 2; i++) begin
        for (j = 0; j <= 2; j++) begin
            mat_a_plus_b_tmp[i][j] = mat_a_plus_b[(i*3+j)*8+:8];
        end
    end
    #5;
    enable = 0;
    #5;
    $display("mat_a_plus_b = %b", mat_a_plus_b);
    $dumpfile("mmul_tb.vcd");
    $dumpvars(0, mmul_tb);
    $stop;
end

// period = 5ns
// freq = 200MHz
always #5 clk = ~clk;

mmul mmul_inst(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .mat_a(mat_a),
    .mat_b(mat_b),
    .mat_a_plus_b(mat_a_plus_b),
    .done(done)
);

endmodule