`define R_T 7'd0
`define I_T 7'd1
`define S_T 7'd2
`define B_T 7'd3
`define U_T 7'd4
`define J_T 7'd5
`define LW 3'b110
`define JALR 3'b111
`define IF 4'b0000
`define ID 4'b0001
`define EX1 4'b0010
`define EX2 4'b0011
`define EX3 4'b0100
`define EX4 4'b0101
`define EX5 4'b0110
`define EX6 4'b0111
`define EX7 4'b1000
`define MEM1 4'b1001
`define MEM2 4'b1010
`define MEM3 4'b1011
`define MEM4 4'b1100
`define MEM5 4'b1101
`define MEM6 4'b1110
`define WB 4'b1111

module MainController(clk, rst, op, func3, func7, zero, neg,
                    PCUpdate, AdrSrc, MemWrite, branch,
                    IRWrite, resultSrc, ALUOp,
                    ALUSrcA, ALUSrcB, immSrc, RegWrite);
        input [6:0] op;
        input [2:0] func3;
        input [6:0] func7;
        input clk, rst, zero ,neg;

        output reg [1:0]  resultSrc, ALUSrcA, ALUSrcB, ALUOp;
        output reg [2:0] immSrc;
        output reg AdrSrc, RegWrite, ءemWrite, PCUpdate, branch, IRWrite;
        reg [3:0] pstate;
        reg [3:0] nstate = `IF;

        always @(pstate) begin
            {resultSrc, ءemWrite, ALUOp, ALUSrc,immSrc, RegWrite , PCUpdate, branch} <= 13'b0;
            case(pstate):
                `IF : begin
                    IRWrite <= 1'b1;
                    ALUSrcA <= 2'b00;
                    ALUSrcB <= 2'b10;
                    ALUOp <= 2'b00;
                    resultSrc <= 2'b10;
                    PCUpdate <= 1'b1;
                 end
                `ID: begin
                    ALUSrcA <= 2'b01;
                    ALUSrcB <= 2'b01;
                    ALUOp <= 2'b00;
                    immSrc <= 3'b010;
                 end
                `EX1: begin 
                    ALUSrcA <= 2'b10;
                    ALUSrcB <= 2'b01;
                    immSrc <= 3'b000;
                    ALUOp <= 2'b10;
                    end
                `EX2: begin
                    ALUSrcA <= 2'b10;
                    ALUSrcB <= 2'b00;
                    ALUOp <= 2'b10;
                 end
                `EX3: begin
                    ALUSrcA <= 2'b10;
                    ALUSrcB <= 2'b00;
                    ALUOp <= 2'b01;
                    resultSrc <= 2'b0;
                    branch <= 1'b1;
                 end
                `EX4: begin
                    ALUSrcA <= 2'b01;
                    ALUSrcB <= 2'b10;
                    ALUOp <= 2'b00;
                 end
                `EX5: begin
                    ALUSrcA <= 2'b01;
                    ALUSrcB <= 2'b10;
                    ALUOp <= 2'b00;
                    resultSrc <= 2'b00;
                    PCUpdate <= 1'b1;
                 end
                `EX6: begin
                    ALUSrcA <= 2'b10;
                    ALUSrcB <= 2'b01;
                    ALUOp <= 2'b00;
                    immSrc <= 3'b001;
                 end
                `EX7: begin
                    RegWrite <= 1'b1;
                    ALUSrcA <= 2'10;
                    ALUSrcB <= 2'b01;
                    immSrc <= 3'b100;
                    ALUOp <= 2'b00;
                 end
                `MEM1: begin
                    resultSrc <= 2'b00;
                    AdrSrc <= 1'b1;
                 end
                `MEM2: begin
                    resultSrc <= 2'b00;
                    RegWrite <= 1'b1;
                 end
                `MEM3: begin
                    resultSrc <= 2'b00;
                    AdrSrc <= 1'b1;
                    MemWrite <= 1'b1;
                 end
                `MEM4: begin
                    resultSrc <= 2'b00;
                    RegWrite <= 1'b1;
                 end
                `MEM5: begin
                    resultSrc <= 2'b11;
                    immSrc <= 3'b011;
                    RegWrite <= 1'b1;
                 end
                `MEM6: begin
                    resultSrc <= 2'b00;
                    PCUpdate <= 1'b1;
                 end
                `WB: begin
                    resultSrc <= 2'b01;
                    RegWrite <= 1'b1;
                 end
            endcase
        end

        always @(pstate, op, func3, func7) begin
            case(pstate):
                `IF : nstate <= `ID;
                `ID: nstate <= (op == `R_T) ? `EX2:
                               (op == `I_T) ? `EX1:
                               (op == `S_T) ? `EX6:
                               (op == `J_T) ? `EX4:
                               (op == `B_T) ? `EX3:
                               (op == `U_T) ? `MEM5:
                               `IF;
                `EX1: nstate <= (func3 == `JALR) ? `EX5 :
                                (func3 == `LW) ? `MEM1:
                                `MEM2;
                `EX2: nstate <= `MEM4;
                `EX3: nstate <= `IF;
                `EX4: nstate <= `EX7;
                `EX5: nstate <= `MEM2;
                `EX6: nstate <= `MEM3;
                `EX7: nstate <= `MEM6;
                `MEM1: nstate <= `WB;
                `MEM2: nstate <= `IF;
                `MEM3: nstate <= `IF;
                `MEM4: nstate <= `IF;
                `MEM5: nstate <= `IF;
                `MEM6: nstate <= `IF;
                `WB: nstate <= `IF;
            endcase
        end

        always @(posedge clk,posedge rst) begin
            if(rst)
                pstate <= `IF;
            else
                pstate <= nstate;
         end
endmodule