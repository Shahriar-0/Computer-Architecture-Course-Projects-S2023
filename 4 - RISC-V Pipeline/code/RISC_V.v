module RISC_V(clk, rst);
    input clk, rst;

    wire ALUSrcD, jumpD, branchD, 
         memWriteD, regWriteD, luiD;    
    wire [1:0] immSrcD, resultSrcD;
    wire [2:0] func3, ALUControlD;
    wire [6:0] op, func7; 

    RISC_V_Controller CU(
        .clk(clk), .rst(rst), .op(op), .func3(func3), 
        .regWriteD(regWriteD), .resultSrcD(resultSrcD), 
        .memWriteD(memWriteD), .ALUControlD(ALUControlD),
        .jumpD(jumpD), .branchD(branchD), .func7(func7),
        .ALUSrcD(ALUSrcD), .immSrcD(immSrcD)
    );

    RISC_V_Datapath DP(  
        .clk(clk), .rst(rst), .regWriteD(regWriteD), 
        .memWriteD(memWriteD), .jumpD(jumpD), .func3(func3),
        .branchD(branchD), .immSrcD(immSrcD), .luiD(luiD),
        .ALUControlD(ALUControlD), .ALUSrcD(ALUSrcD),
        .func7(func7), .resultSrcD(resultSrcD), .op(op)
    );
    
    
endmodule