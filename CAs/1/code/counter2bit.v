module counter2bit(RST, CLK,init, ld, en, prl, out, co);
   
    input init, ld, en, RST, CLK;
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