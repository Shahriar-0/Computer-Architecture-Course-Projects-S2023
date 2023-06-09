module RegEX_MEM(clk, rst, regWriteE, resultSrcE, memWriteE,
                 ALUResultE, writeDataE, RdE, PCPlus4E, luiE, extImmE,
                 regWriteM, resultSrcM, memWriteM, ALUResultM,
                 writeDataM, RdM, PCPlus4M, luiM,extImmM);

    input clk, rst, memWriteE, regWriteE, luiE;
    input [1:0] resultSrcE;
    input [4:0] RdE;
    input [31:0] ALUResultE, writeDataE, PCPlus4E, extImmE;
    
    output reg  memWriteM, regWriteM , luiM;
    output reg [1:0] resultSrcM;
    output reg [4:0] RdM;
    output reg [31:0] ALUResultM, writeDataM, PCPlus4M, extImmM;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            ALUResultM <= 32'b0;
            writeDataM <= 32'b0;
            PCPlus4M   <= 32'b0;
            extImmM    <= 32'b0;
            RdM        <= 5'b0;
            memWriteM  <= 1'b0;
            regWriteM  <= 1'b0;
            resultSrcM <= 2'b0;
            luiM       <= 1'b0;
        end 
        
        else begin
            ALUResultM <= ALUResultE;
            writeDataM <= writeDataE;
            PCPlus4M   <= PCPlus4E;
            RdM        <= RdE;
            memWriteM  <= memWriteE;
            regWriteM  <= regWriteE;
            resultSrcM <= resultSrcE;
            luiM       <= luiE;
            extImmM    <= extImmE;
        end

    end

endmodule
