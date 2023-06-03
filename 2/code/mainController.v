`define R_T 7'd0
`define I_T 7'd1
`define S_T 7'd2
`define B_T 7'd3
`define U_T 7'd4
`define J_T 7'd5

`define LW 3'b110
`define JALR 3'b111

module MainController(op, func3, func7, zero,
                      resultSrc, memWrite, ALUOp,
                      ALUSrc, immSrc, regWrite, 
                      jal, jalr, neg, branch);

    input [6:0] op;
    input [2:0] func3;
    input [6:0] func7;
    input zero, neg;

    output reg [1:0] resultSrc, ALUOp;
    output reg [2:0] immSrc;
    output reg regWrite, memWrite, ALUSrc, jal, jalr, branch;
    
    always @(op, func3) begin 
    
        {memWrite, regWrite, ALUSrc, jal, 
            jalr, branch, immSrc, resultSrc, ALUOp} = 13'b0;
    
        case(op)

            `R_T:begin
                ALUOp     <= 2'b10;
                regWrite  <= 1'b1;
                end

            `I_T:begin
                ALUOp     <= 2'b10;
                regWrite  <= 1'b1;
                immSrc    <= 3'b000;
                ALUSrc    <= 1'b1;
                jalr      <= (func3 == `JALR) ? 1'b1  : 1'b0;
                resultSrc <= (func3 == `JALR) ? 2'b10 :
                             (func3 == `LW)   ? 2'b01 : 2'b00;
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