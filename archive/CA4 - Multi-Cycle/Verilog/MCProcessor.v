`include "Cpu.v"
`include "Memory.v"

module MCProcessor (clk, rst);
    input clk, rst;

    wire [15:0] memData, memwriteData;
    wire [11:0] memAdr;
    wire memRead, memWrite;

    Cpu cpu(memData, clk, rst, memAdr, memwriteData, memWrite, memRead);
    Memory memory(memAdr, memwriteData, memRead, memWrite, clk, memData);
endmodule
