`timescale 1ns/1ns

module register(input [N-1:0] prl,input CLK,RST,ld,init,output [N-1:0] W);
    parameter N = 4;
    always @(posedge CLK)
        begin 
            if (RST) W <= N'b0;
            else if(init) W <= N'b0;
            else if(ld) W <= prl;
        end
endmodule
    