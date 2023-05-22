module mux2to1(slc, a, b, w);
    parameter N = 32;
    
    input slc;
    input [N-1:0] a, b;

    output [N-1:0] w;
    
    w = slc ? a : b;

endmodule