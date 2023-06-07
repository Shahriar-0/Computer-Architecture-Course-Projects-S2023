module RegMEM_WB(clk, rst, ALUResult, memData, RD, memToReg, ALUResultOut, memDataOut, RDOut, memWriteOut);
    
    input clk, rst;
    input [31:0] ALUResult, memData;
    input [4:0] RD;
    input [2:0] memToReg;

    output reg [31:0] ALUResultOut, memDataOut;
    output reg [4:0] RDOut,
    output reg [2:0] memToRegOut

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ALUResultOut <= 32'b0;
            memDataOut <= 32'b0;
            RDOut <= 5'b0;
            memToRegOut <= 3'b0;
        end else begin
            ALUResultOut <= ALUResult;
            memDataOut <= memData;
            RDOut <= RD;
            memToRegOut <= memToReg;
        end
    end

endmodule
