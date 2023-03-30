module register(prl, CLK, RST, ld, init, W);
    parameter N = 4;

    input [N - 1:0] prl;
    input CLK, RST, ld, init; 
    output [N - 1:0] W;
    reg W;

    always @(posedge CLK or posedge RST) begin 
        if (RST || init) 
            W <= {N{1'b0}};

        else if (ld) 
            W <= prl;
    end
endmodule
    