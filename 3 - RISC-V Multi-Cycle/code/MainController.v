`define R_T     7'b0110011
`define I_T     7'b0010011
`define S_T     7'b0100011
`define B_T     7'b1100011
`define U_T     7'b0110111
`define J_T     7'b1101111
`define LW_T    7'b0000011
`define JALR_T  7'b1100111

`define IF       5'b00000
`define ID       5'b00001
`define EX_I     5'b00010
`define MEM_I    5'b01100
`define EX_R     5'b00011
`define MEM_R    5'b01110
`define EX_B     5'b00100
`define EX_J     5'b00101
`define MEM_J    5'b01000
`define WB_J     5'b10000
`define EX_JALR  5'b01001
`define MEM_JALR 5'b00110
`define EX_S     5'b00111
`define MEM_S    5'b01101
`define EX_LW    5'b01010
`define MEM_LW   5'b01011
`define WB_LW    5'b10001
`define EX_U     5'b01111

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
            `IF  : nstate <= `ID;

            `ID  : nstate <= (op == `I_T)    ? `EX_I     :
                             (op == `R_T)    ? `EX_R     :
                             (op == `B_T)    ? `EX_B     :
                             (op == `J_T)    ? `EX_J     :
                             (op == `U_T)    ? `EX_U     :   
                             (op == `S_T)    ? `EX_S     :
                             (op == `JALR_T) ? `EX_JALR  :
                             (op == `LW_T)   ? `EX_LW    : `IF; // undefined instruction

            `EX_I : nstate <= `MEM_I;
            `MEM_I: nstate <= `IF;

            `EX_R : nstate <= `MEM_R;
            `MEM_R: nstate <= `IF;

            `EX_B : nstate <= `IF;

            `EX_J : nstate <= `MEM_J;
            `MEM_J : nstate <= `WB_J;
            `WB_J: nstate <= `IF;

            `EX_S : nstate <= `MEM_S;
            `MEM_S: nstate <= `IF;
            
            `EX_JALR : nstate <= `MEM_JALR;
            `MEM_JALR : nstate <= `MEM_I;

            `EX_LW : nstate <= `MEM_LW;
            `MEM_LW: nstate <= `WB_LW;
            `WB_LW  : nstate <= `IF;

            `EX_U: nstate <= `IF;
        endcase
    end


    always @(pstate) begin

        {resultSrc, memWrite, ALUOp, ALUSrcA, ALUSrcB, immSrc, 
                regWrite, PCUpdate, branch, IRWrite} <= 14'b0;

        case(pstate)
            // instruction fetch
            `IF : begin
                IRWrite   <= 1'b1;
                adrSrc    <= 1'b0;
                ALUSrcA   <= 2'b00;
                ALUSrcB   <= 2'b10;
                ALUOp     <= 2'b00;
                resultSrc <= 2'b10;
                PCUpdate  <= 1'b1;
            end
            // instruction decode
            `ID: begin
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b01;
                ALUOp     <= 2'b00;
                immSrc    <= 3'b010;
            end
            // I-type
            `EX_I: begin 
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b000;
                ALUOp     <= 2'b11;
            end

            `MEM_I: begin
                resultSrc <= 2'b00;
                regWrite  <= 1'b1;
            end
            // JALR-type (it's different from I-type so in another cycle it's handled)
            `EX_JALR: begin 
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b000;
                ALUOp     <= 2'b00;
            end

            `MEM_JALR: begin
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b10;
                ALUOp     <= 2'b00;
                resultSrc <= 2'b00;
                PCUpdate  <= 1'b1;
            end
            // LW (like JALR)
            `EX_LW: begin 
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b000;
                ALUOp     <= 2'b00;
            end

            `MEM_LW: begin
                resultSrc <= 2'b00;
                adrSrc    <= 1'b1;
            end

            `WB_LW: begin
                resultSrc <= 2'b01;
                regWrite  <= 1'b1;
            end
            // T-type
            `EX_R: begin
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b00;
                ALUOp     <= 2'b10;
            end

            `MEM_R: begin
                resultSrc <= 2'b00;
                regWrite  <= 1'b1;
            end
            // B-type
            `EX_B: begin
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b00;
                ALUOp     <= 2'b01;
                resultSrc <= 2'b00;
                branch    <= 1'b1;
            end
            // J-type
            `EX_J: begin
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b10;
                ALUOp     <= 2'b00;
            end
        
            `MEM_J: begin
                regWrite  <= 1'b1;
                ALUSrcA   <= 2'b01;
                ALUSrcB   <= 2'b01;
                immSrc    <= 3'b011;
                ALUOp     <= 2'b00;
            end

            `WB_J: begin
                resultSrc <= 2'b00;
                PCUpdate  <= 1'b1;
            end
            // S-type
            `EX_S: begin
                ALUSrcA   <= 2'b10;
                ALUSrcB   <= 2'b01;
                ALUOp     <= 2'b00;
                immSrc    <= 3'b001;
            end
        
            `MEM_S: begin
                resultSrc <= 2'b00;
                adrSrc    <= 1'b1;
                memWrite  <= 1'b1;
            end
            // U-type
            `EX_U: begin
                resultSrc <= 2'b11;
                immSrc    <= 3'b100;
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