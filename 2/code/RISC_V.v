module RISC_V(clk);
    input clk;
    
    wire [2:0] func3, ALUControl;
    wire zero, neg, PCSrc, memWrite, regWrite, ALUSrc;
    wire [1:0] resultSrc, immSrc;
    wire [6:0] op, func7; 

    CPU_Controller CPU(
        .op(op), .func3(func3), .func7(func7), 
        .zero(zero), .PCSrc(PCSrc),
        .resultSrc(resultSrc), .memWrite(memWrite), 
        .ALUControl(ALUControl), .immSrc(immSrc),
        .ALUSrc(ALUSrc), .neg(neg), .regWrite(regWrite)
    );

    RISC_V_Datapath DP(
        .clk(clk), .regWrite(regWrite), .ALUSrcB(ALUSrcB),
        .resultSrc(resultSrc), .PCSrc(PCSrc),
        .ALUControl(ALUControl), .immSrc(immSrc),
        .zero(), .neg(neg), .op(op),
        .func7(func7), .memWrite(memWrite), .func3(func3)
    );
endmodule