module RegID_EX(clk, rst, clr, regWriteD, resultSrcD, memWriteD, jumpD,
                branchD, ALUControlD, ALUSrcD, RD1D, RD2D, PCD,Rs1D,
                Rs2D,RdD, ExtimmD,PCPlus4D,
                regWriteE, ALUSrcE, memWriteE, jumpE,
                BranchE, ALUControlE, resultSrcE, RD1E, RD2E, PCE,Rs1E,
                Rs2E,RdE, ExtimmE,PCPlus4E);

    input clk, rst, clr, ALUSrcD;
    input [31:0] RD1D, RD2D, PCD;
    input [31:0] PCPlus4D, ExtimmD;
    input [4:0] Rs1D, Rs2D,RdD;
    input [2:0] branchD;
    input [1:0] jumpD, resultSrcD;
    output ALUSrcE;
    output reg [31:0] RD1E, RD2E, PCE;
    output reg [31:0] PCPlus4E, ExtimmE;
    output reg [4:0] Rs1E, Rs2E,RdE;
    output reg [2:0] branchE;
    output reg [1:0] jumpE, resultSrcE;
    
    always @(posedge clk or posedge rst) begin
        if (rst || clr) begin
            RD1E <= 32'b0;
            RD2E <= 32'b0;
            PCE <= 32'b0;
            PCPlus4E <= 32'b0;
            ExtimmE <= 32'b0;
            Rs1E <= 5'b0;
            Rs2E <= 5'b0;
            RdE <= 5'b0;
            branchE <= 3'b0;
            jumpE <= 2'b0;
            ALUSrcE <= 1'b0;
            resultSrcE 2'b00;
        end
        else begin
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            PCPlus4E <= PCPlus4D;
            ExtimmE <= ExtimmD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;
            branchE <= branchD;
            jumpE <= jumpD;
            ALUSrcE <= ALUSrcD;
            resultSrcE <= resultSrcD;
        end
    end

endmodule
