`define R_T     7'b0110011
`define I_T     7'b0010011
`define S_T     7'b0100011
`define B_T     7'b1100011
`define U_T     7'b0110111
`define J_T     7'b1101111
`define LW_T    7'b0000011
`define JALR_T  7'b1100111


`define IF     5'b00000
`define ID     5'b00001
`define EX1    5'b00010
`define EX2    5'b00011
`define EX3    5'b00100
`define EX4    5'b00101
`define EX5    5'b00110
`define EX6    5'b00111
`define EX7    5'b01000
`define EX8    5'b01001
`define EX9    5'b01010
`define MEM1   5'b01011
`define MEM2   5'b01100
`define MEM3   5'b01101
`define MEM4   5'b01110
`define MEM5   5'b01111
`define MEM6   5'b10000
`define WB     5'b10001

module MainController(clk, rst, op, zero, 
                      PCUpdate, adrSrc, memWrite, branch,
                      IRWrite, resultSrc, ALUOp, neg,
                      ALUSrcA, ALUSrcB, immSrc, regWrite);

    input [6:0] op;
    input clk, rst, zero , neg;

    output reg [1:0]  resultSrc, ALUSrcA, ALUSrcB, ALUOp;
    output reg [2:0] immSrc;
    output reg adrSrc, regWrite, memWrite, PCUpdate, branch, IRWrite;

    reg [4:0] pstate;
    reg [4:0] nstate = `IF;

    always @(pstate or op) begin
        case(pstate)
            `IF : nstate <= `ID;

            `ID: nstate <= (op == `R_T) ? `EX2 :
                           (op == `I_T) ? `EX1 :
                           (op == `S_T) ? `EX6 :
                           (op == `J_T) ? `EX4 :
                           (op == `B_T) ? `EX3 :
                           (op == `U_T) ? `MEM5 :
                           (op == `LW_T) ? `EX9 :
                           (op == `JALR_T) ? `EX8: `IF;

            `EX1 : nstate <= `MEM2;
            `EX2 : nstate <= `MEM4;
            `EX3 : nstate <= `IF;
            `EX4 : nstate <= `EX7;
            `EX5 : nstate <= `MEM2;
            `EX6 : nstate <= `MEM3;
            `EX7 : nstate <= `MEM6;
            `EX8 : nstate <= `EX5;
            `EX9 : nstate <= `MEM1;
            `MEM1: nstate <= `WB;
            `MEM2: nstate <= `IF;
            `MEM3: nstate <= `IF;
            `MEM4: nstate <= `IF;
            `MEM5: nstate <= `IF;
            `MEM6: nstate <= `IF;

            `WB  : nstate <= `IF;
        endcase
    end


    always @(pstate) begin

        {resultSrc, memWrite, ALUOp, ALUSrcA, ALUSrcB, immSrc, 
                regWrite, PCUpdate, branch, IRWrite} <= 14'b0;

        case(pstate)

            `IF : begin
                IRWrite   <= 1'b1;
                ALUSrcA   <= 2'b00;
                ALUSrcB   <= 2'b10;
                ALUOp     <= 2'b00;
                resultSrc <= 2'b10;
                PCUpdate  <= 1'b1;
                adrSrc = 1'b0;
            end
        
            `ID: begin
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b01;
                ALUOp     <= 2'b00;
                immSrc    <= 3'b010;
            end
        
            `EX1: begin 
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b000;
                ALUOp     <= 2'b11;
            end

            `EX2: begin
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b00;
                ALUOp     <= 2'b10;
            end
        
            `EX3: begin
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b00;
                ALUOp     <= 2'b01;
                resultSrc <= 2'b0;
                branch    <= 1'b1;
            end
        
            `EX4: begin
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b10;
                ALUOp     <= 2'b00;
            end
        
            `EX5: begin
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b10;
                ALUOp     <= 2'b00;
                resultSrc <= 2'b00;
                PCUpdate  <= 1'b1;
            end
        
            `EX6: begin
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                ALUOp     <= 2'b00;
                immSrc    <= 3'b001;
            end
        
            `EX7: begin
                regWrite  <= 1'b1;
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b011;
                ALUOp     <= 2'b00;
            end

            `EX8: begin 
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b000;
                ALUOp     <= 2'b00;
            end

            `EX9: begin 
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b000;
                ALUOp     <= 2'b00;
            end

            `MEM1: begin
                resultSrc <= 2'b00;
                adrSrc    <= 1'b1;
            end
        
            `MEM2: begin
                resultSrc <= 2'b00;
                regWrite  <= 1'b1;
            end
        
            `MEM3: begin
                resultSrc <= 2'b00;
                adrSrc    <= 1'b1;
                memWrite  <= 1'b1;
            end
        
            `MEM4: begin
                resultSrc <= 2'b00;
                regWrite  <= 1'b1;
            end
        
            `MEM5: begin
                resultSrc <= 2'b11;
                immSrc    <= 3'b100;
                regWrite  <= 1'b1;
            end
        
            `MEM6: begin
                resultSrc <= 2'b00;
                PCUpdate  <= 1'b1;
            end
        
            `WB: begin
                resultSrc <= 2'b01;
                regWrite  <= 1'b1;
                end
        
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst)
            pstate <= `IF;
        else
            pstate <= nstate;
    end

endmodule