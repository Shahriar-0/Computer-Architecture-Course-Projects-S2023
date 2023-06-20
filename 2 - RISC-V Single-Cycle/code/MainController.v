`define R_T     7'b0110011
`define I_T     7'b0010011
`define S_T     7'b0100011
`define B_T     7'b1100011
`define U_T     7'b0110111
`define J_T     7'b1101111
`define LW_T    7'b0000011
`define JALR_T  7'b1100111

module MainController(op, zero, resultSrc, memWrite,
                      ALUOp, ALUSrc, immSrc, regWrite, 
                      jal, jalr, neg, branch);

    input [6:0] op;
    input zero, neg;

    output reg [1:0] resultSrc, ALUOp;
    output reg [2:0] immSrc;
    output reg regWrite, memWrite, ALUSrc, jal, jalr, branch;
    
    always @(op) begin 
        {memWrite, regWrite, ALUSrc, jal, 
            jalr, branch, immSrc, resultSrc, ALUOp} <= 13'b0;
        case(op)
            `R_T:begin
                ALUOp     <= 2'b10;
                regWrite  <= 1'b1;
            end

            `I_T:begin
                ALUOp     <= 2'b11;
                regWrite  <= 1'b1;
                immSrc    <= 3'b000;
                ALUSrc    <= 1'b1;
                jalr      <= 1'b0;
                resultSrc <= 2'b00;
            end
            
            `LW_T:begin
                ALUOp     <= 2'b00;
                regWrite  <= 1'b1;
                immSrc    <= 3'b000;
                ALUSrc    <= 1'b1;
                jalr      <= 1'b0;
                resultSrc <= 2'b01;
            end

            `JALR_T:begin
                ALUOp     <= 2'b00;
                regWrite  <= 1'b1;
                immSrc    <= 3'b000;
                ALUSrc    <= 1'b1;
                jalr      <= 1'b1;
                resultSrc <= 2'b10;
            end

            `S_T:begin
                ALUOp     <= 2'b00;
                memWrite  <= 1'b1;
                immSrc    <= 3'b001;
                ALUSrc    <= 1'b1;
            end
            
            `J_T:begin
                resultSrc <= 2'b10;
                immSrc    <= 3'b011;
                jal       <= 1'b1;
                regWrite  <= 1'b1;
            end

            `B_T:begin
                ALUOp     <= 2'b01;
                immSrc    <= 3'b010;
                branch    <= 1'b1;
            end

            `U_T:begin
                resultSrc <= 2'b11;
                immSrc    <= 3'b100;
                regWrite  <= 1'b1;
            end
        endcase
    end
endmodule