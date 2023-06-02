module CPU_Controller(clk, op, func3, func7, zero, neg,
                    PCWrite, AdrSrc, MemWrite,
                    IRWrite, ResultSrc, ALUControl,
                    ALUSrcA, ALUSrcB, ImmSrc, RegWrite);
        input [6:0] op;
        input [6:0] func7;
        input [2:0] func3;
        input clk, zero , neg;
        
        output PCWrite, AdrSrc, MemWrite, IRWrite, RegWrite;
        output [1:0] ResultSrc, ALUSrcA, ALUSrcB;
        output [2:0] ALUControl, ImmSrc;
        wire PCUpdate, branch, branchRes;
        wire[1:0] ALUOp;

        MainController MainDecoder(clk, op, func3, func7, zero, neg,
                    PCUpdate, AdrSrc, MemWrite, branch,
                    IRWrite, ResultSrc, ALUOp,
                    ALUSrcA, ALUSrcB, ImmSrc, RegWrite);
        
        ALU_Controller ALUDecoder(func3, ALUOp, ALUControl);

        
        BranchController BranchDecoder(.func3(func3), .branch(branch), .neg(neg),
                                             .zero(zero), .w(branchRes)); 
                                             
        assign PCWrite = (PCUpdate | branchRes);


endmodule