module RISC_V_Datapath(clk, rst, PCWrite, adrSrc, memWrite,
                    IRWrite, resultSrc, ALUControl,
                    ALUSrcA, ALUSrcB, immSrc, regWrite,
                    op, func3, func7, zero, neg);

    input clk, rst, PCWrite, adrSrc, memWrite, IRWrite, regWrite;
    input [1:0] resultSrc, ALUSrcA, ALUSrcB;
    input [2:0] ALUControl, immSrc;
    output [6:0] op;
    output [2:0] func3;
    output func7, zero, neg;

    
endmodule