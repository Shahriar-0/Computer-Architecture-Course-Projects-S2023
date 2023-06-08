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

    wire [31:0] PC, Adr, ReadData, OldPC;
    wire [31:0] ImmExt, instr, Data;
    wire [31:0] RD1, RD2, A, B, SrcA, SrcB;
    wire [31:0] ALUResult, ALUOut,Result;

    Register PCR   (.in(Result),    .en(PCWrite), .rst(rst),  .clk(clk), .out(PC));
    Register OldPCR(.in(PC),        .en(IRWrite), .rst(1'b0), .clk(clk), .out(OldPC));
    Register IR    (.in(ReadData),  .en(IRWrite), .rst(1'b0), .clk(clk), .out(instr));
    Register MDR   (.in(ReadData),  .en(1'b1),    .rst(1'b0), .clk(clk), .out(Data));
    Register AR    (.in(RD1),       .en(1'b1),    .rst(1'b0), .clk(clk), .out(A));
    Register BR    (.in(RD2),       .en(1'b1),    .rst(1'b0), .clk(clk), .out(B));
    Register ALUR  (.in(ALUResult), .en(1'b1),    .rst(1'b0), .clk(clk), .out(ALUOut));

    Mux2to1 AdrMux(.slc(adrSrc),    .a(PC),     .b(Result), .w(Adr));

    Mux4to1 AMux  (.slc(ALUSrcA),   .a(PC),     .b(OldPC),  .c(A),         .d(32'd0),  .w(SrcA));
    Mux4to1 BMux  (.slc(ALUSrcB),   .a(B),      .b(ImmExt), .c(32'd4),     .d(32'd0),  .w(SrcB));
    Mux4to1 ResultMux  (.slc(resultSrc), .a(ALUOut), .b(Data),   .c(ALUResult), .d(ImmExt), .w(Result));

    ImmExtension Extend(
        .immSrc(immSrc), .data(instr[31:7]), .w(ImmExt)
    );

    ALU Alu(
        .opc(ALUControl), .a(SrcA), .b(SrcB), 
        .zero(zero), .neg(neg), .w(ALUResult)
    );

    InstrDataMemory DM(
        .memAdr(Adr), .writeData(B), .clk(clk), 
        .memWrite(memWrite), .readData(ReadData)
    );

    RegisterFile RF(
        .clk(clk), 
        .regWrite(regWrite),
        .writeData(Result), 
        .readData1(RD1), .readData2(RD2),
        .readRegister1(instr[19:15]), 
        .readRegister2(instr[24:20]),
        .writeRegister(instr[11:7])
    );

    assign op = instr[6:0];
    assign func3 = instr[14:12];
    assign func7 = instr[30];
endmodule