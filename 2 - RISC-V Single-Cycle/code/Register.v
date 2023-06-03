module Register(in, clk, rst, out);
    parameter N = 32;

    input [N-1:0] in;
    input clk, rst;

    output reg [N-1:0] out;
    
    always @(posedge clk,posedge rst) begin
        if(rst)
            out <= {N{1'b0}};
        else
            out <= in;
    end

endmodule