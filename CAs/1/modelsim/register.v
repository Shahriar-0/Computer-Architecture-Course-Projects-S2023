`timescale 1ns/1ns

module register(prl, CLK, RST, ld, init, W);
    parameter N = 4;
    input [N - 1:0] prl;
    input CLK;
    input RST;
    input ld;
    input init; 
    output [N - 1:0] W;
    reg W;
    always @(posedge CLK or posedge RST) begin 
        if (RST) W <= N'b0;
        else if(init) W <= N'b0;
        else if(ld) W <= prl;
    end
endmodule
    