`timescale 1ns/1ns

module mux2in(a ,b, slc, w);
    parameter N = 4;
    input [N - 1:0] a;
    input [N - 1:0] b;
    input slc;
    output [N - 1:0] w;

    assign w = ~slc ? a : b;
endmodule