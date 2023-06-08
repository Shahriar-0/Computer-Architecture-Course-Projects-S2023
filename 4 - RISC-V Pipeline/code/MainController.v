`define R_T     7'b0110011
`define I_T     7'b0010011
`define S_T     7'b0100011
`define B_T     7'b1100011
`define U_T     7'b0110111
`define J_T     7'b1101111
`define LW_T    7'b0000011
`define JALR_T  7'b1100111

module MainController(op, zero, resultSrc, memWrite,
                      ALUOp, ALUSrc, immSrc,Write, 
                      jal, jalr, neg, branch);

    input [6:0] op;
    input zero, neg;
    
    output [1:0] resultSrc;
    output memWrite, regWrite, jal, jalr, branch;
    output [2:0] ALUOp, ALUSrc, immSrc;

    assign resultSrc = 2'b00;
    assign memWrite = 0;
    assign jal = 0;
    assign jalr = 0;
    assign neg = 0;
    assign branch = 0;
    assign ALUOp = 3'b000;
    assign ALUSrc = 2'b00;
    assign immSrc 3'b000;

    always @(*) begin
        case (op)

            `R_T: begin
                    regWrite = 1;
                    ALUSrc = 2'b00;
                    ALUOp = 3'b010;
                    resultSrc = 2'b10;
            end
        
            `I_T: begin
                    regWrite = 1;
                    ALUSrc = 2'b01;
                    ALUOp = 3'b010;
                    resultSrc = 2'b10;
            end
        
            `S_T: begin
                    memWrite = 1;
                    ALUSrc = 2'b01;
                    ALUOp = 3'b000;
            end
        
            `B_T: begin
                    branch = 1;
                    ALUSrc = 2'b01;
                    ALUOp = 3'b001;
            end
        
            `U_T: begin
                    regWrite = 1;
                    ALUSrc = 2'b10;
                    ALUOp = 3'b010;
                    resultSrc = 2'b10;
            end
        
            `J_T: begin
                    jal = 1;
                    regWrite = 1;
                    ALUSrc = 2'b10;
                    ALUOp = 3'b011;
                    resultSrc = 2'b11;
            end
        
            `LW_T: begin
                    regWrite = 1;
                    memWrite = 1;
                    ALUSrc = 2'b01;
                    ALUOp = 3'b010;
                    resultSrc = 2'b01;
            end
        
            `JALR_T: begin
                    jalr = 1;
                    regWrite = 1;
                    ALUSrc = 2'b01;
                    ALUOp = 3'b011;
                    resultSrc = 2'b11;
            end
        
            default: begin
                    regWrite = 0;
                    ALUSrc = 2'b00;
                    ALUOp = 3'b000;
            end

        endcase
    end

endmodule
