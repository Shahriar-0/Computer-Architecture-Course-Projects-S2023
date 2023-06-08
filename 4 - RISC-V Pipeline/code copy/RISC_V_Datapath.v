module RISC_V_Datapath(clk, rst, regWriteD, resultSrcD, memWriteD, jumpD
                    branchD, ALUControlD, ALUSrcD,
                    immSrcD, luiD, op, func3, func7);

    input clk, rst, regWriteD, memWriteD, ALUSrcD, luiD;
    input [1:0] resultSrcD, jumpD;
    input [2:0] ALUControl, branchD, immSrcD;
    output [6:0] op;
    output [2:0] func3;
    output func7;

    wire zero, neg;

    wire stallF;
    wire [1:0]  PCSrc;
    wire [31:0] PCPlus4F;
    wire [31:0]  PCFf, PCF, instrF;

    wire [31:0]  PCPlus4D, instrD, PCD;
    wire [31:0]  RD1D, RD2D, extImmD;
    wire [4:0] Rs1D, Rs2D,RdD;
    wire stallD, flushD;
    assign Rs1D =  instrD[19:15];
    assign Rs2D = instrD[24:20];
    assign RdD = instrD[11:7];


    wire regWriteE, ALUSrcE, memWriteE, luiE, flushE;
    wire forwardAE, forwardBE;
    wire [1:0] jumpE, resultSrcE;
    wire [2:0] branchE, ALUControlE;
    wire [31:0] RD1E, RD2E, PCE, PCPlus4E, extImmE, ALUResultE;
    wire [31:0] SrcAE, SrcBE, writeDataE, PCTargetE;
    wire [4:0] Rs1E, Rs2E,RdE;

    wire  regWriteM, memWriteM, luiM;
    wire [1:0] resultSrcM;
    wire [31:0] ALUResultM, writeDataM, PCPlus4M, ,extImmM;
    wire [4:0] RdM;



    wire [4:0] RdW;
    wire regWriteW;
    wire [31:0] resultW;

    InstructionMemory IM(.pc(PCF), .instruction(instrF));
    
    RegisterFile RF(.clk(clk), .regWrite(regWriteW),
                    .readRegister1(instrD[19:15]), .readRegister2(instrD[24:20]),
                    .writeRegister(RdW), .writeData(resultW),
                    .readData1(RD1D), .readData2(RD2D));
    
    ImmExtension Extend(.immSrc(immSrcD), .data(instrD[31:7]), .w(extImmD));

    Adder PC4Adder( .a(PCF), .b(32'd4), .w(PCPlus4F));
    Adder PCtarAdder(.a(PCE), .b(extImmE), .w(PCTargetE));

    ALU Alu(.opc(ALUControlE), .a(SrcAE), .b(SrcBE), .zero(zero), .neg(neg), .w(ALUResultE));

    Mux4to1 PCmux(.slc(PCSrcE), .a(PCPlus4F), .b(PCTargetE), .c(ALUResultE), .d(32'b0), .w(PCFf));

    Mux4to1 SrcAreg(.slc(forwardAE), .a(RD1E) , .b(resultW), .c(ALUResultM) , .d(32'b0), .w(SrcAE));
    Mux4to1 BSrcBreg(.slc(forwardBE), .a(RD2E) , .b(resultW), .c(ALUResultM) , .d(32'b0), .w(writeDataE));
    
    Mux2to1 SrcBreg( .slc(ALUSrcE), .a(writeDataE), .b(extImmE), .w(SrcBE));


    Register PCreg(.in(PCFf), .clk(clk), .en(~stallF), .rst(rst), .out(PCF));
     
    RegIF_ID regIFID(.clk(clk), .rst(rst), .en(~stallD), .clr(flushD), .instrF(instrF), .PCF(PCF), 
                .PCPlus4F(PCPlus4F), .PCPlus4D(PCPlus4D),
                .instrD(instrD), .PCD(PCD));

    RegID_EX regIDEX(.clk(clk), .rst(rst), .clr(flushE), .regWriteD(regWriteD),
                .resultSrcD(resultSrcD), .memWriteD(memWriteD), .jumpD(jumpD),
                .branchD(branchD), .ALUControlD(ALUControlD), .ALUSrcD(ALUSrcD),
                .RD1D(RD1D), .RD2D(RD2D), .PCD(PCD),.Rs1D(Rs1D),
                .Rs2D(Rs2D),.RdD(RdD), .extImmD(extImmD),.PCPlus4D(PCPlus4D), .luiD(luiD),
                .regWriteE(regWriteE), .ALUSrcE(ALUSrcE), .memWriteE(memWriteE), .jumpE(jumpE), .luiE(luiE),
                .branchE(branchE), .ALUControlE(ALUControlE), .resultSrcE(resultSrcE), .RD1E(RD1E), .RD2E(RD2E), .PCE(PCE),.Rs1E(Rs1E),
                .Rs2E(Rs2E),.RdE(RdE), .extImmE(extImmE),.PCPlus4E(PCPlus4E));
    
    RegEX_MEM regEXMEM(.clk(clk), .rst(rst), .regWriteE(regWriteE), .resultSrcE(resultSrcE), .memWriteE(memWriteE),
                 .ALUResultE(ALUResultE), .writeDataE(writeDataE), .RdE(RdE), .PCPlus4E(PCPlus4E), .luiE(luiE), .extImmE(extImmE),
                 .regWriteM(regWriteM), .resultSrcM(resultSrcM), .memWriteM(memWriteM), .ALUResultM(ALUResultM),
                 .writeDataM(writeDataM), .RdM(RdM), .PCPlus4M(PCPlus4M), .luiM(luiM),.extImmM(extImmM));

    
endmodule