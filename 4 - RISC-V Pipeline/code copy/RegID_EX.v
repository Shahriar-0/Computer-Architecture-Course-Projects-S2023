module RegID_EX(clk, rst, instruction, InstructionOut, PC, PCOut,
                OPCode, OPCodeOut, func3, func3Out, func7, func7Out,
                RS1, Rs1Out, RS2, Rs2Out, RD, RDOut, imm, ImmOut,
                ALUOp, ALUOpcOut, regWrite, regWriteOut, memRead, 
                memWrite, memWriteOut, memToReg, memToRegOut, memReadOut);

    input clk, rst;
    input [31:0] instruction, PC, imm;
    input [2:0] OPCode, func3;
    input [6:0] func7;
    input [4:0] RS1, RS2, RD;
    input [1:0] ALUOp, regWrite, memRead, memWrite, memToReg;

    output reg [31:0] instructionOut, PCOut, immOut;
    output reg [2:0] OPCodeOut, func3Out;
    output reg [6:0] func7Out;
    output reg [4:0] RS1Out, RS2Out, RDOut;
    output reg [1:0] ALUOpOut, regWriteOut, memReadOut, memWriteOut, memToRegOut;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            InstructionOut <= 32'b0;
            PCOut <= 32'b0;
            OPCodeOut <= 3'b0;
            func7Out <= 7'b0;
            Funct3Out <= 3'b0;
            Rs1Out <= 5'b0;
            Rs2Out <= 5'b0;
            RdOut <= 5'b0;
            ImmOut <= 32'b0;
            ALUOpOut <= 2'b0;
            regWriteOut <= 2'b0;
            memReadOut <= 2'b0;
            memWriteOut <= 2'b0;
            memToRegOut <= 2'b0;
        end
        else begin
            InstructionOut <= instruction;
            PCOut <= PC;
            OPCodeOut <= OPCode;
            func7Out <= func7;
            func3Out <= func3;
            Rs1Out <= RS1;
            Rs2Out <= RS2;
            RdOut <= RD;
            ImmOut <= imm;
            ALUOpOut <= ALUOp;
            regWriteOut <= regWrite;
            memReadOut <= memRead;
            memWriteOut <= memWrite;
            memToRegOut <= memToReg;
        end
    end

endmodule
