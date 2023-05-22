module register(clk, a, w);
    parameter N = 32;

    input clk;
    input [N-1:0] a;

    output reg [N-1:] w;

    always @(posedge clk) 
        w <= a;
    
endmodule
