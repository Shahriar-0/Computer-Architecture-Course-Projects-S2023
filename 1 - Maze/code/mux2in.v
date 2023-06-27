module Mux2in(a, b, slc, w);
    parameter N = 4;
    input [N - 1:0] a, b;
    input slc;
    output [N - 1:0] w;

    assign w = ~slc ? a : b;
endmodule