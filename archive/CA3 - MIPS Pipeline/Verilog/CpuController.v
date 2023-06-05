`include "Controller.v"
`include "ForwardingUnit.v"
`include "HazardUnit.v"

module CpuController (opc, func, equal, IFIDRs, IFIDRt, IDExmemRead, ExMemRd, MemWBRd,
                      ExMemregWrite, MemWBregWrite, IDExRs, IDExRt, clk, rst,
                      PcSrc, IFIDFlush, ALUSrc, RegDst, memRead, memWrite, RegData,
                      regWrite, ALUOpc, PcWrite, IFIDLoad, IDExFlush, forwardA, forwardB);
    input [5:0] opc, func;
    input equal, IDExmemRead, ExMemregWrite, MemWBregWrite;
    input [4:0] IFIDRs, IFIDRt, IDExRs, IDExRt, ExMemRd, MemWBRd;
    input clk, rst;
    output [1:0] PcSrc, RegDst, RegData, forwardA, forwardB;
    output [2:0] ALUOpc;
    output IFIDLoad, IFIDFlush, IDExFlush, ALUSrc, memRead, memWrite, regWrite, PcWrite;

    Controller controller(opc, func, equal, clk, rst, PcSrc, IFIDFlush, ALUSrc,
                          RegDst, memRead, memWrite, RegData, regWrite, ALUOpc);

    HazardUnit hazardUnit(IFIDRs, IFIDRt, IDExRt, IDExmemRead, PcWrite, IFIDLoad, IDExFlush);

    ForwardingUnit forwardingUnit(ExMemRd, MemWBRd, ExMemregWrite, MemWBregWrite, IDExRs, IDExRt, forwardA, forwardB);
endmodule
