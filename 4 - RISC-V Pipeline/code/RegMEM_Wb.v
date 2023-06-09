module RegMEM_WB(clk, rst, regWriteM, resultSrcM,
                 ALUResultM, RDM, RdM, PCPlus4M,
                extImmM, extImmW, regWriteW, resultSrcW,
                ALUResultW, RDW, RdW, PCPlus4W);
    
    input clk, rst, regWriteM;
    input [1:0] resultSrcM;
    input [4:0] RdM;
    input [31:0] ALUResultM, RDM, PCPlus4M, extImmM;

    output reg regWriteW;
    output reg [1:0] resultSrcW;
    output reg [4:0] RdW;
    output reg [31:0] ALUResultW, RDW, PCPlus4W, extImmW;

    always @(posedge clk or posedge rst) begin
        
        if (rst) begin
            regWriteW  <= 32'b0;
            ALUResultW <= 32'b0;
            PCPlus4W   <= 32'b0;
            RDW        <= 32'b0;
            RdW        <= 5'b0;
            resultSrcW <= 2'b0;
            extImmW    <= 32'b0;
        end 
        
        else begin
            regWriteW  <= regWriteM; 
            ALUResultW <= ALUResultM;
            PCPlus4W   <= PCPlus4M;
            RDW        <= RDM;
            RdW        <= RdM;
            resultSrcW <= resultSrcM;
            extImmW    <= extImmM;
        end
        
    end

endmodule

