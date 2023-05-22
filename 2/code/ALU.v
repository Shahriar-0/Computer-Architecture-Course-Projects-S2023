module ALU(opc, a, b, zero, w);
    parameter N = 32;

    input [2:0] opc;
    input [N-1:0] a;
    input [N-1:0] b;
    
    output zero;
    output [N-1:0] w;

    w = (opc == 3'b000) ?  a + b :
        (opc == 3'b001) ?  a - b :
        (opc == 3'b010) ?  a & b :
        (opc == 3'b011) ?  a | b :
        (opc == 3'b101) ? // TODO: FIX THIS LINE : 3'bz;
    
    zero = (~|w);

endmodule