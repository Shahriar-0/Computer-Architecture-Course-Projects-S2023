module RegIF_ID(clk, rst, instruction, OPCode, 
                func3, func7, RS1, RS2, RD, RDOut,
                PCOut, func7Out, func3Out, PC,
                instructionOut, RS1Out, RS2Out);
    
    input clk, rst;
    input [31:0] instruction, PC;
    input [2:0] OPCode, func3;
    input [6:0] func7;
    input [4:0] RS1, RS2, RD;


    output reg [31:0] instructionOut, PCOut;
    output reg [2:0] OPCodeOut, func3Out;
    output reg [6:0] func7Out;
    output reg [4:0] RS1Out, RS2Out, RDOut;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instructionOut <= 32'b0;
            PCOut <= 32'b0;
            OPCodeOut <= 3'b0;
            func7Out <= 7'b0;
            func3Out <= 3'b0;
            RS1Out <= 5'b0;
            RS2Out <= 5'b0;
            RDOut <= 5'b0;
        end 
        else begin
            instructionOut <= instruction;
            PCOut <= PC;
            OPCodeOut <= OPCode;
            func7Out <= func7;
            func3Out <= func3;
            RS1Out <= RS1;
            RS2Out <= RS2;
            RD1Out <= RD;
        end
    end

endmodule
