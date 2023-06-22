`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b010
`define BGE 3'b011

module BranchController(func3, branch, neg, zero, w);

    input branch, zero, neg;
    inout [2:0] func3;

    output reg w;
    
    always @(func3, zero, neg, branch) begin
        case (func3)
            `BEQ   : w <= branch & zero;
            `BNE   : w <= branch & ~zero;
            `BLT   : w <= branch & neg;
            `BGE   : w <= branch & (zero | ~neg);
            default: w <= 1'b0;
        endcase
    end

endmodule