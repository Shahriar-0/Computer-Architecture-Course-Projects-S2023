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

    wire [31:0] PC, PCNext, PCPlus4, PCTarget, 
                immExt, instr, ALUResult, 
                readData, result, 
                SrcA, SrcB, RD2, RD1;

    Register PC_Register(
        .in(PCNext), .clk(clk), .out(PC)
    );

    Mux4to1 PC_Mux(
        .slc(PCSrc), .a(PCPlus4), .b(result), 
        .c(ALUResult), .d(32'b0), w(PCNext)
    );

    Mux2to1 branchMux(
        .slc(ALUSrcB), .a(RD2), .b(immExt), w(SrcB)
    );
    
    
    Mux4to1 ResultMux(
        .slc(resultSrc), .a(ALUResult), .b(readData), 
        .c(PCPlus4), .d(immExt), .w(result)
    );

    Adder PCTar(
        .a(PC), .b(immExt), .w(PCTarget)
    );

    Adder PCP4(
        .a(PC), 32'd4, .w(PCPlus4)
    );

    immExtension immExtensionInstance(
        .immSrc(immSrc), .data(PC[31:7]), .w(immExt)
    );

    ALU ALU_Instance(
        .opc(ALUControl), .a(SrcA), .b(SrcB), 
        .zero(zero), .neg(neg), .w(ALUResult)
    );

    DataMemory DM(
        .memAdr(ALUResult), .writeData(RD2), .clk(clk), 
        .memWrite(memWrite), .readData(readData)
    );

    InstructionMemory IM(
        .pc(PC), .instruction(instr)
    );

    RegisterFile RF(
        .clk(clk), .regWrite(regWrite),
        .readRegister1(instr[19:15]), .readRegister2(instr[[24:20]]),
        .writeRegister(instr[11:7]), .writeData(ALUResult),
        .readData1(RD1), .readData2(RD2)
    );

    assign SrcA = RD1;

endmodule