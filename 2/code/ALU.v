module ALU(opc, a, b, zero, w);
    parameter N = 32;

    input [2:0] opc;
    input [N-1:0] a;
    input [N-1:0] b;
    
    output zero;
    output [N-1:0] w;
    
    always @(a, b, opc) begin
        case (opc)
            3'b000 :  w = a + b;
            3'b001 :  w = a - b;
            3'b010 :  w = a & b;
            3'b011 :  w = a | b;
            3'b100 :  w = a < b ? 1'd1 : 1'd0;
            default:  w = {N{1'bz}};
        endcase
    end

    assign zero = (~|w);

endmodule