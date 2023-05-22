module Adder(a, b, w);
    parameter N = 32;

    input [N-1:0] a;
    input [N-1:0] b;
    
    output [N-1:0] w;
    
    assign w = a + b;
    
endmodule