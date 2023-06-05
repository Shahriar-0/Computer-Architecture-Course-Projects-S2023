`include "Adder.v"
`include "ALU.v"
`include "Mux.v"
`include "Register.v"
`include "RegisterFile.v"
`include "RegisterBlocks.v"

module CpuDatapath (Inst, memReadData, PcWrite, PcSrc, IFIDFlush, IDExFlush, IFIDLoad, ALUOpc, ALUSrc,
                    RegDst, memRead, memWrite, RegData, regWrite, forwardA, forwardB, clk, rst,
                    Pc, equal, MemAdr, memWriteData, MemoryRead, MemoryWrite, opc, func, IFIDRs, IFIDRt,
                    IDExmemRead, ExMemRd, MemWBRd, ExMemregWrite, MemWBregWrite, IDExRs, IDExRt);
    input clk, rst;
    input PcWrite, IFIDFlush, IDExFlush, IFIDLoad, ALUSrc, memRead, memWrite, regWrite;
    input [31:0] Inst, memReadData;
    input [1:0] PcSrc, RegDst, RegData, forwardA, forwardB;
    input [2:0] ALUOpc;
    input [5:0] opc, func;
    output [4:0] IFIDRs, IFIDRt, ExMemRd, MemWBRd, IDExRs, IDExRt;
    output [31:0] Pc, MemAdr, memWriteData;
    output equal, MemoryRead, MemoryWrite, IDExmemRead, ExMemregWrite, MemWBregWrite;

    // IF Wires
    wire [31:0] PcIn, IncrementedPc;
    // ID Wires
    wire [31:0] ID_Pc, ID_Inst, SExtended, ShLeft2, ReadData1, ReadData2, beqPc, jPc, jrPc;
    wire [4:0] Rs, Rt, Rd;
    // Ex Wires
    wire Ex_ALUSrc, Ex_memRead, Ex_memWrite, Ex_regWrite;
    wire [1:0] Ex_RegDst, Ex_RegData;
    wire [2:0] Ex_ALUOpc;
    wire [31:0] Ex_ReadData1, Ex_ReadData2, Ex_SExtended, Ex_Pc, ALUIn1, ALUIn2, ALUSrcIn0, ALURes;
    wire [4:0] Ex_Rs, Ex_Rt, Ex_Rd, RegDestination;
    // Mem Wires
    wire Mem_memRead, Mem_memWrite, Mem_regWrite;
    wire [1:0] Mem_RegData;
    wire [31:0] Mem_ALURes, Mem_ReadData2, Mem_Pc;
    wire [4:0] Mem_Rd;
    // WB Wires
    wire WB_regWrite;
    wire [1:0] WB_RegData;
    wire [31:0] WB_memReadData, WB_ALURes, WB_Pc, regWriteData;
    wire [4:0] WB_Rd;

    assign opc = ID_Inst[31:26];
    assign func = ID_Inst[5:0];
    assign MemAdr = Mem_ALURes;
    assign memWriteData = Mem_ReadData2;
    assign MemoryRead = Mem_memRead;
    assign MemoryWrite = Mem_memWrite;
    assign IFIDRs = Rs;
    assign IFIDRt = Rt;
    assign ExMemRd = Mem_Rd;
    assign MemWBRd = WB_Rd;
    assign IDExRs = Ex_Rs;
    assign IDExRt = Ex_Rt;
    assign IDExmemRead = Ex_memRead;
    assign ExMemregWrite = Mem_regWrite;
    assign MemWBregWrite = WB_regWrite;


    // IF
    Register #(32) PcReg(.in(PcIn), .ld(PcWrite), .sclr(1'b0), .clk(clk), .rst(rst), .out(Pc));
    Adder #(32) PcAdder(.a(32'd4), .b(Pc), .res(IncrementedPc));
    Mux4To1 #(32) PcMux(.a00(IncrementedPc), .a01(beqPc), .a10(jPc), .a11(jrPc), .sel(PcSrc), .out(PcIn));

    // IF/ID
    RegIF_ID IF_ID(IncrementedPc, Inst, IFIDFlush, IFIDLoad, clk, rst, ID_Pc, ID_Inst);

    // ID
    assign Rs = ID_Inst[25:21];
    assign Rt = ID_Inst[20:16];
    assign Rd = ID_Inst[15:11];
    assign SExtended = {{16{ID_Inst[15]}}, ID_Inst[15:0]};
    assign ShLeft2 = SExtended << 2;
    assign jPc = {ID_Pc[31:28], ID_Inst[25:0], 2'b00};
    assign jrPc = ReadData1;
    assign equal = (ReadData1 == ReadData2);
    Adder #(32) beqAdder(.a(ID_Pc), .b(ShLeft2), .res(beqPc));
    RegisterFile regFile(.readRegister1(Rs), .readRegister2(Rt), .writeRegister(WB_Rd),
                         .writeData(regWriteData), .regWrite(WB_regWrite), .sclr(1'b0), .clk(clk), .rst(rst),
                         .readData1(ReadData1), .readData2(ReadData2));

    // ID/Ex
    RegID_Ex ID_Ex(ALUOpc, ALUSrc, RegDst, memRead, memWrite, RegData, regWrite, ReadData1, ReadData2, SExtended,
                   Rs, Rt, Rd, ID_Pc, IDExFlush, clk, rst, Ex_ALUOpc, Ex_ALUSrc, Ex_RegDst, Ex_memRead, Ex_memWrite,
                   Ex_RegData, Ex_regWrite, Ex_ReadData1, Ex_ReadData2, Ex_SExtended, Ex_Rs, Ex_Rt, Ex_Rd, Ex_Pc);

    // Ex
    Mux4To1 #(32) aMux(.a00(Ex_ReadData1), .a01(Mem_ALURes), .a10(regWriteData), .sel(forwardA), .out(ALUIn1));
    Mux4To1 #(32) bMux(.a00(Ex_ReadData2), .a01(Mem_ALURes), .a10(regWriteData), .sel(forwardB), .out(ALUSrcIn0));
    Mux2To1 #(32) ALUSrcMux(.a0(ALUSrcIn0), .a1(Ex_SExtended), .sel(Ex_ALUSrc), .out(ALUIn2));
    ALU alu(.a(ALUIn1), .b(ALUIn2), .opc(Ex_ALUOpc), .res(ALURes));
    Mux4To1 #(5) RegDestinationMux(.a00(Ex_Rt), .a01(Ex_Rd), .a10(5'd31), .sel(Ex_RegDst), .out(RegDestination));

    // Ex/Mem
    RegEx_Mem Ex_Mem(Ex_memRead, Ex_memWrite, Ex_RegData, Ex_regWrite, ALURes, Ex_ReadData2, RegDestination,
                     Ex_Pc, clk, rst, Mem_memRead, Mem_memWrite, Mem_RegData, Mem_regWrite, Mem_ALURes,
                     Mem_ReadData2, Mem_Rd, Mem_Pc);

    // Mem

    // Mem/WB
    RegMem_WB Mem_WB(Mem_RegData, Mem_regWrite, memReadData, Mem_ALURes, Mem_Rd, Mem_Pc, clk, rst,
                     WB_RegData, WB_regWrite, WB_memReadData, WB_ALURes, WB_Rd, WB_Pc);

    // WB
    Mux4To1 #(32) RegDataMux(.a00(WB_ALURes), .a01(WB_memReadData), .a10(WB_Pc), .sel(WB_RegData), .out(regWriteData));
endmodule
