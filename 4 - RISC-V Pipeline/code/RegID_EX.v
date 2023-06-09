module RegID_EX(clk, rst, clr, regWriteD, resultSrcD, memWriteD, jumpD,
                branchD, ALUControlD, ALUSrcD, RD1D, RD2D, PCD,Rs1D,
                Rs2D,RdD, extImmD,PCPlus4D, luiD,
                regWriteE, ALUSrcE, memWriteE, jumpE, luiE,
                branchE, ALUControlE, resultSrcE, RD1E, RD2E, PCE,Rs1E,
                Rs2E,RdE, extImmE,PCPlus4E);

    input clk, rst, clr, ALUSrcD, luiD, regWriteD, memWriteD;
    input [31:0] RD1D, RD2D, PCD;
    input [31:0] PCPlus4D, extImmD;
    input [4:0] Rs1D, Rs2D,RdD;
    input [2:0] branchD, ALUControlD;
    input [1:0] jumpD, resultSrcD;
    output reg ALUSrcE ,luiE, regWriteE, memWriteE;
    output reg [31:0] RD1E, RD2E, PCE;
    output reg [31:0] PCPlus4E, extImmE;
    output reg [4:0] Rs1E, Rs2E,RdE;
    output reg [2:0] branchE, ALUControlE;
    output reg [1:0] jumpE, resultSrcE;
    
    always @(posedge clk or posedge rst) begin
        if (rst || clr) begin
            regWriteE <= 1'b0;
            memWriteE <= 1'b0;
            ALUControlE <= 3'b000;
            RD1E <= 32'b0;
            RD2E <= 32'b0;
            PCE <= 32'b0;
            PCPlus4E <= 32'b0;
            extImmE <= 32'b0;
            Rs1E <= 5'b0;
            Rs2E <= 5'b0;
            RdE <= 5'b0;
            branchE <= 3'b0;
            jumpE <= 2'b0;
            ALUSrcE <= 1'b0;
            resultSrcE <= 2'b00;
            luiE <= 1'b0;
        end
        else begin
            regWriteE <= regWriteD;
            memWriteE <= memWriteD;
            ALUControlE <= ALUControlD;
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            PCPlus4E <= PCPlus4D;
            extImmE <= extImmD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;
            branchE <= branchD;
            jumpE <= jumpD;
            ALUSrcE <= ALUSrcD;
            resultSrcE <= resultSrcD;
            luiE <= luiD;
        end
    end

endmodule

