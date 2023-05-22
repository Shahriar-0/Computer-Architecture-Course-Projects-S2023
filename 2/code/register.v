module register(clk, a, w);
    input clk;
    input [N-1:0] a;

    output reg [N-1:] w;
    
    parameter N = 32;

    always @(posedge clk) begin
        w <= a;
    end
endmodule
