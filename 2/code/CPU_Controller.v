module CPU_Controller(op, func3, func7, zero, neg, PCSrc,
                      resultSrc, memWrite, ALUControl,
                      ALUSrc,immSrc,regWrite);
        input [6:0] op;
        input [2:0] func3;
        input [6:0] func7;
        input zero , neg;

        output [1:0] PCsrc, resultSrc;
        output [2:0] ALUControl, immSrc;
        output regWrite, memWrite, ALUSrc;
        wire jal, jalr, branch, branchRes;
        wire[1:0] ALUOp;
        MainController MainDecoder(op, func3, func7, zero, neg,
                      resultSrc, memWrite, ALUOp,
                      ALUSrc,immSrc,regWrite , jal, jalr, branch);
        BranchController BranchDecoder(.func3(func3), .branch(branch), .neg(neg),
                                             .zero(zero), .w(branchRes));   
        ALU_Controller ALUDecoder(func3, ALUOp, ALUControl)  ;
        assign PCSrc =  (jalr) ? 2'b11 : (jal | branchRes) ? 2'b01: 2'b00;


endmodule