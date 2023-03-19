`include "mmul.v"

module mmul_tb;

parameter integer RA = 3;
parameter integer CA = 2;
parameter integer RB = 2;
parameter integer CB = 4;

reg [RA*CA*8-1:0] mat_a;
reg [RB*CB*8-1:0] mat_b;
wire [RA*CB*8-1:0] mat_axb;
reg clk;
reg enable;
wire completed;

initial begin
    clk = 1;
    enable = 1;
    #100;
    mat_a = { 8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6 };
    mat_b = { 8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7, 8'd8 };

    wait (completed);

    $display("AxB=C");
    $display("A = %B", mat_a);
    $display("B = %B", mat_b);
    $display("C = %B", mat_axb);

    $stop;
end

// period = 5ns
// freq = 200MHz
always #5 clk <= ~clk;

mmul #(
    .RA(RA),
    .CA(CA),
    .RB(RB),
    .CB(CB),
    .W(8)
) mmul_inst (
    .clk(clk),
    .enable(enable),
    .A(mat_a),
    .B(mat_b),
    .C(mat_axb),
    .completed(completed)
);

endmodule