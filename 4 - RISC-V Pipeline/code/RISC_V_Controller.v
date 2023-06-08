module RISC_V_Controller(clk, rst, op, func3, func7,
                         regWriteD, resultSrcD, memWriteD,
                         jumpD, branchD, ALUControlD,
                         ALUSrcD, immSrcD);
    input [6:0] op;
    input [2:0] func3;
    input clk, rst, func7;
    
    output ALUSrcD, memWriteD, regWriteD;
    output [1:0] resultSrcD, jumpD, ALUOp;
    output [2:0] ALUControlD, immSrcD,branchD;

    MainController maindecoder(
        .op(op), .func3(func3), .regWriteD(regWriteD), 
        .resultSrcD(resultSrcD), .memWriteD(memWriteD),
        .jumpD(jumpD), .branchD(branchD), .ALUOp(ALUOp), 
        .ALUSrcD(ALUSrcD), .immSrcD(immSrcD) 
    );
    
    ALU_Controller ALUdecoder(
        .func3(func3), .func7(func7), .ALUOp(ALUOp), 
        .ALUControl(ALUControlD)
    );
    
endmodule