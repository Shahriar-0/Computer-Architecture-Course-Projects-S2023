module CPU_Datapath(input clk, RegWrite, ALUSrcB, MemWrite,
                     input [1:0] ResultSrc, PCSrc,
                     input [2:0] ALUControl, ImmSrc,
                     output zero, neg output[6:0] op,
                     func7, output[2:0]func3);


    wire [31:0] PC, PCNext, PCPlus4, PCTarget;
    wire [31:0] ImmExt, instr, SrcB, ALUResult;
    wire [31:0] ReadData, WriteData, Result;
    wire [31:0] SrcA, Rd2;

    mux2to1 BMux(.slc(ALUSrcB), .a(RD2), .b(ImmExt), w(SrcB));
    mux4to1 PCMux(.slc(PCSrc), .a(PCPlus4), .b(Result), .c(ALUResult), .d(32'b0), w(PCNext));
    mux4to1 ResultMux(.slc(ResultSrc), .a(ALUResult), .b(ReadData), .c(PCPlus4), .d(ImmExt), .w(Result));

    Adder PCTar(.a(PC), .b(ImmExt), .w(PCTarget));
    Adder PCP4(.a(PC), 4, .w(PCPlus4));

    ImmExtension Extend(.ImmSrc(ImmSrc), .data(PC[31:7]), .w(ImmExt));

    ALU Alu(.opc(ALUControl), .a(SrcA), .b(SrcB), .zero(zero), .neg(neg), .w(ALUResult));

    DataMemory DM(.memAdr(ALUResult), .writeData(WriteData), .clk(clk), .memWrite(MemWrite), .readData(ReadData));

    InstructionMemory IM(.pc(PC), .instruction(instr));

    RegisterFile RF(.clk(clk), .regWrite(RegWrite), .sRst(1'b0), .rst(1'b0),
                    .readRegister1(instr[19:15]), .readRegister2(instr[[24:20]]),
                    .writeRegister(instr[11:7]), .writeData(ALUResult),
                    .readData1(SrcA), .readData2(RD2));

endmodule