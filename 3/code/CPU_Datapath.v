module CPU_Datapath(clk, PCWrite, AdrSrc, MemWrite,
                    IRWrite, ResultSrc, ALUControl,
                    ALUSrcA, ALUSrcB, ImmSrc, RegWrite,
                    op, func3, func7, zero, neg);

    input clk, PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite;
    input [1:0] ResultSrc, ALUSrcA, ALUSrcB;
    input [2:0] ALUControl, ImmSrc;

    wire [31:0] PC, Adr, ReadData, OldPC;
    wire [31:0] ImmExt, Instr, Data, ALUResult;
    wire [31:0] RD1, RD2, A, B, SrcA, SrcB;
    wire [31:0] ALUResult, ALUOut,Result;

    Register PCR(.in(Result), .en(PCWrite), .clk(clk), .out(PC));
    Register OldPCR(.in(PC), .en(IRWrite), .clk(clk), .out(OldPC));
    Register IR(.in(ReadData), .en(IRWrite), .clk(clk), .out(Instr));
    Register MDR(.in(ReadData), .en(1'b1), .clk(clk), .out(Data));
    Register AR(.in(RD1), .en(1'b1), .clk(clk), .out(A));
    Register BR(.in(RD2), .en(1'b1), .clk(clk), .out(B));
    Register ALUR(.in(ALUResult), .en(1'b1), .clk(clk), .out(ALUOut));

    mux2to1 AdrMux(.slc(AdrSrc), .a(PC), .b(Result), w(Adr));
    mux4to1 AMux(.slc(ALUSrcA), .a(PC), .b(OldPC), .c(A), .d(32'b0), .w(SrcA));
    mux4to1 BMux(.slc(ALUSrcB), .a(B), .b(ImmExt), .c(32'd4), .d(32'b0), .w(SrcB));
    mux4to1 BMux(.slc(ResultSrc), .a(ALUOut), .b(Data), .c(ALUResult), .d(ImmExt), .w(Result));

    ImmExtension Extend(.ImmSrc(ImmSrc), .data(PC[31:7]), .w(ImmExt));

    ALU Alu(.opc(ALUControl), .a(SrcA), .b(SrcB), .zero(zero), .neg(neg), .w(ALUResult));

    InstrDataMemory DM(.memAdr(Adr), .writeData(B), .clk(clk), .memWrite(MemWrite), .readData(ReadData));

    RegisterFile RF(.clk(clk), .regWrite(RegWrite),
                    .readRegister1(Instr[19:15]), .readRegister2(Instr[[24:20]]),
                    .writeRegister(Instr[11:7]), .writeData(ALUResult),
                    .readData1(RD1), .readData2(RD2));

endmodule