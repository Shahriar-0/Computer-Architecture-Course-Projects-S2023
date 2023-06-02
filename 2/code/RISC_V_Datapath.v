module RISC_V_Datapath(clk, regWrite, ALUSrcB,
                       resultSrc, PCSrc,
                       ALUControl, immSrc,
                       zero, neg, op,
                       func7, memWrite, func3);


    input clk, regWrite, ALUSrcB, memWrite;
    input [1:0] resultSrc, PCSrc;
    input [2:0] immSrc, ALUControl;

    output zero, neg;
    output [6:0] op, func7;
    output [2:0] func3;

    wire [31:0] PC, PCNext, PCPlus4, PCTarget;
    wire [31:0] ImmExt, instr, ALUResult;
    wire [31:0] ReadData, Result;
    wire [31:0] SrcA, SrcB, Rd2;

    Register PCR(
        .in(PCNext), .clk(clk), .out(PC)
    );

    Mux2to1 BMux(
        .slc(ALUSrcB), .a(RD2), .b(ImmExt), w(SrcB)
    );
    
    Mux4to1 PCMux(
        .slc(PCSrc), .a(PCPlus4), .b(Result), 
        .c(ALUResult), .d(32'b0), w(PCNext)
    );
    
    Mux4to1 ResultMux(
        .slc(resultSrc), .a(ALUResult), .b(ReadData), 
        .c(PCPlus4), .d(ImmExt), .w(Result)
    );

    Adder PCTar(
        .a(PC), .b(ImmExt), .w(PCTarget)
    );

    Adder PCP4(
        .a(PC), 32'd4, .w(PCPlus4)
    );

    ImmExtension ImmExtensionInstance(
        .immSrc(immSrc), .data(PC[31:7]), .w(ImmExt)
    );

    ALU ALU_Instance(
        .opc(ALUControl), .a(SrcA), .b(SrcB), 
        .zero(zero), .neg(neg), .w(ALUResult)
    );

    DataMemory DM(.memAdr(ALUResult), .writeData(RD2), .clk(clk), .memWrite(memWrite), .readData(ReadData));

    InstructionMemory IM(
        .pc(PC), .instruction(instr)
    );

    RegisterFile RF(.clk(clk), .regWrite(regWrite),
                    .readRegister1(instr[19:15]), .readRegister2(instr[[24:20]]),
                    .writeRegister(instr[11:7]), .writeData(ALUResult),
                    .readData1(SrcA), .readData2(RD2));

endmodule