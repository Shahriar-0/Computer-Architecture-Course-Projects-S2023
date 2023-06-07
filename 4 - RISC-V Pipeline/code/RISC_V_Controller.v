module RISC_V_Controller(clk, rst, op, func3, func7, zero, neg,
                    PCWrite, adrSrc, memWrite,
                    IRWrite, resultSrc, ALUControl,
                    ALUSrcA, ALUSrcB, immSrc, regWrite);
    input [6:0] op;
    input [2:0] func3;
    input clk, rst, zero , neg, func7;
    
    output PCWrite, adrSrc, memWrite, IRWrite, regWrite;
    output [1:0] resultSrc, ALUSrcA, ALUSrcB;
    output [2:0] ALUControl, immSrc;
    
endmodule