`timescale 1ns / 1ns

module counter2bit(init, ld, en, RST, CLK, prl, out, co);
    input init;
    input ld;
    input en;
    input RST;
    input CLK;
    input [1:0] prl;
    output [1:0] out;
    output co;
    reg out;

    always @(posedge CLK or posedge RST) begin
        if (RST) out <= 2'b0;
        else if (init) out <= 2'b0;
        else if (ld) out <= prl;
        else if (en) out <= out + 1;
    end

    assign co = &out;

endmodule