module RISC_V_Controller(clk, rst, op, func3, func7, zero, neg,
                    PCWrite, adrSrc, memWrite,
                    IRWrite, resultSrc, ALUControl,
                    ALUSrcA, ALUSrcB, immSrc, regWrite);
    input [6:0] op;
    input [2:0] func3;
    input clk, rst, zero , neg, func7;
    
    output PCWrite, adrSrc, memWrite, IRWrite, regWrite;
    output [1:0] resultSrc, ALUSrcA, ALUSrcB;
    output [2:0] ALUControl, immSrc;
    
    wire PCUpdate, branch, branchRes;
    wire[1:0] ALUOp;

    MainController mainController(
        .clk(clk), .rst(rst), .op(op),
        .zero(zero), .neg(neg), .PCUpdate(PCUpdate),
        .adrSrc(adrSrc), .memWrite(memWrite),
        .branch(branch), .resultSrc(resultSrc),
        .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
        .immSrc(immSrc), .regWrite(regWrite),
        .IRWrite(IRWrite), .ALUOp(ALUOp)
    );
    
    ALU_Controller ALUController(
        .func3(func3), .func7(func7), .ALUOp(ALUOp), .ALUControl(ALUControl)
    );    
    
    BranchController branchController(
        .func3(func3), .branch(branch), 
        .neg(neg), .zero(zero), .w(branchRes)
    ); 
                                         
    assign PCWrite = (PCUpdate | branchRes);    

endmodule