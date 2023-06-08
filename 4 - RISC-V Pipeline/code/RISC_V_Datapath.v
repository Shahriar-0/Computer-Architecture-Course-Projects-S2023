module RISC_V_Datapath(clk, rst, regWriteD, resultSrcD, 
                       memWriteD, jumpD, branchD, 
                       ALUControlD, ALUSrcD, immSrcD, 
                       luiD, op, func3, func7);

    input clk, rst, regWriteD, memWriteD, ALUSrcD, luiD;
    input  [1:0] resultSrcD, jumpD;
    input  [2:0] ALUControlD, branchD, immSrcD; // ?

    output [6:0] op;
    output [2:0] func3;
    output func7;

    wire regWriteW, regWriteM, memWriteM, luiE, 
         luiM, forwardAE, forwardBE, regWriteE, 
         ALUSrcE, memWriteE, flushE, zero, neg, 
         stallF, stallD, flushD;

    wire [1:0] resultSrcW, resultSrcM, jumpE, resultSrcE;
    wire [2:0] branchE, ALUControlE;
    wire [4:0] RdW, RdM, Rs1E, Rs2E, RdE, Rs1D, Rs2D, RdD;

    wire [31:0] ALUResultM, writeDataM, PCPlus4M, extImmM, RDM,
                resultW, extImmW, ALUResultW, PCPlus4W, RDW,
                RD1E, RD2E, PCE, SrcAE, SrcBE, writeDataE,        // E wires
                PCTargetE, extImmE, PCPlus4E, ALUResultE, PCSrcE, // E wires
                PCPlus4D, instrD, PCD, RD1D, RD2D, extImmD,
                PCF_Prime, PCF, instrF, PCPlus4F,
                idk; // FIXME: idk

    InstructionMemory IM(
        .pc(PCF), .instruction(instrF)
    );
    
    DataMemory DN(
        .memAdr(ALUResultM), .writeData(writeDataM), 
        .memWrite(memWriteM), .clk(clk), .readData(RDM)
    );

    RegisterFile RF(
        .clk(clk), .regWrite(regWriteW),
        .writeRegister(RdW), .writeData(resultW),
        .readData1(RD1D), .readData2(RD2D),
        .readRegister1(instrD[19:15]), 
        .readRegister2(instrD[24:20])
    );
    
    ImmExtension Extend(
        .immSrc(immSrcD), .w(extImmD),
        .data(instrD[31:7])
    );

    ALU Alu(
        .opc(ALUControlE), .a(SrcAE), .b(SrcBE), 
        .zero(zero), .neg(neg), .w(ALUResultE)
    );

    Register PCreg(
        .in(PCF_Prime), .clk(clk), .en(~stallF), 
        .rst(rst), .out(PCF)
    );
     
    RegIF_ID regIFID(
        .clk(clk), .rst(rst), .en(~stallD), 
        .clr(flushD), .instrF(instrF), .PCF(PCF), 
        .PCPlus4F(PCPlus4F), .PCPlus4D(PCPlus4D),
        .instrD(instrD), .PCD(PCD)
    );

    RegID_EX regIDEX(
        .clk(clk), .rst(rst), .clr(flushE), 
        .regWriteD(regWriteD), .resultSrcD(resultSrcD), 
        .memWriteD(memWriteD), .jumpD(jumpD),
        .branchD(branchD), .ALUControlD(ALUControlD), 
        .ALUSrcD(ALUSrcD), .RD1D(RD1D), .RD2D(RD2D), 
        .PCD(PCD),.Rs1D(Rs1D), .Rs2D(Rs2D), .RdD(RdD), 
        .extImmD(extImmD),.PCPlus4D(PCPlus4D), .luiD(luiD),
        .regWriteE(regWriteE), .ALUSrcE(ALUSrcE), 
        .memWriteE(memWriteE), .jumpE(jumpE), .luiE(luiE),
        .branchE(branchE), .ALUControlE(ALUControlE), 
        .resultSrcE(resultSrcE), .RD1E(RD1E), .RD2E(RD2E), 
        .PCE(PCE),.Rs1E(Rs1E), .Rs2E(Rs2E),.RdE(RdE), 
        .extImmE(extImmE),.PCPlus4E(PCPlus4E)
    );
    
    RegEX_MEM regEXMEM(
        .clk(clk), .rst(rst), .regWriteE(regWriteE), 
        .resultSrcE(resultSrcE), .memWriteE(memWriteE),
        .ALUResultE(ALUResultE), .writeDataE(writeDataE), 
        .RdE(RdE), .PCPlus4E(PCPlus4E), .luiE(luiE), 
        .extImmE(extImmE), .regWriteM(regWriteM), .RdM(RdM),
        .resultSrcM(resultSrcM), .memWriteM(memWriteM), 
        .ALUResultM(ALUResultM), .writeDataM(writeDataM),
         .PCPlus4M(PCPlus4M), .luiM(luiM),.extImmM(extImmM)
    );

    RegMEM_WB regMEMWB(
        .clk(clk), .rst(rst), .regWriteM(regWriteM), 
        .resultSrcM(resultSrcM), .RDM(RDM), .RdM(RdM),
        .ALUResultM(ALUResultM), .PCPlus4M(PCPlus4M),
        .extImmM(extImmM), .extImmW(extImmW), .RdW(RdW),
        .regWriteW(regWriteW), .resultSrcW(resultSrcW),
        .ALUResultW(ALUResultW), .RDW(RDW), .PCPlus4W(PCPlus4W)
    );
    
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

    Adder PC4Adder  (.a(PCF), .b(32'd4),   .w(PCPlus4F));
    Adder PCtarAdder(.a(PCE), .b(extImmE), .w(PCTargetE));

    Mux4to1 SrcAreg (.slc(forwardAE),  .a(RD1E),       .b(resultW),   .c(idk),        .d(32'b0),   .w(SrcAE));
    Mux4to1 BSrcBreg(.slc(forwardBE),  .a(RD2E),       .b(resultW),   .c(idk),        .d(32'b0),   .w(writeDataE));
    Mux4to1 resMux  (.slc(resultSrcW), .a(ALUResultW), .b(RDW),       .c(PCPlus4W),   .d(extImmW), .w(resultW));
    Mux4to1 PCmux   (.slc(PCSrcE),     .a(PCPlus4F),   .b(PCTargetE), .c(ALUResultE), .d(32'b0),   .w(PCF_Prime));

    Mux2to1 SrcBreg (.slc(ALUSrcE), .a(writeDataE), .b(extImmE), .w(SrcBE));
    Mux2to1 muxMSrcA(.slc(luiM),    .a(ALUResultM), .b(extImmM), .w(idk));

    assign op = instr[6:0];
    assign RdD = instrD[11:7];
    assign func3 = instr[14:12];
    assign Rs1D =  instrD[19:15];
    assign Rs2D = instrD[24:20];
    assign func7 = instr[30];

endmodule