module RISC_V(clk, rst);
    input clk, rst;
    
    wire [2:0] func3, ALUControl, immSrc;

    wire zero, neg, PCSrc, memWrite, 
         regWrite, ALUSrc, PCWrite, AdrSrc IRWrite;

    wire [1:0] resultSrc, ALUSrcA, ALUSrcB;
    
    wire [6:0] op, func7; 

    CPU_Controller CPU(
        .clk(clk), .rst(rst), .op(op), 
        .func3(func3), .immSrc(immSrc), 
        .func7(func7), .zero(zero), 
        .neg(neg), .PCWrite(PCWrite),
        .AdrSrc(AdrSrc), .MemWrite(MemWrite), 
        .IRWrite(IRWrite), .resultSrc(resultSrc), 
        .ALUControl(ALUControl), .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB), .RegWrite(RegWrite)
    );

    CPU_Datapath DP(
        .clk(clk), .rst(rst), .neg(neg),
        .PCWrite(PCWrite), .AdrSrc(AdrSrc),
        .MemWrite(MemWrite), .IRWrite(IRWrite), 
        .resultSrc(resultSrc), .immSrc(immSrc), 
        .ALUControl(ALUControl), .op(op),
        .ALUSrcA(ALUSrcA), .func3(func3),
        .ALUSrcB(ALUSrcB), .zero(zero),
        .RegWrite(RegWrite), .func7(func7)
    );
    
endmodule