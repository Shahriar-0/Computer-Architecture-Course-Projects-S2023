module CPU_Controller(clk, rst, op, func3, func7, zero, neg,
                    PCWrite, AdrSrc, MemWrite,
                    IRWrite, resultSrc, ALUControl,
                    ALUSrcA, ALUSrcB, immSrc, RegWrite);
    input [6:0] op;
    input [2:0] func3;
    input clk, rst, zero , neg, func7;
    
    output PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite;
    output [1:0] resultSrc, ALUSrcA, ALUSrcB;
    output [2:0] ALUControl, immSrc;
    
    wire PCUpdate, branch, branchRes;
    wire[1:0] ALUOp;

    MainController MainDecoder(
        .clk(clk), .rst(rst), .op(op),
        .zero(zero), .neg(neg), .PCUpdate(PCUpdate),
        .AdrSrc(AdrSrc), .MemWrite(MemWrite),
        .branch(branch), .resultSrc(resultSrc),
        .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
        .immSrc(immSrc), .RegWrite(RegWrite),
        .IRWrite(IRWrite), .ALUOp(ALUOp)
    );
    
    ALU_Controller ALUDecoder(
        .func3(func3), .func7(func7), .ALUOp(ALUOp), .ALUControl(ALUControl)
    );    
    
    BranchController BranchDecoder(
        .func3(func3), .branch(branch), 
        .neg(neg), .zero(zero), .w(branchRes)
    ); 
                                         
    assign PCWrite = (PCUpdate | branchRes);    

endmodule