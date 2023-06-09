`define R_T     7'b0110011
`define I_T     7'b0010011
`define S_T     7'b0100011
`define B_T     7'b1100011
`define U_T     7'b0110111
`define J_T     7'b1101111
`define LW_T    7'b0000011
`define JALR_T  7'b1100111

`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b010
`define BGE 3'b011

module MainController(op, func3, regWriteD, ALUOp,
                      resultSrcD, memWriteD, jumpD,
                      branchD, ALUSrcD, immSrcD, luiD);

    input [6:0] op;
    input [2:0] func3;
    output reg memWriteD, regWriteD, ALUSrcD, luiD;
    output reg [1:0] resultSrcD, jumpD, ALUOp;
    output reg [2:0] branchD, immSrcD;


    always @(op, func3) begin
        {ALUOp, regWriteD, immSrcD, ALUSrcD, memWriteD, 
             resultSrcD, jumpD, ALUOp, branchD, immSrcD, luiD} <= 16'b0;
        case (op)
            `R_T: begin
                ALUOp      <= 2'b10;
                regWriteD  <= 1'b1;
            end
        
            `I_T: begin
                ALUOp      <= 2'b11;
                regWriteD  <= 1'b1;
                immSrcD    <= 3'b000;
                ALUSrcD    <= 1'b1;
                resultSrcD <= 2'b00;
            end
        
            `S_T: begin
                ALUOp      <= 2'b00;
                memWriteD  <= 1'b1;
                immSrcD    <= 3'b001;
                ALUSrcD    <= 1'b1;
            end
        
            `B_T: begin
                ALUOp      <= 2'b01;
                immSrcD    <= 3'b010;
                case(func3)
                    `BEQ   : branchD <= 3'b001;
                    `BNE   : branchD <= 3'b010;
                    `BLT   : branchD <= 3'b011;
                    `BGE   : branchD <= 3'b100;
                    default: branchD <= 3'b000;
                endcase
            end
        
            `U_T: begin
                resultSrcD <= 2'b11;
                immSrcD    <= 3'b100;
                regWriteD  <= 1'b1;
                luiD <= 1'b1;
            end
        
            `J_T: begin
                resultSrcD <= 2'b10;
                immSrcD    <= 3'b011;
                jumpD      <= 2'b01;
                regWriteD  <= 1'b1;
            end
        
            `LW_T: begin
                ALUOp      <= 2'b00;
                regWriteD  <= 1'b1;
                immSrcD    <= 3'b000;
                ALUSrcD    <= 1'b1;
                resultSrcD <= 2'b01;
            end
        
            `JALR_T: begin
                ALUOp      <= 2'b00;
                regWriteD  <= 1'b1;
                immSrcD    <= 3'b000;
                ALUSrcD    <= 1'b1;
                jumpD      <= 2'b10;
                resultSrcD <= 2'b10;
            end
        
            default: begin
                regWriteD <= 1'b0;
                ALUSrcD   <= 2'b00;
                ALUOp     <= 3'b000;
            end

        endcase
    end

endmodule
