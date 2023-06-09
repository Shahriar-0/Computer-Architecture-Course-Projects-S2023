module RegID_EX(clk, rst, clr, ALUSrcD, luiD,
                jumpD, resultSrcD, branchD, 
                Rs1D, Rs2D, RdD, RD1D, RD2D,
                PCD, PCPlus4D, extImmD, ALUSrcE,
                luiE, jumpE, resultSrcE, branchE,
                Rs1E, Rs2E, RdE, RD1E, RD2E, PCE,
                PCPlus4E, extImmE);

    input clk, rst, clr, ALUSrcD, luiD;
    input [1:0] jumpD, resultSrcD;
    input [2:0] branchD;
    input [4:0] Rs1D, Rs2D, RdD;
    input [31:0] RD1D, RD2D, PCD, PCPlus4D, extImmD;

    output reg ALUSrcE, luiE;
    output reg [1:0] jumpE, resultSrcE;
    output reg [2:0] branchE;
    output reg [4:0] Rs1E, Rs2E, RdE;
    output reg [31:0] RD1E, RD2E, PCE, PCPlus4E, extImmE;
    
    always @(posedge clk or posedge rst) begin
        
        if(rst || clr) begin
            RD1E       <= 32'b0;
            RD2E       <= 32'b0;
            PCE        <= 32'b0;
            PCPlus4E   <= 32'b0;
            extImmE    <= 32'b0;
            Rs1E       <= 5'b0;
            Rs2E       <= 5'b0;
            RdE        <= 5'b0;
            branchE    <= 3'b0;
            jumpE      <= 2'b0;
            ALUSrcE    <= 1'b0;
            resultSrcE <= 2'b00;
            luiE       <= 1'b0;
        end

        else begin
            RD1E       <= RD1D;
            RD2E       <= RD2D;
            PCE        <= PCD;
            PCPlus4E   <= PCPlus4D;
            extImmE    <= extImmD;
            Rs1E       <= Rs1D;
            Rs2E       <= Rs2D;
            RdE        <= RdD;
            branchE    <= branchD;
            jumpE      <= jumpD;
            ALUSrcE    <= ALUSrcD;
            resultSrcE <= resultSrcD;
            luiE       <= luiD;
        end
        
    end

endmodule

