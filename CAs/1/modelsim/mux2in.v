`timescale 1ns/1ns

module mux2in(input [N-1:0] a,b,input slc,output [N-1:0] w);
    parameter N = 4;
    assign w = a ? ~slc : b;
endmodule