module Register(in, en, clk, out);
    parameter N = 32;

    input [N-1:0] in;
    input en, clk;

    output reg [N-1:0] out;

    always @(posedge clk) begin
        else if (en)
            out <= in;
    end

endmodule
