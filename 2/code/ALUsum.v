module ALUsum(A, B, W);
    parameter N = 32;
    input [N-1:0] A;
    input [N-1:0] B;
    output [N-1:0] W;
    w = A + B;
endmodule