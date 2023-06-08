module RISC_V(clk, rst);
    input clk, rst;
    
    wire [2:0] func3, ALUControl, immSrc;

    wire zero, neg, PCSrc, memWrite, func7, 
         regWrite, ALUSrc, PCWrite, adrSrc, IRWrite;

    wire [1:0] resultSrc, ALUSrcA, ALUSrcB;
    
    wire [6:0] op; 

    RISC_V_Controller CU(   // TODO: i connected parts that i know
        .clk(clk), .rst(rst), .op(op), .func3(func3), 
        .regWriteD(), .resultSrcD(), .memWriteD(),
        .jumpD(), .branchD(), .ALUControlD(),
        .ALUSrcD(), .immSrcD(), .func7(func7),
    );

    RISC_V_Datapath DP(     // TODO: i connected parts that i know
        .clk(clk), .rst(rst), .regWriteD(), .func3(func3),
        .memWriteD(), .jumpD(), .branchD(),
        .ALUControlD(), .ALUSrcD(), .immSrcD(),
        .luiD(), .op(op), .func7(func7), .resultSrcD()
    );
    
    
endmodule