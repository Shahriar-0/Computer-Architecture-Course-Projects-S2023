module RISC_V(clk);
    input clk;
    CPU_Controller CPU(op, func3, func7, zero, neg, PCSrc,
                      resultSrc, memWrite, ALUControl,
                      ALUSrc,immSrc,regWrite);
    CPU_Datapath DP(clk, RegWrite, ALUSrcB, MemWrite,
                     ResultSrc, PCSrc,
                     ALUControl, ImmSrc,
                     zero, neg, op,
                     func7, func3);
endmodule