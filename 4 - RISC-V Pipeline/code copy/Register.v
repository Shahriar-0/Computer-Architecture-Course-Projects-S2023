module Register(in, clk, rst, out, ld);
    parameter N = 32;

    input [N-1:0] in;
    input clk, rst, ld;

    output reg [N-1:0] out;
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            out <= {N{1'b0}};
        else if (ld)
            out <= in;
    end

endmodule