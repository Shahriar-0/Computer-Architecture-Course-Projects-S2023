module Register(prl, clk, rst, ld, init, W);
    parameter N = 4;

    input [N - 1:0] prl;
    input clk, rst, ld, init; 
    output reg [N - 1:0] W;

    always @(posedge clk or posedge rst) begin 
        if (rst || init) 
            W <= {N{1'b0}};

        else if (ld) 
            W <= prl;
    end
endmodule
    