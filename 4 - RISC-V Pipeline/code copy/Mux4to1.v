module Mux4to1(slc, a, b, c, d, w);
    parameter N = 32;

    input [1:0] slc;
    input [N-1:0] a, b, c, d;
    
    output reg [N-1:0] w;

    always @(a or b or c or d or slc) begin
        case (slc)
            2'b00  : w <= a;
            2'b01  : w <= b;
            2'b10  : w <= c;
            2'b11  : w <= d;
            default: w <= {N{1'bz}};
        endcase
    end

endmodule