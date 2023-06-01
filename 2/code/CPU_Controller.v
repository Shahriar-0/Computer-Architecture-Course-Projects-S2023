`define R_T 7'd0
`define I_T 7'd1
`define S_T 7'd2
`define B_T 7'd3
`define U_T 7'd4
`define J_T 7'd5
`define LW 3'b110
`define JALR 3'b111

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