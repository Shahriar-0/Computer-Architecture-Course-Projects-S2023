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
    wire [1:0]  PCSrcE;
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
    wire [31:0] ALUResultM, writeDataM, PCPlus4M, ,extImmM, RDM;
    wire [4:0] RdM;



    wire [4:0] RdW;
    wire regWriteW;
    wire [1:0] resultSrcW
    wire [4:0] RdW;
    wire [31:0] resultW, extImmW, ALUResultW, RDW, PCPlus4W;
    
    wire [31:0] idk; //fix me

    InstructionMemory IM(.pc(PCF), .instruction(instrF));
    
    DataMemory DN(.memAdr(ALUResultM), .writeData(writeDataM), .memWrite(memWriteM), .clk(clk), .readData(RDM));

    RegisterFile RF(.clk(clk), .regWrite(regWriteW),
                    .readRegister1(instrD[19:15]), .readRegister2(instrD[24:20]),
                    .writeRegister(RdW), .writeData(resultW),
                    .readData1(RD1D), .readData2(RD2D));
    
    ImmExtension Extend(.immSrc(immSrcD), .data(instrD[31:7]), .w(extImmD));

    Adder PC4Adder( .a(PCF), .b(32'd4), .w(PCPlus4F));
    Adder PCtarAdder(.a(PCE), .b(extImmE), .w(PCTargetE));

    ALU Alu(.opc(ALUControlE), .a(SrcAE), .b(SrcBE), .zero(zero), .neg(neg), .w(ALUResultE));

    Mux4to1 PCmux(.slc(PCSrcE), .a(PCPlus4F), .b(PCTargetE), .c(ALUResultE), .d(32'b0), .w(PCFf));

    Mux4to1 SrcAreg(.slc(forwardAE), .a(RD1E) , .b(resultW), .c(idk) , .d(32'b0), .w(SrcAE));
    Mux4to1 BSrcBreg(.slc(forwardBE), .a(RD2E) , .b(resultW), .c(idk) , .d(32'b0), .w(writeDataE));
    
    Mux4to1 resMux(.slc(resultSrcW), .a(ALUResultW), .b(RDW), .c(PCPlus4W), d(extImmW), .w(resultW));

    Mux2to1 SrcBreg( .slc(ALUSrcE), .a(writeDataE), .b(extImmE), .w(SrcBE));

    Mux2to1 muxMSrcA( .slc(luiM), .a(ALUResultM), .b(extImmM) , .w(idk));

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

    RegMEM_WB regMEMWB(.clk(clk), .rst(rst), .regWriteM(regWriteM), .resultSrcM(resultSrcM),
                 .ALUResultM(ALUResultM), .RDM(RDM), .RdM(RdM), .PCPlus4M(PCPlus4M),
                .extImmM(extImmM), .extImmW(extImmW), .regWriteW(regWriteW), .resultSrcW(resultSrcW),
                .ALUResultW(ALUResultW), .RDW(RDW), .RdW(RdW), .PCPlus4W(PCPlus4W)
                );
    
    HazardUnit hazard(.Rs1D(Rs1D), .Rs2D(Rs2D), .RdE(RdE), .RdM(RdM), .RdW(RdW), .Rs2E(Rs2E), .Rs1E(Rs1E),
                 .PCSrcE(PCSrcE), .resultSrc0(resultSrcE[0]), .regWriteW(regWriteW),
                 .regWriteM(regWriteM), .stallF(stallF), .stallD(stallD), .flushD(flushD),
                 .flushE(flushE), .forwardAE(forwardAE), .forwardBE(forwardBE));

    BranchController JBprosecc(.branchE(branchE), .jumpE(jumpE), .neg(neg), .zero(zero), .PCSrcE(PCSrcE));

    

endmodule