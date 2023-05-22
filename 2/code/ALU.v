module ALU(ALUcntrl, A, B, zero, W);
    parameter N = 32;

    input [2:0] ALUcntrl;
    input [N-1:0] A;
    input [N-1:0] B;
    
    output zero;
    output [N-1:0] W;
    
    w = (ALUcntrl  == 3'b000) ?  A + B :
        (ALUcntrl  == 3'b001) ?  A - B :
        (ALU cntrl == 3'b010) ?  A & B :
        (ALU cntrl == 3'b011) ?  A | B :
        (ALU cntrl == 3'b101) ? : 3'bz;
    
    zero = ( ~|w );

endmodule