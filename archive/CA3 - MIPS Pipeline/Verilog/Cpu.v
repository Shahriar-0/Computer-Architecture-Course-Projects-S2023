`include "CpuDatapath.v"
`include "CpuController.v"

module Cpu (Inst, memReadData, clk, rst, Pc, MemAdr, memWriteData, MemoryRead, MemoryWrite);
    input [31:0] Inst, memReadData;
    input clk, rst;
    output [31:0] Pc, MemAdr, memWriteData;
    output MemoryRead, MemoryWrite;

    wire PcWrite, IFIDFlush, IDExFlush, IFIDLoad, ALUSrc, memRead, memWrite, regWrite, equal,
         IDExmemRead, ExMemregWrite, MemWBregWrite;
    wire [1:0] PcSrc, RegDst, RegData, forwardA, forwardB;
    wire [2:0] ALUOpc;
    wire [5:0] opc, func;
    wire [4:0] IFIDRs, IFIDRt, ExMemRd, MemWBRd, IDExRs, IDExRt;

    CpuDatapath dp(Inst, memReadData, PcWrite, PcSrc, IFIDFlush, IDExFlush, IFIDLoad, ALUOpc, ALUSrc,
                   RegDst, memRead, memWrite, RegData, regWrite, forwardA, forwardB, clk, rst,
                   Pc, equal, MemAdr, memWriteData, MemoryRead, MemoryWrite, opc, func, IFIDRs, IFIDRt,
                   IDExmemRead, ExMemRd, MemWBRd, ExMemregWrite, MemWBregWrite, IDExRs, IDExRt);

    CpuController cu(opc, func, equal, IFIDRs, IFIDRt, IDExmemRead, ExMemRd, MemWBRd,
                     ExMemregWrite, MemWBregWrite, IDExRs, IDExRt, clk, rst,
                     PcSrc, IFIDFlush, ALUSrc, RegDst, memRead, memWrite, RegData,
                     regWrite, ALUOpc, PcWrite, IFIDLoad, IDExFlush, forwardA, forwardB);
endmodule
