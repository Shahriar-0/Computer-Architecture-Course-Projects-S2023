module RegEX_MEM(clk, rst, regWriteE, resultSrcE, memWriteE,
                 ALUResultE, WriteDataE, RdE, PCPlus4E, luiE,
                 regWriteM, resultSrcM, memWriteM, ALUResultM,
                 WriteDataM, RdM, PCPlus4M, luiM);

    input clk, rst;
    input [31:0] ALUResultE, WriteDataE, PCPlus4E;
    input [4:0] RdE;
    input  memWriteE, regWriteE, luiE;
    input [1:0] resultSrcE;
    
    output reg [31:0] ALUResultM, WriteDataM, PCPlus4M;
    output reg [4:0] RdM;
    output reg  memWriteM, regWriteM , luiM;
    output reg [1:0] resultSrcM;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ALUResultM <= 32'b0;
            WriteDataM <= 32'b0;
            PCPlus4M   <= 32'b0;
            RdM <= 5'b0;
            memWriteM <= 1'b0;
            regWriteM <= 1'b0;
            resultSrcM <= 2'b0;
            luiM <= 1'b0;
        end else begin
            ALUResultM <=  ALUResultE;
            WriteDataM <=  WriteDataE;
            PCPlus4M   <=  PCPlus4E;
            RdM <= RdE;
            memWriteM <= memWriteE;
            regWriteM <= regWriteE;
            resultSrcM <= resultSrcE;
            luiM <= luiE;
        end
    end

endmodule
