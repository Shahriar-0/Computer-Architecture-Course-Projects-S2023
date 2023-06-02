module Register(in, clk, out);
    parameter N = 32;

    input [N-1:0] in;
    input clk;

    output reg [N-1:0] out;
    
    always @(posedge clk) begin
        out <= in
    end

endmodule
