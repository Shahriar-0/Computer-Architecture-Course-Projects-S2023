module RISC_V(clk, rst);
    input clk, rst;
    
    wire [2:0] func3, ALUControl, immSrc;

    wire zero, neg, PCSrc, memWrite, func7, 
         regWrite, ALUSrc, PCWrite, adrSrc, IRWrite;

    wire [1:0] resultSrc, ALUSrcA, ALUSrcB;
    
    wire [6:0] op; 

    RISC_V_Controller CU(
        .clk(clk), .rst(rst), .op(op), 
        .func3(func3), .immSrc(immSrc), 
        .func7(func7), .zero(zero), 
        .neg(neg), .PCWrite(PCWrite),
        .adrSrc(adrSrc), .memWrite(memWrite), 
        .IRWrite(IRWrite), .resultSrc(resultSrc), 
        .ALUControl(ALUControl), .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB), .regWrite(regWrite)
    );

    RISC_V_Datapath DP(
        .clk(clk), .rst(rst), .neg(neg),
        .PCWrite(PCWrite), .adrSrc(adrSrc),
        .memWrite(memWrite), .IRWrite(IRWrite), 
        .resultSrc(resultSrc), .immSrc(immSrc), 
        .ALUControl(ALUControl), .op(op),
        .ALUSrcA(ALUSrcA), .func3(func3),
        .ALUSrcB(ALUSrcB), .zero(zero),
        .regWrite(regWrite), .func7(func7)
    );
    
endmodule