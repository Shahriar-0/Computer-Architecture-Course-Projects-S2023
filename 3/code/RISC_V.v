module RISC_V(clk);
    input clk;
    CPU_Controller CPU(clk, op, func3, func7, zero, neg, PCSrc,
                      resultSrc, memWrite, ALUControl,
                      ALUSrc,immSrc,regWrite);
    CPU_Datapath DP(clk, RegWrite, ALUSrcB, MemWrite,
                     resultSrc, PCSrc,
                     ALUControl, immSrc,
                     zero, neg, op,
                     func7, func3);
endmodule