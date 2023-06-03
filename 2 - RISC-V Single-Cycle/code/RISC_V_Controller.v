module RISC_V_Controller(op, func3, func7, zero, PCSrc,
                         resultSrc, memWrite, ALUControl,
                         ALUSrc, immSrc, neg, regWrite);

    input [6:0] op;
    input [2:0] func3;
    input zero, neg, func7;
    
    output [1:0] PCSrc, resultSrc;
    output [2:0] ALUControl, immSrc;
    output regWrite, memWrite, ALUSrc;
    
    wire jal, jalr, branch, branchRes;
    wire [1:0] ALUOp;
    
    MainController MainDecoder(
        .op(op), .zero(zero), .neg(neg), .ALUOp(ALUOp),
        .resultSrc(resultSrc), .memWrite(memWrite),
        .ALUSrc(ALUSrc), .immSrc(immSrc), .regWrite(regWrite), 
        .jal(jal), .jalr(jalr), .branch(branch)
    );
    
    BranchController BranchDecoder(
        .func3(func3), .branch(branch), .neg(neg),
        .zero(zero), .w(branchRes)
    );   
    
    ALU_Controller ALUDecoder(
        .func3(func3), .func7(func7), .ALUOp(ALUOp), .ALUControl(ALUControl)
    );
    
    assign PCSrc =  (jalr) ? 2'b10 : (jal | branchRes) ? 2'b01: 2'b00;

endmodule