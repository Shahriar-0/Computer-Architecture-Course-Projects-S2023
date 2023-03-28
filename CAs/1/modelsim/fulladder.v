`timescale 1ns/1ns

module fulladder(input [N-1:0] a,b,input cin,output [N-1:0] w,output cout);
    parameter N = 4;
    assign {cout,w} = a + b + cin;
endmodule