`define ADD  3'b000
`define SUB  3'b001
`define AND  3'b010
`define OR   3'b011
`define SLT  3'b100
`define XOR  3'b101
`define LW   3'b110
`define JALR 3'b111

`define S_T   2'b00
`define B_T   2'b01
`define R_I_T 2'b10

module ALU_Controller(func3, ALUOp, ALUControl);

    input [2:0] func3;
    input [1:0] ALUOp;

    output reg [2:0] ALUControl;
    
    always @(ALUOp or func3)begin
        case (ALUOp):
            `S_T   : ALUControl <= `ADD;
            `B_T   : ALUControl <= `SUB;
            `R_I_T : ALUControl <= 
                    (func3 == `ADD | func3 == `LW | func3 == `JALR) ? `ADD:
                    (func3 == `SUB) ? `SUB:
                    (func3 == `AND) ? `AND:
                    (func3 == `OR ) ? `OR :
                    (func3 == `SLT) ? `SLT:
                    (func3 == `XOR) ? `XOR: 3'bzzz;
            default: ALUControl <= `ADD;
        endcase
    end
endmodule
