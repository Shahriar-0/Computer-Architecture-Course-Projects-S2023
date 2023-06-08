module RegMEM_WB(clk, rst, regWriteM, resultSrcM,
                 ALUResultM, RDM, RdM, PCPlus4M,
                extImmM, extImmW, regWriteW, resultSrcW,
                ALUResultW, RDW, RdW, PCPlus4W
                );
    
    input clk, rst, regWriteM;
    input [31:0] ALUResultM, RDM, PCPlus4M, extImmM;
    input [4:0] RdM;
    input [1:0] resultSrcM;

    output reg clk, rst, regWriteW;
    output reg [31:0] ALUResultW, RDW, PCPlus4W, extImmW;
    output reg [4:0] RdW;
    output reg [1:0] resultSrcW;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            regWriteW <= 32'b0;
            ALUResultW <= 32'b0;
            PCPlus4W <= 32'b0;
            RDW <= 32'b0;
            RdW <= 5'b0;
            resultSrcW <= 2'b0;
            extImmW <= 32'b0;
        end else begin
            regWriteW <= regWriteW;
            ALUResultW <= ALUResultW;
            PCPlus4W <= PCPlus4W;
            RDW <= RDW;
            RdW <= RdW;
            resultSrcW <= resultSrcW;
            extImmW <= extImmM;
        end
    end

endmodule
