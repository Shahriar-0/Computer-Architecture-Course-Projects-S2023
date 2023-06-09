module RISC_V_Datapath(clk, rst, regWriteD, resultSrcD, 
                       memWriteD, jumpD, branchD, 
                       ALUControlD, ALUSrcD, immSrcD, 
                       luiD, op, func3, func7);

    input clk, rst, regWriteD, memWriteD, ALUSrcD, luiD;
    input  [1:0] resultSrcD, jumpD;
    input  [2:0] ALUControlD, branchD, immSrcD;

    output [6:0] op;
    output [2:0] func3;
    output func7;

    wire regWriteW, regWriteM, memWriteM, luiE, 
         luiM, regWriteE, 
         ALUSrcE, memWriteE, flushE, zero, neg, 
         stallF, stallD, flushD;

    wire [1:0] resultSrcW, resultSrcM, jumpE, PCSrcE, resultSrcE, forwardAE, forwardBE;
    wire [2:0] branchE, ALUControlE;
    wire [4:0] RdW, RdM, Rs1E, Rs2E, RdE, Rs1D, Rs2D, RdD;

    wire [31:0] ALUResultM, writeDataM, PCPlus4M, extImmM, RDM,
                resultW, extImmW, ALUResultW, PCPlus4W, RDW,
                RD1E, RD2E, PCE, SrcAE, SrcBE, writeDataE,        // E wires
                PCTargetE, extImmE, PCPlus4E, ALUResultE, // E wires
                PCPlus4D, instrD, PCD, RD1D, RD2D, extImmD,
                PCF_Prime, PCF, instrF, PCPlus4F,
                idk; // FIXME: idk

    // F
    Adder PCFAdder(
        .a(PCF), .b(32'd4), .w(PCPlus4F)
    );

    Register PCreg(
        .in(PCF_Prime), .clk(clk), .en(~stallF), 
        .rst(rst), .out(PCF)
    );

    InstructionMemory IM(
        .pc(PCF), .instruction(instrF)
    );

    Mux4to1 PCmux(
        .slc(PCSrcE), .a(PCPlus4F), .b(PCTargetE), 
        .c(ALUResultE), .d(32'bz), .w(PCF_Prime)
    );

    RegIF_ID regIFID(
        .clk(clk), .rst(rst), 
        .en(~stallD), .clr(flushD),

        .PCF(PCF),                 .PCD(PCD),
        .PCPlus4F(PCPlus4F),       .PCPlus4D(PCPlus4D),
        .instrF(instrF),           .instrD(instrD)
    );
    // end F

    // D
    RegisterFile RF(
        .clk(clk), .regWrite(regWriteW),
        .writeRegister(RdW), 
        .writeData(resultW),
        .readData1(RD1D), .readData2(RD2D),
        .readRegister1(instrD[19:15]), 
        .readRegister2(instrD[24:20])
    );
    
    ImmExtension Extend(
        .immSrc(immSrcD), .w(extImmD),
        .data(instrD[31:7])
    );

    ALU ALU_Instance(
        .opc(ALUControlE), .a(SrcAE), .b(SrcBE), 
        .zero(zero), .neg(neg), .w(ALUResultE)
    );

    assign op = instrD[6:0];
    assign RdD = instrD[11:7];
    assign func3 = instrD[14:12];
    assign Rs1D =  instrD[19:15];
    assign Rs2D = instrD[24:20];
    assign func7 = instrD[30];

    RegID_EX regIDEX(
        .clk(clk), .rst(rst), .clr(flushE), 

        .regWriteD(regWriteD),     .regWriteE(regWriteE), 
        .PCD(PCD),                 .PCE(PCE),
        .Rs1D(Rs1D),               .Rs1E(Rs1E),
        .Rs2D(Rs2D),               .Rs2E(Rs2E),
        .RdD(RdD),                 .RdE(RdE),
        .RD1D(RD1D),               .RD1E(RD1E),
        .RD2D(RD2D),               .RD2E(RD2E), 
        .resultSrcD(resultSrcD),   .resultSrcE(resultSrcE),
        .memWriteD(memWriteD),     .memWriteE(memWriteE),
        .jumpD(jumpD),             .jumpE(jumpE),
        .branchD(branchD),         .branchE(branchE),
        .ALUControlD(ALUControlD), .ALUControlE(ALUControlE), 
        .ALUSrcD(ALUSrcD),         .ALUSrcE(ALUSrcE),    
        .extImmD(extImmD),         .extImmE(extImmE),
        .luiD(luiD),               .luiE(luiE),
        .PCPlus4D(PCPlus4D),       .PCPlus4E(PCPlus4E) 
    );
     
    // end D
    
    // E    
    Mux4to1 SrcAreg (
        .slc(forwardAE), .a(RD1E), .b(resultW), .c(idk), .d(32'bz), .w(SrcAE)
    );

    Mux4to1 BSrcBreg(
        .slc(forwardBE), .a(RD2E), .b(resultW), .c(idk), .d(32'bz), .w(writeDataE)
    );

    Mux2to1 SrcBreg(
        .slc(ALUSrcE), .a(writeDataE), .b(extImmE), .w(SrcBE)
    );

    Adder PCEAdder(
        .a(PCE), .b(extImmE), .w(PCTargetE)
    );

    RegEX_MEM regEXMEM(
        .clk(clk), .rst(rst), 

        .PCPlus4M(PCPlus4M),       .PCPlus4E(PCPlus4E),
        .resultSrcE(resultSrcE),   .resultSrcM(resultSrcM),
        .writeDataE(writeDataE),   .writeDataM(writeDataM),
        .luiE(luiE),               .luiM(luiM),
        .regWriteE(regWriteE),     .regWriteM(regWriteM), 
        .RdE(RdE),                 .RdM(RdM),
        .memWriteE(memWriteE),     .memWriteM(memWriteM),
        .ALUResultE(ALUResultE),   .ALUResultM(ALUResultM),
        .extImmE(extImmE),         .extImmM(extImmM)
    );
    // end E

    // M
    DataMemory DM(
        .memAdr(ALUResultM), .writeData(writeDataM), 
        .memWrite(memWriteM), .clk(clk), .readData(RDM)
    );

    Mux2to1 muxMSrcA(
        .slc(luiM), .a(ALUResultM), .b(extImmM), .w(idk)
    );

    RegMEM_WB regMEMWB(
        .clk(clk), .rst(rst), 

        .regWriteM(regWriteM),     .regWriteW(regWriteW),
        .ALUResultM(ALUResultM),   .ALUResultW(ALUResultW),
        .RDM(RDM),                 .RDW(RDW),
        .RdM(RdM),                 .RdW(RdW),
        .resultSrcM(resultSrcM),   .resultSrcW(resultSrcW),  
        .PCPlus4M(PCPlus4M),       .PCPlus4W(PCPlus4W),
        .extImmM(extImmM),         .extImmW(extImmW)
    );
    // end M

    // W
    Mux4to1 resMux(
        .slc(resultSrcW), .a(ALUResultW), .b(RDW), 
        .c(PCPlus4W), .d(extImmW), .w(resultW)
    );
    // end W
    
    HazardUnit hazard(
        .Rs1D(Rs1D), .Rs2D(Rs2D), .RdE(RdE), .RdM(RdM), 
        .RdW(RdW), .Rs2E(Rs2E), .Rs1E(Rs1E), .stallF(stallF),
        .PCSrcE(PCSrcE), .resultSrc0(resultSrcE[0]), 
        .regWriteW(regWriteW),.regWriteM(regWriteM), 
        .stallD(stallD), .flushD(flushD), .flushE(flushE), 
        .forwardAE(forwardAE), .forwardBE(forwardBE)
    );

    BranchController JBprosecc(
        .branchE(branchE), .jumpE(jumpE), .neg(neg), 
        .zero(zero), .PCSrcE(PCSrcE)
    );

endmodule